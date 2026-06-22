// lib/services/categories_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider = Provider((ref) => CategoriesService());

class CategoryData {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> items;
  final String color;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.items,
    this.color = 'blue',
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
items: [
'Milk', 'Bread', 'Eggs', 'Rice', 'Cooking Oil', 'Sugar', 'Salt',
'Flour', 'Butter', 'Cheese', 'Yogurt', 'Tea', 'Coffee', 'Pasta',
'Canned Beans', 'Vegetables', 'Fruits', 'Honey', 'Peanut Butter', 'Jam',
],
color: 'blue',
),
CategoryData(
id: 'kitchen',
name: 'KITCHEN & DINING',
icon: '🍳',
description: 'Cookware, spices, kitchen gadgets, tableware...',
items: [
'Spices (Turmeric, Cumin, Chili)', 'Vinegar', 'Soy Sauce', 'Baking Powder',
'Baking Soda', 'Cooking Spray', 'Aluminum Foil', 'Plastic Wrap',
'Parchment Paper', 'Kitchen Towels', 'Dish Towels', 'Aprons', 'Oven Mitts',
'Trivets', 'Pot Holders', 'Cutting Boards', 'Knives', 'Spoons', 'Spatulas', 'Whisks',
],
color: 'orange',
),
CategoryData(
id: 'cleaning',
name: 'CLEANING & MAINTENANCE',
icon: '🧹',
description: 'Detergents, soaps, cleaning tools, disinfectants...',
items: [
'Dish Soap', 'Laundry Detergent', 'Bleach', 'Floor Cleaner', 'Glass Cleaner',
'Disinfectant Spray', 'All-Purpose Cleaner', 'Bathroom Cleaner', 'Kitchen Degreaser',
'Toilet Brush', 'Sponges', 'Microfiber Cloths', 'Mop Pads', 'Broom', 'Dustpan',
'Vacuum Bags', 'Air Freshener', 'Odor Eliminator', 'Trash Bags', 'Cleaning Gloves',
],
color: 'green',
),
CategoryData(
id: 'bathroom',
name: 'BATHROOM & PERSONAL CARE',
icon: '🚿',
description: 'Toiletries, hygiene products, skincare items...',
items: [
'Shampoo', 'Conditioner', 'Body Wash', 'Soap', 'Face Wash', 'Face Moisturizer',
'Toothpaste', 'Toothbrush', 'Dental Floss', 'Mouthwash', 'Deodorant', 'Razor Blades',
'Shaving Cream', 'Body Lotion', 'Hand Sanitizer', 'Tissues', 'Toilet Paper',
'Paper Towels', 'Hand Soap', 'Bath Bomb',
],
color: 'blue',
),
CategoryData(
id: 'bedroom',
name: 'BEDROOM & BEDDING',
icon: '🛏️',
description: 'Sheets, pillows, blankets, mattress covers...',
items: [
'Bed Sheets', 'Fitted Sheets', 'Pillowcases', 'Pillows', 'Blankets', 'Comforters',
'Duvet Covers', 'Mattress Protectors', 'Mattress Pads', 'Bed Skirts', 'Throw Pillows',
'Decorative Blankets', 'Curtains', 'Curtain Rods', 'Blinds', 'Sheer Panels',
'Valances', 'Bed Frame', 'Nightstands', 'Bed Headboards',
],
color: 'purple',
),
CategoryData(
id: 'laundry',
name: 'LAUNDRY & IRONING',
icon: '👕',
description: 'Fabric care, stain removers, laundry tools...',
items: [
'Fabric Softener', 'Laundry Starch', 'Stain Remover', 'Laundry Baskets', 'Iron',
'Ironing Board', 'Ironing Board Cover', 'Spray Starch', 'Clothes Hangers',
'Wooden Hangers', 'Plastic Hangers', 'Padded Hangers', 'Clothesline', 'Clothespins',
'Drying Rack', 'Lint Roller', 'Shoe Bags', 'Sweater Bags', 'Garment Bags', 'Sock Organizer',
],
color: 'pink',
),
CategoryData(
id: 'storage',
name: 'STORAGE & ORGANIZATION',
icon: '📦',
description: 'Storage boxes, shelves, organizers, bags...',
items: [
'Plastic Storage Boxes', 'Wooden Storage Boxes', 'Storage Bins', 'Shelves', 'Wire Shelves',
'Wall Shelves', 'Drawer Organizers', 'Desk Organizers', 'Storage Bags', 'Vacuum Storage Bags',
'Baskets', 'Woven Baskets', 'Wall Hooks', 'Hooks & Hangers', 'Under-Bed Storage',
'Closet Organizers', 'Shoe Organizer', 'Tie Rack', 'Belt Rack', 'Pegboards',
],
color: 'brown',
),
CategoryData(
id: 'baby',
name: 'BABY & KIDS CARE',
icon: '👶',
description: 'Diapers, wipes, baby food, bottles, toys...',
items: [
'Diapers (Various Sizes)', 'Pull-Up Pants', 'Baby Wipes', 'Baby Shampoo', 'Baby Conditioner',
'Baby Lotion', 'Diaper Rash Cream', 'Baby Powder', 'Baby Soap', 'Pacifiers', 'Teething Rings',
'Baby Food', 'Baby Formula', 'Baby Bottles', 'Bottle Sterilizer', 'Bottle Warmer',
'High Chair', 'Baby Feeding Chair', 'Bib', 'Baby Blanket',
],
color: 'pink',
),
CategoryData(
id: 'outdoor',
name: 'OUTDOOR & GARDEN',
icon: '🌱',
description: 'Plant pots, soil, seeds, garden tools...',
items: [
'Plant Pots', 'Terracotta Pots', 'Ceramic Pots', 'Plant Soil', 'Potting Mix', 'Fertilizer',
'Plant Food', 'Plant Seeds', 'Flower Seeds', 'Vegetable Seeds', 'Watering Can', 'Garden Hose',
'Hose Nozzle', 'Hose Reel', 'Garden Rake', 'Garden Shovel', 'Garden Spade', 'Pruning Shears',
'Garden Gloves', 'Outdoor Furniture',
],
color: 'green',
),
CategoryData(
id: 'electronics',
name: 'ELECTRONICS & BATTERIES',
icon: '⚡',
description: 'Light bulbs, batteries, chargers, cables...',
items: [
'LED Light Bulbs', 'Incandescent Bulbs', 'CFL Bulbs', 'Tube Lights', 'Flashlight Bulbs',
'AA Batteries', 'AAA Batteries', 'C Batteries', 'D