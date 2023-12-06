import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/socail/model/social_model.dart';

@immutable
abstract class SocialState extends Equatable {}

// class searchState extends SocialState {
//   final List<String> searchItem;
//   searchState(this.searchItem);
//   @override
//   List<Object?> get props => [searchItem];
// }

class SocialInitial extends SocialState {
  @override
  List<Object?> get props => [];
}

class SocialLoading extends SocialState {
  @override
  List<Object?> get props => [];
}

class SocialLoaded extends SocialState {
  final List<Social> Socials;

  SocialLoaded(this.Socials);
  @override
  List<Object?> get props => [Socials];
}

class SocialOperationSuccess extends SocialState {
  final String message;

  SocialOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class SocialError extends SocialState {
  final String errorMessage;

  SocialError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
