import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../backend/servicerequest/showservicerequest.dart';

class RequestVendorCard1 extends StatefulWidget{
  final ShowServiceRequestModel request;
  const RequestVendorCard1({Key? key, required this.request}) : super(key: key);

  @override
  State<RequestVendorCard1> createState() => _RequestVendorCard1State();
}

class _RequestVendorCard1State extends State<RequestVendorCard1> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00B3A7),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 95, // enough space for image + rating badge
                        child: Column(
                          children: [
                            // Profile Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/icons/business_card_placeholder.png"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Rating Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.request.rating,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Row(
                                    children: const [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 12),
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 12),
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 12),
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 12),
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 12),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              widget.request.price,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              widget.request.productName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/icons/business_card_placeholder.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  VendorFooter(),
                ],
              ),
            ),
          ),
          DualSliderButton(
            onEnquiry: () {
              print("Reject leds ✅");
            },
            onRequest: () {
              print("Accept leds ✅");
            },
          ),
        ],
      ),
    );
  }
}

// Widget _buildRequestVendor(BuildContext context) {
//   return GestureDetector(
//     onTap: () {},
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 400),
//             curve: Curves.easeInOut,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00B3A7),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   spreadRadius: 4,
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 95, // enough space for image + rating badge
//                       child: Column(
//                         children: [
//                           // Profile Image
//                           Container(
//                             width: 80,
//                             height: 80,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                               image: const DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage(
//                                     "assets/icons/business_card_placeholder.png"),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           // Rating Badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4, horizontal: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                  Text(
//                                   widget.request,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Row(
//                                   children: const [
//                                     Icon(Icons.star,
//                                         color: Colors.orange, size: 12),
//                                     Icon(Icons.star,
//                                         color: Colors.orange, size: 12),
//                                     Icon(Icons.star,
//                                         color: Colors.orange, size: 12),
//                                     Icon(Icons.star,
//                                         color: Colors.orange, size: 12),
//                                     Icon(Icons.star,
//                                         color: Colors.orange, size: 12),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text(
//                             "499",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w300,
//                               color: Colors.white,
//                               letterSpacing: 0.6,
//                             ),
//                           ),
//                           SizedBox(height: 3),
//                           Text(
//                             "Car Service",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: 0.6,
//                             ),
//                           ),
//                           SizedBox(height: 3),
//                           Text(
//                             "Full AC repairing and clean spirit AC",
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w300,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 6,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           fit: BoxFit.cover,
//                           image: AssetImage(
//                               "assets/icons/business_card_placeholder.png"),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 VendorFooter(),
//               ],
//             ),
//           ),
//         ),
//         DualSliderButton(
//           onEnquiry: () {
//             print("Reject leds ✅");
//           },
//           onRequest: () {
//             print("Accept leds ✅");
//           },
//         ),
//       ],
//     ),
//   );
// }

class DualSliderButton extends StatefulWidget {
  final VoidCallback onEnquiry;
  final VoidCallback onRequest;

  const DualSliderButton({
    Key? key,
    required this.onEnquiry,
    required this.onRequest,
  }) : super(key: key);

  @override
  _DualSliderButtonState createState() => _DualSliderButtonState();
}

class _DualSliderButtonState extends State<DualSliderButton> with SingleTickerProviderStateMixin {
  double _position = 0;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _labelOpacityAnimationLeft;
  late Animation<double> _labelOpacityAnimationRight;
  late Animation<double> _positionAnimation;
  bool _isDoneIcon = false;
  String? _successMessage;
  bool _isResetting = false;
  double? _startPosition;
  double? _targetPosition;

  @override
  void initState() {
    super.initState();
    // Initialize position to center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.of(context).size.width * 0.8;
      const circleSize = 36.0;
      setState(() {
        _position = (width - circleSize) / 2;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey[350],
      end: const Color(0xFF00B3A7),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
    _labelOpacityAnimationLeft = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _labelOpacityAnimationRight = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _positionAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut, // Replaced Curves.spring with Curves.bounceOut
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = 40.0;
    const circleSize = 35.0;
    final centerPosition = (width - circleSize) / 2;
    final minLimit = width * 0.02;
    final maxLimit = width * 0.98 - circleSize;

    double effectivePosition;
    if (_isResetting) {
      effectivePosition = _startPosition! + (_targetPosition! - _startPosition!) * _positionAnimation.value;
    } else {
      effectivePosition = _position;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF00B3A7).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value!.withOpacity(0.85),
                _colorAnimation.value!,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1 - _textFadeAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: AnimatedOpacity(
                        opacity: _position < centerPosition ? _labelOpacityAnimationLeft.value : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "Reject | leds",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: AnimatedOpacity(
                        opacity: _position > centerPosition ? _labelOpacityAnimationRight.value : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "Accept leds",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_successMessage != null)
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Center(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: effectivePosition,
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    HapticFeedback.lightImpact();
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      _position = _position.clamp(minLimit, maxLimit);
                      final progress = ((_position - minLimit) / (maxLimit - minLimit) - 0.5).abs() * 2;
                      _controller.value = progress.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    _targetPosition = centerPosition;
                    if (_position <= minLimit + 12) {
                      // Slide left → Enquiry
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = minLimit;
                        _isDoneIcon = true;
                        _successMessage = " Reject leds";
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onEnquiry();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else if (_position >= maxLimit - 12) {
                      // Slide right → Request
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = maxLimit;
                        _isDoneIcon = true;
                        _successMessage = "Accept leds";
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onRequest();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _position = centerPosition;
                      });
                    }
                  },
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1.2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: const Color(0xFF00B3A7).withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Icon(
                          _isDoneIcon ? Icons.done : Icons.arrow_forward_ios,
                          key: ValueKey<bool>(_isDoneIcon),
                          size: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget VendorFooter() {
  return Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 18),
        Icon(Icons.emoji_emotions_outlined, color: Colors.white, size: 18),
        Icon(Icons.perm_identity_outlined, color: Colors.white, size: 18),
        Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
        Icon(Icons.wifi_off, color: Colors.white, size: 18),
      ],
    ),
  );
}

class RequestVendorHeader extends StatelessWidget {
  const RequestVendorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.19; // Responsive width (22% of screen width)
    final isTablet = screenWidth >= 600; // Adjust for tablet screens

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!], begin: Alignment.topLeft, end: Alignment.bottomRight, ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFF00B3A7), width: 1),
          boxShadow: [
            BoxShadow( color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4), ), ], ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: FadeInLeft(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: isTablet ? 200 : screenWidth * 0.3, // Responsive width
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '7456',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.wallet,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: InfoCard(
                    icon: Icons.sell,
                    value: "7556",
                    label: "Reselling\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: InfoCard(
                    icon: Icons.cancel_rounded,
                    value: "7556",
                    label: "Cancelled\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: InfoCard(
                    icon: Icons.verified,
                    value: "7556",
                    label: "Successful\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 900),
                  child: InfoCard(
                    icon: Icons.pending_actions_sharp,
                    value: "7556",
                    label: "Pending\nOrders",
                    width: cardWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final double width;

  const InfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.width,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 18,
              color: Colors.white,
            ),
          ),
          // Use ScaleIn if animate_do is resolved
          /*
          ScaleIn(
            duration: const Duration(milliseconds: 400),
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 24,
              color: Colors.white,
            ),
          ),
          */
          const SizedBox(height: 2),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 12 : 9,
              color: Colors.white70,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}