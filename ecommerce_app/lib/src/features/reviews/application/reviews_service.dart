import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/data/reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reviews_service.g.dart';

abstract class ReviewsService {
  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  });
}

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  throw UnimplementedError();
});

/// Check if a product was previously reviewed by the user
@riverpod
Future<Review?> userReviewFuture(UserReviewFutureRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(reviewsRepositoryProvider)
        .fetchUserReview(productId, user.uid);
  } else {
    return Future.value(null);
  }
}

/// Check if a product was previously reviewed by the user
final userReviewStreamProvider =
    StreamProvider.autoDispose.family<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(reviewsRepositoryProvider)
        .watchUserReview(productId, user.uid);
  } else {
    return Stream.value(null);
  }
});
