import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meqamax/themes/theme.dart';

class VariationProduct extends StatefulWidget {
  final String id;
  final dynamic gallery;
  final Function(String) action;
  final Function slideAction;
  final GlobalKey containerKey;
  final bool attention;

  const VariationProduct({
    super.key,
    required this.id,
    required this.action,
    required this.gallery,
    required this.slideAction,
    required this.containerKey,
    required this.attention,
  });

  @override
  State<VariationProduct> createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> with TickerProviderStateMixin {
  Map data = {};
  Map attributes = {};
  Map attrDetails = {};
  List variations = [];
  Map selecteds = {};
  String price = '';
  String salePrice = '';
  String finalPrice = '';
  String stock = '';
  Map stockControl = {};
  String variation = '';

  get() async {
    var urlText = '${App.domain}/api/variations.php?action=get&id=${widget.id}&lang=${Get.locale?.languageCode}';
    var url = Uri.parse(urlText);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        if (result['status'] == 'success') {
          data = result;
          attributes = data['attr'];
          attrDetails = data['attr_details'];
          variations = data['result'];
          attrDetails.forEach((key, value) {
            selecteds[key] = '';
            stockControl[key] = [];
          });
          // If attribute is single, detect automatically out of stock attributes
          if (attributes.length == 1) {
            stockControl[attributes[0]] = [];
            for (var i = 0; i < variations.length; i++) {
              if (variations[i]['variation_stock'] == '0') {
                var singleAttr = attributes.keys.elementAt(0);
                stockControl[singleAttr].add(variations[i]['variation_$singleAttr']);
              }
            }
          }
          attributes.forEach((key, value) {
            if (attributes[key].length == 1) {
              selecteds[key] = value.keys.elementAt(0);
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    List keys = attrDetails.keys.toList();

    return Container(
        key: widget.containerKey,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).colorScheme.secondaryBg,
            border: Border.all(
              width: 2.0,
              color: (widget.attention) ? Colors.red : Theme.of(context).colorScheme.secondaryBg,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: attrDetails.length,
                itemBuilder: (context, index) {
                  String attr = keys[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(attrDetails[attr]['name'], style: Theme.of(context).textTheme.extraSmallTitle),
                      SizedBox(height: 5.0),
                      Wrap(
                        children: List<Widget>.from(attributes[attr].entries.map((subEntry) {
                          return GestureDetector(
                              onTap: () {
                                if (attrDetails[attr]['type'] == 'color') {
                                  if (widget.gallery is Map && widget.gallery.containsKey(subEntry.key)) {
                                    widget.slideAction(widget.gallery[subEntry.key]);
                                  }
                                }
                                if (!stockControl[attr].contains(subEntry.key)) {
                                  setState(() {
                                    selecteds[attr] = subEntry.key;
                                    for (var i in variations) {
                                      var x = 0;
                                      selecteds.forEach((key, value) {
                                        if (i['variation_$key'] == selecteds[key]) {
                                          x++;
                                        }
                                      });
                                      if (x == selecteds.length) {
                                        price = i['variation_price'];
                                        salePrice = i['variation_sale_price'];
                                        finalPrice = i['variation_final_price'];
                                        stock = i['variation_stock'] ?? '';
                                        widget.action(i['variation_id']);
                                        break;
                                      }
                                    }
                                    for (var a in selecteds.keys) {
                                      if (a != attr) {
                                        stockControl[a] = [];
                                        for (var i in variations) {
                                          if (i['variation_$attr'] == subEntry.key && i['variation_stock'] == '0') {
                                            stockControl[a].add(i['variation_$a']);
                                          }
                                        }
                                      }
                                    }
                                  });
                                }
                              },
                              child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: (attrDetails[attr]['type'] == 'color')
                                        ? Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 32.0,
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: (selecteds[attr].contains(subEntry.key)) ? Colors.black : Colors.grey.shade300),
                                                  borderRadius: BorderRadius.circular(50.0),
                                                ),
                                                child: Tooltip(
                                                  message: subEntry.value['name'],
                                                  child: Container(
                                                    width: 23.0,
                                                    height: 23.0,
                                                    decoration: BoxDecoration(color: hexToColor(subEntry.value['color']), borderRadius: BorderRadius.circular(50.0)),
                                                  ),
                                                ),
                                              ),
                                              if (stockControl[attr].contains(subEntry.key)) ...[
                                                Positioned.fill(
                                                  child: SvgPicture.asset(
                                                    'assets/interface/cancel.svg',
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                      Colors.grey.withOpacity(.7),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    constraints: BoxConstraints(
                                                      minWidth: 45.0,
                                                    ),
                                                    height: 35.0,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.secondaryBg,
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        border: Border.all(
                                                          color: (selecteds[attr].contains(subEntry.key)) ? Colors.black : Theme.of(context).colorScheme.grey3,
                                                        )),
                                                    child: Text(subEntry.value['name'].toString(), style: TextStyle(height: 1.2, fontSize: 12.0)),
                                                  ),
                                                ],
                                              ),
                                              if (stockControl[attr].contains(subEntry.key)) ...[
                                                Positioned.fill(
                                                  child: SvgPicture.asset(
                                                    'assets/interface/cancel.svg',
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                      Colors.grey.withOpacity(.7),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                  )));
                        })),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.0);
                }),
            if (price.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0),
                  displayPrice({'price': price, 'final_price': salePrice}, type: 'Large'),
                  if (stock != '' && stock != '0') ...[
                    SizedBox(height: 5.0),
                    Text(
                      'product_stock'.trParams(
                        {
                          'count': stock.toString(),
                        },
                      ),
                    )
                  ] else if (stock == '0') ...[
                    SizedBox(height: 5.0),
                    Text('Məhsul bitib'.tr)
                  ]
                ],
              )
            ]
          ],
        ));
  }
}
