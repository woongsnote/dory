import 'package:flutter/material.dart';
import 'package:dory/components/dory_widgets.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({
    Key? key,
    required this.onPressedModify,
    required this.onPressedDeleteOnlyMedicine,
    required this.onPressedDeleteAll,
  }) : super(key: key);
  final VoidCallback onPressedModify;
  final VoidCallback onPressedDeleteOnlyMedicine;
  final VoidCallback onPressedDeleteAll;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.blue),
            onPressed: onPressedDeleteOnlyMedicine,
            child: const Text('약 정보 삭제'),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.redAccent),
            onPressed: onPressedDeleteOnlyMedicine,
            child: const Text('약 정보 삭제'),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.redAccent),
            onPressed: onPressedDeleteAll,
            child: const Text('약 기록과 함께 약 정보 삭제'),
          ),
        ),
      ],
    );
  }
}
