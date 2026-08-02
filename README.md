# ChefMate Mobile 🍳📱

## Native Android App for ChefMate AI

The Flutter/Android client for [ChefMate AI](https://github.com/Lavanya3112/chefmate-ai-api) — a Gemini-powered cooking tutor. This app calls the live FastAPI backend to deliver step-by-step lessons, real-life examples, quizzes, and personalized feedback, right on your phone.

---
## 🔗 Related Links

| Component | Link |
|---|---|
| ⚙️ Backend API (Live) | [chefmate-ai-api.onrender.com](https://chefmate-ai-api.onrender.com) |
| 🧪 Interactive API Docs / Testing | [chefmate-ai-api.onrender.com/docs](https://chefmate-ai-api.onrender.com/docs) |
| 💻 Backend Repo | [github.com/Lavanya3112/chefmate-ai-api](https://github.com/Lavanya3112/chefmate-ai-api) |
| 🌐 Original Streamlit App | [chefmate-ai-cooking-tutor.streamlit.app](https://chefmate-ai-cooking-tutor.streamlit.app/) |


---

## 📱 Features

* Topic + skill-level selection (Beginner / Intermediate / Advanced)
* Step-by-step concept explanations
* Real-life cooking examples
* Auto-generated 5-question quizzes
* AI-evaluated answer feedback
* Full structured lesson sessions
* Open-ended cooking Q&A — with automatic redirection of health/medical questions to a qualified professional

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **Backend:** FastAPI + Google Gemini API (see [chefmate-ai-api](https://github.com/Lavanya3112/chefmate-ai-api))
* **HTTP Client:** `http` package
* **Deployment target:** Android

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK installed
* Android SDK + an emulator or physical device

### Setup
```bash
git clone https://github.com/Lavanya3112/chefmate-mobile.git
cd chefmate-mobile
flutter pub get
```

### Run
```bash
flutter run
```

### Build a release APK
```bash
flutter build apk --release
```
The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🏗️ Project Origin

This app is the mobile client for ChefMate AI, a solo-built project designed and developed end-to-end — starting as a Streamlit web app, converted into a FastAPI backend, and finally shipped as this native Android app.

---

## 👩‍🍳 Author

**Lavanya Ajit Dive**
B.Sc. Data Science Student | Data Analyst | AI & GenAI Enthusiast
[LinkedIn](https://linkedin.com/in/lavanyadive) · [GitHub](https://github.com/Lavanya3112)
