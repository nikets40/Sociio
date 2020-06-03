import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';

class BusyOverlay extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final bool show;

  BusyOverlay({
    this.child,
    this.title = 'Please wait...',
    this.description = '',
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          child,
          IgnorePointer(
            ignoring: show ? false : true,
            child: Opacity(
              opacity: show ? 1.0 : 0.0,
              child: Container(
                width: screenWidth(context),
                height: screenHeight(context),
                alignment: Alignment.center,
                color: Color.fromARGB(175, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                    description.isNotEmpty
                        ? Text(
                            description,
                            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white,fontWeight: FontWeight.w600),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
