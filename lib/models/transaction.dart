class UserTransaction{
  String transID;
  int amount;
  int co2;
  String company;
  String companyID;
  String date;
  String mcc;
  String category;
  String categoryID;
  String region;

  UserTransaction({
    this.transID, this.amount,
    this.company, this.companyID,
    this.date, this.mcc, this.categoryID,
    this.category, this.region,
    this.co2
  });
}