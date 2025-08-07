import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/router/app_router.dart';
import '../../models/dynamic_form.dart';
import '../../models/form_step.dart';
import '../../models/input_field.dart';
import '../widgets/dynamic_form_dropdown_input_field.dart';
import '../widgets/dynamic_form_numeric_input_field.dart';
import '../widgets/dynamic_form_text_input_field.dart';
import '../widgets/dynamic_form_toggle_input_field.dart';

class DynamicFormScreen extends StatefulWidget {
  final DynamicForm form;
  final Function(Map<String, dynamic>)? onSubmit;
  final bool readOnly;

  DynamicFormScreen({
    super.key,
    required this.form,
    this.onSubmit,
    this.readOnly = false,
  }) : assert(form.steps.isNotEmpty, 'Form must have at least one step');

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.dynamicForm.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.dynamicForm.toPathName);
  }

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  late final PageController _pageController;
  late int _currentStep;
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentStep = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentStep < widget.form.steps.length - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_formData);
    }
  }

  void _updateFormData(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  Widget _buildInputField(InputField field) {
    final value = _formData[field.key]?.toString();

    switch (field.type) {
      case InputFieldType.text:
        return DynamicFormTextInputField(
          field: field,
          value: value,
          onChanged: (value) => _updateFormData(field.key!, value),
          readOnly: widget.readOnly,
        );
      case InputFieldType.number:
        return DynamicFormNumericInputField(
          field: field,
          value: value,
          onChanged: (value) => _updateFormData(field.key!, value),
          readOnly: widget.readOnly,
        );
      case InputFieldType.dropdown:
        return DynamicFormDropdownInputField(
          field: field,
          value: value,
          onChanged: (value) => _updateFormData(field.key!, value),
          readOnly: widget.readOnly,
        );
      case InputFieldType.toggle:
        return DynamicFormToggleInputField(
          field: field,
          value: (_formData[field.key] as bool?) ?? false,
          onChanged: (value) => _updateFormData(field.key!, value),
          readOnly: widget.readOnly,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFormStep(FormStep step) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step.title != null) ...[
            Text(
              step.title!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
          if (step.description != null) ...[
            Text(
              step.description!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
          ],
          ...step.inputs.map((field) => _buildInputField(field)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: _previousStep,
                  child: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                onPressed: _nextStep,
                child: Text(
                  _currentStep < widget.form.steps.length - 1
                      ? 'Next'
                      : 'Submit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.form.title ?? 'Dynamic Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.form.steps.length,
          itemBuilder: (context, index) {
            return _buildFormStep(widget.form.steps[index]);
          },
        ),
      ),
    );
  }
}
