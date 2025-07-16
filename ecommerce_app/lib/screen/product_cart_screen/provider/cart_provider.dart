import 'dart:developer';

import 'package:ecommerce_app/utility/utility_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../models/api_response.dart';
import '../../../models/coupon.dart';
import '../../../services/http_services.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../login_screen/provider/user_provider.dart';

class CartProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();
  Razorpay razorpay = Razorpay();
  final UserProvider _userProvider;
  var flutterCart = FlutterCart();
  List<CartModel> myCartItems = [];

  final GlobalKey<FormState> buyNowFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  bool isExpanded = false;

  Coupon? couponApplied;
  double couponCodeDiscount = 0;
  String selectedPaymentOption = 'prepaid';

  CartProvider(this._userProvider);

  getCartItems() {
    myCartItems = flutterCart.cartItemsList;
    notifyListeners();
  }

  void updateCart(CartModel cartItem, int quantity) {
    quantity = cartItem.quantity + quantity;
    flutterCart.updateQuantity(cartItem.productId, cartItem.variants, quantity);
    notifyListeners();
  }

  double getCartSubTotal() {
    return flutterCart.subtotal;
  }

  clearCartItems() {
    flutterCart.clearCart();
    notifyListeners();
  }

  double getGrandTotal() {
    return getCartSubTotal() - couponCodeDiscount;
  }

  checkCoupon() async {
    try {
      if (couponController.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Enter a coupon code');
        return;
      }
      List<String> productIds =
          myCartItems.map((cartItem) => cartItem.productId).toList();
      Map<String, dynamic> couponData = {
        "couponCode": couponController.text,
        "purchaseAmount": getCartSubTotal(),
        "productIds": productIds
      };
      final response = await service.addItem(
          endpointUrl: 'couponCodes/check-coupon', itemData: couponData);
      if (response.isOk) {
        final ApiResponse<Coupon> apiResponse = ApiResponse<Coupon>.fromJson(
            response.body,
            (json) => Coupon.fromJson(json as Map<String, dynamic>));
        if (apiResponse.success == true) {
          Coupon? coupon = apiResponse.data;
          if (coupon != null) {
            couponApplied = coupon;
            couponCodeDiscount = getCouponDiscountAmount(coupon);
          }
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Coupon is valid');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to validate Coupon: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
      notifyListeners();
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  double getCouponDiscountAmount(Coupon coupon) {
    double discountAmount = 0;
    String discountType = coupon.discountType ?? 'fixed';
    if (discountType == 'fixed') {
      discountAmount = coupon.discountAmount ?? 0;
      return discountAmount;
    } else {
      double discountPercentage = coupon.discountAmount ?? 0;
      double amountAfterDiscountPercentage =
          getCartSubTotal() * (discountPercentage / 100);
      return amountAfterDiscountPercentage;
    }
  }

  submitOrder(BuildContext context) async {
    if (selectedPaymentOption == 'cod') {
      addOrder(context);
    } else {
      await razorpayPayment(operation: () {
        addOrder(context);
      });
    }
  }

  addOrder(BuildContext context) async {
    try {
      Map<String, dynamic> order = {
        "userID": _userProvider.getLoginUsr()?.sId ?? '',
        "orderStatus": "pending",
        "items": cartItemToOrderItem(myCartItems),
        "totalPrice": getCartSubTotal(),
        "shippingAddress": {
          "phone": phoneController.text,
          "street": streetController.text,
          "city": cityController.text,
          "state": streetController.text,
          "postalCode": postalCodeController.text,
          "country": countryController.text
        },
        "paymentMethod": selectedPaymentOption,
        "couponCode": couponApplied?.sId,
        "orderTotal": {
          "subtotal": getCartSubTotal(),
          "discount": couponCodeDiscount,
          "total": getGrandTotal()
        },
      };
      final response =
          await service.addItem(endpointUrl: 'orders', itemData: order);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Order added');
          clearCouponDiscount();
          clearCartItems();
          Navigator.pop(context);
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add Order: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  List<Map<String, dynamic>> cartItemToOrderItem(List<CartModel> cartItems) {
    return cartItems.map((cartItem) {
      return {
        "productID": cartItem.productId,
        "productName": cartItem.productName,
        "quantity": cartItem.quantity,
        "price": cartItem.variants.safeElementAt(0)?.price ?? 0,
        "variant": cartItem.variants.safeElementAt(0)?.color ?? "",
      };
    }).toList();
  }

  clearCouponDiscount() {
    couponApplied = null;
    couponCodeDiscount = 0;
    couponController.text = '';
    notifyListeners();
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  Future<void> razorpayPayment({required void Function() operation}) async {
    try {
      Response response =
          await service.addItem(endpointUrl: 'payment/razorpay', itemData: {});
      final data = await response.body;
      String? razorpayKey = data['key'];
      if (razorpayKey != null && razorpayKey != '') {
        var options = {
          'key': razorpayKey,
          'amount': getGrandTotal() * 100,
          'name': "user",
          "currency": 'INR',
          'description': 'Your transaction description',
          'send_sms_hash': true,
          "prefill": {
            "email": _userProvider.getLoginUsr()?.email,
            "contact": ''
          },
          "theme": {'color': '#FFE64A'},
          "image":
              'https://res.cloudinary.com/dqkgm7wuy/image/upload/v1716048792/chat-app-file/jobgrvvuql7e1r6uctsp.jpg',
        };
        razorpay.open(options);
        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse response) {
          operation();
          return;
        });
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
            (PaymentFailureResponse response) {
          SnackBarHelper.showErrorSnackBar('Error ${response.message}');
          return;
        });
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error$e');
      return;
    }
  }

  void updateUI() {
    notifyListeners();
  }
}
