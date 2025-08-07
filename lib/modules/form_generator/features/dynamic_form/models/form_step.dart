import 'input_field.dart';

class FormStep {
  FormStep({this.title, this.description, this.inputs = const []});

  final String? title;
  final String? description;
  final List<InputField> inputs;

  FormStep copy({
    String? title,
    String? description,
    List<InputField>? inputs,
  }) {
    return FormStep(
      title: title ?? this.title,
      description: description ?? this.description,
      inputs: inputs ?? this.inputs,
    );
  }

  factory FormStep.fromJson(Map<String, dynamic> json) {
    return FormStep(
      title: json["title"],
      description: json["description"],
      inputs: json["inputs"] == null || json["inputs"] is! List
          ? []
          : List<InputField>.from(
        json["inputs"]!.map((x) => InputField.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "inputs": inputs.map((x) => x.toJson()).toList(),
  };
}