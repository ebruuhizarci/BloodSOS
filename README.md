# Blood sos App 🩸


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

## 📱 Mobil Ekran Görüntüleri
## 📱 Mobil Ekran Görüntüleri

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/80bbf7d3-a435-4f6a-b9d0-f904f22dbffd" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/c258f75b-8ad5-4267-a153-486a8dca83c0" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/35bb3a33-4195-418d-bcec-b59b720ce0f9" width="250"/></td>
  </tr>

  <tr>
    <td><img src="https://github.com/user-attachments/assets/3e153df2-a995-4d33-8575-8475e53f5c33" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/d97cc899-8d4c-4e07-8097-312b25777999" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/50524e18-857e-48ce-8369-ff4293a0982f" width="250"/></td>
  </tr>
</table>


