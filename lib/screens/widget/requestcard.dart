import 'package:flutter/material.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../cartscreen.dart';


class FloatingRequestCard extends StatefulWidget {
  const FloatingRequestCard({
    super.key,
    required this.onRemove,
  });

  final VoidCallback onRemove;

  @override
  FloatingRequestCardState createState() => FloatingRequestCardState();
}

class FloatingRequestCardState extends State<FloatingRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _wobbleAnimation;
  late Animation<double> _closeButtonRotation;
  final List<GetBusinessCardModel> _selectedCards = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
    ));

    _wobbleAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    _closeButtonRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void dismiss() {
    _controller.reverse().then((_) => widget.onRemove());
  }

  void addAvatar(GetBusinessCardModel card) {
    setState(() {
      _selectedCards.add(card);
      _controller.forward(from: 0.0); // Restart bubble animation
    });
  }

  void removeAvatar(GetBusinessCardModel card) {
    setState(() {
      _selectedCards.removeWhere((c) => c.id == card.id);
      if (_selectedCards.isEmpty) {
        dismiss();
      } else {
        _controller.forward(from: 0.0); // Restart bubble animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateZ(_wobbleAnimation.value), // Subtle wobble effect
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1DB954), Color(0xFF17A14A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildOverlappingAvatars(),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                        },
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                            child: Icon(Icons.chevron_right,color: Colors.white,),
                            // child: const Text(
                            //   "Request Now",
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: (){},
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlappingAvatars() {
    const double radius = 23;
    const double overlap = 28;
    final int avatarCount = _selectedCards.length;

    final int displayCount = avatarCount <= 2 ? avatarCount : 3;
    final double totalWidth = (displayCount - 1) * overlap + radius * 2;

    return SizedBox(
      width: totalWidth,
      height: radius * 2,
      child: Stack(
        children: List.generate(displayCount, (index) {
          // Staggered bubble animation for each avatar
          final bubbleAnimation = Tween<double>(
            begin: 0.4,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.1 * index,
              0.4 + 0.1 * index,
              curve: Curves.elasticOut,
            ),
          ));

          if (index < 2 && index < avatarCount) {
            final card = _selectedCards[index];
            return Positioned(
              left: index * overlap,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: bubbleAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: radius,
                        backgroundColor: Colors.white,
                        backgroundImage: (card.fullImageUrl != null &&
                            card.fullImageUrl.isNotEmpty)
                            ? NetworkImage(card.fullImageUrl)
                            : const AssetImage(
                            "assets/icons/business_card_placeholder.png"),
                      ),
                      CircleAvatar(
                        radius: radius,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (index == 2 && avatarCount > 2) {
            return Positioned(
              left: index * overlap,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: bubbleAnimation,
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Text(
                      "+${avatarCount - 2}",
                      style: const TextStyle(
                        color: Color(0xFF1DB954),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}