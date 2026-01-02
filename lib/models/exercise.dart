import 'package:isar_community/isar.dart';

import '../utils/datatypes.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;
  late String name;
  @enumerated
  late BodyPart bodyPart;
  @enumerated
  late Difficulty difficulty;
  String? moreInformationURL;
}
