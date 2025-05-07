import 'package:flutter/material.dart';
import 'walking_animation.dart';

class WalkingScreen extends StatefulWidget {
  const WalkingScreen({Key? key}) : super(key: key);

  @override
  State<WalkingScreen> createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen> {
  Color _characterColor = Colors.blue;
  double _characterWidth = 150;
  double _characterHeight = 300;
  bool _showControls = true;
  double _danceSpeed = 1.0;
  Color _backgroundColor1 = Colors.purple[100]!;
  Color _backgroundColor2 = Colors.white;

  final List<Color> _skinColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.brown.shade600,
    Colors.pinkAccent.shade100,
  ];

  final List<List<Color>> _backgroundOptions = [
    [Colors.purple[100]!, Colors.white],
    [Colors.blue[100]!, Colors.white],
    [Colors.grey[200]!, Colors.grey[50]!],
    [Colors.orange[100]!, Colors.yellow[50]!],
    [Colors.pink[100]!, Colors.white],
  ];

  int _currentBackgroundIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dancing Animation'),
        backgroundColor: _backgroundColor1.withOpacity(0.7),
        actions: [
          IconButton(
            icon: Icon(_showControls ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_backgroundColor1, _backgroundColor2],
                ),
              ),
              child: Center(
                child: WalkingAnimation(
                  width: _characterWidth,
                  height: _characterHeight,
                  color: _characterColor,
                ),
              ),
            ),
          ),
          if (_showControls)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customize Dancer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Dancer Color:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              _skinColors.map((color) {
                                return _ColorButton(
                                  color: color,
                                  isSelected: _characterColor == color,
                                  onTap:
                                      () => setState(
                                        () => _characterColor = color,
                                      ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Dancer Size: '),
                          Expanded(
                            child: Slider(
                              value: _characterWidth,
                              min: 100,
                              max: 300,
                              divisions: 8,
                              label: '${_characterWidth.toInt()}',
                              onChanged: (value) {
                                setState(() {
                                  _characterWidth = value;
                                  _characterHeight = value * 2;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Dance Floor:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _backgroundOptions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentBackgroundIndex = index;
                                    _backgroundColor1 =
                                        _backgroundOptions[index][0];
                                    _backgroundColor2 =
                                        _backgroundOptions[index][1];
                                  });
                                },
                                child: Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: _backgroundOptions[index],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          _currentBackgroundIndex == index
                                              ? Colors.black
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Dance Style: '),
                          Expanded(
                            child: Slider(
                              value: _danceSpeed,
                              min: 0.5,
                              max: 1.5,
                              divisions: 4,
                              label: _getDanceStyleLabel(_danceSpeed),
                              onChanged: (value) {
                                setState(() {
                                  _danceSpeed = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Dancing human with realistic movements,\nexpressive face and fluid dance moves!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getDanceStyleLabel(double speed) {
    if (speed <= 0.6) return 'Slow Dance';
    if (speed <= 0.9) return 'Rhythm Dance';
    if (speed <= 1.2) return 'Fast Dance';
    return 'Party Mode';
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
      ),
    );
  }
}
