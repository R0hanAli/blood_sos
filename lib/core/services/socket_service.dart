import 'dart:developer' as dev;
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final String _serverUrl;
  io.Socket? _socket;

  SocketService(this._serverUrl);

  
  void Function(Map<String, dynamic>)? onEmergencyRequestReceived;
  void Function(Map<String, dynamic>)? onRequestAcceptedReceived;
  void Function(Map<String, dynamic>)? onRequestStatusUpdatedReceived;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String userId) {
    if (_socket != null) {
      disconnect();
    }

    dev.log('Connecting to Socket.io server at $_serverUrl');
    
    _socket = io.io(
      _serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket']) 
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      dev.log('Socket.io connected successfully for user $userId');
      _socket!.emit('join', userId);
    });

    _socket!.onDisconnect((_) {
      dev.log('Socket.io disconnected');
    });

    _socket!.onConnectError((err) {
      dev.log('Socket.io connection error: $err');
    });

    
    _socket!.on('new_emergency_request', (data) {
      if (onEmergencyRequestReceived != null && data != null) {
        onEmergencyRequestReceived!(Map<String, dynamic>.from(data as Map));
      }
    });

    _socket!.on('request_accepted', (data) {
      if (onRequestAcceptedReceived != null && data != null) {
        onRequestAcceptedReceived!(Map<String, dynamic>.from(data as Map));
      }
    });

    _socket!.on('request_status_updated', (data) {
      if (onRequestStatusUpdatedReceived != null && data != null) {
        onRequestStatusUpdatedReceived!(Map<String, dynamic>.from(data as Map));
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    dev.log('Socket.io connection closed and disposed');
  }
}
