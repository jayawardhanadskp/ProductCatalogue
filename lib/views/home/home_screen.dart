import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/views/home/widgets/product_card.dart';
import 'package:product_catalogue/views/home/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              surfaceTintColor: context.theme.scaffoldBackgroundColor,
              expandedHeight: 20,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 10, bottom: 10),
                title: Row(
                  mainAxisAlignment: .center,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.read<ThemeProvider>().toggleTheme(),
                      icon: Icon(Icons.circle),
                    ),
                    
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        dragStartBehavior: DragStartBehavior.values.first,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Padding(
                              padding:index == 0 ? EdgeInsets.only( left: MediaQuery.of(context).size.width * 0.3) : EdgeInsets.zero,
                              child: Text(
                                'All Items',
                                style: context.textTheme.displayLarge,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(15),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const SearchBarWidget(),
                ),
              ),
            ),

            // SliverPadding(
            //   padding: EdgeInsets.only(top: AppDimensions.top),
            //   sliver: SliverToBoxAdapter(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Icon(Icons.list_rounded),
            //         Text('All Items', style: context.textTheme.displayLarge),
            //         IconButton(
            //           onPressed: () =>
            //               context.read<ThemeProvider>().toggleTheme(),
            //           icon: Icon(Icons.circle),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 20.0),
            //     child: const SearchBarWidget(),
            //   ),
            // ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
              sliver: SliverGrid.builder(
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, index) {
                  return ProductCard();
                },
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
