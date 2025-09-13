import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../core/app_state.dart';
import '../../../models/goal.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _titleController = TextEditingController();
  int _target = 10;
  
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addGoal() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final goal = Goal(
      title: title,
      target: _target,
    );

    await context.read<AppState>().addGoal(goal);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal added successfully!')),
    );
    
    // Reset form
    setState(() {
      _titleController.clear();
      _target = 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GradientHeader(title: 'Goals'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add new goal card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set New Goal',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Goal Title',
                          prefixIcon: Icon(Icons.flag_rounded),
                          hintText: 'What do you want to achieve?',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target: $_target',
                            style: theme.textTheme.titleMedium,
                          ),
                          Slider(
                            value: _target.toDouble(),
                            min: 1,
                            max: 100,
                            divisions: 99,
                            label: '$_target',
                            onChanged: (value) {
                              setState(() => _target = value.round());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addGoal,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add Goal'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Goals list
              Text(
                'Your Goals',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Goal>>(
                future: context.read<AppState>().db.goalDao.findAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No goals set yet. Add your first goal!'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final goal = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          leading: goal.completed
                              ? Icon(Icons.check_circle_rounded,
                                  color: theme.colorScheme.tertiary)
                              : const Icon(Icons.radio_button_unchecked_rounded),
                          title: Text(goal.title),
                          subtitle: LinearProgressIndicator(
                            value: goal.progress / goal.target,
                            backgroundColor: theme.colorScheme.secondary.withAlpha(40),
                          ),
                          trailing: Text(
                            '${goal.progress}/${goal.target}',
                            style: theme.textTheme.bodyLarge,
                          ),
                          onTap: () async {
                            await context.read<AppState>().toggleGoal(goal);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
