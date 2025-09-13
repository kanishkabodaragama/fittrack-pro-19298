class Goal {
  final int? id;
  final String title;
  final int target;
  final int progress;
  final bool completed;

  const Goal({
    this.id,
    required this.title,
    required this.target,
    this.progress = 0,
    this.completed = false,
  });

  Goal copyWith({
    int? id,
    String? title,
    int? target,
    int? progress,
    bool? completed,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'target': target,
      'progress': progress,
      'completed': completed ? 1 : 0,
    };
  }

  static Goal fromMap(Map<String, Object?> map) {
    return Goal(
      id: map['id'] as int?,
      title: map['title'] as String,
      target: map['target'] as int,
      progress: map['progress'] as int,
      completed: (map['completed'] as int) == 1,
    );
  }
}
