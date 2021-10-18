class RegexMatchInfo {
  final int matcheCount;
  final String matchTime;
  final bool hasError;

  const RegexMatchInfo({
    required final this.matcheCount,
    required final this.matchTime,
    required final this.hasError,
  });

  RegexMatchInfo copyWithNoError() {
    return RegexMatchInfo(
      matcheCount: matcheCount,
      matchTime: matchTime,
      hasError: false,
    );
  }

  RegexMatchInfo.init()
      : matchTime = '',
        matcheCount = 0,
        hasError = false;
}

extension RegExpMethod on RegExp {
  RegExp copyWith({
    final bool? isCaseSensitive,
    final bool? isDotAll,
    final bool? isMultiLine,
    final bool? isUnicode,
    final String? pattern,
  }) {
    return RegExp(
      pattern ?? this.pattern,
      caseSensitive: isCaseSensitive ?? this.isCaseSensitive,
      dotAll: isDotAll ?? this.isDotAll,
      multiLine: isMultiLine ?? this.isMultiLine,
      unicode: isUnicode ?? this.isUnicode,
    );
  }

  List<bool> getBoolValues() {
    return List.from(
      [this.isCaseSensitive, this.isDotAll, this.isMultiLine, this.isUnicode],
      growable: false,
    );
  }
}
