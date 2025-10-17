import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../backend/social/getsociallink.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening links

class BusinessFooter extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onFooterSelected;

  const BusinessFooter({
    super.key,
    required this.selectedIndex,
    required this.onFooterSelected,
  });

  @override
  State<BusinessFooter> createState() => _BusinessFooterState();
}

class _BusinessFooterState extends State<BusinessFooter> {
  final GetSocialLink _getSocialLink = Get.put(GetSocialLink());

  @override
  void initState() {
    super.initState();
    _fetchSocial();
  }

  Future<void> _fetchSocial() async {
    await _getSocialLink.getsociallinks(
      token: "wvnwivnoweifnqinqfinefnq",
    );
    print("🏦 Number of social links: ${_getSocialLink.social.length}");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Footer Button
          GestureDetector(
            onTap: () => widget.onFooterSelected(4),
            child: Container(
              width: isTablet ? 70 : 60,
              height: 55,
              decoration: BoxDecoration(
                gradient: widget.selectedIndex == 4
                    ? const LinearGradient(
                  colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                    : null,
                color: widget.selectedIndex == 0 ? null : Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.description,
                  color: widget.selectedIndex == 4 ? Colors.white : Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),

          // Middle Social Links
          Expanded(
            child: Obx(() {
              if (_getSocialLink.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_getSocialLink.social.isEmpty) {
                return const Center(child: Text("No social links found"));
              }

              final socialLinks = _getSocialLink.social.first;
              final linkList = [
                socialLinks.link1,
                socialLinks.link2,
                socialLinks.link3,
                socialLinks.link4,
                socialLinks.link5
              ].where((e) => e.isNotEmpty).toList();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: linkList.map((link) {
                  IconData icon;
                  Color color;

                  if (link.contains("facebook")) {
                    icon = Icons.facebook;
                    color = Colors.blue;
                  } else if (link.contains("instagram")) {
                    icon = Icons.camera_alt;
                    color = Colors.purple;
                  } else if (link.contains("youtube")) {
                    icon = Icons.play_circle_fill;
                    color = Colors.red;
                  } else if (link.contains("telegram")) {
                    icon = Icons.send;
                    color = Colors.blue;
                  } else {
                    icon = Icons.close;
                    color = Colors.black;
                  }
                  return GestureDetector(
                    onTap: () async {
                      print("🌐 Open link: $link");

                      // Ensure link starts with http:// or https://
                      String url = link.trim();
                      if (!url.startsWith("http://") && !url.startsWith("https://")) {
                        url = "https://$url";
                      }

                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        if (!await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        )) {
                          print("❌ Could not launch $url");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Could not open $url")),
                          );
                        }
                      } else {
                        print("❌ Invalid URL: $url");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid URL: $url")),
                        );
                      }
                    },
                    child: _CircleIcon(icon: icon, color: color),
                  );
                }).toList(),
              );
            }),
          ),

          // Right Footer Button
          GestureDetector(
            onTap: () => widget.onFooterSelected(5),
            child: Container(
              width: isTablet ? 70 : 60,
              height: 55,
              decoration: BoxDecoration(
                gradient: widget.selectedIndex == 5
                    ? const LinearGradient(
                  colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                    : null,
                color: widget.selectedIndex == 1 ? null : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                border: Border.all(
                  color: widget.selectedIndex == 1 ? Colors.orange : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.support_agent,
                  color: widget.selectedIndex == 5 ? Colors.white : Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Circle Icon Widget
class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CircleIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
