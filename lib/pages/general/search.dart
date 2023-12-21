import 'package:get/get.dart';
import 'package:meqamax/components/app/appbar_back_button.dart';
import 'package:meqamax/components/products/load_products.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String search = '';
  final box = GetStorage();
  List history = [];
  List displayHistory = [];
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey loadProductsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    box.writeIfNull('history', []);
    history = box.read('history');
    displayHistory = history.reversed.take(10).toList();
  }

  void _searchSubmit() {
    setState(() {
      search = _textEditingController.text;
    });
    if (search != '') {
      history.remove(search);
      history.add(search);
      box.write('history', history);
      loadProductsKey = GlobalKey();
    }
    displayHistory = history.reversed.take(10).toList();
  }

  void _removeItem(value) {
    setState(() {
      history.remove(value);
      displayHistory = history.reversed.take(10).toList();
    });
    box.write('history', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryBg,
      appBar: AppBar(
        leading: AppBarBackButton(),
        title: Text('Axtarış'.tr),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    hintText: 'Məhsullar üzrə axtarış...'.tr,
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 60,
                      minHeight: 2,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (search != '') ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                search = '';
                                _textEditingController.text = '';
                              });
                            },
                            child: MsSvgIcon(
                              icon: 'assets/interface/cancel.svg',
                              color: Theme.of(context).colorScheme.grey1,
                              size: 15.0,
                            ),
                          ),
                          SizedBox(width: 10.0),
                        ],
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _searchSubmit();
                          },
                          child: MsSvgIcon(
                            icon: 'assets/interface/search.svg',
                            color: Theme.of(context).colorScheme.grey1,
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    )),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  _searchSubmit();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      search = value;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        if (search != '') ...[
          Expanded(
            child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.bg,
                child: LoadProducts(
                  key: loadProductsKey,
                  search: search,
                )),
          )
        ] else if (history.isNotEmpty) ...[
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                shrinkWrap: true,
                children: [
                  if (displayHistory.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Son axtarışlar'.tr)),
                        SizedBox(width: 15.0),
                        GestureDetector(
                          onTap: () {
                            box.write('history', []);
                            setState(() {
                              displayHistory = [];
                            });
                          },
                          child: Text('Keçmişi təmizlə'.tr, style: Theme.of(context).textTheme.link),
                        )
                      ],
                    ),
                  ],
                  SizedBox(height: 25.0),
                  for (var item in displayHistory) ...[
                    Row(
                      children: [
                        Icon(Icons.search, color: Theme.of(context).colorScheme.grey2, size: 20.0),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                search = item;
                                _textEditingController.text = item;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                item,
                                style: TextStyle(height: 1.0),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              _removeItem(item);
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
                              child: MsSvgIcon(
                                icon: 'assets/interface/cancel.svg',
                                size: 12.0,
                                color: Theme.of(context).colorScheme.grey1,
                              ),
                            )),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          )
        ]
      ]),
    );
  }
}
