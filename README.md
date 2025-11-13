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

<table>
  <tr>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/02ca044d-649a-41a3-87c9-f875969068ec" width="250"/></td>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/e8e9ac2c-58bb-49b1-b2f0-35cf7e96d3bd" width="250"/></td>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/870d2282-be3c-4eeb-bef5-605cb7648b65" width="250"/></td>
  </tr>

  <tr>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/83997f6c-8439-40a8-bafb-95a575e2ccc0" width="250"/></td>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/84b3258f-a278-432a-bf0b-0c4f5e525c85" width="250"/></td>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/2529c080-2e1f-4dfa-9dc1-7b0ae51abffd" width="250"/></td>
  </tr>

  <tr>
    <td><img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/f2d6e185-6bad-47ea-a19f-e74712e0c606" width="250"/></td>
  </tr>
</table>








