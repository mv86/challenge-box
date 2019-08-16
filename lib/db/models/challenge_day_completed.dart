import 'package:challenge_box/db/constants.dart';

class ChallengeDayCompleted {
  int id;
  int challengeId;
  DateTime completedDate;

  ChallengeDayCompleted(this.challengeId, this.completedDate);

  ChallengeDayCompleted.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    challengeId = map[columnChallengeIdFk];
    completedDate =
        DateTime.fromMillisecondsSinceEpoch(map[columnCompletedDate]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnChallengeIdFk: challengeId,
      columnCompletedDate: completedDate.millisecondsSinceEpoch,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
