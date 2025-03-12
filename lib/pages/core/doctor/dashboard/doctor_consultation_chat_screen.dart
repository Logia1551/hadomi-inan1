import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ChatMessage {
  final String text;
  final bool isDoctor;
  final DateTime timestamp;
  final String? imageUrl;

  ChatMessage({
    required this.text,
    required this.isDoctor,
    required this.timestamp,
    this.imageUrl,
  });
}

class DoctorConsultationChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final String chatRoomId;

  const DoctorConsultationChatScreen({
    Key? key,
    required this.user,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  State<DoctorConsultationChatScreen> createState() =>
      _DoctorConsultationChatScreenState();
}

class _DoctorConsultationChatScreenState
    extends State<DoctorConsultationChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isChatEnded = false;
  bool _isInCall = false;

  // Safely get user ID with null check

  // Safely get user name with null check
  String get _remoteUserName => (widget.user['name'] ?? 'Pengguna').toString();

  // Safely get user photo URL with null check
  String? get _remoteUserPhotoUrl => widget.user['photoUrl']?.toString();

  @override
  void initState() {
    super.initState();
    _fetchExistingMessages();
    _markMessagesAsRead();
    _listenToCallStatus();
  }

  void _listenToCallStatus() {}

  // First, remove these variables from the state class:
// bool _isInCall = false;
// StreamSubscription? _callStatusSubscription;

// Remove the _listenToCallStatus method entirely

// Replace the _initiateVideoCall method with this simpler version:
  Future<void> _initiateVideoCall() async {
    try {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskulpa, funsaun ida ne\'e sei dezenvolve hela'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _fetchExistingMessages() async {
    if (currentUser == null) return;

    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .get();

    if (!mounted) return;

    setState(() {
      _messages.addAll(
        messagesSnapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            text: data['text']?.toString() ?? '',
            isDoctor: data['senderId'] == currentUser!.uid,
            timestamp:
                (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
            imageUrl: data['imageUrl']?.toString(),
          );
        }).toList(),
      );
    });
  }

  Future<void> _markMessagesAsRead() async {
    if (currentUser == null) return;

    final messagesQuery = await _firestore
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: currentUser!.uid)
        .get();

    final batch = _firestore.batch();
    for (var doc in messagesQuery.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> _sendImage() async {
    if (currentUser == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 40,
      );

      if (image != null) {
        File imageFile = File(image.path);
        List<int> imageBytes = await imageFile.readAsBytes();

        if (imageBytes.length > 300 * 1024) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imajen boot liu. Másimu 300KB'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        String base64Image = base64Encode(imageBytes);

        final int chunkSize = 200 * 1024;
        final List<String> chunks = [];
        for (var i = 0; i < base64Image.length; i += chunkSize) {
          chunks.add(
              base64Image.substring(i, min(i + chunkSize, base64Image.length)));
        }

        await _firestore
            .collection('chatRooms')
            .doc(widget.chatRoomId)
            .collection('messages')
            .add({
          'text': 'Foto',
          'senderId': currentUser!.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': chunks.first,
          'imageChunks': chunks,
          'type': 'image',
          'isRead': false,
        });

        if (!mounted) return;

        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Foto',
              isDoctor: true,
              timestamp: DateTime.now(),
              imageUrl: base64Image,
            ),
          );
        });
        _scrollToBottom();

        await _firestore.collection('chatRooms').doc(widget.chatRoomId).update({
          'lastMessage': 'Foto',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La konsege haruka imajen: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _sendMessage() async {
    if (currentUser == null || _messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isDoctor: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = false;
    });

    _scrollToBottom();

    await _firestore
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
      'isRead': false,
    });

    await _firestore.collection('chatRooms').doc(widget.chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _endChat() async {
    if (currentUser == null) return;

    if (mounted) {
      setState(() {
        _isChatEnded = true;
      });
    }

    await _firestore.collection('chatRooms').doc(widget.chatRoomId).update({
      'isChatEnded': true,
      'endedAt': FieldValue.serverTimestamp(),
      'endedBy': currentUser!.uid,
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            if (_isChatEnded) _buildChatEndedBanner(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            if (!_isChatEnded) _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B57D2),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: _remoteUserPhotoUrl != null
                  ? Image.network(
                      _remoteUserPhotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _remoteUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    if (_isTyping)
                      const Text(
                        'Tipu... • ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      _isChatEnded ? 'Konsultasaun Kompleta ona' : 'Online',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: 24,
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.videocam, color: Colors.white),
        onPressed: _isChatEnded
            ? null
            : _isInCall
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Xamada la o hela'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                : _initiateVideoCall,
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        onSelected: (value) {
          if (value == 'end_chat') {
            _showEndChatDialog();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'end_chat',
            child: Row(
              children: [
                Icon(Icons.close, color: Colors.red),
                SizedBox(width: 8),
                Text('Hakotu Konsulta', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildChatEndedBanner() {
    return Container(
      color: Colors.red[50],
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Text(
            'Konsulta remata ona',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isDoctor = message.isDoctor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDoctor ? const Color(0xFF6B57D2) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border:
                    !isDoctor ? Border.all(color: Colors.grey.shade200) : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64.decode(message.imageUrl!),
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageError(),
                        ),
                      ),
                      if (message.text.isNotEmpty) const SizedBox(height: 8),
                    ],
                    if (message.text.isNotEmpty)
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isDoctor ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isDoctor ? Colors.white70 : Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey[400], size: 32),
          const SizedBox(height: 8),
          Text(
            'La konsege hatama imajen',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo_outlined),
              color: const Color(0xFF6B57D2),
              onPressed: _sendImage,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik ita-boot nia mensajen...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              color: const Color(0xFF6B57D2),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hakotu Konsulta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Ita-boot iha serteza katak ita-boot hakarak hakotu konsulta ida-ne e? Bainhira remata ona, konversa labele kontinua.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Kanseladu',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _endChat();
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B57D2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: const Text(
              'Sim, Remata',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
