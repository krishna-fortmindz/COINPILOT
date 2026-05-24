import '../../api_client.dart';
import '../../../end_points.dart';
import 'predictions_repo.dart';
import 'models/predictions_models.dart';

class PredictionsRepoImpl implements PredictionsRepo {
  final _api = ApiClient.instance;

  List<T> _parseList<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    List<dynamic> list = [];
    if (raw is List) {
      list = raw;
    } else if (raw is Map) {
      list = raw['items'] as List? ??
          raw['data'] as List? ??
          raw['results'] as List? ??
          [];
    }
    return list.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  Map<String, dynamic> _unwrap(Map<String, dynamic>? raw) {
    final data = raw?['data'];
    if (data is Map<String, dynamic>) return data;
    return raw ?? {};
  }

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionsLeaderboard,
    );
    return _parseList(res.data?['data'], LeaderboardEntry.fromJson);
  }

  @override
  Future<CoinAccuracy> fetchAccuracy(String coinId) async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionAccuracy(coinId),
    );
    return CoinAccuracy.fromJson(_unwrap(res.data));
  }

  @override
  Future<List<PredictionRecord>> fetchHistory(String coinId) async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionHistory(coinId),
    );
    return _parseList(res.data?['data'], PredictionRecord.fromJson);
  }

  @override
  Future<List<PostMortem>> fetchPostMortems(String coinId) async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionPostMortems(coinId),
    );
    return _parseList(res.data?['data'], PostMortem.fromJson);
  }

  @override
  Future<void> submitUserPrediction(UserPrediction prediction) async {
    await _api.post<Map<String, dynamic>>(
      EndPoints.predictionsUser,
      data: prediction.toJson(),
    );
  }

  @override
  Future<List<PredictionRecord>> fetchUserMine(String userId) async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionsUserMine,
      queryParams: {'userId': userId},
    );
    return _parseList(res.data?['data'], PredictionRecord.fromJson);
  }

  @override
  Future<UserVsAi> fetchUserVsAi(String userId) async {
    final res = await _api.get<Map<String, dynamic>>(
      EndPoints.predictionsUserVsAi,
      queryParams: {'userId': userId},
    );
    return UserVsAi.fromJson(_unwrap(res.data));
  }
}
