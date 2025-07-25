import 'dart:developer';

import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/coupon.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';

class CouponCodeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  Coupon? couponForUpdate;

  final addCouponFormKey = GlobalKey<FormState>();
  TextEditingController couponCodeCtrl = TextEditingController();
  TextEditingController discountAmountCtrl = TextEditingController();
  TextEditingController minimumPurchaseAmountCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  String selectedDiscountType = 'fixed';
  String selectedCouponStatus = 'active';
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Product? selectedProduct;

  CouponCodeProvider(this._dataProvider);

  addCoupon() async {
    try {
      if (endDateCtrl.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Select end date');
        return;
      }
      Map<String, dynamic> coupon = {
        "couponCode": couponCodeCtrl.text,
        "discountType": selectedDiscountType,
        "discountAmount": discountAmountCtrl.text,
        "minimumPurchaseAmount": minimumPurchaseAmountCtrl.text,
        "endDate": endDateCtrl.text,
        "status": selectedCouponStatus,
        "applicableCategory": selectedCategory?.sId,
        "applicableSubCategory": selectedSubCategory?.sId,
        "applicableProduct": selectedProduct?.sId
      };
      final response =
          await service.addItem(endpointUrl: 'couponCodes', itemData: coupon);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Coupon added');
          _dataProvider.getAllCoupons();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add Coupon: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      log(e.toString());
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  updateCoupon() async {
    try {
      if (couponForUpdate != null) {
        Map<String, dynamic> coupon = {
          "couponCode": couponCodeCtrl.text,
          "discountType": selectedDiscountType,
          "discountAmount": discountAmountCtrl.text,
          "minimumPurchaseAmount": minimumPurchaseAmountCtrl.text,
          "endDate": endDateCtrl.text,
          "status": selectedCouponStatus,
          "applicableCategory": selectedCategory?.sId,
          "applicableSubCategory": selectedSubCategory?.sId,
          "applicableProduct": selectedProduct?.sId
        };
        final response = await service.updateItem(
            endpointUrl: 'couponCodes',
            itemData: coupon,
            itemId: couponForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar(apiResponse.message);
            log('Coupon updated');
            _dataProvider.getAllCoupons();
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Failed to update Coupon: ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      log(e.toString());
      SnackBarHelper.showErrorSnackBar('An error occured: $e');
      rethrow;
    }
  }

  submitCoupon() {
    if (couponForUpdate != null) {
      updateCoupon();
    } else {
      addCoupon();
    }
  }

  deleteCoupon(Coupon coupon) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'couponCodes', itemId: coupon.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Coupon Deleted Succesfully');
          _dataProvider.getAllCoupons();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //? set data for update on editing
  setDataForUpdateCoupon(Coupon? coupon) {
    if (coupon != null) {
      couponForUpdate = coupon;
      couponCodeCtrl.text = coupon.couponCode ?? '';
      selectedDiscountType = coupon.discountType ?? 'fixed';
      discountAmountCtrl.text = '${coupon.discountAmount}';
      minimumPurchaseAmountCtrl.text = '${coupon.minimumPurchaseAmount}';
      endDateCtrl.text = '${coupon.endDate}';
      selectedCouponStatus = coupon.status ?? 'active';
      selectedCategory = _dataProvider.categories.firstWhereOrNull(
          (element) => element.sId == coupon.applicableCategory?.sId);
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull(
          (element) => element.sId == coupon.applicableSubCategory?.sId);
      selectedProduct = _dataProvider.products.firstWhereOrNull(
          (element) => element.sId == coupon.applicableProduct?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update coupon
  clearFields() {
    couponForUpdate = null;
    selectedCategory = null;
    selectedSubCategory = null;
    selectedProduct = null;

    couponCodeCtrl.text = '';
    discountAmountCtrl.text = '';
    minimumPurchaseAmountCtrl.text = '';
    endDateCtrl.text = '';
  }

  updateUi() {
    notifyListeners();
  }
}
