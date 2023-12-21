import 'package:get/get.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ecommerce {
  static Map<String, List<String>> sorts = {
    'new': ['Ən yenilər'.tr, 'desc', 'post_date'],
    'expensive': ['Əvvəlcə baha'.tr, 'desc', 'final_price'],
    'cheap': ['Əvvəlcə ucuz'.tr, 'asc', 'final_price'],
  };
  static double maxPrice = 2000.0;
}

fixedPrice(price) {
  if (price != '' && price != null && price != 'null') {
    if (price.runtimeType == String) {
      return double.parse(price).toStringAsFixed(2);
    } else if (price.runtimeType == int) {
      return price.toDouble().toStringAsFixed(2);
    }
  }
}

displayPrice(price, finalPrice, {type = 'simple'}) {
  price = fixedPrice(price);
  finalPrice = fixedPrice(finalPrice);
  if (price == finalPrice) {
    return Text('$finalPrice ${App.currency}', style: GoogleFonts.inter(height: 1.0, fontWeight: FontWeight.w600, fontSize: (type == 'simple') ? 13.0 : 20.0));
  } else {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 5.0,
      children: [
        Text('$finalPrice ${App.currency}', style: GoogleFonts.inter(height: 1.0, fontWeight: FontWeight.w600, fontSize: (type == 'simple') ? 13.0 : 20.0)),
        SizedBox(width: 5.0),
        Text('$price ${App.currency}', style: GoogleFonts.inter(color: Color(0xFF999999), height: 1.0, decoration: TextDecoration.lineThrough, fontSize: (type == 'simple') ? 10.0 : 13.0)),
      ],
    );
  }
}

getOrderStatus(status) {
  String data = 'Gözləyir'.tr;
  if (status == 'pending') {
    data = 'Gözləyir'.tr;
  } else if (status == 'confirmed') {
    data = 'Təsdiqləndi'.tr;
  } else if (status == 'completed') {
    data = 'Tamamlandı'.tr;
  } else if (status == 'canceled') {
    data = 'Ləğv edildi'.tr;
  } else if (status == 'whatsapp') {
    data = 'Whatsapp sifarişi'.tr;
  } else if (status == 'waiting-payment') {
    data = 'Ödəniş edilməyib'.tr;
  } else if (status == 'cargo') {
    data = 'Kuryerə verildi'.tr;
  }
  return data;
}

getPaymentMethod(method) {
  String method = 'Qapıda ödəniş'.tr;
  if (method == 'online') {
    method = 'Onlayn ödəniş'.tr;
  } else if (method == 'offline') {
    method = 'Qapıda ödəniş'.tr;
  }
  return method;
}
