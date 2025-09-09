# 🗓️ Flutter Events App

A feature-rich Flutter application that displays upcoming events in an interactive calendar view with user-specific favorites and bookings.

## ✨ Features

### Core Functionality
- 📅 **Calendar View**: Interactive calendar with event markers showing event counts per date
- 🔍 **Search & Filter**: Real-time search by event title, description, or category
- 👥 **Multi-User Support**: Switch between User A, User B, and User C with separate data
- ❤️ **Favorites System**: Mark events as favorites with persistent storage
- 🎫 **Booking System**: Book events with simulated booking functionality
- 📊 **Event Counts**: Display favorited and booked counts for each event

### User Experience
- 🎨 **Visual Indicators**: Color-coded events (gold for favorites, green for booked)
- 📱 **Responsive Design**: Works on both mobile and tablet devices
- 💾 **Persistent Storage**: SQLite database for all user data
- 🔄 **Real-time Updates**: UI updates immediately on user interactions
- 📖 **Event Details**: Full event details with navigation

## 🛠️ Technical Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Database**: SQLite with sqflite
- **Calendar**: table_calendar package
- **Architecture**: Clean Architecture Pattern

## 📁 Project Structure
lib/
├── router.dart
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── colors.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── database_helper.dart
│   │   │   └── local_data_source.dart
│   ├── models/
│   │   └── event_model.dart
│   └── repositories/
│       └── event_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── event.dart
│   ├── repositories/
│   │   └── event_repository.dart
│   └── usecases/
└── presentation/
    ├── views/
    │   ├── calendar_view.dart
    │   └── event_detail_view.dart
    ├── providers/
    │   ├── event_provider.dart
    │   ├── event_notifier.dart
    │   └── event_state.dart
    └── widgets/
        ├── event_calendar.dart
        ├── event_card.dart
        ├── day_events_list.dart
        ├── search_bar.dart
        └── user_selector.dart


## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.0 or higher  
- Dart SDK 2.19 or higher  
- Android Studio/Xcode (for emulator)

### Steps
1. Clone the repository  
   ```bash
   git clone https://github.com/tejas2213/flutter_event_app.git
   cd events_app

2. Install dependencies
   ```bash
   flutter pub get

3. Run the application
   ```bash
   flutter run

## 🎯 Usage Guide
**Viewing Events:**
1. Calendar Navigation: Scroll through months or use the "Today" button

2. Date Selection: Tap on any date to view events for that day

3. Event Details: Tap on any event card to view full details

**Managing Events:**
1. Search Events: Use the search bar to filter events in real-time

2. Add to Favorites: Click the heart icon on any event

3. Book Events: Click the "Book" button to reserve an event

**User Management:**
1. Switch Users: Use the dropdown in the app bar to switch between User A, User B, and User C

2. User-Specific Data: Each user has their own events, favorites, and bookings

## Database Schema
The app uses SQLite with three main tables:

1. **Events Table:**
CREATE TABLE events(
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  date TEXT NOT NULL,
  location TEXT NOT NULL,
  category TEXT NOT NULL,
  booked_count INTEGER DEFAULT 0,
  favorited_count INTEGER DEFAULT 0,
  user_id TEXT NOT NULL
)

2. **User Favorites Table:**
CREATE TABLE user_favorites(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  event_id TEXT NOT NULL,
  UNIQUE(user_id, event_id)
)

3. **User Bookings Table:**
CREATE TABLE user_bookings(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  event_id TEXT NOT NULL,
  UNIQUE(user_id, event_id)
)

## 🎨 UI Components
**EventCard:**
1. Displays event preview with title, date, location, and category
2. Shows favorited and booked counts
3. Interactive favorite and book buttons

**EventCalendar:**
1. Interactive calendar with event markers
2. Date selection and navigation
3. Visual indicators for events

**SearchBar:**
1. Real-time search functionality
2. Clear search option
3. Filters events by multiple criteria

## 🔧 State Management
The app uses Riverpod for state management with:
1. EventNotifier: Handles all business logic
2. EventState: Contains application state
3. Providers: For dependency injection and state access

## 🌟 Key Features Implementation
**Multi-User System:**
1. Each user has completely isolated data
2. Separate events, favorites, and bookings
3. Persistent user preferences

**Search Functionality:**
1. Real-time filtering across all events
2. Search by title, description, and category
3. Works seamlessly with calendar view

**Calendar Integration:**
1. Event markers show event counts per date
2. Smooth navigation between months
3. Selected date highlighting

## 📱 Screens
**Main Calendar View:**
1. Interactive calendar
2. Search bar
3. User selector
4. Events list for selected date

**Event Detail View:**
1. Complete event information
2. Favorite and book actions
3. Count displays
4. Navigation back to calendar
