class CardModel {
  final String name, image, date;

  CardModel({required this.name, required this.image, required this.date});
}

List<CardModel> demoCardData = [
  CardModel(
    name: "Aniket Pradhan(Brother)",
    image: "group.jpg",
    date: "4-20-30",
  ),
  CardModel(
    name: "Aditya kushwaha(Friend)",
    image: "aditya.jpg",
    date: "4-28-31",
  ),
];
