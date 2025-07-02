part of '../page/home_page.dart';

class LikeTab extends StatefulWidget {
  const LikeTab({super.key});

  @override
  State<LikeTab> createState() => _LikeTabState();
}

class _LikeTabState extends State<LikeTab> {
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    final provider = context.read<LikedBookProvider>();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollCtrl.addListener(() async {
        if (scrollCtrl.position.maxScrollExtent == scrollCtrl.position.pixels) {
          provider.fetchNextIndex().then((val) {
            if (val is BooksFailure) {
              Fluttertoast.showToast(msg: val.failure.message);
            }
          });
        }
      });
      if (provider.likedState is BooksInitial) {
        final result = await provider.refresh();
        if (result is BooksFailure) {
          Fluttertoast.showToast(msg: result.failure.message);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LikedBookProvider>(
      builder: (_, provider, __) {
        final state = provider.likedState;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SearchTextField(
                value: provider.search,
                onSearch: (search) {
                  provider.startSearch(search: search).then((val) {
                    if (val is BooksFailure) {
                      Fluttertoast.showToast(msg: val.failure.message);
                    }
                  });
                }
              )
            ),
            Expanded(
              child: state is BooksInitial || state is BooksRefresh ? const Center(
                child: CircularProgressIndicator()
              ) : provider.listLiked.isEmpty ? ReloadLayout(
                message: state is BooksFailure ? state.failure.message : "No Book found",
                onReload: () => provider.refresh().then((val) {
                  if (val is BooksFailure) {
                    Fluttertoast.showToast(msg: val.failure.message);
                  }
                })
              ) : RefreshIndicator(
                onRefresh: () => provider.refresh().then((val) {
                  if (val is BooksFailure) {
                    Fluttertoast.showToast(msg: val.failure.message);
                  }
                }),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollCtrl,
                  slivers: [
                    SliverList.builder(
                      itemCount: provider.listLiked.length,
                      itemBuilder: (_, index) => BookCard(
                        data: provider.listLiked[index]
                      )
                    ),
                    if (state is BooksLoading) SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: const CircularProgressIndicator()
                      )
                    )
                  ]
                )
              )
            )
          ]
        );
      }
    );
  }
}