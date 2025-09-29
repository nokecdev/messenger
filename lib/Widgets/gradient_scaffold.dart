import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? floatingActionButton;

  const GradientScaffold({
    super.key,
    this.appBar,
    this.drawer,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: Container(
        constraints: const BoxConstraints.expand(), // mindig full screen
        decoration: BoxDecoration(
          gradient: themeNotifier.getGradient(),
        ),
        child: body,
      ),
    );
  }
}
