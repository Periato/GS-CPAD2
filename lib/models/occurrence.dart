
class Occurrence {
  final String id;
  final String neighborhood;
  final String type;
  final String description;
  final String referencePoint;
  final DateTime date;

  Occurrence({
    required this.id,
    required this.neighborhood,
    required this.type,
    required this.description,
    required this.referencePoint,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'neighborhood': neighborhood,
      'type': type,
      'description': description,
      'referencePoint': referencePoint,
      'date': date.toIso8601String(),
    };
  }

  factory Occurrence.fromMap(Map<String, dynamic> map) {
    return Occurrence(
      id: map['id'],
      neighborhood: map['neighborhood'],
      type: map['type'],
      description: map['description'],
      referencePoint: map['referencePoint'],
      date: DateTime.parse(map['date']),
    );
  }
}
