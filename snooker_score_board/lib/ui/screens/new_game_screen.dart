import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/game_board_screen.dart';
import 'package:snooker_score_board/ui/screens/game_history_screen.dart';
import 'package:snooker_score_board/utils/accessibility_utils.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final List<TextEditingController> _playerControllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Start with 2 player input fields
    _addPlayerField();
    _addPlayerField();
  }

  void _addPlayerField() {
    setState(() {
      _playerControllers.add(TextEditingController());
    });
  }

  void _removePlayerField(int index) {
    setState(() {
      _playerControllers[index].dispose();
      _playerControllers.removeAt(index);
    });
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final playerNames = _playerControllers
          .map((controller) => controller.text.trim())
          .where((name) => name.isNotEmpty)
          .toList();

      if (playerNames.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter at least 2 player names.')),
        );
        return;
      }

      Provider.of<GameProvider>(context, listen: false).startNewGame(playerNames);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GameBoardScreen()),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Snooker Game',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GameHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _playerControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              explicitChildNodes: true,
                              label: AccessibilityUtils.generatePlayerLabel(index, 'Player ${index + 1}'),
                              child: TextFormField(
                                controller: _playerControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Player ${index + 1} Name',
                                  border: const OutlineInputBorder(),
                                  semanticCounterText: 'Player ${index + 1} name field',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Player name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          if (_playerControllers.length > 2) // Allow removing if more than 2 players
                            Semantics(
                              button: true,
                              label: 'Remove player ${index + 1}',
                              child: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _removePlayerField(index),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    button: true,
                    label: 'Add another player field',
                    child: ElevatedButton.icon(
                      onPressed: _addPlayerField,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Player'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Semantics(
                    button: true,
                    label: 'Start the snooker game with the entered players',
                    child: ElevatedButton.icon(
                      onPressed: _startGame,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Game'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}