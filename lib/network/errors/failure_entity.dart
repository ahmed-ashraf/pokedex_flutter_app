abstract class FailureEntity {}

class ServerFailure extends FailureEntity {}

class DataParsingException extends FailureEntity {}

class NoConnectionException extends FailureEntity {}
