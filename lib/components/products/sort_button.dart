import 'package:meqamax/themes/ecommerce.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:meqamax/widgets/bottom_sheet_liner.dart';
import 'package:meqamax/widgets/radio_listtile.dart';

class SortButton extends StatefulWidget {
  const SortButton({super.key, required this.onChanged, required this.orderType});

  final Function(dynamic) onChanged;
  final String orderType;

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  String selectedSort = '';

  Map sorts = Ecommerce.sorts;
  @override
  void initState() {
    super.initState();
    selectedSort = widget.orderType;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MsBottomSheetLiner(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sorts.keys.map((key) {
                        List<dynamic> sort = sorts[key]!;

                        return MsRadioListTile(
                          title: sort[0],
                          value: key,
                          groupValue: selectedSort,
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                selectedSort = value;
                              });
                            }
                            Navigator.of(context).pop();
                            widget.onChanged(value);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          },
          child: Ink(
            color: Theme.of(context).colorScheme.secondaryBg,
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Icon(Icons.sort),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    Ecommerce.sorts[selectedSort]![0].toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
