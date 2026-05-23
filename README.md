# DELTASIGNE - Sign Language Translator

🤟 **Application mobile de traduction en temps réel de la langue des signes utilisant l'IA**

*Auteur: Joseph Mukubu Kapoya*

## 📋 Description

DELTASIGNE est une application mobile innovante qui utilise l'intelligence artificielle pour reconnaître et traduire les gestes de la langue des signes en texte en temps réel. L'application combine une interface Flutter moderne avec un backend Python utilisant MediaPipe et TensorFlow pour une reconnaissance précise des gestes.

### 🎯 Fonctionnalités principales

- **🎥 Traduction en temps réel**: Reconnaissance instantanée des gestes via la caméra
- **🤖 Double modèle IA**: Combinaison de deux modèles de reconnaissance pour une meilleure précision
- **📚 Dictionnaire de gestes**: Base de données des gestes supportés avec démonstrations
- **⭐ Favoris**: Sauvegarde des traductions fréquemment utilisées
- **📜 Historique**: Historique complet des traductions effectuées
- **👤 Profil utilisateur**: Gestion du compte utilisateur avec Firebase
- **🌙 Mode sombre**: Interface adaptée aux préférences de l'utilisateur
- **🔗 Connexion API**: Communication avec un serveur Flask pour le traitement IA

## 🏗️ Architecture

Le projet est divisé en deux composants principaux:

### Frontend (Flutter)
- **Framework**: Flutter avec Riverpod pour la gestion d'état
- **Navigation**: Go Router pour une navigation fluide
- **Backend Cloud**: Firebase (Authentification, Firestore, Storage)
- **Architecture**: Feature-based avec séparation des responsabilités

### Backend (Python Flask API)
- **Framework**: Flask avec CORS pour la communication avec le frontend
- **Vision par ordinateur**: MediaPipe pour la détection des mains
- **Machine Learning**: TensorFlow/Keras pour la classification des gestes
- **Double approche**: Modèle basé sur les landmarks + modèle Teachable Machine

## 🚀 Technologies utilisées

### Frontend Flutter
- **State Management**: flutter_riverpod ^2.5.1
- **Navigation**: go_router ^13.2.0
- **Firebase**: firebase_core, firebase_auth, cloud_firestore, firebase_storage
- **Camera**: camera ^0.11.0+2
- **HTTP**: dio ^5.7.0, connectivity_plus ^6.0.5
- **UI**: google_fonts, flutter_animate, smooth_page_indicator, shimmer
- **Charts**: fl_chart ^0.69.0
- **Utils**: intl, uuid, share_plus, shared_preferences

### Backend Python
- **Web Framework**: Flask, Flask-CORS
- **Computer Vision**: MediaPipe, OpenCV
- **Machine Learning**: TensorFlow, Keras
- **Data Processing**: NumPy, Pillow

## 📦 Installation

### Prérequis

- Flutter SDK (>=3.0.0)
- Python 3.8+
- Node.js (pour certains outils)
- Compte Firebase (optionnel pour le développement)

### Installation du Frontend Flutter

```bash
# Naviguer vers le répertoire Flutter
cd DELTASIGNE2.2

# Installer les dépendances
flutter pub get

# Configurer Firebase (remplacer les clés dans lib/main.dart)
# Activer les services Firebase nécessaires:
# - Authentication
# - Firestore Database  
# - Storage

# Lancer l'application
flutter run -d chrome    # Pour le web
flutter run             # Pour mobile (Android/iOS)
```

### Installation du Backend Python

```bash
# Naviguer vers le répertoire de l'API
cd hand-gesture-recognition-code

# Créer un environnement virtuel (recommandé)
python -m venv venv

# Activer l'environnement virtuel
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Lancer le serveur API
python api_server.py
```

Le serveur API démarrera sur `http://localhost:5000`

## 🔧 Configuration

### Configuration Firebase

1. Créer un projet sur [Firebase Console](https://console.firebase.google.com/)
2. Activer les services: Authentication, Firestore Database, Storage
3. Télécharger le fichier de configuration et mettre à jour `lib/main.dart`
4. Remplacer les clés de démonstration par vos vraies clés Firebase

### Configuration API

L'API Flask se configure automatiquement avec les fichiers présents:
- `mp_hand_gesture/` - Modèle Keras basé sur les landmarks
- `tm_model.h5` - Modèle Teachable Machine
- `gesture.names` - Liste des gestes du modèle 1
- `tm_labels.txt` - Liste des gestes du modèle 2
- `hand_landmarker.task` - Fichier modèle MediaPipe

## 🤚 Gestes supportés

### Modèle 1 - Landmarks (10 gestes)
- ✅ Okay
- ✅ Peace
- ✅ Thumbs up
- ✅ Thumbs down
- ✅ Call me
- ✅ Stop
- ✅ Rock
- ✅ Live long
- ✅ Fist
- ✅ Smile

### Modèle 2 - Teachable Machine (7 gestes)
- ✅ Hello
- ✅ I love you
- ✅ No
- ✅ Okay
- ✅ Please
- ✅ Thank you
- ✅ Yes

## 📱 Structure du projet

```
DELTASIGNE2.2/
├── lib/                          # Code source Flutter
│   ├── core/                     # Cœur de l'application
│   │   ├── constants/           # Constantes et thèmes
│   │   ├── network/             # Configuration réseau et API
│   │   └── router/              # Configuration de navigation
│   ├── features/                 # Fonctionnalités par domaine
│   │   ├── auth/                # Authentification (login, register)
│   │   ├── dictionary/          # Dictionnaire de gestes
│   │   ├── favorites/           # Gestes favoris
│   │   ├── onboarding/          # Première utilisation
│   │   ├── profile/             # Profil utilisateur
│   │   ├── settings/            # Paramètres de l'application
│   │   └── translation/         # Traduction en temps réel
│   ├── models/                   # Modèles de données
│   ├── widgets/                  # Widgets réutilisables
│   └── main.dart                 # Point d'entrée
├── hand-gesture-recognition-code/  # Backend Python
│   ├── api_server.py            # Serveur Flask API
│   ├── TechVidvan-hand_gesture_detection.py
│   ├── mp_hand_gesture/         # Modèle Keras landmarks
│   ├── tm_model.h5              # Modèle Teachable Machine
│   ├── gesture.names            # Labels modèle 1
│   ├── tm_labels.txt            # Labels modèle 2
│   ├── hand_landmarker.task     # Modèle MediaPipe
│   └── requirements.txt         # Dépendances Python
├── assets/                      # Ressources statiques
│   ├── images/                  # Images
│   ├── animations/              # Animations
│   ├── icons/                   # Icônes
│   └── gestures/                # Images de démonstration des gestes
├── android/                     # Configuration Android
├── web/                         # Configuration Web
├── pubspec.yaml                 # Dépendances Flutter
└── README.md                    # Ce fichier
```

## 🔌 API Documentation

### Endpoints disponibles

#### Health Check
```http
GET /health
```
Retourne le statut du serveur et les informations sur les modèles chargés.

**Response:**
```json
{
  "status": "ok",
  "model_loaded": true,
  "gestures": ["okay", "peace", "thumbs up", ...],
  "version": "2.0.0"
}
```

#### Prédiction de geste
```http
POST /predict
Content-Type: application/json
```

**Body:**
```json
{
  "image": "base64_encoded_image_string"
}
```

**Response:**
```json
{
  "gesture": "thumbs up",
  "confidence": 0.9542,
  "detected": true,
  "models_info": {
    "model1_gesture": "thumbs up",
    "model1_conf": 0.9234,
    "model2_gesture": "thank you",
    "model2_conf": 0.8756
  }
}
```

#### Liste des gestes
```http
GET /gestures
```
Retourne la liste complète des gestes supportés par les deux modèles.

## 🎮 Utilisation

### Démarrage rapide

1. **Lancer le backend:**
   ```bash
   cd hand-gesture-recognition-code
   python api_server.py
   ```

2. **Lancer l'application Flutter:**
   ```bash
   cd ..
   flutter run
   ```

3. **Utiliser l'application:**
   - Créer un compte ou se connecter
   - Accéder à la page de traduction en direct
   - Pointer la caméra vers votre main
   - Faire un geste supporté
   - Voir la traduction apparaître en temps réel

### Fonctionnalités détaillées

- **Page d'accueil**: Accès rapide aux fonctionnalités principales
- **Traduction en direct**: Reconnaissance continue via caméra
- **Résultat de traduction**: Affichage du geste détecté avec niveau de confiance
- **Dictionnaire**: Consultation de tous les gestes avec démonstrations
- **Historique**: Relecture des traductions précédentes
- **Favoris**: Marquage des traductions importantes
- **Profil**: Gestion des informations utilisateur
- **Paramètres**: Personnalisation de l'expérience

## 🧪 Tests

### Tests Flutter
```bash
flutter test
```

### Tests Backend
```bash
cd hand-gesture-recognition-code
python test.py
```

## 🔒 Sécurité

- Les clés Firebase doivent être remplacées avant le déploiement
- L'API Flask utilise CORS pour autoriser les requêtes depuis le frontend
- Les données utilisateur sont stockées de manière sécurisée dans Firebase
- Communication HTTPS recommandée pour la production

## 🐛 Dépannage

### Problèmes courants

**L'API ne se connecte pas:**
- Vérifier que le serveur Python est en cours d'exécution
- Vérifier que le port 5000 n'est pas utilisé par une autre application
- Consulter les logs du serveur Python

**La caméra ne fonctionne pas:**
- Vérifier les permissions de caméra sur votre appareil
- Sur Android: configurer les permissions dans `android/app/src/main/AndroidManifest.xml`
- Sur iOS: configurer les permissions dans `ios/Runner/Info.plist`

**Erreur de modèle:**
- Vérifier que tous les fichiers de modèle sont présents
- Consulter les logs pour voir les erreurs de chargement
- Réinstaller les dépendances Python si nécessaire

**Problèmes Firebase:**
- Vérifier que les clés Firebase sont correctes
- S'assurer que les services Firebase sont activés
- Vérifier les règles de sécurité Firestore et Storage

## 📈 Améliorations futures

- [ ] Support de plusieurs mains simultanément
- [ ] Ajout de plus de gestes dans les modèles
- [ ] Traduction vers d'autres langues
- [ ] Mode hors-ligne avec modèles intégrés
- [ ] Fonction d'apprentissage personnalisé
- [ ] Integration vocale pour la prononciation
- [ ] Statistiques d'utilisation et progression

## 🤝 Contribution

Les contributions sont les bienvenues! Pour contribuer:

1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commit vos changements
4. Push vers la branche
5. Ouvrir une Pull Request

## 📝 Licence

Ce projet a été développé par Joseph Mukubu Kapoya dans le cadre de DELTASIGNE.

## 🙏 Remerciements

- **MediaPipe** pour la technologie de détection des mains
- **TensorFlow/Keras** pour les outils de machine learning
- **Flutter** pour le framework de développement mobile
- **Firebase** pour les services backend
- La communauté open-source pour les nombreuses bibliothèques utilisées

## 📞 Contact

Pour toute question ou suggestion concernant DELTASIGNE, n'hésitez pas à contacter l'auteur.

---

**DELTASIGNE** - Rendre la langue des signes accessible à tous grâce à l'IA. 🤟