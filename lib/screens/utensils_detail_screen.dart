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
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  utensil.description ?? 'No description',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (utensil.uses != null && utensil.uses!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uses:',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var use in utensil.uses!)
                        Text(
                          use,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              if (utensil.material != null && utensil.material!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material:',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var material in utensil.material!)
                        Text(
                          material,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onHover: (isHovering) {
                  if (isHovering) {
                    print("Mouse is hovering");
                  } else {
                    print("Mouse is not hovering");
                  }
                },
                child: const Text("Buy Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
