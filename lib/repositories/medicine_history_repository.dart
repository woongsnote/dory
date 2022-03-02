import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:dory/models/medicine_history.dart';
import 'package:dory/repositories/dory_hive.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    _historyBox ??= Hive.box<MedicineHistory>(DoryHiveBox.medicineHistory);
    return _historyBox!;
  }

  void addHistory(MedicineHistory history) async {
    int key = await historyBox.add(history);
    print(key);
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);
  }

  void updateHistory(
      {required int key, required MedicineHistory history}) async {
    await historyBox.put(key, history);
  }

  void deleteAllHistory(Iterable<int> keys) async {
    await historyBox.deleteAll(keys);

    log('[deleteHistory] delete (key:$keys)');
    log('result ${historyBox.values.toList()}');
  }
}
