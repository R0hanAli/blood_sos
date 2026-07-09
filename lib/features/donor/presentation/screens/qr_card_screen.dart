import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/donor_profile_controller.dart';
import '../../../../core/theme/app_theme.dart';

class QrCardScreen extends ConsumerWidget {
  const QrCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(donorProfileControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital QR Card'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: profileState.when(
            data: (donor) {
              if (donor == null) {
                return const Text('No profile found to generate QR card.');
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF3A0D0D), const Color(0xFF1E1E1E)]
                            : [AppTheme.primaryRed, AppTheme.primaryDarkRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 38,
                                    height: 38,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'BloodSOS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  donor.bloodGroup,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Text(
                            donor.fullName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Donor ID: ${donor.id.substring(0, 8).toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('STATUS', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                  const SizedBox(height: 2),
                                  Text(
                                    donor.isCurrentlyEligible ? 'ELIGIBLE' : 'INELIGIBLE',
                                    style: TextStyle(
                                      color: donor.isCurrentlyEligible ? Colors.greenAccent : Colors.amberAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('PHONE', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                  const SizedBox(height: 2),
                                  Text(
                                    donor.phone,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        
                        CustomPaint(
                          size: const Size(200, 200),
                          painter: _QrMockPainter(),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'SCAN TO VERIFY DONATION ELIGIBILITY',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Present this card at any BloodSOS affiliate hospital or blood donation camp to check-in instantly and sync your history records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, height: 1.4),
                    ),
                  ),
                ],
              );
            },
            error: (err, stack) => Text('Error loading QR card: $err'),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}


class _QrMockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    
    _drawFinderPattern(canvas, 0, 0, 45);
    _drawFinderPattern(canvas, size.width - 45, 0, 45);
    _drawFinderPattern(canvas, 0, size.height - 45, 45);

    
    final pixelSize = size.width / 21; 
    for (int col = 0; col < 21; col++) {
      for (int row = 0; row < 21; row++) {
        
        if ((col < 7 && row < 7) || (col > 13 && row < 7) || (col < 7 && row > 13)) {
          continue;
        }

        
        if ((col * row + col + row) % 3 == 0 || (col + row) % 5 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(col * pixelSize, row * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, double x, double y, double size) {
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paintBlack);
    
    final margin = size / 7;
    canvas.drawRect(Rect.fromLTWH(x + margin, y + margin, size - 2 * margin, size - 2 * margin), paintWhite);
    
    final dotSize = size - 4 * margin;
    canvas.drawRect(Rect.fromLTWH(x + 2 * margin, y + 2 * margin, dotSize, dotSize), paintBlack);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
