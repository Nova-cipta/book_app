part of '../page/home_page.dart';

class LikeTab extends StatefulWidget {
  const LikeTab({super.key});

  @override
  State<LikeTab> createState() => _LikeTabState();
}

class _LikeTabState extends State<LikeTab> {
  final searchCtrl = TextEditingController(text: "");
  final scrollCtrl = ScrollController();

  String get query => searchCtrl.text;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollCtrl.addListener(() async {
        if (scrollCtrl.position.maxScrollExtent == scrollCtrl.position.pixels) {
          context.read<LikedBookProvider>().fetchNextIndex(query: query).then((val) {
            if (val is LikedBooksFailure) {
              Fluttertoast.showToast(msg: val.failure.message);
            }
          });
        }
      });
      final provider = context.read<LikedBookProvider>();
      if (provider.likedState is LikedBooksInitial) {
        final result = await provider.refresh();
        if (result is LikedBooksFailure) {
          Fluttertoast.showToast(msg: result.failure.message);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: searchCtrl,
            onTapOutside: (event) => primaryFocus?.unfocus(),
            onEditingComplete: () {
              primaryFocus?.unfocus();
              context.read<LikedBookProvider>().refresh(query: query).then((val) {
                if (val is LikedBooksFailure) {
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
          child: Consumer<LikedBookProvider>(
            builder: (_, provider, __) {
              final state = provider.likedState;
              if (state is LikedBooksInitial || state is LikedBooksRefresh) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.listLiked.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Text(
                        state is LikedBooksFailure ? state.failure.message : "No Book found"
                      )
                    ),
                    FilledButton(
                      onPressed: () => provider.refresh(query: query).then((val) {
                        if (val is LikedBooksFailure) {
                          Fluttertoast.showToast(msg: val.failure.message);
                        }
                      }),
                      child: Text("Refresh")
                    )
                  ]
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => provider.refresh(query: query).then((val) {
                    if (val is LikedBooksFailure) {
                      Fluttertoast.showToast(msg: val.failure.message);
                    }
                  }),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollCtrl,
                    slivers: [
                      SliverList.separated(
                        itemCount: provider.listLiked.length,
                        itemBuilder: (_, index) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20.h,
                          child: BookCard(data: provider.listLiked[index])
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                      ),
                      if (state is LikedBooksLoading) SliverToBoxAdapter(
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