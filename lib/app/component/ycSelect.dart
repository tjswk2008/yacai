import 'package:flutter/material.dart';

class YCSelect extends StatefulWidget {
  /// List of Widgets you'll display after you tap the child
  final List<String> items;

  /// Listener when you select any item from the Selection List
  final ValueChanged<int> onSelectedItemChanged;

  /// Width of each Item of the Selection List
  final double itemWidth;

  /// Selected index of your selection list
  final int selectedIndex;
  
  YCSelect({this.selectedIndex,
    @required this.items,
    @required this.onSelectedItemChanged,
    @required this.itemWidth,});
  
  @override
  State<StatefulWidget> createState() => YCSelectState();
}

class YCSelectState extends State<YCSelect> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return Stack(
      children: <Widget>[
        new InkWell(
          onTap: () {
            setState(() {
             isMenuOpen = !isMenuOpen; 
            });
          },
          child: Container(
            height: 60.0*factor,
            width: widget.itemWidth,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10*factor),
                  child: Text(widget.items[widget.selectedIndex], style: TextStyle(fontSize: 26*factor),),
                ),
                Icon(isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 40*factor,),
              ],
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            isMenuOpen ? Positioned(
              top: 60.0*factor,
              child: Container(
                width: widget.itemWidth,
                height: 70*widget.items.length*factor,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length, itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSelectedItemChanged(index);
                        setState(() {
                          isMenuOpen = !isMenuOpen; 
                        });
                      },
                      child: Container(
                        height: 70.0*factor,
                        width: widget.itemWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(width: factor, color: Colors.grey[300])
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.items[index], style: TextStyle(fontSize: 26*factor),),
                          ],
                        )
                      ),
                    );
                  }
                ),
              )
            ) : Container()
          ],
        )
      ],
    );
  }
}