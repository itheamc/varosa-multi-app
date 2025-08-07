enum InputFieldType {
  text,
  number,
  dropdown,
  toggle;

  factory InputFieldType.fromStr(String type) {
    return InputFieldType.values.firstWhere((e) => e.name == type);
  }
}

class InputField {
  InputField({
    this.key,
    this.type,
    this.label,
    this.required,
    this.inputDefault,
    this.validation,
    this.options = const [],
  });

  final String? key;
  final InputFieldType? type;
  final String? label;
  final bool? required;
  final dynamic inputDefault;
  final Validation? validation;
  final List<String> options;

  InputField copy({
    String? key,
    InputFieldType? type,
    String? label,
    bool? required,
    dynamic inputDefault,
    Validation? validation,
    List<String>? options,
  }) {
    return InputField(
      key: key ?? this.key,
      type: type ?? this.type,
      label: label ?? this.label,
      required: required ?? this.required,
      inputDefault: inputDefault ?? this.inputDefault,
      validation: validation ?? this.validation,
      options: options ?? this.options,
    );
  }

  factory InputField.fromJson(Map<String, dynamic> json) {
    final field = InputField(
      key: json["key"],
      type: InputFieldType.fromStr(json["type"]),
      label: json["label"],
      required: json["required"],
      inputDefault: json["default"],
      validation: json["validation"] == null
          ? null
          : Validation.fromJson(json["validation"]),
      options: json["options"] == null
          ? []
          : List<String>.from(json["options"]!.map((x) => x)),
    );

    if (field.validation?.numberOnly == true &&
        field.type != InputFieldType.number) {
      return field.copy(type: InputFieldType.number);
    }
    return field;
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "type": type?.name,
    "label": label,
    "required": required,
    "default": inputDefault,
    "validation": validation?.toJson(),
    "options": options.map((x) => x).toList(),
  };
}

class Validation {
  Validation({this.numberOnly});

  final bool? numberOnly;

  Validation copy({bool? numberOnly}) {
    return Validation(numberOnly: numberOnly ?? this.numberOnly);
  }

  factory Validation.fromJson(Map<String, dynamic> json) {
    return Validation(numberOnly: json["numberOnly"]);
  }

  Map<String, dynamic> toJson() => {"numberOnly": numberOnly};
}
