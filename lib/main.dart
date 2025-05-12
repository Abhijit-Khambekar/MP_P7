import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato',
      theme: ThemeData(
        primaryColor: Colors.red[200], // 60% primary color
        scaffoldBackgroundColor: Colors.red[50], // Lighter shade for background
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: Colors.red[900], // 10% accent
          backgroundColor: Colors.red[50],
          cardColor: Colors.white, // 30% secondary
        ).copyWith(
          primary: Colors.red[200], // 60% primary
          secondary: Colors.red[900], // 10% accent
          surface: Colors.white, // 30% secondary
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[900], // Accent for buttons
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.red[900]), // Accent for titles
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200], // 60% primary
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [Colors.red[200]!, Colors.red[400]!],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.local_dining,
                    size: 100,
                    color: Colors.red[900], // 10% accent
                  ),
                ),
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Tomato',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 30% secondary
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.red[900]!.withOpacity(0.5),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Freshness on silver platter',
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.red[900], // 10% accent
                    ),
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  static List<Widget> _widgetOptions = <Widget>[
    CuisinesTab(),
    CartTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.index = index;
    });
    Navigator.pop(context); // Close drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomato'),
        backgroundColor: Colors.red[200], // 60% primary
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red[900], // Accent
          labelColor: Colors.red[900], // Accent
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Cuisines'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _widgetOptions,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white, // 30% secondary
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[200]!, Colors.red[900]!], // Primary to accent
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tomato',
                      style: TextStyle(
                        color: Colors.white, // Secondary
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your Food Haven',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.restaurant_menu, color: Colors.red[900]), // Accent
                title: Text('Cuisines', style: TextStyle(color: Colors.black87)),
                selected: _selectedIndex == 0,
                selectedTileColor: Colors.red[100], // Light primary
                onTap: () => _onItemTapped(0),
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.red[900]),
                title: Text('Cart', style: TextStyle(color: Colors.black87)),
                selected: _selectedIndex == 1,
                selectedTileColor: Colors.red[100],
                onTap: () => _onItemTapped(1),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.red[900]),
                title: Text('Profile', style: TextStyle(color: Colors.black87)),
                selected: _selectedIndex == 2,
                selectedTileColor: Colors.red[100],
                onTap: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Cuisine {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Cuisine({required this.name, required this.description, required this.price, required this.imageUrl});
}

class CuisinesTab extends StatelessWidget {
  final List<Cuisine> cuisines = [
    Cuisine(
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato and mozzarella',
      price: 12.99,
      imageUrl: 'https://media.istockphoto.com/id/451865971/photo/margherita-pizza.jpg?s=2048x2048&w=is&k=20&c=OrQeIpWjUf-soMqN_L6UdKQQn5cPqClNQZU51f2xDxw=',
    ),
    Cuisine(
      name: 'Pasta Carbonara',
      description: 'Creamy pasta with bacon and parmesan',
      price: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?q=80&w=1000&auto=format&fit=crop',
    ),
    Cuisine(
      name: 'Caesar Salad',
      description: 'Fresh romaine with caesar dressing',
      price: 8.99,
      imageUrl: 'https://images.unsplash.com/photo-1551248429-40975aa4de74?q=80&w=1000&auto=format&fit=crop',
    ),
    Cuisine(
      name: 'Grilled Salmon',
      description: 'Fresh salmon with lemon herb sauce',
      price: 18.99,
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=1000&auto=format&fit=crop',
    ),
    Cuisine(
      name: 'Tiramisu',
      description: 'Classic Italian coffee dessert',
      price: 6.99,
      imageUrl: 'https://media.istockphoto.com/id/1134778606/photo/fresh-tiramisu-cake-white-background.jpg?s=2048x2048&w=is&k=20&c=A0E534mPkezjs4j1IgTdKXa6tl9GzfGpacZoWOOLvbU=',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.6, // Adjusted to increase card height
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cuisines.length,
      itemBuilder: (context, index) {
        final cuisine = cuisines[index];
        return Card(
          color: Colors.white, // 30% secondary
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  cuisine.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.red[900],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.red[900]),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        cuisine.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900], // 10% accent
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        cuisine.description,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${cuisine.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          await Cart.addToCart(cuisine);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${cuisine.name} added to cart')),
                          );
                        },
                        child: Text('Add to Cart', style: TextStyle(fontSize: 14)),
                      ),
                      SizedBox(height: 8), // Spacing below button
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CartItem {
  final Cuisine cuisine;
  int quantity;

  CartItem({required this.cuisine, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        'cuisine': {
          'name': cuisine.name,
          'description': cuisine.description,
          'price': cuisine.price,
          'imageUrl': cuisine.imageUrl,
        },
        'quantity': quantity,
      };

  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      cuisine: Cuisine(
        name: json['cuisine']['name'],
        description: json['cuisine']['description'],
        price: json['cuisine']['price'],
        imageUrl: json['cuisine']['imageUrl'],
      ),
      quantity: json['quantity'],
    );
  }
}

class Cart {
  static List<CartItem> items = [];

  static Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> jsonData = jsonDecode(cartData);
      items = jsonData.map((item) => CartItem.fromJson(item)).toList();
    }
  }

  static Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = items.map((item) => item.toJson()).toList();
    await prefs.setString('cart', jsonEncode(jsonData));
  }

  static Future<void> addToCart(Cuisine cuisine) async {
    await loadCart();
    final existingItem = items.firstWhere(
      (item) => item.cuisine.name == cuisine.name,
      orElse: () => CartItem(cuisine: cuisine),
    );
    if (!items.contains(existingItem)) {
      items.add(existingItem);
    } else {
      existingItem.quantity++;
    }
    await saveCart();
  }

  static Future<void> updateQuantity(CartItem item, int delta) async {
    await loadCart();
    final cartItem = items.firstWhere((i) => i.cuisine.name == item.cuisine.name);
    cartItem.quantity += delta;
    if (cartItem.quantity <= 0) {
      items.remove(cartItem);
    }
    await saveCart();
  }

  static Future<void> clearCart() async {
    items.clear();
    await saveCart();
  }

  static double getTotalCost() {
    return items.fold(0.0, (sum, item) => sum + (item.cuisine.price * item.quantity));
  }
}

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  void initState() {
    super.initState();
    Cart.loadCart().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Cart.items.isEmpty
              ? Center(child: Text('No cuisines added', style: TextStyle(color: Colors.black87)))
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.6, // Adjusted to increase card height
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: Cart.items.length,
                  itemBuilder: (context, index) {
                    final item = Cart.items[index];
                    return Card(
                      color: Colors.white, // 30% secondary
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.network(
                              item.cuisine.imageUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    item.cuisine.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[900], // 10% accent
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    item.cuisine.description,
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${item.cuisine.price.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: Colors.red[900]), // Accent
                                        onPressed: () async {
                                          await Cart.updateQuantity(item, -1);
                                          setState(() {});
                                        },
                                      ),
                                      Text('${item.quantity}', style: TextStyle(color: Colors.black87, fontSize: 16)),
                                      IconButton(
                                        icon: Icon(Icons.add, color: Colors.red[900]), // Accent
                                        onPressed: () async {
                                          await Cart.updateQuantity(item, 1);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8), // Spacing below buttons
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (Cart.items.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${Cart.getTotalCost().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900], // Accent
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white, // 30% secondary
                        title: Text('Order Confirmed', style: TextStyle(color: Colors.red[900])), // Accent
                        content: Text('Your order will be delivered to the given address shortly.'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await Cart.clearCart();
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text('OK', style: TextStyle(color: Colors.red[900])), // Accent
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Buy Now', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _contactController.text = prefs.getString('contact') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('address', _addressController.text);
      await prefs.setString('contact', _contactController.text);
      await prefs.setString('email', _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white, // 30% secondary
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.red[900]), // Accent
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!), // Accent
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.red[900]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    labelStyle: TextStyle(color: Colors.red[900]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.red[900]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Profile', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}