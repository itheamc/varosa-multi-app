import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/router/app_router.dart';
import '../../bloc/form_bloc.dart';
import '../../bloc/form_event.dart';
import '../../bloc/form_state.dart';
import '../../models/dynamic_form.dart';
import '../widgets/dynamic_form_step.dart';

class DynamicFormScreen extends StatelessWidget {
  final DynamicForm form;
  final Function(Map<String, dynamic>)? onSubmit;
  final bool readOnly;

  const DynamicFormScreen({
    super.key,
    required this.form,
    this.onSubmit,
    this.readOnly = false,
  });

  /// Method to navigate to this screen
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.dynamicForm.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.dynamicForm.toPathName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DynamicFormBloc(onSubmit: onSubmit)
            ..add(DynamicFormInitialized(form: form, readOnly: readOnly)),
      child: _DynamicFormContent(readOnly: readOnly),
    );
  }
}

class _DynamicFormContent extends StatefulWidget {
  final bool readOnly;

  const _DynamicFormContent({super.key, required this.readOnly});

  @override
  State<_DynamicFormContent> createState() => _DynamicFormContentState();
}

class _DynamicFormContentState extends State<_DynamicFormContent> {
  late final PageController _pageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DynamicFormBloc, DynamicFormState>(
      listener: (context, state) {
        // Animate to the current step when it changes
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentStep) {
          _pageController.animateToPage(
            state.currentStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.form.title ?? 'Dynamic Form'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.form.steps.length,
              itemBuilder: (context, index) {
                return DynamicFormStep(
                  step: state.form.steps[index],
                  readOnly: state.readOnly,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
