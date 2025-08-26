// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
//
// import 'package:flutter/foundation.dart';
// import 'package:goldapi/utils/constant.dart';
// import 'package:http/http.dart' as http;
//
// class PlayerService{
//
//   static Future<List<dynamic>>fetchPlayers({
//     required int teamId,
//     required int season,
//     int page=1,
//     int perPage=20,
//     int maxRetries=3,
//     CanelToken? cancelToken,
//     ProgressCb? onProgress,
//     Duration requestTimeout = const Duration(seconds: 12),
// }) async{
//     int attempt=0;
//     final rng= Random();
//
//     Duration backoff(int n){
//       final base= 200*(1<<(n-1));
//       final jitter= rng.nextInt(120);
//       return Duration(milliseconds: base+jitter);
//     }
//     while(true){
//       if(cancelToken?.isCancelled??false){
//         throw Exception("Request cancelled");
//       }
//       attempt++;
//       http.Client? client;
//
//       try{
//         client= http.Client();
//
//         final uri= Uri(
//           scheme: 'https',
//           host: ApiConstants.baseurl,
//           path: ApiConstants.players(teamId),
//           queryParameters: {
//             'season':season.toString(),
//             'page':page.toString(),
//             'per_page':perPage.toString()
//           },
//         );
//
//         final req = http.Request('GET', uri)..headers.addAll({
//           'Authorization':ApiConstants.token,
//         });
//
//         final streamed = await client.send(req).timeout(requestTimeout);
//
//         final status= streamed.statusCode;
//
//         if(status == 429){
//           client.close();
//           if(attempt >= maxRetries){
//             throw Exception("429 Too Many Requests");
//           }
//           final wait = backoff(attempt);
//           await Future.delayed(wait);
//           continue;
//         }
//         if (status >= 500) {
//           client.close();
//           throw Exception("Server error: $status");
//         }
//         if (status != 200) {
//           client.close();
//           throw Exception("API error: $status");
//         }
//
//         final total= streamed.contentLength;
//         if(total == null || total<= 0){
//           onProgress?.call(-1);
//         }
//         else{
//           onProgress?.call(0.0);
//         }
//
//         final bytes = <int>[];
//         int received =0;
//
//           await for( final chunk in streamed.stream){
//             if(cancelToken?.isCancelled??false){
//               client.close();
//               throw Exception("Request cancelled");
//             }
//             bytes.addAll(chunk);
//             received += chunk.length;
//
//             if(total !=null && total >0){
//               scheduleMicrotask(() => onProgress?.call(received / total));
//             }
//             if (received % 50000 == 0) {
//               await Future.delayed(Duration.zero);
//             }
//           }
//         scheduleMicrotask(() => onProgress?.call(1.0));
//
//           final body= utf8.decode(bytes);
//         debugPrint(body);
//         print("successfully fetched: ${body}");
//
//         final json = jsonDecode(body);
//
//         final data = (json is Map && json['data'] is List) ? json['data'] as List : <dynamic>[];
//
//         final result = <dynamic>[];
//         const chunkSize = 20; // screen per batch
//         for (int i = 0; i < data.length; i += chunkSize) {
//           if (cancelToken?.isCancelled ?? false) throw Exception("Cancelled");
//           final chunk = data.sublist(i, (i + chunkSize).clamp(0, data.length));
//           result.addAll(chunk);
//           // yield frame to UI
//           await Future.delayed(Duration.zero);
//           onProgress?.call((i + chunk.length) / data.length);
//         }
//         onProgress?.call(1.0);
//
//         return result;
//       } catch(e){
//         if (attempt >= maxRetries) rethrow;
//         final wait = backoff(attempt);
//         await Future.delayed(wait);
//       }
//
//     }
//   }
// }
//
//
//
//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:goldapi/utils/constant.dart';

class PlayerService {
  static Future<List<dynamic>> fetchPlayers({
    required int teamId,
    required int season,
    int page = 1,
    int perPage = 20,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: ApiConstants.baseurl,
      path: ApiConstants.players(teamId),
      queryParameters: {
        'season': season.toString(),
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );

    final response = await http.get(uri, headers: {
      'Authorization': ApiConstants.token,
    });

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final jsonBody = jsonDecode(response.body);
    final data = (jsonBody['data'] as List?) ?? <dynamic>[];
    return data;
  }
}