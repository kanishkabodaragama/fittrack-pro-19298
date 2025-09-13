class Workout {
  final int? id;
  final DateTime date;
  final String type;
  final int durationMinutes;
  final String? notes;

  const Workout({
    this.id,
    required this.date,
    required this.type,
    required this.durationMinutes,
    this.notes,
  });

  Workout copyWith({
    int? id,
    DateTime? date,
    String? type,
    int? durationMinutes,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }

  static Workout fromMap(Map<String, Object?> map) {
    return Workout(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      type: map['type'] as String,
      durationMinutes: map['duration_minutes'] as int,
      notes: map['notes'] as String?,
    );
  }
}
