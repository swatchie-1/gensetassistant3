import 'package:flutter/material.dart';

void main() {
  runApp(const GensetAssistant());
}

class GensetAssistant extends StatelessWidget {
  const GensetAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genset Assistant',
      theme: ThemeData(
        primaryColor: const Color(0xFF7B1FA2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B1FA2),
          primary: const Color(0xFF7B1FA2),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF7B1FA2),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _activeCategory = 0;

  final List<Map<String, dynamic>> gensets = const [
    {
      'name': 'Portable Generator',
      'description': 'Compact and powerful, ideal for camping and emergencies.',
      'price': '\$499',
      'image': Icons.electrical_services,
    },
    {
      'name': 'Inverter Generator',
      'description': 'Quiet operation, perfect for sensitive electronics.',
      'price': '\$799',
      'image': Icons.electrical_services,
    },
    {
      'name': 'Gasoline Generator',
      'description': 'Reliable power source for construction sites and events.',
      'price': '\$999',
      'image': Icons.electrical_services,
    },
    {
      'name': 'Diesel Generator',
      'description': 'Heavy-duty performance for industrial and commercial use.',
      'price': '\$1499',
      'image': Icons.electrical_services,
    },
  ];

  final List<Map<String, dynamic>> maintenanceParts = const [
    {
      'name': 'Oil Filter',
      'price': '\$15',
      'image': Icons.filter_alt,
    },
    {
      'name': 'Air Filter',
      'price': '\$20',
      'image': Icons.air,
    },
    {
      'name': 'Fuel Filter',
      'price': '\$10',
      'image': Icons.local_gas_station,
    },
    {
      'name': 'Coolant',
      'price': '\$25',
      'image': Icons.water_drop,
    },
    {
      'name': 'Spark Plug',
      'price': '\$5',
      'image': Icons.electrical_services,
    },
    {
      'name': 'Belt',
      'price': '\$12',
      'image': Icons.settings,
    },
  ];

  final List<Map<String, dynamic>> spareParts = const [
    {
      'name': 'Engine Oil Filter',
      'price': '\$18.99',
      'image': Icons.filter_alt,
    },
    {
      'name': 'Air Filter',
      'price': '\$22.50',
      'image': Icons.air,
    },
    {
      'name': 'Fuel Filter',
      'price': '\$18.75',
      'image': Icons.local_gas_station,
    },
    {
      'name': 'Coolant',
      'price': '\$12.00',
      'image': Icons.water_drop,
    },
    {
      'name': 'Spark Plug',
      'price': '\$5.50',
      'image': Icons.electrical_services,
    },
    {
      'name': 'Belt',
      'price': '\$8.39',
      'image': Icons.settings,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    double offset = _scrollController.offset;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate which category is active based on scroll position
    int newCategory = _activeCategory;
    if (offset < screenHeight * 0.5) {
      newCategory = 0;
    } else if (offset < screenHeight * 1.2) {
      newCategory = 1;
    } else {
      newCategory = 2;
    }

    if (newCategory != _activeCategory) {
      setState(() => _activeCategory = newCategory);
    }
  }

  void _scrollToCategory(int categoryIndex) {
    if (!mounted) return;

    double screenHeight = MediaQuery.of(context).size.height;
    double targetOffset;

    switch (categoryIndex) {
      case 0:
        targetOffset = 0;
        break;
      case 1:
        targetOffset = screenHeight * 0.8;
        break;
      case 2:
        targetOffset = screenHeight * 1.6;
        break;
      default:
        targetOffset = 0;
    }

    // Ensure target offset doesn't exceed scrollable content
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Category indicators
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.grey[50],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryIndicator('Gensets', 0),
                  const SizedBox(width: 40),
                  _buildCategoryIndicator('Maintenance Parts', 1),
                  const SizedBox(width: 40),
                  _buildCategoryIndicator('Spare Parts', 2),
                ],
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                _buildGensetsSection(),
                _buildMaintenancePartsSection(),
                _buildSparePartsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIndicator(String title, int index) {
    bool isActive = _activeCategory == index;
    return GestureDetector(
      onTap: () => _scrollToCategory(index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF7B1FA2) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 30,
            height: 3,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF7B1FA2) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGensetsSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Seller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gensets.length,
            itemBuilder: (context, index) {
              final genset = gensets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        genset['image'],
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            genset['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            genset['description'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            genset['price'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7B1FA2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenancePartsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Maintenance Parts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Engine'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Alternator'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Control Panel'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: maintenanceParts.length,
            itemBuilder: (context, index) {
              final part = maintenanceParts[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        part['image'],
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      part['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      part['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSparePartsSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spare Parts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for spare parts',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter buttons
          Row(
            children: [
              Expanded(
                child: _buildFilterButton('Category'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('Brand'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('Price'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: spareParts.length,
            itemBuilder: (context, index) {
              final part = spareParts[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        part['image'],
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      part['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      part['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7B1FA2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '$title Screen\nComing Soon!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ProductsScreen(),
    const PlaceholderScreen(title: 'Explore Further'),
    const PlaceholderScreen(title: 'Search'),
    const PlaceholderScreen(title: 'Bag'),
  ];

  final List<Map<String, dynamic>> serviceItems = [
    {'icon': Icons.shopping_cart, 'label': 'Buy Genset', 'color': Colors.blue},
    {'icon': Icons.build, 'label': 'Buy\nMaintenance\nParts', 'color': Colors.orange},
    {'icon': Icons.settings, 'label': 'Buy Spare\nParts', 'color': Colors.purple},
    {'icon': Icons.book, 'label': 'Operating\nInstructions', 'color': Colors.teal},
    {'icon': Icons.help_outline, 'label': 'Troubleshooting', 'color': Colors.red},
    {'icon': Icons.cable, 'label': 'Cable\nInstallation', 'color': Colors.brown},
    {'icon': Icons.chat, 'label': 'Contact Us', 'color': Colors.green},
    {'icon': Icons.monitor, 'label': 'Monitor My\nGenset', 'color': Colors.indigo},
  ];

  final List<Map<String, dynamic>> gensets = [
    {
      'name': 'Genset Model X',
      'spec': '500 KVA, Silent Type',
      'rating': 4.8,
      'reviews': 120,
      'image': 'assets/images/genset1.jpg',
    },
    {
      'name': 'Genset Model Y',
      'spec': '750 KVA, Open Type',
      'rating': 4.9,
      'reviews': 98,
      'image': 'assets/images/genset2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B1FA2),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore Further',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  final List<Map<String, dynamic>> serviceItems = const [
    {'icon': Icons.shopping_cart, 'label': 'Buy Genset', 'color': Colors.blue},
    {'icon': Icons.build, 'label': 'Buy\nMaintenance\nParts', 'color': Colors.orange},
    {'icon': Icons.settings, 'label': 'Buy Spare\nParts', 'color': Colors.purple},
    {'icon': Icons.book, 'label': 'Operating\nInstructions', 'color': Colors.teal},
    {'icon': Icons.help_outline, 'label': 'Troubleshooting', 'color': Colors.red},
    {'icon': Icons.cable, 'label': 'Cable\nInstallation', 'color': Colors.brown},
    {'icon': Icons.chat, 'label': 'Contact Us', 'color': Colors.green},
    {'icon': Icons.monitor, 'label': 'Monitor My\nGenset', 'color': Colors.indigo},
  ];

  final List<Map<String, dynamic>> gensets = const [
    {
      'name': 'Genset Model X',
      'spec': '500 KVA, Silent Type',
      'rating': 4.8,
      'reviews': 120,
      'image': 'assets/images/genset1.jpg',
    },
    {
      'name': 'Genset Model Y',
      'spec': '750 KVA, Open Type',
      'rating': 4.9,
      'reviews': 98,
      'image': 'assets/images/genset2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search bar and icons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search for gensets, parts, etc.',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.notifications, color: Colors.white, size: 24),
                    const SizedBox(width: 16),
                    const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Services Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: serviceItems.length,
              itemBuilder: (context, index) {
                final item = serviceItems[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        item['label'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Gensets for Sale Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gensets for Sale',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: gensets.length,
                    itemBuilder: (context, index) {
                      final genset = gensets[index];
                      return Container(
                        width: 180,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: Colors.grey[300],
                              ),
                              child: const Icon(
                                Icons.electrical_services,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    genset['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    genset['spec'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      Text(
                                        ' ${genset['rating']} (${genset['reviews']})',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Genset News Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Genset News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.article,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Latest News & Updates',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Stay updated with the latest generator technology, maintenance tips, and industry news.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7B1FA2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Read More'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
