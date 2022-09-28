import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../services/login_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// Para telas grandes
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 0,
            child: Image.asset(
              'assets/logo+texto.png',
              height: size.height * 0.41,
              width: double.infinity,
              //fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// Para telas pequenas
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  ///Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Image.asset(
                'assets/logo.png',
                height: size.height * 0.3,
                width: size.width,
                //fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.00,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'WorkOut Tasker',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Bem vindo de volta!',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: emailController,
                  // O validador recebe o valor do texto que será digitado
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor digite seu Email';
                    } else if (value.length < 13) {
                      return 'Email inválido';
                    } else if (value.length > 25) {
                      return 'O máximo de caractéres é 25';
                    }
                    return null;
                  },
                ),
                // SizedBox(
                //   height: size.height * 0.02,
                // ),
                // TextFormField(
                //   controller: emailController,
                //   decoration: const InputDecoration(
                //     prefixIcon: Icon(Icons.email_rounded),
                //     hintText: 'gmail',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //   ),
                //   // O validador recebe o valor que o usuário digitar
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter gmail';
                //     } else if (!value.endsWith('@gmail.com')) {
                //       return 'please enter valid gmail';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Senha
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Senha',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // O validador recebe o texto que o usuário digitar
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor digite sua senha';
                      } else if (value.length < 7) {
                        return 'Deve conter no mínimo 7 caractéres';
                      } else if (value.length > 13) {
                        return 'O máximo de caracteres é 13';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navegar para tela de login
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Não possui uma conta?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: " Cadastre-se",
                          style: kLoginOrSignUpTextStyle(
                            size,
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
      ],
    );
  }

  // Botão Login
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Valida e retorna true se valido, se nao, invalido
          if (_formKey.currentState!.validate()) {
            LoginService().login(
              emailController.text,
              passwordController.text,
            );
            // ... Navegar para a homePage
          } else {
            print("Invalido!");
          }
        },
        child: const Text('Login'),
      ),
    );
  }
}
