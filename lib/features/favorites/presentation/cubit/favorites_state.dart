import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteModel> favorites;
  final Set<String> favoriteImageIds; // For quick lookup
  final String? errorMessage;
  final IconData? errorIcon;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.favoriteImageIds = const {},
    this.errorMessage,
    this.errorIcon,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteModel>? favorites,
    Set<String>? favoriteImageIds,
    String? errorMessage,
    IconData? errorIcon,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteImageIds: favoriteImageIds ?? this.favoriteImageIds,
      errorMessage: errorMessage ?? this.errorMessage,
      errorIcon: errorIcon ?? this.errorIcon,
    );
  }

  bool isFavorite(String imageId) {
    return favoriteImageIds.contains(imageId);
  }

  int? getFavoriteId(String imageId) {
    try {
      return favorites.firstWhere((favorite) => favorite.imageId == imageId).id;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    favoriteImageIds,
    errorMessage,
    errorIcon,
  ];
}
