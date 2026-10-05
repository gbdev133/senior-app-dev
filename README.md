# Memory Music App

A Flutter-based music memory game designed to support seniors living with dementia by encouraging engagement, recognition, and enjoyment through familiar songs and simple interactions.

## Overview

Summer Memory Music is a mobile app that helps seniors recognize, remember, and enjoy music in a calm and accessible way. The game uses familiar songs, large touch targets, and a clear user interface to reduce confusion and make the experience comfortable and rewarding.

The app is designed to be easy to use for both older adults and caregivers, with features that support personalization and flexible music content.

## Why this app?

Music has a powerful connection to memory, emotion, and routine. For many people living with dementia, familiar songs can spark recognition, encourage participation, and provide moments of joy and comfort.

This project aims to create a low-stress, easy-to-use memory game that uses music as a therapeutic and social activity.

## Key Features

- Simple, senior-friendly interface
  - Large buttons and clear layouts
  - Minimal clutter and easy-to-read text
  - High-contrast colors and straightforward navigation

- Music-based memory gameplay
  - Play short songs or melodies
  - Encourage recognition of familiar music
  - Support memory recall through repeated, calming interactions

- Accessible design for older adults
  - Simple instructions
  - Reduced cognitive load
  - Gentle pacing and supportive feedback

- Firebase integration
  - Store and manage custom song libraries
  - Load songs from Firebase for personalization
  - Support future expansion with user-specific music content

- Custom music support
  - Add family favorites, cultural songs, or personalized playlists
  - Adapt the experience to each person’s preferences and background

- Caregiver-friendly configuration
  - Easy content updates
  - Flexible game setup for different usage scenarios

## Target Audience

- Seniors with dementia
- Caregivers and family members
- Assisted living and memory care environments
- Therapeutic or recreational music activities

## Technology Stack

- Flutter
- Dart
- Firebase
  - Firestore or Realtime Database for music metadata
  - Storage for audio files
  - Authentication support for future user access and management

## Getting Started

### Prerequisites

- Flutter SDK installed
- A Firebase project set up
- Android/iOS simulator or device for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/gbdev133/senior-app-dev.git
   cd senior-app-dev
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a Firebase project
   - Add Android and/or iOS support
   - Download and place the Firebase configuration files in the project
   - Enable the services needed for audio and data management

4. Run the app:
   ```bash
   flutter run
   ```

## Firebase Music Integration

This project is designed to support Firebase-based song loading so custom music collections can be used in the app. The Firebase setup can be used to store:

- Song titles
- Artist names
- Audio file references
- Categories or memory themes
- Personalized content for different users

This allows caregivers or family members to add familiar, meaningful songs tailored to the person using the app.

## Future Enhancements

- Personalized user profiles
- Difficulty levels and progression
- Voice prompts and spoken instructions
- Caregiver dashboard for song management
- Offline support for downloaded music
- Analytics for usage and engagement

## License

This project is intended for educational and assistive use. Please check the repository license file for specific terms.

## Contributing

Contributions are welcome, especially improvements related to accessibility, user experience, and memory-supportive design.

## Contact

For questions or collaboration opportunities, please contact the project maintainer through the repository.
