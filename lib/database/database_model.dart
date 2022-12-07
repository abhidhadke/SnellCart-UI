import 'package:hive/hive.dart';

part 'database_model.g.dart';

@HiveType(typeId:0)
class Mock{

  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String job;

  @HiveField(3)
  String number;

   Mock({
     required this.name,
     this.id,
     required this.job,
     required this.number
});

}