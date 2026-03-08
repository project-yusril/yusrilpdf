abstract class Failure {
  final String message;
  const Failure(this.message);
}

class FileFailure extends Failure {
  const FileFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class ProcessingFailure extends Failure {
  const ProcessingFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
