class TodoModel {
  final int? id;
  final String title;
  final String desc;
  final int priorities;
  final String createdAt;
  TodoModel({
    this.id,
    required this.title,
    required this.desc,
    required this.priorities,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['ID'] = id;
    map['Title'] = title;
    map['Desc'] = desc;
    map['Priorities'] = priorities;
    map['Created'] = createdAt;
    return map;
  }

  factory TodoModel.fromJson(Map<String, dynamic> map) => TodoModel(
        id: map['ID'],
        title: map['Title'],
        desc: map['Desc'],
        priorities: map['Priorities'],
        createdAt: map['Created'],
      );
}
