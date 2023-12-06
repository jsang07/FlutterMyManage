import 'package:bloc/bloc.dart';
import 'package:mymanage/socail/bloc/social_event.dart';
import 'package:mymanage/socail/bloc/social_state.dart';
import 'package:mymanage/socail/repo/firebase_social_api.dart';
// import 'package:rxdart/rxdart.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialService socialService;
  SocialBloc(this.socialService) : super(SocialInitial()) {
    on<ReadSocial>((event, emit) async {
      try {
        emit(SocialLoading());
        final socials = await socialService.get().first;
        emit(SocialLoaded(socials));
      } catch (e) {
        print(e.toString());
        emit(SocialError('Failed to load social.'));
      }
    });

    on<CreateSocial>((event, emit) async {
      try {
        emit(SocialLoading());
        await socialService.add(event.social);
        emit(SocialOperationSuccess('post success'));
      } catch (e) {
        emit(SocialError('fail to create ${e.toString()}'));
      }
    });

    on<EditSocial>((event, emit) async {
      try {
        emit(SocialLoading());
        await socialService.update(event.social);
        emit(SocialOperationSuccess('Todo updated successfully.'));
      } catch (e) {
        emit(SocialError('Failed to update todo.'));
      }
    });

    on<DeleteSocial>((event, emit) async {
      try {
        emit(SocialLoading());
        await socialService.delete(event.socialId);
        emit(SocialOperationSuccess('Todo deleted successfully.'));
      } catch (e) {
        emit(SocialError('Failed to delete todo.'));
      }
    });
  }
}
