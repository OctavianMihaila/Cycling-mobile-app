import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/time_counter_provider.dart';
import 'info_field.dart';

class RideDetailsPopUpBox extends StatelessWidget {
  final double width;
  final double height;

  const RideDetailsPopUpBox({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeCounterProvider>(
      builder: (context, timeCounterProvider, _) {
        return Stack(
          children: [
            Center(
              child: Container(
                width: width * 0.8,
                height: height * 0.2,
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
                              fieldValue: context.watch<TimeCounterProvider>().getCurrentTime(),
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
      },
    );
  }
}
