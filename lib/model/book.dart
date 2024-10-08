class Book {
  final String? id;
  final String ?name;
  final String ?type;
  final String ?rack;


  const Book({
     this.id,
     this.name,
     this.type,
     this.rack,

  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['_id'],
        name: json['name']==null? '': json['name'],
        type:  json['type']==null? '': json['type'],
        rack:  json['rack']==null? '': json['rack'],

      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'rack': rack,

      };
}