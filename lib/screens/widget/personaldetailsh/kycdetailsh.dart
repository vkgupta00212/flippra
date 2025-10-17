import 'package:flippra/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class KYCViewer extends StatelessWidget {
   KYCViewer({super.key});

  // Sample data based on provided JSON
  final Map<String, dynamic> userData = {
    "ID": 10,
    "AadharFront": "http://flippraa.anklegaming.live/image/2f672f43-2fa2-4f69-a4e4-14bbdff1b00f.png",
    "AadharBack": "http://flippraa.anklegaming.live/image/fb99d056-7cbb-4689-8e57-b2731d831752.png",
    "PencardFront": "http://flippraa.anklegaming.live/image/884ab677-eff3-43a0-a53e-cffdee1d7ae9.png",
    "PencardBack": "http://flippraa.anklegaming.live/image/a9ec1942-4122-48eb-ad4a-0469a8da2669.png",
    "Gst": "http://flippraa.anklegaming.live/image/4a439dbc-5abc-4698-acfc-10f52fb97a28.png",
    "Phone": "7700818001"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Document Viewer',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const SizedBox(height: 8),
            _buildDetailRow(context,'Aadhar card',0,3),
            _buildDetailRow(context,'PAN Card',1,3),
            _buildDetailRow(context,'GST',2,3),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, String title, String imageUrl) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KYCFullScreenImage(imageUrl: imageUrl),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

   Widget _buildDetailRow(BuildContext context, String label, int index, int total) {
     BorderRadius radius;
     if (index == 0) {
       radius = const BorderRadius.only(
         topRight: Radius.circular(16),
         topLeft: Radius.circular(16),
       );
     } else if (index == total - 1) {
       radius = const BorderRadius.only(
         bottomRight: Radius.circular(16),
         bottomLeft: Radius.circular(16),
       );
     } else {
       radius = BorderRadius.zero;
     }
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 1.0),
       child: GestureDetector(
         onTap: () {
           // 👇 Navigate to VideoSlider screen
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => const VideoSlider()),
           );
         },
         child: AnimatedContainer(
           duration: const Duration(milliseconds: 300),
           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
           decoration: BoxDecoration(
             color: AppColors.containerBackground,
             borderRadius: radius,
             gradient: LinearGradient(
               colors: [
                 AppColors.footerGradientEnd.withOpacity(0.8),
                 AppColors.pillButtonGradientStart.withOpacity(0.8),
               ],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
             ),

             border: Border.all(
                 color: AppColors.iconGradientStart.withOpacity(0.2), width: 1),
           ),
           child: Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(1),
                 child: Icon(
                   Icons.note_add,
                   color: AppColors.pillButtonGradientStart,
                   size: 24,
                   semanticLabel: label,
                 ),
               ),
               const SizedBox(width: 12),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     label,
                     style: GoogleFonts.poppins(
                       fontSize: 14,
                       fontWeight: FontWeight.w500,
                       color: AppColors.primaryText,
                     ),
                   ),
                 ],
               ),
               const Spacer(),
               Icon(
                 Icons.arrow_forward_ios_rounded,
                 size: 14,
                 color: AppColors.closeIcon, // Updated color
               ),
             ],
           ),
         ),
       ),
     );
   }
}

class VideoSlider extends StatefulWidget {
  const VideoSlider({Key? key}) : super(key: key);

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
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
    final height = 220.0; // bigger for nice carousel feel

    return Center(
      child: _SectionCard(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _thumbnails.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                        }
                        return Center(
                          child: Transform.scale(
                            scale: value,
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
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2));
                                    },
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                          Icons.broken_image_outlined),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // dots indicator
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
                          : Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.3)),
      ),
      child: child,
    );
  }
}


class KYCFullScreenImage extends StatelessWidget {
  final String imageUrl;

  const KYCFullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Document View'),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.error,
              size: 50,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}