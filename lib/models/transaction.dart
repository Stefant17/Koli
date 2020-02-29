class UserTransaction{
  String transID;
  int amount;
  String company;
  String date;
  String mcc;
  String category;
  String categoryID;
  String region;

  UserTransaction({
    this.transID, this.amount,
    this.company, this.date,
    this.mcc, this.categoryID,
    this.category, this.region
  });
}