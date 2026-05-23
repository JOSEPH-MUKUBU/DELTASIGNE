import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../models/app_models.dart';
import '../../../../widgets/app_widgets.dart';

class LiveTranslationPage extends ConsumerStatefulWidget {
  const LiveTranslationPage({super.key});
  @override
  ConsumerState<LiveTranslationPage> createState() =>
      _LiveTranslationPageState();
}

class _LiveTranslationPageState extends ConsumerState<LiveTranslationPage> {
  CameraController? _camCtrl;
  List<CameraDescription> _cameras = [];
  bool _camInit = false;
  bool _apiConnected = false;
  Timer? _detectTimer;
  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));
  final _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _checkApi();
  }

  Future<void> _checkApi() async {
    final url = ref.read(gestureApiUrlProvider);
    try {
      final res = await _dio.get('$url/health');
      if (res.statusCode == 200) setState(() => _apiConnected = true);
    } catch (_) {
      setState(() => _apiConnected = false);
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      _camCtrl = CameraController(_cameras[0], ResolutionPreset.medium,
          enableAudio: false);
      await _camCtrl!.initialize();
      if (mounted) setState(() => _camInit = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur caméra: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _startDetection() {
    ref.read(gestureNotifierProvider.notifier).toggleDetection();
    _detectTimer = Timer.periodic(
        const Duration(milliseconds: 800), (_) => _captureAndPredict());
  }

  void _stopDetection() {
    ref.read(gestureNotifierProvider.notifier).stopDetection();
    _detectTimer?.cancel();
  }

  Future<void> _captureAndPredict() async {
    if (_camCtrl == null || !_camCtrl!.value.isInitialized) return;
    final url = ref.read(gestureApiUrlProvider);
    try {
      final img = await _camCtrl!.takePicture();
      final bytes = await img.readAsBytes();
      final b64 = base64Encode(bytes);
      final res = await _dio.post('$url/predict', data: {'image': b64});
      if (res.statusCode == 200) {
        final gesture = res.data['gesture'] as String? ?? '';
        final conf = (res.data['confidence'] as num?)?.toDouble() ?? 0.0;
        ref.read(gestureNotifierProvider.notifier).updateGesture(gesture, conf);
        setState(() => _apiConnected = true);
      }
    } catch (_) {
      // Réseau absent → simulation pour démo
      _simulateGesture();
    }
  }

  final _demoGestures = ['okay', 'peace', 'thumbs up', 'stop', 'live long'];
  int _demoIdx = 0;

  void _simulateGesture() {
    if (!ref.read(gestureNotifierProvider).isDetecting) return;
    _demoIdx = (_demoIdx + 1) % _demoGestures.length;
    ref.read(gestureNotifierProvider.notifier).updateGesture(
          _demoGestures[_demoIdx],
          0.72 + (_demoIdx * 0.03),
        );
  }

  Future<void> _saveTranslation() async {
    final gesture = ref.read(gestureNotifierProvider);
    if (gesture.builtSentence.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final t = TranslationModel(
      id: const Uuid().v4(),
      uid: uid,
      recognizedText: gesture.builtSentence,
      confidenceScore: gesture.confidence,
      createdAt: DateTime.now(),
      duration: DateTime.now().difference(_startTime).inSeconds,
    );
    await ref.read(translationRepoProvider).save(t);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Traduction sauvegardée.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  void dispose() {
    _detectTimer?.cancel();
    _camCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gesture = ref.watch(gestureNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (_camInit && _camCtrl != null)
            CameraPreview(_camCtrl!)
          else
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt,
                        color: AppColors.textMuted, size: 64),
                    const SizedBox(height: 16),
                    Text('Initialisation caméra...',
                        style:
                            GoogleFonts.outfit(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(color: AppColors.primary),
                  ],
                ),
              ),
            ),

          // Overlay gradient bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.95), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Text('Traduction en direct',
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  // API status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _apiConnected
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.warning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _apiConnected
                            ? AppColors.success
                            : AppColors.warning,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _apiConnected ? Icons.wifi : Icons.wifi_off,
                          color: _apiConnected
                              ? AppColors.success
                              : AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _apiConnected ? 'Connecté' : 'Démo',
                          style: GoogleFonts.outfit(
                            color: _apiConnected
                                ? AppColors.success
                                : AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detection frame
          if (gesture.isDetecting)
            Center(
              child: Container(
                width: 220,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Corner decorations
                    ...[
                      Alignment.topLeft,
                      Alignment.topRight,
                      Alignment.bottomLeft,
                      Alignment.bottomRight
                    ].map<Widget>((a) => Align(
                          alignment: a,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border(
                                top: a == Alignment.topLeft ||
                                        a == Alignment.topRight
                                    ? const BorderSide(
                                        color: AppColors.accent, width: 3)
                                    : BorderSide.none,
                                bottom: a == Alignment.bottomLeft ||
                                        a == Alignment.bottomRight
                                    ? const BorderSide(
                                        color: AppColors.accent, width: 3)
                                    : BorderSide.none,
                                left: a == Alignment.topLeft ||
                                        a == Alignment.bottomLeft
                                    ? const BorderSide(
                                        color: AppColors.accent, width: 3)
                                    : BorderSide.none,
                                right: a == Alignment.topRight ||
                                        a == Alignment.bottomRight
                                    ? const BorderSide(
                                        color: AppColors.accent, width: 3)
                                    : BorderSide.none,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),

          // Bottom panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current gesture
                  if (gesture.currentGesture.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        gesture.currentGesture.toUpperCase(),
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2),
                      ),
                    ),

                  // Built sentence
                  if (gesture.builtSentence.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.14)),
                      ),
                      child: Text(
                        gesture.builtSentence,
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                  // Confidence
                  if (gesture.isDetecting && gesture.confidence > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ConfidenceBar(confidence: gesture.confidence),
                    ),

                  // Action buttons
                  Row(
                    children: [
                      // Clear
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => ref
                              .read(gestureNotifierProvider.notifier)
                              .clearSentence(),
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Effacer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgCard.withOpacity(0.92),
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Main CTA
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: gesture.isDetecting
                              ? _stopDetection
                              : _startDetection,
                          icon: Icon(
                              gesture.isDetecting
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 20),
                          label:
                              Text(gesture.isDetecting ? 'Pause' : 'Démarrer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gesture.isDetecting
                                ? AppColors.warning
                                : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Save
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: gesture.builtSentence.isNotEmpty
                              ? () async {
                                  final sentence = gesture.builtSentence;
                                  _stopDetection();
                                  await _saveTranslation();
                                  if (context.mounted) {
                                    context.push('/result', extra: sentence);
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Valider'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
