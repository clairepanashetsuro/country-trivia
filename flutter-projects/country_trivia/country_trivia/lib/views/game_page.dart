import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/game_viewmodel.dart';

/// Main game screen. Full layout is built out in T014; this is the wiring
/// scaffold that consumes [GameViewModel].
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Country Trivia')),
      body: Center(
        child: Text('Score: ${viewModel.state.score}'),
      ),
    );
  }
}
