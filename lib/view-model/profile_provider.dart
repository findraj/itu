/// ProfileProvider - Poskytovatel stavu a funkcnosti pre spravu uzivatelskych profilov.
///
///Autor: Filip Botlo (xbotlo01)
/// Tato trieda spravuje uzivatelsky profil a interaguje s ProfileAPI
/// pre ziskavanie, aktualizaciu a manipulaciu s profilovymi datami.
///
/// ## Funkcie
/// - Umoznuje ziskavat a aktualizovat uzivatelsky profil.
/// - Poskytuje metody pre manipulaciu s bilanciou a vernostnymi bodmi uzivatela.
/// - Spravuje stav, ci uzivatel pouziva vernostne odmeny alebo edituje rezervacie.
///
/// ## Pouzitie
/// Pouziva sa v spojeni s `Provider` balickom pre spristupnenie dat
/// o uzivatelskom profile cez celej aplikacii.
import 'package:flutter/foundation.dart';
import 'package:vyperto/api/profile_api.dart';
import 'package:vyperto/model/profile.dart';
import 'package:vyperto/model/reservation.dart';

class ProfileProvider extends ChangeNotifier {
  late ProfileAPI _profileApi;

  late Profile _profile;

  ProfileProvider() {
    _profileApi = ProfileAPI();
    _profile = Profile(
        meno: "", priezvisko: "", email: "", zostatok: 0, body: 0, miesto: "");
    fetchProfile(_profile);
  }

  Profile get profile => _profile;

  Future<void> providerInsertProfile(Profile profile) async {
    try {
      await _profileApi.insertProfile(profile);
      await fetchProfile(profile);
    } catch (e) {
      print('Error inserting profile: $e');
      rethrow;
    }
  }

  Future<void> fetchProfile(Profile profile) async {
    try {
      _profile = await _profileApi.getProfile(_profile);
      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> updateProfileBalance(Profile profile, int amount) async {
    try {
      _profile.zostatok += amount;
      await _profileApi.manipulateBalance(profile, amount);
      notifyListeners();
    } catch (e) {
      print('Error updating balance: $e');
      rethrow;
    }
  }

  Future<void> updateProfilePoints(Profile profile, int amount) async {
    try {
      _profile.body += amount;
      await _profileApi.manipulateBalance(profile, amount);
      notifyListeners();
    } catch (e) {
      print('Error updating balance: $e');
      rethrow;
    }
  }

  bool _isUsingReward = false;
  bool get isUsingReward => _isUsingReward;
  bool _isEditingReservation = false;
  bool get isEditingReservation => _isEditingReservation;

  void setUsingReward(bool value) {
    _isUsingReward = value;
    notifyListeners();
  }

  void setEditingReservation(bool value) {
    _isEditingReservation = value;
    notifyListeners();
  }

  Reservation _currentReservation = Reservation(
    machine: "",
    date: DateTime.now(),
    location: "",
    isPinVerified: 0,
    isExpired: 0,
    wasFree: 0,
  );
  Reservation get currentReservation => _currentReservation;

  void setCurrentReservation(Reservation reservation) {
    _currentReservation = reservation;
    notifyListeners();
  }
}
