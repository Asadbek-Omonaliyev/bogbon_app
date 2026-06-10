import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:bogbon/servis/model/AIPlantModel.dart';
import 'package:bogbon/servis/model/AIDiseaseModel.dart';

class AIService {

  static const String _apiKey = "";

  static Future<AIPlantModel?> identifyPlant(List<Uint8List> imagesBytes) async {
    debugPrint("AI: Identifikatsiya boshlandi... Rasmlar soni: ${imagesBytes.length}");
    
    if (_apiKey.length < 10) return null;

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final prompt = """
Siz ekspert botaniksiz. Taqdim etilgan bir yoki bir nechta rasmlar asosida o'simlikni aniq tahlil qiling.
Ma'lumotlarni FAQAT quyidagi JSON formatida va O'ZBEK TILIDA taqdim eting:

{
  "name": "O'simlik nomi",
  "latin_name": "Ilmiy lotincha nomi",
  "category": "O'simlik toifasi",
  "description": "O'simlik haqida batafsil ma'lumot.",
  "care": {
    "watering_days": "Sug'orish oraliqlari (faqat raqam)",
    "sunlight": "Quyosh nuri talabi",
    "temperature": "Ideal harorat oralig'i",
    "fertilizer": {
      "type": "O'g'it turi",
      "frequency": "Qo'llash chastotasi",
      "usage": "Qo'llash usuli"
    }
  },
  "tips": ["Maslahat 1"],
  "benefits": ["Foyda 1"],
  "propagation_methods": ["Usul 1"],
  "diseases": [
    {
      "name": "Kasallik nomi",
      "cause": "Sababi",
      "symptoms": ["Alomat 1"],
      "treatment": {"chemical": "Kimyoviy", "organic": "Tabiiy"}
    }
  ],
  "confidence": 0.95
}

Muhim ko'rsatmalar:
1. Faqat JSON qaytaring. 
2. Agar rasmda o'simlik bo'lmasa, "name": "Noma'lum" deb yozing.
3. Agar rasmda SUN'IY (plastik/sintetik) o'simlik bo'lsa, uning nomini "Sun'iy [O'simlik nomi]" deb yozing (masalan: "Sun'iy Orxideya"). 
   Lekin tavsif, parvarish va boshqa ma'lumotlarni ushbu o'simlikning TIRIK (asl) turi uchun taqdim eting. 
   Tavsifda ushbu o'simlikning sun'iy nusxa ekanligini qayd etib o'ting.
""";

      final content = [
        Content.multi([
          TextPart(prompt),
          ...imagesBytes.map((bytes) => DataPart('image/jpeg', bytes)),
        ]),
      ];

      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        debugPrint("AI: Empty response text.");
        return null;
      }

      String raw = response.text!.trim();
      debugPrint("AI RAW: $raw");

      /// CLEAN JSON - Handle markdown code blocks if present
      String cleanJson = raw;
      if (cleanJson.contains("```json")) {
        cleanJson = cleanJson.split("```json")[1].split("```")[0];
      } else if (cleanJson.contains("```")) {
        cleanJson = cleanJson.split("```")[1].split("```")[0];
      }

      final Map<String, dynamic> jsonData = jsonDecode(cleanJson.trim());
      return AIPlantModel.fromJson(jsonData);

    } catch (e) {
      debugPrint("AI ERROR TAFSILOTI: $e");
      return null;
    }
  }

  static Future<AIDiseaseModel?> identifyDisease(List<Uint8List> imagesBytes) async {
    debugPrint("AI: Kasallikni aniqlash boshlandi... Rasmlar soni: ${imagesBytes.length}");
    
    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final prompt = """
Siz ekspert botanik va o'simliklar patologisiz. Taqdim etilgan rasmlar asosida o'simlikning holatini va undagi kasallikni aniq tahlil qiling.
Ma'lumotlarni FAQAT quyidagi JSON formatida va O'ZBEK TILIDA taqdim eting:

{
  "plant_name": "O'simlik nomi",
  "disease_name": "Kasallik nomi (agar sog'lom bo'lsa 'Sog'lom' deb yozing)",
  "symptoms": "Kasallik belgilari",
  "causes": "Kasallik sabablari",
  "solutions": ["Davolash usullari"],
  "prevention": ["Oldini olish choralari"],
  "treatment_medicine": "Tavsiya etiladigan dori",
  "medicine_preparation": "Dorini tayyorlash va qo'llash ko'rsatmasi",
  "confidence": 0.95
}

Muhim: Faqat JSON qaytaring. Agar rasmda o'simlik bo'lmasa, "plant_name": "Noma'lum" deb yozing.
""";

      final content = [
        Content.multi([
          TextPart(prompt),
          ...imagesBytes.map((bytes) => DataPart('image/jpeg', bytes)),
        ]),
      ];

      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) return null;

      String raw = response.text!.trim();
      String cleanJson = raw;
      if (cleanJson.contains("```json")) {
        cleanJson = cleanJson.split("```json")[1].split("```")[0];
      } else if (cleanJson.contains("```")) {
        cleanJson = cleanJson.split("```")[1].split("```")[0];
      }

      final Map<String, dynamic> jsonData = jsonDecode(cleanJson.trim());
      return AIDiseaseModel.fromJson(jsonData);

    } catch (e) {
      debugPrint("AI DISEASE ERROR: $e");
      return null;
    }
  }

  static Future<String?> getWateringAdvice(List<Map<String, dynamic>> plantData) async {
    debugPrint("AI: Sug'orish tahlili boshlandi...");
    
    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final now = DateTime.now().toString().split(' ')[0];
      final prompt = """
Sen "Bog'bon" degan o'simlik parvarish ilovasidagi AI yordamchisan. Foydalanuvchi sug'orish statistikasi ekranida turibdi.
Foydalanuvchi berayotgan ma'lumotlar asosida:
1. Har bir o'simlikning holatini tahlil qil (juda ko'p, juda kam, yoki normal sug'orilyaptimi)
2. Muammo borlar haqida ogohlantir (ildiz chirishi xavfi, qurib qolish xavfi, kechikkan sug'orishlar)
3. Keyingi 3–5 kun uchun amaliy maslahat ber

Qisqa va do'stona yoz. Texnik atamalardan qoching. Javobni 3–5 gapdan oshirma.
Bugungi sana: $now

Foydalanuvchi ma'lumotlari:
$plantData
""";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text?.trim();
    } catch (e) {
      debugPrint("AI WATERING ADVICE ERROR: $e");
      return null;
    }
  }
}
