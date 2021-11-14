import '/logic/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CounterSlider extends StatefulWidget {
  const CounterSlider({
    Key key,
  }) : super(key: key);

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<CounterSlider>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double _startAnimationPosX;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    _animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: SizerUtil.deviceType == DeviceType.tablet ? 40.0.w : 60.0.w,
        height: 10.h,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60.0),
          // ignore: deprecated_member_use
          color: Color.fromRGBO(38, 122, 133, 1).withOpacity(0.6),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 25.0,
                bottom: null,
                child: Icon(
                  Icons.remove,
                  size: SizerUtil.deviceType == DeviceType.tablet
                      ? 7.0.w
                      : 10.0.w,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 25.0,
                top: null,
                child: Icon(
                  Icons.add,
                  size: SizerUtil.deviceType == DeviceType.tablet
                      ? 7.0.w
                      : 10.0.w,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Padding(
                    padding: const EdgeInsets.all(11.5),
                    child: Material(
                      // ignore: deprecated_member_use
                      color: Color.fromRGBO(123, 187, 187, 1),
                      shape: const CircleBorder(),
                      elevation: 5.0,
                      child: Center(
                        child: Icon(Icons.trip_origin,
                            size: SizerUtil.deviceType == DeviceType.tablet
                                ? 7.0.w
                                : 5.0.w,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;

    return ((local.dx * 0.75) / box.size.width) - 0.4;
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();

    if (_controller.value <= -0.20) {
      context.read<CounterCubit>().decrement();
    } else if (_controller.value >= 0.20) {
      context.read<CounterCubit>().increment();
    }

    final SpringDescription _kDefaultSpring =
        SpringDescription.withDampingRatio(
      mass: 0.9,
      stiffness: 250.0,
      ratio: 0.6,
    );

    _controller.animateWith(
        SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
  }
}
