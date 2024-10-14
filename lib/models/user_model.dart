class UserModel {
  final String uid;

  String name;
  String iconPath;
  int totalProjects;
  String averageScore;
  String totalFarmSize;
  bool isCurrentlySelected;

  UserModel({
    required this.uid,
    this.name = "", 
    required this.iconPath,
    this.totalProjects = 0,
    this.averageScore = "0",
    this.totalFarmSize = "",
    this.isCurrentlySelected = false,
    });

  static List<UserModel> getUsers() {
    List<UserModel> users = [];
    users.add(UserModel(uid: "1", name: "John Doe", iconPath: "assets/icons/user.svg", totalProjects: 5, averageScore: "4.5", totalFarmSize: "10 acres", isCurrentlySelected: false));
    users.add(UserModel(uid: "2", name: "Jane Doe", iconPath: "assets/icons/user.svg", totalProjects: 3, averageScore: "4.0", totalFarmSize: "5 acres", isCurrentlySelected: false));
    users.add(UserModel(uid: "3", name: "John Smith", iconPath: "assets/icons/user.svg", totalProjects: 2, averageScore: "3.5", totalFarmSize: "3 acres", isCurrentlySelected: false));
    users.add(UserModel(uid: "4", name: "Jane Smith", iconPath: "assets/icons/user.svg", totalProjects: 1, averageScore: "3.0", totalFarmSize: "2 acres", isCurrentlySelected: false));
    users.add(UserModel(uid: "5", name: "John Doe", iconPath: "assets/icons/user.svg", totalProjects: 5, averageScore: "4.5", totalFarmSize: "10 acres", isCurrentlySelected: false));

    return users;
  }


  // UserModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'];
  //   email = json['email'];
  //   password = json['password'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['email'] = email;
  //   data['password'] = password;
  //   return data;
  // }
}