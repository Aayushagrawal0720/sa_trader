import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/Resources/Color.dart';

class CustomFilterChip extends StatefulWidget {
  String label;
  bool selected;
  int id;
  Function onSelected;

  CustomFilterChip({this.selected, this.id, this.label, this.onSelected});

  @override
  _FilterChipState createState() => _FilterChipState();
}

class _FilterChipState extends State<CustomFilterChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: widget.onSelected,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 5, maxWidth: MediaQuery.of(context).size.width / 2),
          child: Container(
            decoration: BoxDecoration(
                color: widget.selected ? ColorsTheme.themeLightOrange : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Text(
                widget.label,
                style: TextStyle(
                    color: widget.selected ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
