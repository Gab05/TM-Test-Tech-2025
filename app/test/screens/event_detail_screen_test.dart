import 'package:app/api/ticketmaster_events_api.dart';
import 'package:app/model/simple_event.dart';
import 'package:app/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_detail_screen_test.mocks.dart';

@GenerateMocks([TicketmasterEventsApi])
void main() {
  group('EventDetailScreen', () {
    final String eventID = 'test_event_id';
    final TicketmasterEventsApi mockTicketmasterEventsApi =
        MockTicketmasterEventsApi();
    final testWidget = EventDetailScreen(
      eventID: eventID,
      ticketmasterEventsApi: mockTicketmasterEventsApi,
    );

    testWidgets(
      'when the event is not yet loaded from the TicketmasterEventsApi, should display the circular progress',
      (WidgetTester tester) async {
        when(mockTicketmasterEventsApi.fetchEvent(any, any)).thenAnswer(
          // Purposely null to simulate api call still loading
          // ignore: null_argument_to_non_null_type
          (_) async => Future.value(null),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(
          find.byKey(Key("event_detail_circular_progress")),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when the event is received from the TicketmasterEventsApi, should display the event details',
      (WidgetTester tester) async {
        final String eventName = "test_event_name";
        final String rawEventDate = "2025-02-06T02:30:00Z";
        final String parsedEventDate = "Wed, Feb 5, 2025 - 9:30 PM";

        when(mockTicketmasterEventsApi.fetchEvent(any, any)).thenAnswer(
          (_) async => Future.value(SimpleEvent(
            name: eventName,
            date: rawEventDate
          )),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        // Simulate waiting for test event to load
        await tester.pump(Duration(milliseconds: 100));

        expect(find.textContaining('Event ID: $eventID'), findsOneWidget);
        expect(find.textContaining(eventName), findsOneWidget);
        expect(find.textContaining(parsedEventDate), findsOneWidget);
        expect(find.textContaining('Return to Scanning'), findsOneWidget);
      },
    );
  });
}
