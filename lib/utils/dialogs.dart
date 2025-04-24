import 'package:flutter/material.dart';

Future<String?> showRoleSelectionDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String selectedRole = 'User'; // Default role

      return AlertDialog(
        title: Text('Select Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please choose your role to continue'),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['User', 'Doctor'].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          ElevatedButton(
            child: Text('Continue'),
            onPressed: () => Navigator.of(context).pop(selectedRole),
          ),
        ],
      );
    },
  );
}
