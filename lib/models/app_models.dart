// Models for DELTASIGNE

// ─── User Model ──────────────────────────────────────────────────
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final String preferredLanguage;
  final String theme;
  final double speechRate;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    this.preferredLanguage = 'fr',
    this.theme = 'dark',
    this.speechRate = 1.0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photoUrl'],
        createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
        preferredLanguage: map['preferredLanguage'] ?? 'fr',
        theme: map['theme'] ?? 'dark',
        speechRate: (map['speechRate'] ?? 1.0).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'createdAt': createdAt,
        'preferredLanguage': preferredLanguage,
        'theme': theme,
        'speechRate': speechRate,
      };

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? preferredLanguage,
    String? theme,
    double? speechRate,
  }) =>
      UserModel(
        uid: uid,
        name: name ?? this.name,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        createdAt: createdAt,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        theme: theme ?? this.theme,
        speechRate: speechRate ?? this.speechRate,
      );
}

// ─── Translation Model ────────────────────────────────────────────
class TranslationModel {
  final String id;
  final String uid;
  final String recognizedText;
  final double confidenceScore;
  final DateTime createdAt;
  final int duration; // seconds
  final String sourceType;

  const TranslationModel({
    required this.id,
    required this.uid,
    required this.recognizedText,
    required this.confidenceScore,
    required this.createdAt,
    required this.duration,
    this.sourceType = 'live',
  });

  factory TranslationModel.fromMap(Map<String, dynamic> map, String docId) =>
      TranslationModel(
        id: docId,
        uid: map['uid'] ?? '',
        recognizedText: map['recognizedText'] ?? '',
        confidenceScore: (map['confidenceScore'] ?? 0.0).toDouble(),
        createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
        duration: map['duration'] ?? 0,
        sourceType: map['sourceType'] ?? 'live',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'recognizedText': recognizedText,
        'confidenceScore': confidenceScore,
        'createdAt': createdAt,
        'duration': duration,
        'sourceType': sourceType,
      };
}

// ─── Favorite Model ───────────────────────────────────────────────
class FavoriteModel {
  final String id;
  final String uid;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final bool isImportant;

  const FavoriteModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isImportant = false,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map, String docId) =>
      FavoriteModel(
        id: docId,
        uid: map['uid'] ?? '',
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        category: map['category'] ?? 'Général',
        createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
        isImportant: map['isImportant'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'title': title,
        'content': content,
        'category': category,
        'createdAt': createdAt,
        'isImportant': isImportant,
      };
}

// ─── Sign Model ───────────────────────────────────────────────────
class SignModel {
  final String id;
  final String label;
  final String description;
  final String? mediaUrl;
  final String difficultyLevel;
  final String category;
  final String emoji;

  const SignModel({
    required this.id,
    required this.label,
    required this.description,
    this.mediaUrl,
    required this.difficultyLevel,
    required this.category,
    required this.emoji,
  });
}

// ─── Gesture Prediction Model ─────────────────────────────────────
class GesturePrediction {
  final String gesture;
  final double confidence;
  final DateTime timestamp;

  const GesturePrediction({
    required this.gesture,
    required this.confidence,
    required this.timestamp,
  });
}
