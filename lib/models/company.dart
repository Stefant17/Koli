class Company {
  String companyID;
  String mccID;
  String name;
  String region;
  bool co2Friendly;

  int co2;
  Company({
    this.companyID, this.mccID,
    this.name, this.region, this.co2,
    this.co2Friendly
  });
}