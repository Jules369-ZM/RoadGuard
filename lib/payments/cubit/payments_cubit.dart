import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit() : super(const PaymentsState());
}
