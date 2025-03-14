import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repo/firebase_repo.dart';
part 'drivers_license_state.dart';

class DriversLicenseCubit extends Cubit<DriversLicenseState> {
  DriversLicenseCubit(this.firebaseRepo) : super(const DriversLicenseState());
  final FirebaseRepo firebaseRepo;

  Future<void> updateAction(String action) async {
    emit(state.copyWith(action: action));
  }
}
