import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';

enum HomeStatus { initial, loading, loadingMore, success, failure, reachedEnd }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<BreedModel> breeds;
  final int currentPage;
  final String? errorMessage;
  final IconData? errorIcon;
  final bool hasReachedEnd;

  const HomeState({
    this.status = HomeStatus.initial,
    this.breeds = const [],
    this.currentPage = 0,
    this.errorMessage,
    this.errorIcon,
    this.hasReachedEnd = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BreedModel>? breeds,
    int? currentPage,
    String? errorMessage,
    IconData? errorIcon,
    bool? hasReachedEnd,
  }) {
    return HomeState(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
      errorIcon: errorIcon ?? this.errorIcon,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    breeds,
    currentPage,
    errorMessage,
    errorIcon,
    hasReachedEnd,
  ];
}
