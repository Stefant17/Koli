class UserCard {
  String cardID;
  String cardNumber;
  String cvv;
  String expiry;
  String provider;
  int transCount;

  UserCard({
    this.cardID, this.cardNumber, this.cvv,
    this.expiry, this.provider, this.transCount
  });
}