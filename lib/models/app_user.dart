
class AppUser{
  String uId;
  String name;
  String email;
  String photoUrl;
  String phoneNumber;
  bool isNewUser;
  DateTime memberSince;
  DateTime lastSignInTime;

  AppUser(this.uId, this.name, this.email, this.photoUrl, this.phoneNumber,this.isNewUser,this.memberSince,this.lastSignInTime);
}