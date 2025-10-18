import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/home/data/repositories/home_repository.dart';
import 'package:cat_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadBreeds({bool isRefresh = false}) async {
    if (state.hasReachedEnd && !isRefresh) return;

    try {
      if (isRefresh) {
        emit(const HomeState(status: HomeStatus.loading));
      } else if (state.status == HomeStatus.initial) {
        emit(state.copyWith(status: HomeStatus.loading));
      } else {
        emit(state.copyWith(status: HomeStatus.loadingMore));
      }

      final page = isRefresh ? 0 : state.currentPage;
      final breeds = await _repository.getBreeds(page: page);

      if (breeds.isEmpty) {
        emit(
          state.copyWith(status: HomeStatus.reachedEnd, hasReachedEnd: true),
        );
      } else {
        final updatedBreeds = isRefresh ? breeds : [...state.breeds, ...breeds];
        emit(
          state.copyWith(
            status: HomeStatus.success,
            breeds: updatedBreeds,
            currentPage: page + 1,
            hasReachedEnd: false,
          ),
        );
      }
    } on ApiErrorModel catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: e.message,
          errorIcon: e.icon,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'An unexpected error occurred',
          errorIcon: Icons.error,
        ),
      );
    }
  }

  Future<void> refreshBreeds() async {
    await loadBreeds(isRefresh: true);
  }

  void loadMoreBreeds() {
    if (state.status != HomeStatus.loadingMore && !state.hasReachedEnd) {
      loadBreeds();
    }
  }
}
