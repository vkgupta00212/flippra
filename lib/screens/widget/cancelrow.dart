import 'package:flutter/material.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../../backend/category/getbusinesscards/updatebusinesscard.dart';

class CancelButton extends StatefulWidget {
  final GetBusinessCardModel card;
  const CancelButton({Key? key, required this.card}) : super(key: key);

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton>
    with SingleTickerProviderStateMixin {
  bool _isCancelling = false;
  late final AnimationController _animCtrl;
  late final Animation<double> _scale;
  late final Animation<Color?> _bgColor;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );

    _bgColor = ColorTween(
      begin: Colors.red.shade50.withOpacity(0.9),
      end: Colors.red.shade100,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _cancel() async {
    if (_isCancelling) return;
    setState(() => _isCancelling = true);
    _animCtrl.forward();

    try {
      await UpdateBusinessCard.updateBusinessCard(
        id: widget.card.id.toString(),
        request: "No",
      );
      // visual feedback
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cancel failed")),
        );
      }
    } finally {
      if (mounted) {
        _animCtrl.reverse().then((_) => setState(() => _isCancelling = false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isCancelling ? null : _cancel,
      child: AnimatedBuilder(
        animation: _animCtrl,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _bgColor.value,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.shade300, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: _isCancelling
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
                  : const Icon(Icons.close, color: Colors.red, size: 22),
            ),
          );
        },
      ),
    );
  }
}