abstract class LocalDataEvent {
  const LocalDataEvent();
}

class ReadTables extends LocalDataEvent {
  const ReadTables();
}

class InitTable extends LocalDataEvent {
  final String user;
  final String pass;
  final String bdName;
  const InitTable({
    required this.user,
    required this.pass,
    required this.bdName,
  });
}
