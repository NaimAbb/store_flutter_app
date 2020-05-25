class EmailExistException implements Exception {
  String _msg;

  EmailExistException(this._msg);

  @override
  String toString() {
    return _msg;
  }
}
