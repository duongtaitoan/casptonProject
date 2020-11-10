import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SemesterDropDown extends StatefulWidget {
  @override
  SemesterDropDownState createState() => SemesterDropDownState();
}

class SemesterDropDownState extends State<SemesterDropDown> {
  List<Semester> _semester = Semester.getSemester();
  List<DropdownMenuItem<Semester>> _dropdownMenuItems;
  Semester _selected;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_semester);
    _selected = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Semester>> buildDropdownMenuItems(List semer) {
    List<DropdownMenuItem<Semester>> items = List();
    for (Semester semester in semer) {
      items.add(
        DropdownMenuItem(
          value: semester,
          child: Text(semester.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Semester selected) {
    setState((){
      _selected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: DropdownButton(
                isExpanded: true,
                value: _selected,
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

class Semester {
  int id;
  String name;

  Semester(this.id, this.name);

  static List<Semester> getSemester() {
    return <Semester>[
      Semester(1, 'Information system'),
      Semester(2, 'Business Management'),
      Semester(3, 'English Language'),
      Semester(4, 'Japan Language'),
      Semester(5, 'Korean Language'),
    ];
  }
}
