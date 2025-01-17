import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_state.dart';
import 'package:ysave/utils/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends AuthState<SignupPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void moveToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth
        .signUp(_emailController.text, _passwordController.text);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'You have created your account');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signup', (route) => false);
      _emailController.clear();
      _passwordController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 18, right: 18),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 36,
                  height: 50,
                  child: ElevatedButton(
                    // style: ButtonStyle(
                      // padding: EdgeInsetsGeometry),
                onPressed: _isLoading ? null : _signIn,
                child: Text(_isLoading ? 'Loading' : 'Sign Up'),
              ),
                ),
              
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account,"),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: moveToLogin,
                  child: Text('Login'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
