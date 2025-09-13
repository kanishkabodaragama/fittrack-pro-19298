import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../core/app_state.dart';
import '../../../models/workout.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final _types = ['Running', 'Cycling', 'Swimming', 'Weights', 'Yoga', 'Other'];
  String _selectedType = 'Running';
  int _duration = 30;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _logWorkout() async {
    final workout = Workout(
      date: DateTime.now(),
      type: _selectedType,
      durationMinutes: _duration,
      notes: _notesController.text.trim(),
    );

    await context.read<AppState>().addWorkout(workout);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout logged successfully!')),
    );
    
    // Reset form
    setState(() {
      _selectedType = 'Running';
      _duration = 30;
      _notesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GradientHeader(title: 'Workouts'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log New Workout',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Workout type
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Workout Type',
                          prefixIcon: Icon(Icons.fitness_center_rounded),
                        ),
                        items: _types.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Duration slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration: $_duration minutes',
                            style: theme.textTheme.titleMedium,
                          ),
                          Slider(
                            value: _duration.toDouble(),
                            min: 5,
                            max: 180,
                            divisions: 35,
                            label: '$_duration min',
                            onChanged: (value) {
                              setState(() => _duration = value.round());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.note_rounded),
                          hintText: 'Add any notes about your workout...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _logWorkout,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Log Workout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
