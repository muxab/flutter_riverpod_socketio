import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_socketio/socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

final providerOfSocket = StreamProvider.autoDispose((ref) async* {
  StreamController stream = StreamController();

  SocketService().socket.onerror((err) => log(err));
  SocketService().socket.onDisconnect((_) => log('disconnect'));
  SocketService().socket.on('fromServer', (_) => log(_));

  SocketService().socket.on('broadcast', (data) {
    stream.add(data);

    log(data.toString());
  });

  // SocketService().socket.on('message', (data) {
  //   stream.add(data);
  //   log(data);
  // });
  SocketService().socket.onerror((_) {
    log("Error IS ${_.toString()}");
  });

  /** if you using .autDisopose */
  // ref.onDispose(() {
  //   // close socketio
  //   _stream.close();
  //   SocketService().socket.dispose();
  // });

  await for (final value in stream.stream) {
    log('stream value => ${value.toString()}');
    yield value;
  }
});

class StreamProviderWithConsumer extends ConsumerWidget {
  const StreamProviderWithConsumer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _controller = TextEditingController();
    final message = ref.watch(providerOfSocket);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                controller: _controller,
              ),
            ),
            ElevatedButton(
                onPressed: () => SocketService().sendMessage(_controller.text),
                child: const Text('Send Message')),
            const Divider(),
            Center(
              child: message.when(
                  data: (data) {
                    return Text(data.toString());
                  },
                  error: (_, __) {
                    log(_.toString());
                    return const Text('Error');
                  },
                  loading: () => const Text('Loading ')),
            )
          ],
        ),
      ),
    );
  }
}
