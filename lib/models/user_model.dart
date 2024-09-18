class UserModel {
  String name;
  String iconPath;
  String totalProjects;
  String averageScore;
  String totalFarmSize;
  bool isCurrentlySelected;

  UserModel({
    required this.name, 
    required this.iconPath,
    required this.totalProjects,
    required this.averageScore,
    required this.totalFarmSize,
    required this.isCurrentlySelected,
    });

  static List<UserModel> getUsers() {
    List<UserModel> users = [];

    users.add(
      UserModel(
        name: 'John Doe',
        iconPath: 'assets/icons/user.svg',
        totalProjects: '5',
        averageScore: '70',
        totalFarmSize: '10 Acres',
        isCurrentlySelected: true,
      ),
    );

    users.add(
      UserModel(
        name: 'Jane Doe',
        iconPath: 'assets/icons/user.svg',
        totalProjects: '3',
        averageScore: '80',
        totalFarmSize: '5 Acres',
        isCurrentlySelected: false,
      ),
    );

    users.add(
      UserModel(
        name: 'John Smith',
        iconPath: 'assets/icons/user.svg',
        totalProjects: '7',
        averageScore: '60',
        totalFarmSize: '15 Acres',
        isCurrentlySelected: false,
      ),
    );

    users.add(
      UserModel(
        name: 'Jane Smith',
        iconPath: 'assets/icons/user.svg',
        totalProjects: '4',
        averageScore: '90',
        totalFarmSize: '8 Acres',
        isCurrentlySelected: false,
      ),
    );

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