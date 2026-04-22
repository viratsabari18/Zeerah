import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded chat data as per specifications
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Ariana Steward',
        'message': 'Did you need home service ?',
        'time': 'Now',
        'unread': 1,
        'hasTick': false,
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': 'Elizabeth Joseph',
        'message': 'Thanks for your patronage',
        'time': '10:00am',
        'unread': 2,
        'hasTick': false,
        'avatar': 'https://randomuser.me/api/portraits/women/68.jpg',
      },
      {
        'name': 'John Williams',
        'message': "Don't forget to leave me a ratings",
        'time': '12:11pm',
        'unread': 0,
        'hasTick': false,
        'avatar': 'https://randomuser.me/api/portraits/men/46.jpg',
      },
      {
        'name': 'Ariana Steward',
        'message': 'my house plumbing is now.....',
        'time': 'Yesterday',
        'unread': 0,
        'hasTick': true,
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      },
    ];

    // Set status bar to dark icons on white background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 80,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE53935)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Messages',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 8),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '2 unread messages',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  itemCount: chats.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildChatItem(chats[index]);
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          right: 15,
          child: Image.asset(
            'lib/assets/images/service_workers.png',
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 110, top: 12, bottom: 12),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        style: GoogleFonts.poppins(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFFBDBDBD),
            fontSize: 13,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFBDBDBD), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(chat['avatar']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['name'],
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF212121),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (chat['hasTick'])
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.done_all, size: 14, color: Color(0xFF1565C0)),
                      ),
                    Expanded(
                      child: Text(
                        chat['message'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF757575),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                chat['time'],
                style: GoogleFonts.poppins(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              if (chat['unread'] > 0)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    chat['unread'].toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
