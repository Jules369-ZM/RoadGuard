import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'start_state.dart';

class StartCubit extends Cubit<StartState> {
  StartCubit() : super(const StartInitial());

  /// A description for yourCustomFunction 
  FutureOr<void> yourCustomFunction() {
    // TODO: Add Logic
  }
}
