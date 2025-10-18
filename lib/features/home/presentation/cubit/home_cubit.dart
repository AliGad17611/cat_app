import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/features/home/data/repositories/home_repository.dart';
import 'package:cat_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadBreeds({bool isRefresh = false}) async {
    if (state.hasReachedEnd && !isRefresh) return;

    if (isRefresh) {
      emit(const HomeState(status: HomeStatus.loading));
    } else if (state.status == HomeStatus.initial) {
      emit(state.copyWith(status: HomeStatus.loading));
    } else {
      emit(state.copyWith(status: HomeStatus.loadingMore));
    }

    final page = isRefresh ? 0 : state.currentPage;
    final result = await _repository.getBreeds(page: page);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: failure.message,
            errorIcon: failure.icon,
          ),
        );
      },
      (breeds) {
        if (breeds.isEmpty) {
          emit(
            state.copyWith(status: HomeStatus.reachedEnd, hasReachedEnd: true),
          );
        } else {
          final updatedBreeds = isRefresh
              ? breeds
              : [...state.breeds, ...breeds];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              breeds: updatedBreeds,
              currentPage: page + 1,
              hasReachedEnd: false,
            ),
          );
        }
      },
    );
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
