class ApiConstants{
  static const String baseurl= "api.balldontlie.io";
  static const String token= "82796606-adde-4c4b-bb0b-486d3b231795";

  static String players(int teamId) => "/epl/v1/teams/$teamId/players";

}

class CanelToken{
  bool _cancelled= false;
  bool get isCancelled=> _cancelled;
  void cancel() => _cancelled=true;
}
typedef ProgressCb= void Function(double progress);