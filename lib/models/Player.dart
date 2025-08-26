class Player{
  final int id;
  final String name;
  final String position;
  final String national_team;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.national_team
});

  factory Player.fromJson(Map<String,dynamic>json){
    return Player(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        national_team: json['national_team']
    );
  }
}