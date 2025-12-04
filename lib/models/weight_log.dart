import 'package:isar_community/isar.dart';

part 'weight_log.g.dart';

@collection
class WeightLog {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late double weight;

}
