class UserProfile {
  String uid;
  String firstName;
  String lastName;
  String carFuelType;
  String carSize;
  String username;

  int age;
  int daysActive;
  int treesPlanted;
  int co2ForCurrentMonth;

  bool pendingInvite;

  String meat;
  String veg;
  String fruit;
  String fish;
  String dairy;
  String grains;
  String nuts;



  UserProfile({
    this.uid, this.firstName,
    this.lastName, this.age,
    this.carSize, this.carFuelType,
    this.daysActive, this.treesPlanted,
    this.pendingInvite,
    this.meat, this.fish, this.fruit, this.dairy, this.grains,
    this.username, this.co2ForCurrentMonth,
  });

}