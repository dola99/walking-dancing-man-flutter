import 'dart:math' as math;
import 'package:flutter/material.dart';

class WalkingAnimation extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const WalkingAnimation({
    Key? key,
    this.width = 200,
    this.height = 300,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  State<WalkingAnimation> createState() => _WalkingAnimationState();
}

class _WalkingAnimationState extends State<WalkingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _walkController;
  late Animation<double> _walkAnimation;

  late AnimationController _armController;
  late AnimationController _legController;
  late AnimationController _breathingController;
  late AnimationController _headBobController;

  late AnimationController _positionController;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _walkAnimation = CurvedAnimation(
      parent: _walkController,
      curve: Curves.linear,
    );

    _armController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    )..repeat(reverse: true);

    _legController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _headBobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _positionAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: const Offset(0.5, 0),
    ).animate(
      CurvedAnimation(parent: _positionController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _walkController.dispose();
    _armController.dispose();
    _legController.dispose();
    _breathingController.dispose();
    _headBobController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _walkAnimation,
          _armController,
          _legController,
          _breathingController,
          _headBobController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: RealisticHumanPainter(
              walkAnimation: _walkController.value,
              armAnimation: _armController.value,
              legAnimation: _legController.value,
              breathingAnimation: _breathingController.value,
              headBobAnimation: _headBobController.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class RealisticHumanPainter extends CustomPainter {
  final double walkAnimation;
  final double armAnimation;
  final double legAnimation;
  final double breathingAnimation;
  final double headBobAnimation;
  final Color color;

  RealisticHumanPainter({
    required this.walkAnimation,
    required this.armAnimation,
    required this.legAnimation,
    required this.breathingAnimation,
    required this.headBobAnimation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final musclePaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final skinColor = HSLColor.fromColor(color).withLightness(0.8).toColor();
    final skinPaint =
        Paint()
          ..color = skinColor
          ..style = PaintingStyle.fill;

    final hairPaint =
        Paint()
          ..color = Colors.brown.shade800
          ..style = PaintingStyle.fill;

    final center = Offset(
      size.width / 2,
      size.height / 2 + math.sin(headBobAnimation * 2 * math.pi) * 2,
    );

    final headHeight = size.height * 0.13;
    final headWidth = headHeight * 0.75;
    final neckLength = size.height * 0.03;
    final shoulderWidth = size.width * 0.22;
    final torsoLength = size.height * 0.34;
    final upperArmLength = size.height * 0.16;
    final lowerArmLength = size.height * 0.14;
    final upperLegLength = size.height * 0.2;
    final lowerLegLength = size.height * 0.19;
    final hipWidth = size.width * 0.14;

    final chestExpansion = 1.0 + breathingAnimation * 0.03;

    final headTop = center.dy - torsoLength / 2 - neckLength - headHeight;
    final neckTop = center.dy - torsoLength / 2 - neckLength;
    final shoulderY = center.dy - torsoLength / 2;
    final hipY = center.dy + torsoLength / 2;

    final faceCenter = Offset(center.dx, headTop + headHeight / 2);

    final hairPath =
        Path()
          ..moveTo(
            faceCenter.dx - headWidth / 2,
            faceCenter.dy - headHeight / 2,
          )
          ..lineTo(
            faceCenter.dx - headWidth / 2,
            faceCenter.dy - headHeight / 2 - 5,
          )
          ..quadraticBezierTo(
            faceCenter.dx,
            faceCenter.dy - headHeight / 2 - 12,
            faceCenter.dx + headWidth / 2,
            faceCenter.dy - headHeight / 2 - 5,
          )
          ..lineTo(
            faceCenter.dx + headWidth / 2,
            faceCenter.dy - headHeight / 2,
          )
          ..close();
    canvas.drawPath(hairPath, hairPaint);

    final headRect = Rect.fromCenter(
      center: faceCenter,
      width: headWidth,
      height: headHeight,
    );
    canvas.drawOval(headRect, skinPaint);
    canvas.drawOval(headRect, paint);

    canvas.drawLine(
      Offset(center.dx, neckTop),
      Offset(center.dx, shoulderY),
      paint,
    );

    final torsoPath = Path();

    torsoPath.moveTo(center.dx - shoulderWidth / 2, shoulderY);

    torsoPath.quadraticBezierTo(
      center.dx - shoulderWidth / 2 * chestExpansion,
      center.dy - torsoLength / 4,
      center.dx - hipWidth / 2,
      hipY,
    );

    torsoPath.lineTo(center.dx + hipWidth / 2, hipY);

    torsoPath.quadraticBezierTo(
      center.dx + shoulderWidth / 2 * chestExpansion,
      center.dy - torsoLength / 4,
      center.dx + shoulderWidth / 2,
      shoulderY,
    );

    torsoPath.close();

    canvas.drawPath(torsoPath, musclePaint);
    canvas.drawPath(torsoPath, paint);

    final leftArmAngle = math.sin(armAnimation * math.pi) * 0.5;
    final rightArmAngle = -math.sin(armAnimation * math.pi) * 0.5;

    final leftLegAngle = math.sin(legAnimation * math.pi) * 0.35;
    final rightLegAngle = -math.sin(legAnimation * math.pi) * 0.35;

    final leftShoulderPoint = Offset(center.dx - shoulderWidth / 2, shoulderY);
    final rightShoulderPoint = Offset(center.dx + shoulderWidth / 2, shoulderY);

    final leftHipPoint = Offset(center.dx - hipWidth / 2, hipY);
    final rightHipPoint = Offset(center.dx + hipWidth / 2, hipY);

    final leftElbowAngle = leftArmAngle * 0.8;
    final leftElbowPoint = Offset(
      leftShoulderPoint.dx + upperArmLength * math.sin(leftArmAngle),
      leftShoulderPoint.dy + upperArmLength * math.cos(leftArmAngle),
    );

    final leftUpperArmPath =
        Path()
          ..moveTo(leftShoulderPoint.dx, leftShoulderPoint.dy)
          ..lineTo(leftElbowPoint.dx + 3, leftElbowPoint.dy)
          ..lineTo(leftElbowPoint.dx - 3, leftElbowPoint.dy)
          ..close();
    canvas.drawPath(leftUpperArmPath, musclePaint);

    canvas.drawLine(leftShoulderPoint, leftElbowPoint, paint);

    final leftWristPoint = Offset(
      leftElbowPoint.dx +
          lowerArmLength * math.sin(leftArmAngle + leftElbowAngle),
      leftElbowPoint.dy +
          lowerArmLength * math.cos(leftArmAngle + leftElbowAngle),
    );

    final leftLowerArmPath =
        Path()
          ..moveTo(leftElbowPoint.dx, leftElbowPoint.dy)
          ..lineTo(leftWristPoint.dx + 2, leftWristPoint.dy)
          ..lineTo(leftWristPoint.dx - 2, leftWristPoint.dy)
          ..close();
    canvas.drawPath(leftLowerArmPath, musclePaint);

    canvas.drawLine(leftElbowPoint, leftWristPoint, paint);

    // Draw right arm with realistic joint articulation
    final rightElbowAngle = rightArmAngle * 0.8;
    final rightElbowPoint = Offset(
      rightShoulderPoint.dx + upperArmLength * math.sin(rightArmAngle),
      rightShoulderPoint.dy + upperArmLength * math.cos(rightArmAngle),
    );

    // Upper arm muscles
    final rightUpperArmPath =
        Path()
          ..moveTo(rightShoulderPoint.dx, rightShoulderPoint.dy)
          ..lineTo(rightElbowPoint.dx + 3, rightElbowPoint.dy)
          ..lineTo(rightElbowPoint.dx - 3, rightElbowPoint.dy)
          ..close();
    canvas.drawPath(rightUpperArmPath, musclePaint);

    // Draw upper arm
    canvas.drawLine(rightShoulderPoint, rightElbowPoint, paint);

    // Lower arm
    final rightWristPoint = Offset(
      rightElbowPoint.dx +
          lowerArmLength * math.sin(rightArmAngle + rightElbowAngle),
      rightElbowPoint.dy +
          lowerArmLength * math.cos(rightArmAngle + rightElbowAngle),
    );

    // Lower arm muscles
    final rightLowerArmPath =
        Path()
          ..moveTo(rightElbowPoint.dx, rightElbowPoint.dy)
          ..lineTo(rightWristPoint.dx + 2, rightWristPoint.dy)
          ..lineTo(rightWristPoint.dx - 2, rightWristPoint.dy)
          ..close();
    canvas.drawPath(rightLowerArmPath, musclePaint);

    canvas.drawLine(rightElbowPoint, rightWristPoint, paint);

    // Draw left leg with realistic joint movement
    final leftKneeAngle = leftLegAngle * 0.6;
    final leftKneePoint = Offset(
      leftHipPoint.dx + upperLegLength * math.sin(leftLegAngle),
      leftHipPoint.dy + upperLegLength * math.cos(leftLegAngle),
    );

    // Upper leg muscles - thicker for realism
    final leftThighPath =
        Path()
          ..moveTo(leftHipPoint.dx, leftHipPoint.dy)
          ..lineTo(leftKneePoint.dx + 5, leftKneePoint.dy)
          ..lineTo(leftKneePoint.dx - 5, leftKneePoint.dy)
          ..close();
    canvas.drawPath(leftThighPath, musclePaint);

    // Draw upper leg
    canvas.drawLine(leftHipPoint, leftKneePoint, paint);

    // Lower leg
    final leftAnklePoint = Offset(
      leftKneePoint.dx +
          lowerLegLength * math.sin(leftLegAngle + leftKneeAngle),
      leftKneePoint.dy +
          lowerLegLength * math.cos(leftLegAngle + leftKneeAngle),
    );

    // Calf muscles
    final leftCalfPath =
        Path()
          ..moveTo(leftKneePoint.dx, leftKneePoint.dy)
          ..lineTo(leftAnklePoint.dx + 3, leftAnklePoint.dy)
          ..lineTo(leftAnklePoint.dx - 3, leftAnklePoint.dy)
          ..close();
    canvas.drawPath(leftCalfPath, musclePaint);

    canvas.drawLine(leftKneePoint, leftAnklePoint, paint);

    // Draw right leg with realistic joint movement
    final rightKneeAngle = rightLegAngle * 0.6;
    final rightKneePoint = Offset(
      rightHipPoint.dx + upperLegLength * math.sin(rightLegAngle),
      rightHipPoint.dy + upperLegLength * math.cos(rightLegAngle),
    );

    // Upper leg muscles
    final rightThighPath =
        Path()
          ..moveTo(rightHipPoint.dx, rightHipPoint.dy)
          ..lineTo(rightKneePoint.dx + 5, rightKneePoint.dy)
          ..lineTo(rightKneePoint.dx - 5, rightKneePoint.dy)
          ..close();
    canvas.drawPath(rightThighPath, musclePaint);

    // Draw upper leg
    canvas.drawLine(rightHipPoint, rightKneePoint, paint);

    // Lower leg
    final rightAnklePoint = Offset(
      rightKneePoint.dx +
          lowerLegLength * math.sin(rightLegAngle + rightKneeAngle),
      rightKneePoint.dy +
          lowerLegLength * math.cos(rightLegAngle + rightKneeAngle),
    );

    // Calf muscles
    final rightCalfPath =
        Path()
          ..moveTo(rightKneePoint.dx, rightKneePoint.dy)
          ..lineTo(rightAnklePoint.dx + 3, rightAnklePoint.dy)
          ..lineTo(rightAnklePoint.dx - 3, rightAnklePoint.dy)
          ..close();
    canvas.drawPath(rightCalfPath, musclePaint);

    canvas.drawLine(rightKneePoint, rightAnklePoint, paint);

    // Add realistic feet with proper angle
    final footLength = size.width * 0.1;

    // Left foot with proper angle relative to leg
    final leftFootAngle = leftLegAngle + leftKneeAngle - math.pi / 2;
    final leftFootEndPoint = Offset(
      leftAnklePoint.dx + footLength * math.cos(leftFootAngle),
      leftAnklePoint.dy + footLength * math.sin(leftFootAngle),
    );

    // Draw foot as a path for more realistic shape
    final leftFootPath =
        Path()
          ..moveTo(leftAnklePoint.dx, leftAnklePoint.dy)
          ..lineTo(
            leftAnklePoint.dx +
                footLength * 0.1 * math.cos(leftFootAngle - 0.2),
            leftAnklePoint.dy +
                footLength * 0.1 * math.sin(leftFootAngle - 0.2),
          )
          ..lineTo(leftFootEndPoint.dx, leftFootEndPoint.dy)
          ..lineTo(
            leftAnklePoint.dx +
                footLength * 0.9 * math.cos(leftFootAngle + 0.3),
            leftAnklePoint.dy +
                footLength * 0.9 * math.sin(leftFootAngle + 0.3),
          )
          ..close();

    canvas.drawPath(leftFootPath, skinPaint);
    canvas.drawPath(leftFootPath, paint);

    // Right foot with proper angle relative to leg
    final rightFootAngle = rightLegAngle + rightKneeAngle - math.pi / 2;
    final rightFootEndPoint = Offset(
      rightAnklePoint.dx + footLength * math.cos(rightFootAngle),
      rightAnklePoint.dy + footLength * math.sin(rightFootAngle),
    );

    // Draw foot as a path
    final rightFootPath =
        Path()
          ..moveTo(rightAnklePoint.dx, rightAnklePoint.dy)
          ..lineTo(
            rightAnklePoint.dx +
                footLength * 0.1 * math.cos(rightFootAngle - 0.2),
            rightAnklePoint.dy +
                footLength * 0.1 * math.sin(rightFootAngle - 0.2),
          )
          ..lineTo(rightFootEndPoint.dx, rightFootEndPoint.dy)
          ..lineTo(
            rightAnklePoint.dx +
                footLength * 0.9 * math.cos(rightFootAngle + 0.3),
            rightAnklePoint.dy +
                footLength * 0.9 * math.sin(rightFootAngle + 0.3),
          )
          ..close();

    canvas.drawPath(rightFootPath, skinPaint);
    canvas.drawPath(rightFootPath, paint);

    // Add hands (ovals for more realistic shape)
    final handWidth = headWidth * 0.35;
    final handHeight = headHeight * 0.25;

    // Left hand
    final leftHandRect = Rect.fromCenter(
      center: leftWristPoint,
      width: handWidth,
      height: handHeight,
    );
    canvas.drawOval(leftHandRect, skinPaint);
    canvas.drawOval(leftHandRect, paint);

    // Right hand
    final rightHandRect = Rect.fromCenter(
      center: rightWristPoint,
      width: handWidth,
      height: handHeight,
    );
    canvas.drawOval(rightHandRect, skinPaint);
    canvas.drawOval(rightHandRect, paint);

    // Add a more realistic face
    final eyeOffset = headWidth * 0.2;
    final eyeY = faceCenter.dy - headHeight * 0.1;
    final eyeSize = headWidth * 0.08;

    // Draw eyes with white sclera and colored iris
    // Left eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx - eyeOffset, eyeY),
        width: eyeSize * 1.8,
        height: eyeSize,
      ),
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      Offset(faceCenter.dx - eyeOffset, eyeY),
      eyeSize * 0.5,
      Paint()..color = Colors.black,
    );

    // Right eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx + eyeOffset, eyeY),
        width: eyeSize * 1.8,
        height: eyeSize,
      ),
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      Offset(faceCenter.dx + eyeOffset, eyeY),
      eyeSize * 0.5,
      Paint()..color = Colors.black,
    );

    // Eyebrows
    canvas.drawLine(
      Offset(faceCenter.dx - eyeOffset - eyeSize * 0.5, eyeY - eyeSize * 1.2),
      Offset(faceCenter.dx - eyeOffset + eyeSize * 0.5, eyeY - eyeSize * 0.8),
      Paint()
        ..color = Colors.brown.shade800
        ..strokeWidth = 2.0,
    );

    canvas.drawLine(
      Offset(faceCenter.dx + eyeOffset - eyeSize * 0.5, eyeY - eyeSize * 0.8),
      Offset(faceCenter.dx + eyeOffset + eyeSize * 0.5, eyeY - eyeSize * 1.2),
      Paint()
        ..color = Colors.brown.shade800
        ..strokeWidth = 2.0,
    );

    // Nose
    final nosePath =
        Path()
          ..moveTo(faceCenter.dx, eyeY + eyeSize * 1.5)
          ..lineTo(faceCenter.dx - eyeSize * 0.5, eyeY + eyeSize * 3.0)
          ..lineTo(faceCenter.dx + eyeSize * 0.5, eyeY + eyeSize * 3.0)
          ..close();

    canvas.drawPath(nosePath, skinPaint);

    // Mouth - slightly smiling
    final mouthY = faceCenter.dy + headHeight * 0.2;
    final mouthPath =
        Path()
          ..moveTo(faceCenter.dx - eyeOffset, mouthY)
          ..quadraticBezierTo(
            faceCenter.dx,
            mouthY + eyeSize * 2,
            faceCenter.dx + eyeOffset,
            mouthY,
          );

    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Add ears
    final earSize = headHeight * 0.25;
    final earY = faceCenter.dy - headHeight * 0.05;

    // Left ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx - headWidth / 2 - 1, earY),
        width: earSize * 0.6,
        height: earSize,
      ),
      skinPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx - headWidth / 2 - 1, earY),
        width: earSize * 0.6,
        height: earSize,
      ),
      paint,
    );

    // Right ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx + headWidth / 2 + 1, earY),
        width: earSize * 0.6,
        height: earSize,
      ),
      skinPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(faceCenter.dx + headWidth / 2 + 1, earY),
        width: earSize * 0.6,
        height: earSize,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(RealisticHumanPainter oldDelegate) {
    return oldDelegate.walkAnimation != walkAnimation ||
        oldDelegate.armAnimation != armAnimation ||
        oldDelegate.legAnimation != legAnimation ||
        oldDelegate.breathingAnimation != breathingAnimation ||
        oldDelegate.headBobAnimation != headBobAnimation ||
        oldDelegate.color != color;
  }
}
