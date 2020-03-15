class UserProfile {
  String uid;
  String firstName;
  String lastName;
  String carFuelType;
  String carSize;

  int age;
  int daysActive;
  int treesPlanted;

  bool pendingInvite;

  UserProfile({
    this.uid, this.firstName,
    this.lastName, this.age,
    this.carSize, this.carFuelType,
    this.daysActive, this.treesPlanted,
    this.pendingInvite,
  });
}