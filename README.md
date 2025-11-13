# Blood sos App 🩸

<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/c722e9c6-68f6-4f0e-982d-c27a7dda3ab3" width="750" />

## Features 📲

- Login/Register Accounts, Forgot Password Feature
- Edit Profile Data with User Uploadable Profile Picture
- Get Blood Request Alerts Around 200 Km Radius Nearby
- Request When Blood is Needed / Donate to Others
- Donation will be Accepted only if Donor is Within Hospital Radius By Verifying GPS Coordinates
- Users can Accept/Reject a Donor & Personal Details are Shared only if Accepted
- Rating System allows to rate and write a review for Donor
- Push Notifications using Firebase

## Running The Application 🧑🏻‍💻

- `git clone https://github.com/jagadeesh-k-2802/blood-donation-app-flutter`
- `cd server && npm i`
- Configure all required environment variables in `server/config/config.env.example`
- Remove `.example` from the filename it should be `config.env`
- Install MongoDB Locally on Your System or use Cloud hosted connection string
- Download Firebase Admin Private Key JSON file and rename it it to `firebase-admin.json`
- Place the JSON file inside server/config/
- `npm run dev` to start the node server
- `dart pub global activate flutterfire_cli` Install flutterfire CLI
- `npm install -g firebase-tools` Install firebase CLI using NPM
- `cd mobile && flutterfire configure` Configure firebase using your own firebase project
- open `./mobile` inside your code editor and run flutter app

## Database Seeding 🌱

- `cd server`
- `node db-seed.js --seed` This command populates the db with few sample data to get started
- `node db-seed.js --clean` This command will delete everything stored in the database

## Screenshots 📷

<<table>
  <tr>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-23-53.jpg" width="250"/></td>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-24-49.jpg" width="250"/></td>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-26-15.jpg" width="250"/></td>
  </tr>

  <tr>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-28-20.jpg" width="250"/></td>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-29-15.jpg" width="250"/></td>
    <td><img src="assets/screenshots/PHOTO-2025-05-04-02-32-02.jpg" width="250"/></td>
  </tr>
</table>


