part of '../page/home_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final searchCtrl = TextEditingController(text: "");
  final scrollCtrl = ScrollController();

  String get query => searchCtrl.text.isNotEmpty
      ? "search=${Uri.encodeComponent(searchCtrl.text)}" : "";

  @override
  void initState() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: searchCtrl,
            onTapOutside: (event) => primaryFocus?.unfocus(),
            onSaved: (value) {
              primaryFocus?.unfocus();
              context.read<HomeProvider>().initiateData(query: query).then((val) {
                if (val is BooksFailure) {
                  Fluttertoast.showToast(msg: val.failure.message);
                }
              });
            },
            onEditingComplete: () {
              primaryFocus?.unfocus();
              context.read<HomeProvider>().initiateData(query: query).then((val) {
                if (val is BooksFailure) {
                  Fluttertoast.showToast(msg: val.failure.message);
                }
              });
            },
            decoration: const InputDecoration(
              hintText: "Search",
              border: OutlineInputBorder(),
              isDense: true
            )
          )
        ),
        Expanded(
          child: Consumer<HomeProvider>(
            builder: (_, provider, __) {
              final state = provider.bookState;
              if (state is BooksInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.listBook.isEmpty) {
                if (state is BooksFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(state.failure.message)
                      ),
                      FilledButton(
                        onPressed: () => provider.initiateData(query: query).then((val) {
                          if (val is BooksFailure) {
                            Fluttertoast.showToast(msg: val.failure.message);
                          }
                        }),
                        child: Text("Reload")
                      )
                    ]
                  );
                } else {
                  return Center(child: Text("No Book found"));
                }
              } else {
                return RefreshIndicator(
                  onRefresh: () => provider.initiateData(query: query).then((val) {
                    if (val is BooksFailure) {
                      Fluttertoast.showToast(msg: val.failure.message);
                    }
                  }),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollCtrl,
                    slivers: [
                      SliverList.separated(
                        itemCount: provider.listBook.length,
                        itemBuilder: (_, index) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20.h,
                          child: BookCard(data: provider.listBook[index])
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                );
              }
            }
          )
        )
      ]
    );
  }
}