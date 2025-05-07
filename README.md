# Flutter Dancing Animation

A sophisticated Flutter application demonstrating complex custom animations with a dancing human figure. This project showcases advanced animation techniques using CustomPaint, multiple animation controllers, and trigonometric functions to create fluid, lifelike movements.

## Features

- **Realistic Human Figure**: Anatomically proportioned figure with detailed limbs and facial features
- **Complex Dance Movements**: Fluid dance animations with coordinated arm and leg movements
- **Interactive Customization**: Change the dancer's color, size, and dance floor background
- **Expressive Animation**: Dynamic facial expressions, blinking eyes, and moving eyebrows
- **Physics-Based Motion**: Natural joint articulation at shoulders, elbows, hips, and knees



## Implementation Details

This animation is built using several advanced Flutter animation techniques:

- **CustomPaint**: Draws the human figure using path-based rendering
- **Multiple AnimationControllers**: Coordinates different body parts with varied timing
- **Trigonometric Functions**: Creates natural, physics-based movement patterns
- **Transform Widgets**: Applies rotation and positioning effects
- **Matrix Operations**: Handles complex transformations for realistic movement

## Dance Animation Features

The dancing animation includes:

- Body bouncing to simulate dancing to a beat
- Arm movements with enhanced range and expressiveness
- Leg movements with realistic hip and knee articulation
- Subtle body rotation for natural dancing feel
- Expressive facial features that react to the dance rhythm
- Hand rotations and gestures to match the dance style

## How to Use

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Launch with `flutter run`
4. Use the controls at the bottom of the screen to customize:
   - Dancer color
   - Dancer size
   - Dance floor background
   - Dance style

## Code Structure

- `walking_animation.dart`: Core animation implementation with CustomPaint
- `walking_screen.dart`: UI for displaying and controlling the animation
- `main.dart`: App entry point and configuration

## Requirements

- Flutter 3.0+
- Dart 3.0+

## Future Improvements

- Add different dance styles with distinct movement patterns
- Implement music detection to sync dance moves with rhythm
- Add shadow effects for enhanced visual appeal
- Create multiple character options

## License

This project is licensed under the MIT License - see the LICENSE file for details.
