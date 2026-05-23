

from flask import Flask, request, jsonify
from flask_cors import CORS
import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'

import sys
import mediapipe as mp
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
import cv2
import base64
import math

app = Flask(__name__)
CORS(app)

from mediapipe.tasks import python as mp_python
from mediapipe.tasks.python import vision

# ─── Chargement du modèle ──────────────────────────────────────────
MODEL_PATH = os.path.join(os.path.dirname(__file__), 'mp_hand_gesture')
NAMES_PATH = os.path.join(os.path.dirname(__file__), 'gesture.names')
TASK_PATH = os.path.join(os.path.dirname(__file__), 'hand_landmarker.task')

TM_MODEL_PATH = os.path.join(os.path.dirname(__file__), 'tm_model.h5')
TM_NAMES_PATH = os.path.join(os.path.dirname(__file__), 'tm_labels.txt')

model = None
classNames = []
tm_model = None
tm_classNames = []
detector = None

def load_resources():
    global model, classNames, tm_model, tm_classNames, detector
    try:
        model = load_model(MODEL_PATH)
        with open(NAMES_PATH, 'r') as f:
            classNames = f.read().strip().split('\n')
        print(f"[*] Modele 1 (Landmarks) charge - {len(classNames)} gestes")

        tm_model = load_model(TM_MODEL_PATH)
        with open(TM_NAMES_PATH, 'r') as f:
            tm_classNames = [line.split(" ", 1)[-1].strip() for line in f.read().strip().split('\n')]
        print(f"[*] Modele 2 (TM Images) charge - {len(tm_classNames)} gestes")
        
        # Init MediaPipe Tasks API
        base_options = mp_python.BaseOptions(model_asset_path=TASK_PATH)
        options = vision.HandLandmarkerOptions(
            base_options=base_options,
            num_hands=1,
            min_hand_detection_confidence=0.8,
            min_hand_presence_confidence=0.8,
            min_tracking_confidence=0.8
        )
        detector = vision.HandLandmarker.create_from_options(options)
        print("[*] MediaPipe HandLandmarker charge")
    except Exception as e:
        print(f"[!] Erreur chargement modele : {e}")

# ─── Health check ─────────────────────────────────────────────────
@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'ok',
        'model_loaded': model is not None and tm_model is not None and detector is not None,
        'gestures': classNames + tm_classNames,
        'version': '2.0.0'
    })

# ─── Predict endpoint ─────────────────────────────────────────────
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        if not data or 'image' not in data:
            return jsonify({'error': 'Aucune image fournie'}), 400

        # Décoder image base64
        img_bytes = base64.b64decode(data['image'])
        nparr = np.frombuffer(img_bytes, np.uint8)
        frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if frame is None:
            return jsonify({'error': 'Image invalide'}), 400

        x, y, _ = frame.shape
        frame = cv2.flip(frame, 1)
        framergb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # MediaPipe Tasks API
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=framergb)
        if detector is None:
             return jsonify({'error': 'Detector non initialise', 'gesture': '', 'confidence': 0.0}), 500
             
        result = detector.detect(mp_image)

        if not result.hand_landmarks:
            return jsonify({
                'gesture': '',
                'confidence': 0.0,
                'detected': False
            })

        landmarks = []
        for lm in result.hand_landmarks[0]:
            lmx = int(lm.x * x)
            lmy = int(lm.y * y)
            landmarks.append([lmx, lmy])

        # Prédiction Modèle 1 (Landmarks)
        prediction_1 = model.predict([landmarks], verbose=0)
        classID_1 = int(np.argmax(prediction_1))
        confidence_1 = float(np.max(prediction_1))
        gesture_1 = classNames[classID_1] if classID_1 < len(classNames) else 'unknown'
        # print(f"Model 1: {gesture_1} ({confidence_1:.2f})")

        # Prédiction Modèle 2 (Teachable Machine)
        gesture_2 = ''
        confidence_2 = 0.0

        if tm_model is not None:
            try:
                offset = 20
                imgSize = 300
                height, width, _ = frame.shape
                
                x_min = int(min([lm.x for lm in result.hand_landmarks[0]]) * width)
                x_max = int(max([lm.x for lm in result.hand_landmarks[0]]) * width)
                y_min = int(min([lm.y for lm in result.hand_landmarks[0]]) * height)
                y_max = int(max([lm.y for lm in result.hand_landmarks[0]]) * height)

                x_box = max(0, x_min - offset)
                y_box = max(0, y_min - offset)
                w_box = min(width - x_box, (x_max - x_min) + 2 * offset)
                h_box = min(height - y_box, (y_max - y_min) + 2 * offset)

                if w_box > 0 and h_box > 0:
                    imgCrop = framergb[y_box:y_box+h_box, x_box:x_box+w_box]
                    imgWhite = np.ones((imgSize, imgSize, 3), np.uint8) * 255
                    aspectRatio = h_box / w_box

                    if aspectRatio > 1:
                        k = imgSize / h_box
                        wCal = math.ceil(k * w_box)
                        imgResize = cv2.resize(imgCrop, (wCal, imgSize))
                        wGap = math.ceil((imgSize - wCal) / 2)
                        # Fix boundaries just in case
                        wGap_end = min(wGap + wCal, imgSize)
                        imgWhite[:, wGap:wGap_end] = imgResize[:, :wGap_end-wGap]
                    else:
                        k = imgSize / w_box
                        hCal = math.ceil(k * h_box)
                        imgResize = cv2.resize(imgCrop, (imgSize, hCal))
                        hGap = math.ceil((imgSize - hCal) / 2)
                        hGap_end = min(hGap + hCal, imgSize)
                        imgWhite[hGap:hGap_end, :] = imgResize[:hGap_end-hGap, :]

                    img_resized = cv2.resize(imgWhite, (224, 224))
                    normalized_img = (img_resized.astype(np.float32) / 127.5) - 1.0
                    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)
                    data[0] = normalized_img

                    tm_prediction = tm_model.predict(data, verbose=0)
                    classID_2 = int(np.argmax(tm_prediction))
                    confidence_2 = float(np.max(tm_prediction))
                    gesture_2 = tm_classNames[classID_2]
                    # print(f"Model 2: {gesture_2} ({confidence_2:.2f})")
            except Exception as e:
                print("[!] TM Model Error:", e)

        print(f"Pred -> M1: {gesture_1} ({confidence_1:.2f}) | M2: {gesture_2} ({confidence_2:.2f})")
        sys.stdout.flush()
        
        # L'Arbitre : On choisit le plus confiant
        final_gesture = gesture_1
        final_confidence = confidence_1

        # On donne un léger avantage au modèle TM s'il est très sûr de lui (> 70%)
        if confidence_2 > 0.70 and (confidence_2 > confidence_1 or confidence_1 < 0.90):
            final_gesture = gesture_2
            final_confidence = confidence_2

        # Si la confiance globale est trop basse, on ignore la prédiction
        if final_confidence < 0.70:
            final_gesture = ''
            
        return jsonify({
            'gesture': final_gesture,
            'confidence': round(final_confidence, 4),
            'detected': True,
            'models_info': {
                'model1_gesture': gesture_1,
                'model1_conf': round(confidence_1, 4),
                'model2_gesture': gesture_2,
                'model2_conf': round(confidence_2, 4)
            }
        })

    except Exception as e:
        return jsonify({'error': str(e), 'gesture': '', 'confidence': 0.0}), 500

# ─── Gestures list ────────────────────────────────────────────────
@app.route('/gestures', methods=['GET'])
def get_gestures():
    all_gestures = classNames + tm_classNames
    return jsonify({'gestures': all_gestures, 'count': len(all_gestures)})

# ─── Main ─────────────────────────────────────────────────────────
if __name__ == '__main__':
    load_resources()
    print("\n[*] DELTASIGNE API demarree sur http://localhost:5000")
    print("   Endpoints disponibles :")
    print("   GET  /health    - verification statut")
    print("   POST /predict   - reconnaissance de geste")
    print("   GET  /gestures  - liste des gestes\n")
    app.run(host='0.0.0.0', port=5000, debug=False)
