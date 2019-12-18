# blemulator_example

Demonstrates how to use the blemulator plugin.

## UI structure

App consists of two screens: PeripheralListScreen and 
PeripheralDetailsScreen.

### PeripheralListScreen

PeripheralListScreen combines two features:
- Control of scan process (start / stop), which is represented by a 
button in the AppBar
- Display of scanned peripherals, which take the main space on the 
screen

Scanned peripherals are represented in a list. Each peripheral row 
contains:
- Peripheral icon based on peripheral category,
- Peripheral identifier,
- Peripheral name,
- Rssi value with appropriate icon and color depending on signal 
strength.

Color of peripheral icon and identifier text is based on category.

Tapping on a given peripheral row results in a transition to the 
PeripheralDetailsScreen.

### PeripheralDetailsScreen

PeripheralDetailsScreen displays more detailed information regarding 
given peripheral.
More specific information is available depending on the peripheral's 
connection state.

#### PeripheralDetailsScreen main layout

For development purposes it was decided that main layout of details
screen is going to be created differently based on the peripheral 
category:

1. Base layout - for most of devices

2. Tabbed layout - for SensorTag peripherals (primary peripheral used 
during development) with 3 tabs:

- View uses by the base layout
- Automated test view
- Manual test view



#### Peripheral is disconnected

#### Peripheral is connected