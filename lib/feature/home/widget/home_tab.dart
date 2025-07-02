part of '../page/home_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    final provider = context.read<HomeProvider>();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollCtrl.addListener(() async {
        if (scrollCtrl.position.maxScrollExtent == scrollCtrl.position.pixels) {
          context.read<HomeProvider>().scrollToNext();
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
        return RefreshIndicator(
          onRefresh: () async {
            provider.refresh().then((val) {
              if (val is BooksFailure) {
                Fluttertoast.showToast(msg: val.failure.message);
              }
            });
          },
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: provider.offlineMode ? Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: tertiaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    "Offline mode. Pull down to refresh.",
                    style: subTitle.copyWith(color: seedColor)
                  )
                ) : const SizedBox.shrink()
              ),
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
                ) : provider.listBook.isEmpty ? ReloadLayout(
                  message:  state is BooksFailure ? state.failure.message : "No Book found",
                  onReload: () => provider.refresh().then((val) {
                    if (val is BooksFailure) {
                      Fluttertoast.showToast(msg: val.failure.message);
                    }
                  })
                ) : CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollCtrl,
                  slivers: [
                    SliverList.builder(
                      itemCount: provider.listBook.length,
                      itemBuilder: (_, index) => BookCard(
                        data: provider.listBook[index]
                      )
                    ),
                    if (state is BooksLoading || state is BooksFailure) SliverToBoxAdapter(
                      child: state is BooksFailure ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        height: 15.h,
                        child: ReloadLayout(
                          message:  state.failure.message,
                          onReload: () => provider.refresh().then((val) {
                            if (val is BooksFailure) {
                              Fluttertoast.showToast(msg: val.failure.message);
                            }
                          })
                        )
                      ) : Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        height: 10.h,
                        child: const CircularProgressIndicator()
                      )
                    )
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}