import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/database/tables/froms/forms_table.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/router/app_router.dart';
import '../../../../../../utils/logger.dart';
import '../../../../../common/widgets/varosa_app_button.dart';
import '../../bloc/dynamic_form_bloc.dart';
import '../../bloc/dynamic_form_event.dart';
import '../../bloc/dynamic_form_state.dart';
import '../../data/dummy_form.dart';
import '../../models/dynamic_form.dart';
import '../widgets/dynamic_form_step.dart';

class DynamicFormScreen extends StatefulWidget {
  final int? formId;
  final bool readOnly;

  const DynamicFormScreen({
    super.key,
    required this.formId,
    this.readOnly = false,
  });

  /// Method to navigate to this screen
  static Future<T?> navigate<T>(
    BuildContext context, {
    required int formId,
    bool readOnly = false,
    bool go = false,
  }) async {
    final params = <String, String>{
      'formId': formId.toString(),
      'readOnly': readOnly.toString(),
    };

    if (go) {
      context.goNamed(
        AppRouter.dynamicForm.toPathName,
        queryParameters: params,
      );
      return null;
    }

    return context.pushNamed(
      AppRouter.dynamicForm.toPathName,
      queryParameters: params,
    );
  }

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DynamicFormBloc(),
      child: _DynamicFormContent(
        formId: widget.formId,
        readOnly: widget.readOnly,
      ),
    );
  }
}

/// Content of the dynamic form screen
///
class _DynamicFormContent extends StatefulWidget {
  const _DynamicFormContent({this.formId, this.readOnly = false});

  final int? formId;
  final bool readOnly;

  @override
  State<_DynamicFormContent> createState() => _DynamicFormContentState();
}

class _DynamicFormContentState extends State<_DynamicFormContent>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadForm();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  /// Method to get the dynamic form from the server or local storage with the formId
  /// But for now, we are using a static form
  ///
  Future<void> _loadForm() async {
    if (widget.formId == null) return;

    final form = DynamicForm.fromJson(dummyFormJson);
    context.read<DynamicFormBloc>().add(
      DynamicFormInitialized(form: form, readOnly: widget.readOnly),
    );

    // Check if the form is already started filling and state is
    // preserve in the database
    final schema = await FormsTable.instance.get(widget.formId!);
    if (schema != null && mounted) {
      if (!schema.isCompleted &&
          schema.answers != null &&
          schema.answers!.trim().isNotEmpty) {
        // Show a dialog to ask user to continue from the previous state
        _showContinueFromPreviousStateConfirmationDialog(
          onRestore: () {
            final answers = jsonDecode(schema.answers!);
            context.read<DynamicFormBloc>().add(
              DynamicFormFieldsUpdated(
                values: answers,
                lastStep: schema.lastStep,
              ),
            );
          },
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) _saveFormState();
  }

  /// Method to save the form state to the database for future use
  ///
  Future<void> _saveFormState() async {
    try {
      final state = context.read<DynamicFormBloc>().state;
      final form = state.form;
      final answers = state.answers;

      if (form.id == null) return;

      final date = DateTime.now().toIso8601String();

      final schema = form.toSchema.copy(
        answers: jsonEncode(answers),
        isCompleted: state.isLastStep && state.errors.isEmpty,
        lastStep: state.currentStep,
        createdAt: date,
        updatedAt: date,
      );

      await FormsTable.instance.insert(schema);
    } catch (e) {
      Logger.logError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DynamicFormBloc, DynamicFormState>(
      listener: (context, state) {
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
        return PopScope(
          canPop: !state.canGoBack,
          onPopInvokedWithResult: (popped, result) {
            if (!popped) {
              if (state.canGoBack) {
                context.read<DynamicFormBloc>().add(
                  const DynamicFormPreviousStepRequested(),
                );
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.form.title ?? 'Dynamic Form'),
              centerTitle: true,
            ),
            body:
                (state.form.title == null ||
                        state.form.title?.isEmpty == true) &&
                    state.form.steps.isEmpty
                ? const Center(child: Text('No form data available.'))
                : Form(
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
          ),
        );
      },
    );
  }

  /// Method to show the dialog to ask user to continue from the previous state
  ///
  void _showContinueFromPreviousStateConfirmationDialog({
    VoidCallback? onRestore,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Previous State'),
        content: Text('Do you want to continue from the previous state?'),
        actions: [
          VarosaAppButton(
            width: 80.0,
            onPressed: context.pop,
            text: 'Cancel',
            buttonType: VarosaAppButtonType.text,
            borderRadius: BorderRadius.circular(42.0),
          ),
          VarosaAppButton(
            width: 80.0,
            onPressed: () {
              context.pop();
              onRestore?.call();
            },
            text: 'Restore',
            buttonType: VarosaAppButtonType.text,
            color: Colors.red,
            borderRadius: BorderRadius.circular(42.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
