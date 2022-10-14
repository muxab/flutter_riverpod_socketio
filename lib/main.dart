import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_socketio/socket.dart';
import 'package:riverpod_socketio/stream_provider.dart';

void main() {
  // call initial connection in the main
  // assuming you want the connection to be continuous
  SocketService().initConnection();
  runApp(
    const ProviderScope(
      // using [streamprovider] with [consumerwidget] with [socketio]
      child: MaterialApp(home: StreamProviderWithConsumer()),
    ),
  );
}
