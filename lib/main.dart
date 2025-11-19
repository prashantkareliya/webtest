import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

// --- Color Palette ---
class AppColors {
  static const Color background = Color(0xFFE0F7FA); // Light Sky Blue background
  static const Color primary = Color(0xFFFFFFFF); // White for cards
  static const Color accent = Color(0xFF0077B6); // A strong blue for accents
  static const Color text = Color(0xFF0D1B2A); // Dark blue for primary text
  static const Color textSecondary = Colors.black54; // Softer text color
  static const Color appBarGradientStart = Color(0xFF81D4FA); // Light blue for gradient
  static const Color appBarGradientEnd = Color(0xFFE0F7FA); // Sky blue to blend with background
}

void main() {
  runApp(const GoalScriptureApp());
}

class GoalScriptureApp extends StatelessWidget {
  const GoalScriptureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoalScripture - Web & Mobile Development',
      theme: ThemeData(
        primaryColor: AppColors.accent,
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const MainLayout(),
    );
  }
}

//--- Main navigation layout ---
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    CompanyHomePage(),
    AboutUsPage(),
    ContactUsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.appBarGradientStart, AppColors.appBarGradientEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: FadeIn(
          child: Row(
            children: [
              SvgPicture.asset('assets/images/logo.svg', height: 30, colorFilter: const ColorFilter.mode(AppColors.text, BlendMode.srcIn)),
              const SizedBox(width: 10),
              const Text("GoalScripture", style: TextStyle(color: AppColors.text)),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
        actions: isWeb
            ? [
          _navButton("Home", 0),
          _navButton("About Us", 1),
          _navButton("Contact Us", 2),
          const SizedBox(width: 20),
        ]
            : null,
      ),
      body: Column( // MODIFIED: Added Column to hold page and footer
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Center(
                key: ValueKey<int>(_selectedIndex),
                child: _pages.elementAt(_selectedIndex),
              ),
            ),
          ),
          const Footer(), // NEW: Added Footer
        ],
      ),
      drawer: !isWeb
          ? Drawer(
        backgroundColor: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.appBarGradientStart, AppColors.appBarGradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Text('Navigation', style: TextStyle(fontSize: 24, color: AppColors.text)),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.text),
              title: const Text('Home', style: TextStyle(color: AppColors.text)),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: AppColors.text),
              title: const Text('About Us', style: TextStyle(color: AppColors.text)),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: AppColors.text),
              title: const Text('Contact Us', style: TextStyle(color: AppColors.text)),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
          : null,
    );
  }

  Widget _navButton(String text, int index) {
    return TextButton(
      onPressed: () => _onItemTapped(index),
      child: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index ? AppColors.accent : AppColors.text,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

//--- HOME PAGE ---
class CompanyHomePage extends StatelessWidget {
  const CompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Crafting Digital Excellence in Web & Mobile.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.text,
                      fontSize: isWeb ? 42 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // --- SERVICES SECTION ---
                _buildSectionTitle("Our Services"),
                const SizedBox(height: 30),
                isWeb
                    ? FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ServiceCard(icon: Icons.phone_android, title: "Mobile App Development", page: const MobileAppPage())),
                      const SizedBox(width: 20),
                      Expanded(child: ServiceCard(icon: Icons.web, title: "Web Development", page: const WebDevPage())),
                      const SizedBox(width: 20),
                      Expanded(child: ServiceCard(icon: Icons.design_services, title: "UI/UX Design", page: const UiUxPage())),
                    ],
                  ),
                )
                    : FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      ServiceCard(icon: Icons.phone_android, title: "Mobile App Development", page: const MobileAppPage()),
                      const SizedBox(height: 20),
                      ServiceCard(icon: Icons.web, title: "Web Development", page: const WebDevPage()),
                      const SizedBox(height: 20),
                      ServiceCard(icon: Icons.design_services, title: "UI/UX Design", page: const UiUxPage()),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                // --- NEW: RECENT WORK SECTION ---
                _buildSectionTitle("Our Recent Work"),
                const SizedBox(height: 30),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: const Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      PortfolioItem(
                        imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
                        title: 'Data Analytics Dashboard',
                        description: 'A comprehensive web app for visualizing business intelligence.',
                      ),
                      PortfolioItem(
                        imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800',
                        title: 'Travel Planning App',
                        description: 'A mobile app for iOS and Android to plan and book trips seamlessly.',
                      ),
                      PortfolioItem(
                        imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
                        title: 'E-commerce Platform',
                        description: 'A scalable online store with a custom CMS and payment integration.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                // --- NEW: TESTIMONIALS SECTION ---
                _buildSectionTitle("What Our Clients Say"),
                const SizedBox(height: 30),
                isWeb
                    ? FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TestimonialCard(name: 'Jane Doe', company: 'Tech Corp', quote: 'GoalScripture delivered a product that exceeded our expectations on time and on budget.')),
                      SizedBox(width: 20),
                      Expanded(child: TestimonialCard(name: 'John Smith', company: 'Innovate LLC', quote: 'The best development partner we have ever worked with. Truly professional and skilled.')),
                    ],
                  ),
                )
                    : FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: const Column(
                    children: [
                      TestimonialCard(name: 'Jane Doe', company: 'Tech Corp', quote: 'GoalScripture delivered a product that exceeded our expectations on time and on budget.'),
                      SizedBox(height: 20),
                      TestimonialCard(name: 'John Smith', company: 'Innovate LLC', quote: 'The best development partner we have ever worked with. Truly professional and skilled.'),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Divider(color: AppColors.accent.withOpacity(0.2)),
          const SizedBox(height: 40),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.text,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// --- ABOUT US PAGE (Unchanged) ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Text("About Us",
                      style: GoogleFonts.poppins(
                          color: AppColors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.accent.withOpacity(0.2)),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildInfoSection(
                    "Our Journey",
                    "GoalScripture was started 1 year ago with a vision to build high-quality digital solutions. We are passionate about turning ideas into reality through code.",
                  ),
                ),
                const SizedBox(height: 30),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildInfoSection(
                    "Mobile Development Expertise (Flutter)",
                    "With 6 years of hands-on experience in Flutter, we have built robust, scalable, and visually appealing mobile applications. We've successfully delivered over 40 Flutter projects from scratch, catering to diverse business needs. Now operating as a dedicated freelancer to provide focused and expert service.",
                  ),
                ),
                const SizedBox(height: 30),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildInfoSection(
                    "Web Development Expertise",
                    "Our skills extend to modern web development, creating responsive and performant websites and web applications. We leverage the latest technologies to ensure your online presence is powerful and effective.",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                color: AppColors.accent,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text(content,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 16, height: 1.5)),
      ],
    );
  }
}

//--- CONTACT US PAGE (Unchanged) ---
class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Text("Have a project in mind?",
                    style: GoogleFonts.poppins(
                        color: AppColors.text,
                        fontSize: 32,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 15),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                    "Let's build something amazing together. Reach out to us!",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _ContactInfoTile(
                  icon: Icons.email_outlined,
                  text: "prashant003kareliya@gmail.com",
                  onTap: () => _launchUrl("mailto:prashant003kareliya@gmail.com"),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: _ContactInfoTile(
                  icon: Icons.phone_outlined,
                  text: "+91 9974723326",
                  onTap: () => _launchUrl("tel:+919974723326"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--- SERVICE DETAIL PAGES (Unchanged) ---
class MobileAppPage extends StatelessWidget {
  const MobileAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildServiceDetailPage(
      context: context,
      title: 'Mobile App Development',
      description: 'We build beautiful, high-performance, and cross-platform mobile applications for iOS and Android using Flutter. Our focus is on creating a seamless user experience and a robust backend that scales with your business.',
      features: [
        'iOS and Android development from a single codebase',
        'Expressive and flexible UI',
        'High performance with native ARM code compilation',
        'Firebase integration for backend services',
        'State management solutions (Provider, BLoC)',
        'API integration and data handling',
      ],
    );
  }
}
class WebDevPage extends StatelessWidget {
  const WebDevPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildServiceDetailPage(
      context: context,
      title: 'Web Development',
      description: 'We create modern, responsive, and fast-loading websites and web applications. From simple landing pages to complex enterprise-level apps, we use the latest technologies to build solutions that work for you.',
      features: [
        'Responsive design for all screen sizes',
        'Frontend development (React, Angular, Vue)',
        'Backend development (Node.js, Python, Firebase)',
        'Full-stack solutions with Flutter Web',
        'E-commerce and payment gateway integration',
        'Content Management Systems (CMS)',
      ],
    );
  }
}
class UiUxPage extends StatelessWidget {
  const UiUxPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildServiceDetailPage(
      context: context,
      title: 'UI/UX Design',
      description: 'A great product starts with a great user experience. We specialize in designing intuitive, engaging, and user-friendly interfaces that solve problems and delight users. Our design process is collaborative and user-centric.',
      features: [
        'User research and persona creation',
        'Wireframing and prototyping',
        'Interactive mockups (Figma, Adobe XD)',
        'User-centric design approach',
        'Design system development',
        'Usability testing and feedback analysis',
      ],
    );
  }
}
Widget _buildServiceDetailPage({
  required BuildContext context,
  required String title,
  required String description,
  required List<String> features,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title, style: GoogleFonts.poppins(color: AppColors.text)),
      backgroundColor: AppColors.appBarGradientStart,
      iconTheme: const IconThemeData(color: AppColors.text),
      elevation: 1,
    ),
    body: SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 30),
                FadeInUp(
                  child: Text(
                    'Key Features & Technologies',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.text),
                  ),
                ),
                const SizedBox(height: 20),
                ...features.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String feature = entry.value;
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * (idx + 1)),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: AppColors.accent),
                      title: Text(feature, style: const TextStyle(fontSize: 16, color: AppColors.text)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


//--- WIDGETS ---

class _ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactInfoTile(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(width: 15),
            Text(text,
                style: const TextStyle(color: AppColors.text, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const ServiceCard({required this.icon, required this.title, required this.page, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 48),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.text.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// NEW: WIDGET FOR PORTFOLIO ITEMS
class PortfolioItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const PortfolioItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NEW: WIDGET FOR TESTIMONIALS
class TestimonialCard extends StatelessWidget {
  final String name;
  final String company;
  final String quote;

  const TestimonialCard({
    super.key,
    required this.name,
    required this.company,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: AppColors.accent, size: 30),
          const SizedBox(height: 10),
          Text('"$quote"', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          const SizedBox(height: 15),
          Text('- $name, $company', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text)),
        ],
      ),
    );
  }
}

// NEW: FOOTER WIDGET
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.appBarGradientStart,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "© 2025 GoalScripture. All Rights Reserved.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          // You can add social media icons here if you like
        ],
      ),
    );
  }
}
