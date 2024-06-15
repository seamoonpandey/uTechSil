import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utechsil/models/utensil.dart';

class UtensilDetailScreen extends StatelessWidget {
  final Utensil utensil;
  const UtensilDetailScreen(
    this.utensil, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(utensil.name!.toUpperCase()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 16,
            ),
            Image.network(
              utensil.imageUrl ?? 'assets/images/placeholder.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                );
              },
            ),
            if (utensil.subImages != null && utensil.subImages!.isNotEmpty)
              GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: utensil.subImages!.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    utensil.subImages![index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                utensil.name ?? 'Unknown',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                utensil.description ?? 'No description',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
