enum DataStatus { initial, loading, failure, success }

extension DataStatusX on DataStatus {
  bool get loading => this == DataStatus.loading;
  bool get failure => this == DataStatus.failure;
  bool get success => this == DataStatus.success;
  bool get initial => this == DataStatus.initial;
}
