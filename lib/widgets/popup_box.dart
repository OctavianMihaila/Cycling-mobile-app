import 'package:cycling_route_planner/widgets/info_field.dart';
import 'package:flutter/material.dart';

class RecordDetailsPopUpBox extends StatefulWidget {
  final double width;
  final double height;

  const RecordDetailsPopUpBox({
    required this.width,
    required this.height,
  });

  @override
  _RecordDetailsPopUpBoxState createState() => _RecordDetailsPopUpBoxState();
}

class _RecordDetailsPopUpBoxState extends State<RecordDetailsPopUpBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isBoxVisible = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: widget.width * 0.8,
            height: widget.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: InfoField(
                          fieldName: 'Duration',
                          fieldValue: '00:00:00',
                        ),
                      ),
                      Expanded(
                        child: InfoField(
                          fieldName: 'Speed',
                          fieldValue: '0.0 km/h',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: InfoField(
                          fieldName: 'Distance',
                          fieldValue: '0.0 km',
                        ),
                      ),
                      Expanded(
                        child: InfoField(
                          fieldName: 'Avg',
                          fieldValue: '0.0 km/h',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}