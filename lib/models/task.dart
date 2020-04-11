class Task {
  int _id;
  String _task, _date, _time, _status,_desc;

  Task(this._task,this._desc, this._date, this._time, this._status);
  Task.withId(this._id, this._task,this._desc, this._date, this._time, this._status);

  int get id => _id;
  String get task => _task;
  String get desc => _desc;
  String get date => _date;
  String get time => _time;
  String get status => _status;

  set task(String newTask) {
    if (newTask.length <= 255) {
      this._task = newTask;
    }
  }
  set desc(String newTask) {
    if (newTask.length <= 255) {
      this._desc = newTask;
    }
  }

  set date(String newDate) => this._date = newDate;

  set time(String newTime) => this._time = newTime;

  set status(String newStatus) => this._status = newStatus;

  //Convert Task object into MAP object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['task'] = _task;
    map['desc'] = _desc;
    map['date'] = _date;
    map['time'] = _time;
    map['status'] = _status;
    return map;
  }

  //Extract Task object from MAP object
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
    this._desc = map['desc'];
    this._date = map['date'];
    this._time = map['time'];
    this._status = map['status'];
  }
}
