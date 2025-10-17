import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../../backend/order/showacceptvendor.dart';
import 'chatscreen.dart';
import '../../backend/chat/getmessege.dart';

class ChatScreen2 extends StatefulWidget{
  final GetBusinessCardModel card;
  final AcceptVendorModel vendor;
  const ChatScreen2({Key? key, required this.card,required this.vendor}) : super(key: key);

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const _HeaderPadding(child: VideoSlider())),
            SliverToBoxAdapter(child: RequestVendorCard(card: widget.card,)),
            SliverToBoxAdapter(
              child: _SectionCard(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child:  ChatScreen(vendor: widget.vendor,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _HeaderPadding extends StatelessWidget {
  final Widget child;
  const _HeaderPadding({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}

class RequestVendorCard extends StatefulWidget {
  final GetBusinessCardModel card;
  const RequestVendorCard({Key? key,required this.card}) : super(key: key);

  @override
  State<RequestVendorCard> createState() => _RequestVendorCardState();
}

class _RequestVendorCardState extends State<RequestVendorCard> {
  final PageController _pageController = PageController(viewportFraction: 0.86);
  int _current = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = List.generate(
      1,
          (i) => VendorCard(
        title: widget.card.productName,
        subtitle: "",
        price: widget.card.price,
        onTap: () => debugPrint("Tapped Vendor $i"),
      ),
    );

    return _SectionCard(
      child: SizedBox(
        height: 210,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: cards.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                child: cards[i],
              ),
            ),
            // Dots indicator
            if (cards.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    cards.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: _current == i ? 18 : 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _current == i
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VendorCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  const VendorCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  _VendorCardState createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  bool isApproved = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withOpacity(.1),
                          scheme.primary.withOpacity(.2)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage(
                            "assets/icons/business_card_placeholder.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(.8)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "₹${widget.price}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00B3A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              const VendorFooter(),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isApproved = true; // change text
                  });
                },
                child: Container(
                  width: 240,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B3A7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      isApproved ? "Approved" : "Approve",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VendorFooter extends StatelessWidget {
  const VendorFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget pill(IconData icon) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(.08),
          shape: BoxShape.circle,
          border: Border.all(color: scheme.primary.withOpacity(.18)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF00B3A7)),
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/icons/business_card_placeholder.png"),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceVariant.withOpacity(.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.thumb_up_alt_outlined, size: 20, color: Color(0xFF00B3A7)),
                Icon(Icons.emoji_emotions_outlined, size: 20, color: Color(0xFF00B3A7)),
                Icon(Icons.perm_identity_outlined, size: 20, color: Color(0xFF00B3A7)),
                Icon(Icons.location_on_outlined, size: 20, color: Color(0xFF00B3A7)),
                Icon(Icons.wifi_off, size: 20, color: Color(0xFF00B3A7)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VideoSlider extends StatefulWidget {
  const VideoSlider({Key? key}) : super(key: key);

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.78);
  int _currentPage = 0;

  static const _thumbnails = [
    "https://picsum.photos/800/400?random=1",
    "https://picsum.photos/800/400?random=2",
    "https://picsum.photos/800/400?random=3",
    "https://picsum.photos/800/400?random=4",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = 160.0;

    return _SectionCard(
      child: SizedBox(
        height: height + 24,
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _thumbnails.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: isActive ? 6 : 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _thumbnails[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, p) {
                              if (p == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.45),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            // dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _thumbnails.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: _currentPage == i ? 16 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class VideoThumbnailCard extends StatelessWidget {
  final String thumbnailUrl;
  final VoidCallback onTap;

  const VideoThumbnailCard({Key? key, required this.thumbnailUrl, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                thumbnailUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
