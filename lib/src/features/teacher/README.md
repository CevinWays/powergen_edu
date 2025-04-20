# Teacher Module Documentation

## Features

### Teacher Home Page
The teacher home page provides a comprehensive dashboard with the following features:

1. **Student Progress Monitoring**
   - View real-time progress of all students
   - Progress bars with color indicators (red < 40%, orange 40-70%, green > 70%)
   - Quick overview of completion percentages

2. **Student Information Management**
   - Search students by name
   - Sort students by:
     - Name (alphabetically)
     - Class
     - Progress (highest to lowest)
   - Quick access to detailed student profiles

3. **Assessment & Feedback System**
   - View pending assessments
   - Filter assessments by subject:
     - Mathematics
     - Science
     - English
   - Quick access to assessment form
   - Provide scores and detailed feedback

## Setup Instructions

1. Ensure you have the required dependencies in your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.3
     firebase_core: ^2.24.2
     cloud_firestore: ^4.13.6
     firebase_auth: ^4.15.3
   ```

2. Set up Firebase:
   - Add your `google-services.json` for Android
   - Add your `GoogleService-Info.plist` for iOS
   - Initialize Firebase in your app

3. Firestore Collections Structure:
   ```
   - students/
     - id: string
     - name: string
     - className: string
   
   - student_progress/
     - id: string
     - studentName: string
     - progressPercentage: number
   
   - assessments/
     - id: string
     - studentName: string
     - taskName: string
     - status: string ('pending' | 'completed')
     - score?: number
     - feedback?: string
     - completedAt?: timestamp
   ```

## Usage

### Viewing Student Progress
- The progress bars automatically update when the student data changes
- Click on individual progress bars to see detailed progress information

### Managing Student Information
- Use the search bar at the top to filter students by name
- Use the sort dropdown to change the ordering of the student list
- Click the arrow icon to view detailed student information

### Handling Assessments
1. Select a subject filter to view relevant assessments
2. Click "Assess" on any pending assessment
3. Enter the score (0-100)
4. Provide detailed feedback
5. Submit the assessment

## Navigation
- Student Detail: `/student-detail` with Student object as argument
- Assessment Page: `/assessment` with PendingAssessment object as argument

## Theme Support
The application supports both light and dark themes, automatically adapting to system preferences.