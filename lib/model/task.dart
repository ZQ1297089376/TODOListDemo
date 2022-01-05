class Task {
  Task();

  int id;
  String title;
  String description;
  bool completed;
  String createTime;

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'] ?? '';
    completed = map['completed'] == 1;
    createTime = map['create_time'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'completed': completed == true ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
