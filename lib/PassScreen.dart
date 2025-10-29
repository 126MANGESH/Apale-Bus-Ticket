import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PassScreen extends StatefulWidget {
  const PassScreen({super.key});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen>
    with SingleTickerProviderStateMixin {
  late DateTime bookingTime;
  late DateTime validityTime;
  late Timer _timer;
  Duration remaining = const Duration(hours: 11, minutes: 0, seconds: 0);
  late AnimationController _logoController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    bookingTime = DateTime.now();
    validityTime = bookingTime.add(const Duration(hours: 15));

    // Countdown timer starting from 11:00:00
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (remaining > Duration.zero) {
            remaining -= const Duration(seconds: 1);
          } else {
            remaining = Duration.zero;
          }
        });
      }
    });

    // Zoom animation controller for logo (pulse effect)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _zoomAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _logoController.dispose();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String formatDurationHHMMSS(Duration d) {
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }

  String formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[dt.month - 1];
    final yearShort = dt.year % 100;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$day $month, ${yearShort.toString().padLeft(2, '0')} | ${hour.toString().padLeft(2, '0')}:$minute $ampm';
  }

  String generateTicketNumber() {
    final now = DateTime.now();
    final yy = (now.year % 100).toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final hh = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');

    return '$yy$mm$dd$hh${min}WAWGHJ';
  }

  void _showQR(String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ticket QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              QrImageView(data: text, size: 220.0),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const passType = 'PMC & PCMC';
    const id = '5823';
    const fare = '₹70.8\n3';
    final transaction = generateTicketNumber();

    return Scaffold(
      backgroundColor: const Color(0xFF2DAE9B),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Need Help?',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('All passes',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            // Expanded ticket area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ticketWidth = constraints.maxWidth;
                      final ticketHeight = constraints.maxHeight;
                      final cutoutRadius = 45.0;
                      final notchTop = 170.0;

                      return Stack(
                        children: [
                          // Main Ticket Container
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: ticketWidth,
                              height: ticketHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Red header (edge-to-edge)
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD73A3A),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    child: const Center(
                                      child: Text(
                                        'पुणे महानगर परिवहन महामंडळ लि.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Labels row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Expanded(
                                            child: Text('Pass Type',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold))),
                                        Expanded(
                                            child: Text('ID',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold))),
                                        Expanded(
                                            child: Text('Fare',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Values row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  passType,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ))),
                                        Expanded(
                                            child: Text(id,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18))),
                                        Expanded(
                                            child: Text(fare,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  // Dashed divider
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.0),
                                    child: CustomPaint(
                                      size: Size(ticketWidth - 34, 1),
                                      painter: DashedLinePainter(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Booking & Validity
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text('Booking Time',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              Text(formatDateTime(bookingTime),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text('Validity Time',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              Text(formatDateTime(validityTime),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Transaction
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.0),
                                    child: Text(transaction,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54,
                                            fontSize: 14)),
                                  ),
                                  const SizedBox(height: 15),
                                  // Dashed divider
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.0),
                                    child: CustomPaint(
                                      size: Size(ticketWidth - 34, 1),
                                      painter: DashedLinePainter(),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  // One Day Pass full-width (edge-to-edge)
                                  Container(
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD73A3A),
                                    ),
                                    child: const Center(
                                      child: Text('One Day Pass',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  // Zoom animation logo (pulse effect)
                                  ScaleTransition(
                                    scale: _zoomAnimation,
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/pmpl_logo.png.webp',
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            size: 80,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 61),
                                  // Expires text - no box, just text
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      'Expires in ${formatDurationHHMMSS(remaining)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black38,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Spacer to fill remaining height
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          // Left circular cutout (half circle)
                          Positioned(
                            left: -cutoutRadius / 2,
                            top: notchTop,
                            child: Container(
                              width: cutoutRadius,
                              height: cutoutRadius,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DAE9B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Right circular cutout (half circle)
                          Positioned(
                            right: -cutoutRadius / 2,
                            top: notchTop,
                            child: Container(
                              width: cutoutRadius,
                              height: cutoutRadius,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DAE9B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            // QR Button (centered with green text and icon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: GestureDetector(
                onTap: () => _showQR(transaction),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.qr_code,
                            color: Color(0xFF2DAE9B), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Show QR code',
                          style: TextStyle(
                            color: Color(0xFF2DAE9B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    const dashWidth = 8;
    const dashSpace = 8;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}