class RefreshTokenResponse {
  RefreshTokenResponse({
    this.refresh,
    this.access,
  });

  final String? refresh;
  final String? access;

  RefreshTokenResponse copyWith({
    String? refresh,
    String? access,
  }) {
    return RefreshTokenResponse(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
    );
  }

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      refresh: json["refresh"],
      access: json["access"],
    );
  }

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
