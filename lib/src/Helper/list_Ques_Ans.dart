import 'package:flutter/material.dart';

class QADropDown extends StatefulWidget {
  @override
  QADropDownState createState() => QADropDownState();
}

class QADropDownState extends State<QADropDown> {
  List<Ans> _ans = Ans.getAns();
  List<DropdownMenuItem<Ans>> _dropdownMenuItems;
  Ans _selectedAns;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_ans);
    _selectedAns = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Ans>> buildDropdownMenuItems(List ans) {
    List<DropdownMenuItem<Ans>> items = List();
    for (Ans anser in ans) {
      items.add(
        DropdownMenuItem(
          value: anser,
          child: Text(anser.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Ans selectedAns) {
    setState(() {
      _selectedAns = selectedAns;
    });
  }

  @override
  Widget build(BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(left: 16.0,right: 16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedAns,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class Ans {
  int id;
  String name;

  Ans(this.id, this.name);

  static List<Ans> getAns() {
    return <Ans>[
      Ans(1, 'Kém'),
      Ans(2, 'Trung bình'),
      Ans(3, 'Khá'),
      Ans(4, 'Tốt'),
      Ans(5, 'Xuất sắc'),
    ];
  }
}
