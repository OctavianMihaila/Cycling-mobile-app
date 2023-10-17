import 'package:flutter/material.dart';

class SaveRideDialog extends StatefulWidget {
  final VoidCallback onSaveCallback;

  SaveRideDialog({required this.onSaveCallback});

  @override
  _SaveRideDialogState createState() => _SaveRideDialogState();
}

class _SaveRideDialogState extends State<SaveRideDialog> {
  final TextEditingController _rideNameController = TextEditingController();
  bool _saveRide = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Ride Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Do you want to save the ride details?'),
          Row(
            children: <Widget>[
              Checkbox(
                value: _saveRide,
                onChanged: (value) {
                  setState(() {
                    _saveRide = value!;
                  });
                },
              ),
              const Text('Yes, save the ride details'),
            ],
          ),
          if (_saveRide)
            TextField(
              controller: _rideNameController,
              decoration: const InputDecoration(labelText: 'Ride Name'),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: () {
            if (_saveRide) {
              String activityName = _rideNameController.text;
              widget.onSaveCallback();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
