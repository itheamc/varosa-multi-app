import 'package:equatable/equatable.dart';
import '../models/todo.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object?> get props => [];
}

class TodosLoaded extends TodosEvent {
  const TodosLoaded();
}

class TodoAdded extends TodosEvent {
  final Todo todo;

  const TodoAdded(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoUpdated extends TodosEvent {
  final Todo todo;

  const TodoUpdated(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoDeleted extends TodosEvent {
  final int id;

  const TodoDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoToggled extends TodosEvent {
  final Todo todo;

  const TodoToggled(this.todo);

  @override
  List<Object?> get props => [todo];
}
