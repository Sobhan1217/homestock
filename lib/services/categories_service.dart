import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider = Provider((ref) => CategoriesService());

class CategoryData {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> items;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.items,
  });
}

class CategoriesService {
  late List<CategoryData> categories;

  CategoriesService() {
    _initializeCategories();
  }

  void _initializeCategories() {
    categories = [
      CategoryData(
        id: 'grocery',
        name: 'GROCERY & FOOD',
        icon: '🛒',
        description: 'Essential food items, grains, oils, spices...',
        items: ['Milk', 'Bread', 'Eggs', 'Rice', 'Cooking Oil', 'Sugar', 'Salt', 'Flour', 'Butter', 'Cheese', 'Yogurt', 'Tea', 'Coffee', 'Pasta', 'Canned Beans', 'Vegetables', 'Fruits', 'Honey', 'Peanut Butter', 'Jam'],
      ),
      CategoryData(
        id: 'kitchen',
        name: 'KITCHEN & DINING',
        icon: '🍳',
        description: 'Cookware, spices, kitchen gadgets...',
        items: ['Spices', 'Vinegar', 'Soy Sauce', 'Baking Powder', 'Baking Soda', 'Aluminum Foil', 'Plastic Wrap', 'Kitchen Towels', 'Aprons', 'Oven Mitts', 'Cutting Boards', 'Knives', 'Spoons', 'Spatulas', 'Whisks', 'Plates', 'Bowls', 'Cups', 'Glasses', 'Utensils'],
      ),
      CategoryData(
        id: 'cleaning',
        name: 'CLEANING & MAINTENANCE',
        icon: '🧹',
        description: 'Detergents, soaps, cleaning tools...',
        items: ['Dish Soap', 'Laundry Detergent', 'Bleach', 'Floor Cleaner', 'Glass Cleaner', 'Disinfectant Spray', 'All-Purpose Cleaner', 'Sponges', 'Microfiber Cloths', 'Mop Pads', 'Broom', 'Dustpan', 'Vacuum Bags', 'Air Freshener', 'Trash Bags', 'Cleaning Gloves', 'Toilet Brush', 'Trash Cans', 'Buckets', 'Mop'],
      ),
      CategoryData(
        id: 'bathroom',
        name: 'BATHROOM & PERSONAL CARE',
        icon: '🚿',
        description: 'Toiletries, hygiene products...',
        items: ['Shampoo', 'Conditioner', 'Body Wash', 'Soap', 'Face Wash', 'Toothpaste', 'Toothbrush', 'Deodorant', 'Body Lotion', 'Hand Sanitizer', 'Tissues', 'Toilet Paper', 'Paper Towels', 'Hand Soap', 'Razor Blades', 'Shaving Cream', 'Dental Floss', 'Mouthwash', 'Bath Bombs', 'Bath Towels'],
      ),
      CategoryData(
        id: 'bedroom',
        name: 'BEDROOM & BEDDING',
        icon: '🛏️',
        description: 'Sheets, pillows, blankets...',
        items: ['Bed Sheets', 'Pillows', 'Blankets', 'Comforters', 'Duvet Covers', 'Mattress Protectors', 'Pillow Cases', 'Bed Skirts', 'Throw Pillows', 'Curtains', 'Curtain Rods', 'Blinds', 'Nightstands', 'Bed Frame', 'Headboards', 'Mattress Pads', 'Wall Shelves', 'Drawers', 'Closet Organizers', 'Storage Bins'],
      ),
      CategoryData(
        id: 'laundry',
        name: 'LAUNDRY & IRONING',
        icon: '👕',
        description: 'Fabric care, stain removers...',
        items: ['Fabric Softener', 'Stain Remover', 'Laundry Baskets', 'Iron', 'Ironing Board', 'Clothes Hangers', 'Clothesline', 'Clothespins', 'Drying Rack', 'Lint Roller', 'Shoe Bags', 'Sweater Bags', 'Garment Bags', 'Sock Organizer', 'Laundry Hamper', 'Spray Starch', 'Ironing Board Cover', 'Wooden Hangers', 'Plastic Hangers', 'Padded Hangers'],
      ),
      CategoryData(
        id: 'storage',
        name: 'STORAGE & ORGANIZATION',
        icon: '📦',
        description: 'Storage boxes, shelves, organizers...',
        items: ['Plastic Storage Boxes', 'Wooden Storage Boxes', 'Shelves', 'Drawer Organizers', 'Storage Bags', 'Baskets', 'Wall Hooks', 'Under-Bed Storage', 'Closet Organizers', 'Shoe Organizer', 'Tie Rack', 'Belt Rack', 'Pegboards', 'Bins', 'Containers', 'Crates', 'Shelving Units', 'Wall Shelves', 'Floating Shelves', 'Desk Organizers'],
      ),
      CategoryData(
        id: 'baby',
        name: 'BABY & KIDS CARE',
        icon: '👶',
        description: 'Diapers, wipes, baby food...',
        items: ['Diapers', 'Baby Wipes', 'Baby Shampoo', 'Baby Lotion', 'Baby Soap', 'Pacifiers', 'Baby Food', 'Baby Formula', 'Baby Bottles', 'Bottle Sterilizer', 'Bottle Warmer', 'High Chair', 'Bibs', 'Baby Blankets', 'Teething Rings', 'Baby Powder', 'Diaper Rash Cream', 'Pull-Up Pants', 'Baby Conditioner', 'Baby Feeding Chair'],
      ),
      CategoryData(
        id: 'outdoor',
        name: 'OUTDOOR & GARDEN',
        icon: '🌱',
        description: 'Plant pots, soil, seeds...',
        items: ['Plant Pots', 'Plant Soil', 'Fertilizer', 'Seeds', 'Watering Can', 'Garden Hose', 'Garden Tools', 'Rake', 'Shovel', 'Pruning Shears', 'Garden Gloves', 'Outdoor Furniture', 'Planters', 'Plant Food', 'Mulch', 'Compost', 'Garden Lights', 'Outdoor Rugs', 'Patio Chairs', 'Benches'],
      ),
      CategoryData(
        id: 'electronics',
        name: 'ELECTRONICS & BATTERIES',
        icon: '⚡',
        description: 'Light bulbs, batteries, chargers...',
        items: ['LED Bulbs', 'Batteries', 'USB Chargers', 'Phone Chargers', 'USB Cables', 'Power Strips', 'Extension Cords', 'Power Banks', 'Electrical Tape', 'Light Fixtures', 'Flashlights', 'Headphones', 'Speakers', 'Adapters', 'Circuit Breakers', 'Wire Connectors', 'Surge Protectors', 'Outlet Covers', 'Cable Organizers', 'Lamp Bulbs'],
      ),
    ];
  }

  List<CategoryData> getCategories() => categories;

  CategoryData? getCategoryById(String id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  List<CategoryData> searchCategories(String query) {
    if (query.isEmpty) return categories;
    final lowercaseQuery = query.toLowerCase();
    return categories
        .where((cat) =>
    cat.name.toLowerCase().contains(lowercaseQuery) ||
        cat.description.toLowerCase().contains(lowercaseQuery) ||
        cat.items.any((item) => item.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }
}