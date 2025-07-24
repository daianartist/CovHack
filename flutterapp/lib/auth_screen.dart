import 'package:flutter/material.dart';
import './widgets/social_login_buttons.dart';
import 'services/api_service.dart';
import 'screens/forgot_password_screen.dart';

class AuthScreen extends StatefulWidget {
  final int initialTab;
  
  const AuthScreen({super.key, this.initialTab = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  String _registerRole = 'student';
  bool _registerObscurePassword = true;
  bool _registerIsLoading = false;
  String? _registerErrorMessage;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerNameController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    final newPasswordController = TextEditingController();
    String? step = 'email';
    String? error;
    String? email;
    String? code;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(step == 'email' ? 'Forgot password' : 'Reset password'),
              content: step == 'email'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 8),
                          Text(error!, style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Код отправлен на email (или выведен в ответе API)'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: codeController,
                          decoration: const InputDecoration(labelText: 'Code'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'New password'),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 8),
                          Text(error!, style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                if (step == 'email')
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                              error = null;
                            });
                            try {
                              final resp = await _apiService.forgotPassword(emailController.text.trim());
                              email = emailController.text.trim();
                              code = resp['code']; // Для теста
                              setState(() {
                                step = 'code';
                                isLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                error = e.toString();
                                isLoading = false;
                              });
                            }
                          },
                    child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Send code'),
                  ),
                if (step == 'code')
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                              error = null;
                            });
                            try {
                              await _apiService.resetPassword(
                                email!,
                                codeController.text.trim(),
                                newPasswordController.text.trim(),
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successful!')));
                            } catch (e) {
                              setState(() {
                                error = e.toString();
                                isLoading = false;
                              });
                            }
                          },
                    child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Reset password'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                'assets/logo_covuni.png',
                height: 80,
              ),
              
              const SizedBox(height: 40),
              
              // Tab Bar
              Container(
                height: 54,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF666666),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Register'),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        const Text(
          'Email address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Your email',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Password field
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Sign in button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () async {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              try {
                await _apiService.login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
        
        const SizedBox(height: 32),
        
        // Social login
        const Center(
          child: Text(
            'Other sign in options',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        const SocialLoginButtons(),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field
        const Text(
          'Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _registerNameController,
          decoration: InputDecoration(
            hintText: 'Your name',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Email field
        const Text(
          'Email address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _registerEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Your email',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Password field
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _registerPasswordController,
          obscureText: _registerObscurePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _registerObscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
              onPressed: () {
                setState(() {
                  _registerObscurePassword = !_registerObscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Role dropdown
        const Text(
          'Role',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _registerRole,
          items: const [
            DropdownMenuItem(value: 'student', child: Text('Student')),
            DropdownMenuItem(value: 'moderator', child: Text('Moderator')),
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
          ],
          onChanged: (value) {
            setState(() {
              _registerRole = value ?? 'student';
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Sign up button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _registerIsLoading ? null : () async {
              setState(() {
                _registerIsLoading = true;
                _registerErrorMessage = null;
              });
              try {
                await _apiService.register(
                  _registerNameController.text.trim(),
                  _registerEmailController.text.trim(),
                  _registerPasswordController.text.trim(),
                  _registerRole,
                );
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              } catch (e) {
                setState(() {
                  _registerErrorMessage = e.toString();
                });
              } finally {
                if (mounted) {
                  setState(() {
                    _registerIsLoading = false;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _registerIsLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (_registerErrorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _registerErrorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
        const SizedBox(height: 32),
        // Social login
        const Center(
          child: Text(
            'Other sign in options',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const SocialLoginButtons(),
      ],
    );
  }
}