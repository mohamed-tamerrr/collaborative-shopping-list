import 'package:bloc/bloc.dart';
import 'package:final_project/featrues/auth/data/models/user_model.dart';
import 'package:final_project/featrues/auth/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    emit(AuthLoading());
    final user = await _authRepository.signUp(
      email: email,
      password: password,
      name: name,
    );
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthFailure('signUp failed'));
    }
  }

  Future<void> logIn({required String email,required String password})async
  {
    emit(AuthLoading());
    final user=await _authRepository.logIn(email: email, password: password);
    if(user!=null)
      {
        emit(AuthSuccess(user));
      }
    else{
      emit(AuthFailure('logIn failed'));
    }
  }

  Future<void>logOut()async
  {
   await _authRepository.logOut();
   emit(AuthLogOut());

  }

  Future<void> getUserById( String uid)async
  {
    emit(AuthLoading());
    final user =await _authRepository.getUserById(uid);
    if (user != null) {
      emit(AuthSuccess(user));
    }
    else {
      emit(AuthFailure('user not found'));
    }
  }

  Future<void> sendPasswordResetEmail(String email)
  async{
    emit(AuthLoading());
   try {
     await _authRepository.sendPasswordResetEmail(email: email);
     emit(AuthResetEmailSent());
   }
   on FirebaseAuthException catch(e)
    {
      emit(AuthFailure(e.message??'something went wrong'));
    }
   catch (e) {
     emit(AuthFailure(e.toString()));
   }
   }
}
