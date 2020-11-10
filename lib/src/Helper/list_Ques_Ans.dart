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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: DropdownButton(
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
      Ans(1, 'Rất tốt'),
      Ans(2, 'Tốt'),
      Ans(3, 'Hài lòng'),
      Ans(4, 'Không hài lòng'),
    ];
  }
}
