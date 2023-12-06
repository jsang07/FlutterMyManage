import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/socail/model/social_model.dart';

@immutable
abstract class SocialEvent extends Equatable {}

// class SearchSocial extends SocialEvent {
//   final String key;
//   SearchSocial(this.key);
//   @override
//
//   List<Object?> get props => [];
// }

class ReadSocial extends SocialEvent {
  @override
  List<Object?> get props => [];
}

class CreateSocial extends SocialEvent {
  final Social social;
  CreateSocial(this.social);
  @override
  List<Object?> get props => [social];
}

class EditSocial extends SocialEvent {
  final Social social;
  EditSocial(this.social);
  @override
  List<Object?> get props => [social];
}

class DeleteSocial extends SocialEvent {
  final String socialId;
  DeleteSocial(this.socialId);
  @override
  List<Object?> get props => [socialId];
}
