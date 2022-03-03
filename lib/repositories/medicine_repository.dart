import 'package:dory/models/medicine.dart';
import 'package:dory/repositories/dory_hive.dart';
import 'package:hive/hive.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    _medicineBox ??= Hive.box<Medicine>(DoryHiveBox.medicine);
    return _medicineBox!;
  }

  void addMedicine(Medicine medicine) async {
    await medicineBox.add(medicine);
    // print(key);
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);
  }

  void updateMedicine({required int key, required Medicine medicine}) async {
    await medicineBox.put(key, medicine);
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
