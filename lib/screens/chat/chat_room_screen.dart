import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/constants/dummy_data_chat.dart';
import 'package:zeerah/core/models/message_model.dart';
import 'package:zeerah/core/models/user_model.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final String myId = "u2";

  late List<UserModel> users;
  late List<MessageModel> messages;
  late UserModel otherUser;

  @override
  void initState() {
    super.initState();

    users = (dummyJson[UserMessages.users] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();

    messages = (dummyJson[UserMessages.messages] as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();

    otherUser = users.firstWhere((u) => u.id != myId);
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        MessageModel(
          id: DateTime.now().toString(),
          text: controller.text.trim(),
          time: _getCurrentTime(),
          senderId: myId,
          isRead: false,
        ),
      );
    });

    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = TimeOfDay.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBgColor,

      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.naturalWhite),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: Insets.xxs),
            CircleAvatar(
              radius: AppSizes.w(context, 24),
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(
                  otherUser.image,
                  width: AppSizes.w(context, 48),
                  height: AppSizes.h(context, 48),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Image.network(
                      UserMessages.defaultProfileImage,
                      width: AppSizes.w(context, 48),
                      height: AppSizes.h(context, 48),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: Insets.xsm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.name,
                    style: const TextStyle(color: AppColors.naturalWhite),
                  ),
                  Text(
                    otherUser.lastSeen,
                    style: const TextStyle(
                      color: AppColors.naturalWhite70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.call, color: AppColors.naturalWhite),
          SizedBox(width: 10),
          Icon(Icons.more_vert, color: AppColors.naturalWhite),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(Insets.xs),
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == myId;
                  return ChatBubble(message: msg, isMe: isMe);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.xs, vertical: Insets.xxs),
              color: AppColors.naturalBlack,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: UserMessages.messageHint,
                        fillColor: AppColors.naturalWhite,
                        filled: true,
                        border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(Insets.md)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.xxs),
                  CircleAvatar(
                    backgroundColor: AppColors.sendButtonColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.naturalWhite),
                      onPressed: sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }
}

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: AppSizes.h(context, 4)),
          padding: EdgeInsets.symmetric(horizontal: Insets.xs, vertical: Insets.xxs),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isMe ? AppColors.chatBubbleMe : AppColors.naturalWhite,
            borderRadius: BorderRadius.circular(Insets.xsm),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message.text,
                  style: TextStyle(fontSize: AppSizes.w(context, 14)),
                ),
              ),
              SizedBox(height: AppSizes.h(context, 2)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: TextStyle(fontSize: AppSizes.w(context, 10)),
                  ),
                  SizedBox(width: Insets.xxs),
                  if (isMe)
                    Icon(
                      Icons.done_all,
                      size: AppSizes.w(context, 14),
                      color: message.isRead ? AppColors.pauseBlue : AppColors.naturalGray,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}