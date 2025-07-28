# Card Fan Layout - Godot Tutorial

A comprehensive tutorial for implementing **Slay the Spire-style card hand layout** in Godot 4. This project demonstrates how to create elegant, animated card layouts with hover effects, scatter animations, and perfect centering.

## 🎯 Features

- ✨ **Fan-shaped card layout** with smooth animations
- 🎮 **Interactive hover effects** with card lifting and scaling
- 🎨 **Smart scatter behavior** - other cards move away when one is hovered
- 📐 **Perfect centering** algorithm that works with any number of cards
- 🎪 **Smooth transitions** with customizable parameters

## 🚀 Quick Start

### Prerequisites
- Godot 4.x
- Basic knowledge of GDScript

### Installation
1. Clone or download this project
2. Open the project in Godot 4
3. Run the main scene (`main.tscn`)

## 📁 Project Structure

```
card_fan_demo/
├── hand.gd              # Main hand manager script
├── card_ui.gd           # Individual card behavior
├── card_ui.tscn         # Card UI scene
├── events.gd            # Event system (if needed)
├── main.tscn            # Main scene
└── project.godot        # Project configuration
```

## 🎮 Core Components

### 1. Hand Manager (`hand.gd`)

The central controller that manages the entire card hand layout.

**Key Features:**
- Dynamic card positioning
- Fan-shaped layout algorithm
- Hover state management
- Scatter effect coordination

**Core Algorithm:**
```gdscript
# Centering formula - the magic behind perfect alignment
start_x = base_position.x - total_width / 2

# Normalized position calculation
t = (float(i) / float(card_count - 1)) * 2.0 - 1.0

# Rotation and arc calculations
rot = t * ROT_MAX
arc_offset = -ARC_HEIGHT * (t * t) + ARC_HEIGHT
```

### 2. Card UI (`card_ui.gd`)

Individual card behavior and hover effects.

**Key Features:**
- Mouse hover detection
- Dynamic position calculation
- Smooth animation transitions
- Anti-flicker protection

### 3. Card Scene (`card_ui.tscn`)

Visual representation of cards with proper anchoring and styling.

## ⚙️ Customization

### Layout Parameters

```gdscript
const ROT_MAX := 0.2                 # Maximum rotation angle (0.1-0.3)
const MAX_CARD_SPACING := -60        # Card spacing (negative = overlap)
const SCATTER_OFFSET := 120          # Scatter distance (80-150)
const ARC_HEIGHT := 40.0            # Arc height (20-60)
const HOVER_SCALE := 1.5            # Hover scale factor (1.2-2.0)
```

### Visual Customization

- **Card Colors**: Modify the color array in `hand.gd`
- **Card Size**: Adjust `custom_minimum_size` in `card_ui.tscn`
- **Animation Speed**: Change tween duration values
- **Screen Position**: Modify `base_position` calculation

## 🔧 Implementation Details

### Fan Layout Algorithm

The fan layout uses a **normalized position system**:

1. **Position Normalization**: Cards are positioned from -1 (leftmost) to 1 (rightmost)
2. **Rotation Calculation**: `rotation = normalized_position * max_rotation`
3. **Arc Height**: Uses parabolic formula for natural curve
4. **Centering**: Ensures the card group center aligns with screen center

### Hover Effect System

```gdscript
# Calculate hover position (card bottom touches screen bottom)
func _calculate_hover_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var card_size = custom_minimum_size * HOVER_SCALE
	var target_bottom_y = viewport_size.y
	var target_center_y = target_bottom_y - card_size.y / 2
	return Vector2(hover_start_position.x, target_center_y)
```

### Anti-Flicker Protection

The system prevents flickering by:
- Recording hover start position
- Using direct position setting for critical movements
- Separating position and animation tweening

## 🎮 Usage Examples

### Basic Implementation

```gdscript
# Add cards to hand
for i in range(5):
	add_card(Color.RED)

# The layout automatically updates
```

### Custom Card Colors

```gdscript
var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE
]

for color in colors:
	add_card(color)
```

### Dynamic Card Management

```gdscript
# Add card
add_card(Color.ORANGE)

# Remove card (implement as needed)
# remove_card(card_index)

# Update layout
_update_card_positions()
```

## 🐛 Troubleshooting

### Common Issues

1. **Cards not centering properly**
   - Check `base_position` calculation
   - Verify `total_width` includes card width
   - Ensure `start_x` formula is correct

2. **Flickering on hover**
   - Use `hover_start_position` instead of `original_position`
   - Set position directly, not with tween
   - Check for conflicting animations

3. **Performance issues**
   - Limit tween creation
   - Use direct position setting for critical movements
   - Optimize update frequency

### Debug Tips

```gdscript
# Add debug output
print("Total width: ", total_width)
print("Start X: ", start_x)
print("Card count: ", card_count)
```


## �� Learning Resources

### Related Topics

- **Godot UI System**: Understanding Control nodes
- **Tween Animations**: Smooth transitions in Godot
- **Vector Mathematics**: Position and rotation calculations
- **Event Systems**: Signal-based communication

### Further Reading

- [Godot UI Tutorial](https://docs.godotengine.org/en/stable/tutorials/ui/)
- [Tween Documentation](https://docs.godotengine.org/en/stable/tutorials/animation/introduction_to_animation.html)
- [Vector Math in Godot](https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report bugs** with detailed descriptions
2. **Suggest features** with use cases
3. **Submit pull requests** with improvements
4. **Share examples** of your implementations

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤔 Acknowledgments

- Inspired by **Slay the Spire**'s elegant card layout
- Built with **Godot 4** game engine
- Community feedback and suggestions

## 📞 Support

- **Issues**: Report bugs on GitHub
- **Discussions**: Ask questions in GitHub Discussions
- **Examples**: Share your implementations

---

**Happy coding!** 🎮✨

*Transform your card games from basic to brilliant with this comprehensive layout system!*
```
