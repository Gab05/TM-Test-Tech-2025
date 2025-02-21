import 'package:app/api/ticketmaster_events_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ticketmaster_events_api_test.mocks.dart';

class TestAssetBundle extends AssetBundle {
  @override
  Future<String> loadString(String asset, {bool cache = true}) async {
    if (asset == 'auth/secret.json') {
      return Future.value('{ "api_key": "test_api_key" }');
    }
    return Future.value("");
  }

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError();
  }
}

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TicketmasterEventsApi', () {
    final mockClient = MockClient();
    final testWidget = const Scaffold();

    group('fetchEvent', () {
      final String testEventId = 'test_event_id';
      final String testEventName = 'test_event_name';
      final String testEventDate = '2025-02-06T02:30:00Z';
      testWidgets(
        'when the http client returns a 200 status response, should return the event data',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: DefaultAssetBundle(
                bundle: TestAssetBundle(),
                child: testWidget,
              ),
            ),
          );
          when(
            mockClient.get(
              Uri.parse(
                'https://app.ticketmaster.com/discovery/v2/events/$testEventId.json?apikey=test_api_key',
              ),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              '{"name": "$testEventName", "dates": { "start": { "dateTime": "$testEventDate" } } }',
              200,
            ),
          );

          final service = TicketmasterEventsApi(client: mockClient);
          var resultEvent = await service.fetchEvent(
            testEventId,
            tester.element(find.byWidget(testWidget)),
          );

          expect(testEventName, resultEvent?.name);
          expect(testEventDate, resultEvent?.date);
        },
      );

      testWidgets(
        'when the http client returns another status than 200, should throw',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: DefaultAssetBundle(
                bundle: TestAssetBundle(),
                child: testWidget,
              ),
            ),
          );
          final mockClient = MockClient();
          when(
            mockClient.get(
              Uri.parse(
                'https://app.ticketmaster.com/discovery/v2/events/$testEventId.json?apikey=test_api_key',
              ),
            ),
          ).thenAnswer((_) async => http.Response('{"error": "test"}', 500));

          final service = TicketmasterEventsApi(client: mockClient);

          expect(() async => await service.fetchEvent(
            testEventId,
            tester.element(find.byWidget(testWidget)),
          ), throwsA(isA<Exception>()));
        },
      );
    });
  });
}
