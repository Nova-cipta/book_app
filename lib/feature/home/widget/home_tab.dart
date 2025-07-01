part of '../page/home_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late TextEditingController searchCtrl;
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    final provider = context.read<HomeProvider>();
    searchCtrl = TextEditingController(text: provider.search);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollCtrl.addListener(() async {
        if (scrollCtrl.position.maxScrollExtent == scrollCtrl.position.pixels) {
          context.read<HomeProvider>().fetchNextPage().then((val) {
            if (val is BooksFailure) {
              Fluttertoast.showToast(msg: val.failure.message);
            }
          });
        }
      });
      if (provider.bookState is BooksInitial) {
        final result = await provider.refresh();
        if (result is BooksFailure) {
          Fluttertoast.showToast(msg: result.failure.message);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        final state = provider.bookState;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SearchTextField(
                controller: searchCtrl,
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
              ) : provider.listBook.isEmpty ? ReloadLayout(
                message:  state is BooksFailure ? state.failure.message : "No Book found",
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
                      itemCount: provider.listBook.length,
                      itemBuilder: (_, index) => BookCard(
                        data: provider.listBook[index]
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