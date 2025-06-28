import '../models/medicine.dart';

class MedicineService {
  Future<List<Medicine>> fetchMedicines() async {
    return [
      Medicine(
        name: "Paracetamol",
        price: 2.50,
        category: "Pain Relief",
        imageUrl:
            "https://img.freepik.com/free-photo/white-pills-white-background_23-2147879387.jpg",
      ),
      // You can later replace this with a DB or API
    ];
  }

  Future<void> addMedicine(Medicine medicine) async {
    // Insert to database
  }
}
