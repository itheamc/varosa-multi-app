import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';
import '../../../../../../core/services/connectivity/connectivity_status_cubit.dart';
import '../../../../../../core/services/router/app_router.dart';
import '../../../../../../core/styles/varosa_app_colors.dart';
import '../../../../../../utils/debouncer.dart';
import '../../../../../common/widgets/fixed_persistent_header_delegate.dart';
import '../../../../../common/widgets/search_box.dart';
import '../../bloc/products_list_bloc.dart';
import '../../bloc/products_list_event.dart';
import '../../bloc/products_list_state.dart';
import '../widgets/product_card_shimmer_view.dart';
import '../widgets/product_card_view.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.products.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.products.toPathName);
  }

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  /// Scroll Controller
  ///
  final _scrollController = ScrollController();

  /// Search Controller
  ///
  final _searchController = TextEditingController();

  /// Query Debounce Handler
  ///
  final _queryDebounceHandler = Debouncer();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_listener);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _fetchProducts(firstLoad: true, forceRefresh: true);
    });
  }

  /// Method to handle scroll listener
  ///
  void _listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final search = _searchController.text.trim();
      _fetchProducts(
        forceRefresh: true,
        query: search.isNotEmpty ? search : null,
      );
    }
  }

  /// Method to fetch products
  ///
  Future<void> _fetchProducts({
    bool firstLoad = false,
    String? query,
    bool forceRefresh = true,
  }) async {
    final isConnected = await context.read<ConnectivityStatusCubit>().refresh();
    if (!isConnected) {
      if (!mounted) return;

      Fluttertoast.showToast(
        msg: context.appLocalization.no_internet_connection,
        backgroundColor: context.theme.colorScheme.error,
        textColor: VarosaAppColors.white,
      );

      return;
    }

    if (!mounted) return;

    if (firstLoad) {
      context.read<ProductsListBloc>().refresh(
        forceRefresh: forceRefresh,
        onSessionExpired: () {
          // You can notify user and logout here
        },
      );
      return;
    }

    context.read<ProductsListBloc>().loadMore(
      forceRefresh: forceRefresh,
      onSessionExpired: () {
        // You can notify user and logout here
      },
    );
  }

  /// Method to execute search
  ///
  void _executeQuery(String? value) {
    _queryDebounceHandler.debounce(
      const Duration(milliseconds: 500),
      () => _fetchProducts(firstLoad: true, query: value, forceRefresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = context.appLocalization;
    final queried = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: Text("Products"),
      ),
      body: BlocBuilder<ProductsListBloc, ProductsListState>(
        builder: (context, listState) {
          final isEmpty = listState.products.isEmpty;
          final isLoading = listState.fetching;

          return RefreshIndicator(
            onRefresh: () async {
              if (isLoading) return;

              if (await context.read<ConnectivityStatusCubit>().refresh()) {
                await _fetchProducts(firstLoad: true, forceRefresh: true);
              } else {
                if (!context.mounted) return;

                Fluttertoast.showToast(
                  msg: appLocalization.no_internet_connection,
                  backgroundColor: context.theme.colorScheme.error,
                  textColor: VarosaAppColors.white,
                );
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (isLoading || !isEmpty || queried)
                  _buildSearchHeaderUi(context),
                if (!isLoading && isEmpty)
                  _buildEmptyStateUi(context, queried)
                else if (isLoading && isEmpty)
                  _buildLoadingListUi()
                else if (!isEmpty)
                  _buildProductsListUi(listState, context),
                if (isLoading && !isEmpty && listState.hasMore)
                  _buildPaginatedLoadingIndicatorUi(context),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper function to build search header ui
  ///
  SliverPersistentHeader _buildSearchHeaderUi(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      delegate: FixedPersistentHeaderDelegate(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SearchBox(
          controller: _searchController,
          onChanged: _executeQuery,
          onSearched: _executeQuery,
        ),
      ),
    );
  }

  /// Helper function to build empty state ui
  ///
  SliverToBoxAdapter _buildEmptyStateUi(BuildContext context, bool queried) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height:
            context.height -
            (context.padding.bottom +
                context.padding.top +
                (queried ? 160.0 : 40.0)),
        width: context.width,
        child: Center(child: Text("No products!")),
      ),
    );
  }

  /// Helper function to build loading list ui
  ///
  SliverList _buildLoadingListUi() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: ProductCardShimmerView(),
        ),
        childCount: 15,
      ),
    );
  }

  /// Helper function to build products list ui
  ///
  SliverList _buildProductsListUi(
    ProductsListState listState,
    BuildContext context,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = listState.products[index];
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: ProductCardView(
            product: product,
            onClick: () {
              // Handle click functionality here
            },
            onFavoriteToggle: (product) {
              context.read<ProductsListBloc>().add(
                FavoriteProductEvent(product: product),
              );
            },
          ),
        );
      }, childCount: listState.products.length),
    );
  }

  /// Helper function to build loading indicator ui
  ///
  SliverToBoxAdapter _buildPaginatedLoadingIndicatorUi(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: ProductCardShimmerView(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
