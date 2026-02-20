import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/provider/favorite_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteData = ref.watch(favoriteProvider);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset('assets/icons/not.png', width: 25, height: 25),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            favoriteData.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'My favorites',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: favoriteData.isEmpty
          ? Center(
              child: Text(
                'No favorites yet',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteData.length,
              itemBuilder: (context, index) {
                final favoriteItem = favoriteData.values.toList()[index];
                final imageUrl = favoriteItem.image;

                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      width: 335,
                      height: 96,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 336,
                                height: 97,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFEFF0F2),
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 13,
                              left: 9,
                              child: Container(
                                width: 78,
                                height: 78,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBCC5FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 270,
                              top: 16,
                              child: Text(
                                '\$${favoriteItem.productPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 101,
                              top: 16,
                              child: SizedBox(
                                width: 101,
                                child: Text(
                                  favoriteItem.productName,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 18,
                              left: 20,
                              child: Image.network(
                                imageUrl!,
                                width: 57,
                                height: 67,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 290,
                              top: 47,
                              child: IconButton(
                                onPressed: () {
                                  favoriteProviderData.removeFromFavorites(favoriteItem.productId);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
