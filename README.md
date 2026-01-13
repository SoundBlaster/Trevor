# Trevor Mouse Tremor Filter

## Overview
Trevor is a mouse tremor filter designed to stabilize mouse pointer movement for individuals with hand tremors. It captures raw mouse events, applies a filtering algorithm, and injects stabilized events back into the system.

## Features
- **FilterCore Algorithm**: Uses the One Euro filter to stabilize mouse movement.
- **Event Pipeline**: Captures, filters, and injects mouse events.
- **UI Controls**: Enable/disable filtering, preset selection, and stability adjustment.

## Getting Started

### Prerequisites
- macOS
- Swift 5.0+
- Xcode

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Trevor.git
   ```
2. Open the project in Xcode:
   ```bash
   cd Trevor
   open Trevor.xcodeproj
   ```
3. Build and run the project.

## Usage
1. Enable the filter using the menubar controller.
2. Select a preset from the dropdown.
3. Adjust the stability slider to fine-tune the filtering.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License.
