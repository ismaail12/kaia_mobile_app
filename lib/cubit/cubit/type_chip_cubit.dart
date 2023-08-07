import 'package:bloc/bloc.dart';

class TypeChipCubit extends Cubit<Map<String, bool>> {
  TypeChipCubit()
      : super({
          "normal": false,
          "lembur": false,
        });
  void setNormalTrue() => emit({
        "normal": true,
        "lembur": false,
      });
  void setLemburTrue() => emit({
        "normal": false,
        "lembur": true,
      });
}
