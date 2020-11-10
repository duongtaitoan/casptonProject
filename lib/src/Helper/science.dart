import 'package:flutter/material.dart';


class ScienceDropDown extends StatefulWidget {
  @override
  ScienceDropDownState createState() => ScienceDropDownState();
}

class ScienceDropDownState extends State<ScienceDropDown> {
  List<Course> _science = Course.getCourse();
  List<DropdownMenuItem<Course>> _dropdownMenuItems;
  Course _selected;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_science);
    _selected = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Course>> buildDropdownMenuItems(List science) {
    List<DropdownMenuItem<Course>> items = List();
    for (Course sciences in science) {
      items.add(
        DropdownMenuItem(
          value: sciences,
          child: Text(sciences.nameCourse)),
      );
    }
    return items;
  }

  onChangeDropdownItem(Course selected) {
    setState(() {
      _selected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: DropdownButton(
        isExpanded: true,
        value: _selected,
        items: _dropdownMenuItems,
        onChanged: onChangeDropdownItem,
      ),
    );
  }
}



class Course {
  int id;
  String nameCourse;

  Course(this.id, this.nameCourse);

  static List<Course> getCourse() {
    return <Course>[
      Course(1, 'not Semester'),
      Course(2, '1'),
      Course(3, '2'),
      Course(4, '3'),
      Course(5, '4'),
      Course(6, '5'),
      Course(7, '6'),
      Course(8, '7'),
      Course(9, '8'),
      Course(10, '9'),
    ];
  }
}