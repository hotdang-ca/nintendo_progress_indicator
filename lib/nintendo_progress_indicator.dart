library nintendo_progress_indicator;

import 'package:flutter/widgets.dart';

class NintendoProgressIndicator extends StatefulWidget {
  @override
  _NintendoProgressIndicatorState createState() =>
      _NintendoProgressIndicatorState();
}

class _NintendoProgressIndicatorState extends State<NintendoProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController _slideAnimationController;
  Animation<double> _slideAnimation;

  AnimationController _sizeAnimationController;
  Animation<double> _sizeAnimation;
  Animation<double> _sizeUpAnimation;

  @override
  void initState() {
    _slideAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween(begin: 0.0, end: (12.0 + 44.0 + 12.0)).animate(
        CurvedAnimation(
            curve: Curves.easeInOut, parent: _slideAnimationController));

    _sizeAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _sizeAnimation = Tween(begin: (44.0 + 12.0 + 12.0), end: 0.0).animate(
        CurvedAnimation(
            curve: Curves.easeInOut, parent: _sizeAnimationController));
    _sizeUpAnimation = Tween(begin: 0.0, end: (44.0 + 12.0 + 12.0)).animate(
        CurvedAnimation(
            curve: Curves.easeInOut, parent: _sizeAnimationController));

    _sizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _doAnimate();
      }
    });

    _doAnimate();
    super.initState();
  }

  void _doAnimate() {
    _sizeAnimationController.reset();
    _slideAnimationController.reset();

    _sizeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _sizeAnimationController.dispose();
    _slideAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(
          width: (12.0 + 44.0 + 12.0 + 44.0 + 12.0 + 44.0 + 12.0)),
      margin: EdgeInsets.only(right: 44.0 + 12.0 + 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _sizeUpAnimation,
                builder: (BuildContext context, Widget child) {
                  return SizedBox(
                    child: child,
                    height: _sizeUpAnimation.value,
                    width: _sizeUpAnimation.value,
                  );
                },
                child: RedCircle(),
              ), // zoom in

              PlaceholderCircle(),

              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (BuildContext context, Widget child) {
                  return Positioned(
                    child: child,
                    right: -(_slideAnimation.value),
                  );
                },
                child: RedCircle(),
              ), // zoom in
            ],
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (BuildContext context, Widget child) {
                  return Positioned(
                    right: -(_slideAnimation.value),
                    child: child,
                  );
                },
                child: RedCircle(),
              ), // slide right

              PlaceholderCircle(),

              Positioned(
                left: (12.0 + 44.0 + 12.0), // Padding + Whole Circle
                child: AnimatedBuilder(
                  animation: _sizeAnimation,
                  builder: (BuildContext context, Widget child) {
                    return SizedBox(
                      child: child,
                      height: _sizeAnimation.value,
                      width: _sizeAnimation.value,
                    );
                  },
                  child: RedCircle(),
                ), // zoom in,
              ), // zoom out
            ],
          )
        ],
      ),
    );
  }
}

class RedCircle extends StatelessWidget {
  const RedCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 255, 0, 0),
      ),
    );
  }
}

class PlaceholderCircle extends StatelessWidget {
  const PlaceholderCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.0,
      height: 44.0,
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.black,
        color: Color.fromARGB(0, 0, 0, 0),
      ),
    );
  }
}
