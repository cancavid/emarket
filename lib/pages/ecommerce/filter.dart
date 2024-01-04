import 'dart:convert';
import 'package:get/get.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/functions.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets_extra/behaviour.dart';
import 'package:meqamax/widgets/button.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterPage extends StatefulWidget {
  final List data;
  final String disable;

  const FilterPage({super.key, required this.data, this.disable = ''});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  Map data = {};
  Map variables = {};
  Map selecteds = {};
  Map selectedsNames = {};
  List localSelects = [];
  List price = [0, Ecommerce.maxPrice];
  SfRangeValues priceRange = SfRangeValues(0.0, Ecommerce.maxPrice);

  Future<void> get() async {
    if (await checkConnectivity()) {
      final url = Uri.parse('${App.domain}/api/filter.php?action=get&disable=${widget.disable}&lang=${Get.locale?.languageCode}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          var result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            data = result['result'];
            for (var item in data.keys) {
              selecteds[item] = widget.data[0][item] ?? [];
              selectedsNames[item] = widget.data[1][item] ?? [];
              variables[item] = data[item]['terms'];
            }
            price = widget.data[2];
            priceRange = SfRangeValues(price[0], price[1]);
          }
        });
      } else {
        setState(() {
          loading = false;
          serverError = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        connectError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(
          title: 'Filter'.tr,
          action: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onTap: () {
              setState(() {
                selecteds.forEach((key, value) {
                  selecteds[key] = [];
                });
                selectedsNames.forEach((key, value) {
                  selectedsNames[key] = [];
                });
                localSelects = [];
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text('Təmizlə'.tr),
            ),
          )),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.keys.length,
                        itemBuilder: (context, index) {
                          final attr = variables.keys.elementAt(index);
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey4),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  localSelects = localSelects + selecteds[attr];
                                  localSelects = localSelects.toSet().toList();
                                });
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(builder: (BuildContext context, StateSetter stateSetter) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: variables[attr].length,
                                              itemBuilder: (c, i) {
                                                final item = variables[attr].keys.elementAt(i);

                                                return CheckboxListTile(
                                                  activeColor: Theme.of(context).colorScheme.primaryColor,
                                                  value: localSelects.contains(item),
                                                  onChanged: (value) {
                                                    stateSetter(() {
                                                      if (value == false) {
                                                        localSelects.remove(item);
                                                      } else {
                                                        if (!localSelects.contains(item)) {
                                                          localSelects.add(item);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  title: (data[attr]['type'] == 'color')
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              decoration: BoxDecoration(color: hexToColor(variables[attr][item]['color']), borderRadius: BorderRadius.circular(20.0)),
                                                            ),
                                                            SizedBox(width: 15.0),
                                                            Text(variables[attr][item]['term_name'])
                                                          ],
                                                        )
                                                      : Text(variables[attr][item]['term_name']),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
                                            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        localSelects = [];
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('İmtina et'.tr)),
                                                SizedBox(width: 10.0),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedsNames[attr] = [];
                                                        selecteds[attr] = localSelects;
                                                        for (var item in selecteds[attr]) {
                                                          selectedsNames[attr].add(data[attr]['terms'][item]['term_name']);
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Təsdiqlə'.tr))
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                  },
                                ).whenComplete(() {
                                  setState(() {
                                    localSelects = [];
                                  });
                                });
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                              title: Text(
                                data[data.keys.elementAt(index)]['name'].toString(),
                                style: const TextStyle(fontSize: 17.0),
                              ),
                              subtitle: (selectedsNames[attr].length != 0)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 7.0),
                                        Text(selectedsNames[attr].join(', '), style: TextStyle(color: Colors.grey)),
                                      ],
                                    )
                                  : null,
                              trailing: Icon(Icons.keyboard_arrow_down),
                            ),
                          );
                        }),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
                        child: Text('Qiymət aralığı'.tr, style: TextStyle(fontSize: 17.0)),
                      ),
                      SfRangeSlider(
                        min: 0.0,
                        max: Ecommerce.maxPrice,
                        values: priceRange,
                        interval: 500,
                        showTicks: false,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (SfRangeValues values) {
                          setState(() {
                            priceRange = values;
                            price = [priceRange.start, priceRange.end];
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Ink(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              color: Theme.of(context).colorScheme.secondaryBg,
              child: MsButton(
                onTap: () {
                  Navigator.pop(context, [selecteds, selectedsNames, price]);
                },
                title: 'Filterlə'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
