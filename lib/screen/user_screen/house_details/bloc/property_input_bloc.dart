import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_construction_pro/screen/user_screen/house_details/property_input_model.dart';
import 'package:house_construction_pro/screen/user_screen/house_details/property_input_service.dart';

part 'property_input_event.dart';
part 'property_input_state.dart';
part 'property_input_bloc.freezed.dart';

class PropertyInputBloc extends Bloc<PropertyInputEvent, PropertyInputState> {
  PropertyInputBloc() : super(_Initial()) {
    on<_PropertySub>((event, emit) async {
     // if (event is _PropertySub) {
        emit(const PropertyInputState.loading());
        try {
          final response = await fetchPropertyDetails(
            cent: event.cent,
            sqft: event.sgft,
            amount: event.amount,
            categoryId: event.category,
            userId: event.userId,
            

          );
          print("Bloc response: $response");
          emit(PropertyInputState.success(response: response));
        } catch (e) {
          emit(PropertyInputState.error(error: e.toString()));
          print('error:${e.toString()}');
        }
      
    });
  }
}
