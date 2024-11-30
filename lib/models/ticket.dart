class Ticket {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String categoryId;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.categoryId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      categoryId: json['categoryId'],
    );
  }
}