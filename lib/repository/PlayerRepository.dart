import 'package:goldapi/models/Player.dart';
import 'package:goldapi/services/player_service.dart';
import 'package:goldapi/utils/constant.dart';

class PlayerRepository{


  static Future<List<Player>>fetchPlayers({
    required int teamId,
    required int season,
    int page=1,
    int perPage=20,
    CanelToken?cancelToken,
    ProgressCb? onProgress
}) async{
    final data= await PlayerService.fetchPlayers(
        teamId: teamId,
        season: season,
        page: page,
        perPage: perPage,
        // cancelToken: cancelToken,
        // onProgress: onProgress
    );
    return data.map<Player>((json) => Player.fromJson(json as Map<String, dynamic>)).toList();
  }
}