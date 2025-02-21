import 'package:app/api/ticketmaster_events_api.dart';
import 'package:intl/intl.dart';
import 'package:app/model/simple_event.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventID;
  final TicketmasterEventsApi ticketmasterEventsApi;

  const EventDetailScreen({
    required this.eventID,
    required this.ticketmasterEventsApi,
    super.key
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  SimpleEvent? event;

  @override
  void initState() {
    super.initState();
    widget.ticketmasterEventsApi.fetchEvent(widget.eventID, context)
      .then(_updateEvent)
      .catchError((error) {
        // Possibly put state in error state to display error on screen, not implemented.
        print("Error loading event: $error");
        return Future.value(null);
      });
  }

  void _updateEvent(SimpleEvent? event) {
    setState(() => this.event = event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              event != null
                  ? _buildEventDetails(event!, context)
                  : _buildLoading(),
        ),
      ),
    );
  }

  Widget _buildEventDetails(SimpleEvent event, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextDisplay("Event ID: ${widget.eventID}"),
        _buildTextDisplay(event.name, 32),
        _buildTextDisplay(_formatDate(event.date), 24),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Return to Scanning"),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return CircularProgressIndicator(
      key: Key("event_detail_circular_progress"),
      color: Colors.white
    );
  }

  Widget _buildTextDisplay(String text, [double? fontSize]) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return "${DateFormat.yMMMEd().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
  }
}
