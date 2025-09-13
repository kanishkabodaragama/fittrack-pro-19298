import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_theme.dart';
import '../../../core/app_state.dart';
import '../../../models/user.dart';
import '../../auth/registration_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _emailC;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().activeUser;
    _nameC = TextEditingController(text: user?.name);
    _emailC = TextEditingController(text: user?.email);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final app = context.read<AppState>();
    final updated = User(
      id: app.activeUser?.id,
      name: _nameC.text.trim(),
      email: _emailC.text.trim(),
      avatar: app.activeUser?.avatar,
    );

    await app.updateUser(updated);
    
    if (!mounted) return;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_account', false);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AppState>().activeUser;
    if (user == null) return const SizedBox();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GradientHeader(
          title: 'Profile',
          actions: [
            IconButton(
              onPressed: () => setState(() => _editing = !_editing),
              icon: Icon(_editing ? Icons.close_rounded : Icons.edit_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary.withAlpha(40),
                child: Text(
                  user.name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Profile form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameC,
                          enabled: _editing,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person_rounded),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty 
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailC,
                          enabled: _editing,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!v.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        if (_editing) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _updateProfile,
                              icon: const Icon(Icons.save_rounded),
                              label: const Text('Save Changes'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Action buttons
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_rounded),
                      title: const Text('Notifications'),
                      trailing: Switch(
                        value: true,
                        onChanged: (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications feature coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
