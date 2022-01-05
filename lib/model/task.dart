class Task {
  Task();

  int id;
  String title;
  String description;
  bool completed;
  DateTime createTime;

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    completed = map['completed'] == 1;
    createTime = getCreateTime(map['create_time']);
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
    if (createTime == null) {
      map['create_time'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    return map;
  }

  DateTime getCreateTime(String time) {
    if (time == null || time.isEmpty) {
      return DateTime.now();
    } else {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    }
  }
}
