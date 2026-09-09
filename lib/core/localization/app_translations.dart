import 'package:get/get.dart';

/// GetX translations for the app. Locale is picked automatically from the
/// device (see [Get.deviceLocale] wiring in `app.dart`); English is the
/// fallback for any system language other than English/Vietnamese.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': _en,
    'vi_VN': _vi,
    'es_ES': _es,
    'pt_BR': _pt,
    'fr_FR': _fr,
    'de_DE': _de,
    'id_ID': _id,
    'ja_JP': _ja,
    'ko_KR': _ko,
    'zh_CN': _zh,
  };

  static const _en = {
    // Home screen
    'home_settings_tooltip': 'Settings',
    'home_daily_reward_tooltip': 'Daily Reward',
    'home_classic_game': 'Classic Game',
    'home_journey': 'Journey',
    'home_collection': 'Collection',
    'home_leaderboard': 'Leaderboard',

    // Onboarding dialog
    'onboarding_step1_title': 'DRAG THE BLOCK',
    'onboarding_step1_desc':
        'Drag a block from the tray onto the board to place it.',
    'onboarding_step2_title': 'COMPLETE A LINE',
    'onboarding_step2_desc':
        'Fill an entire row or column to clear it and score points.',
    'onboarding_step3_title': 'CLEAR THE BOARD',
    'onboarding_step3_desc':
        'Clear every cell at once for a Perfect Clear bonus!',
    'onboarding_next': 'Next',
    'onboarding_lets_play': "Let's Play",

    // Force update dialog
    'force_update_title': 'Update Required',
    'force_update_message':
        'A new version of this app is available. Please update to continue playing.',
    'force_update_button': 'Update Now',

    // Collection screen
    'collection_title': 'Spring Garden',
    'collection_progress_label': 'Spring Garden @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Daily Reward',
    'daily_reward_claim': 'Claim',
    'daily_reward_claimed': 'Claimed',
    'daily_reward_close': 'Close',
    'daily_reward_day_label': 'Day @day',
    'daily_reward_day1': '50 coins',
    'daily_reward_day2': '100 coins',
    'daily_reward_day3': 'Fragment I',
    'daily_reward_day4': '150 coins',
    'daily_reward_day5': 'Fragment II',
    'daily_reward_day6': '250 coins',
    'daily_reward_day7': 'Premium piece',

    // Game view
    'game_title': 'Classic Game',
    'game_back_tooltip': 'Back',

    // Game over dialog
    'game_over_title': 'Game Over',
    'game_over_score': 'Score: @score',
    'game_over_best': 'Best: @score',
    'game_over_watch_ad': 'Watch Ad & Continue',
    'game_over_new_game': 'New Game',
    'game_over_home': 'Home',

    // Level complete dialog
    'level_complete_title': 'Level Complete!',
    'level_complete_score': 'Score: @score',
    'level_complete_journey': 'Journey',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold points!',
    'perfect_clear_text': 'PERFECT!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Score',
    'best_label': 'Best',

    // Leaderboard
    'leaderboard_title': 'Leaderboard',
    'leaderboard_no_scores': 'No scores yet',
    'leaderboard_my_rank': 'Your rank: #@rank — @score',
    'leaderboard_player_fallback': 'Player',

    // Settings
    'settings_title': 'Settings',
    'settings_sound': 'Sound',
    'settings_music': 'Music',
    'settings_haptic': 'Haptic',
    'settings_nickname': 'Nickname',
    'settings_nickname_not_set': 'Not set',
    'settings_notifications': 'Notifications',
    'settings_restore_purchase': 'Restore Purchase',
    'settings_remove_ads': 'Remove Ads',
    'settings_rate_us': 'Rate Us',
    'settings_privacy_policy': 'Privacy Policy',
    'settings_terms': 'Terms',
    'settings_nickname_hint': 'Enter a nickname',
    'settings_save': 'Save',
  };

  static const _vi = {
    // Home screen
    'home_settings_tooltip': 'Cài đặt',
    'home_daily_reward_tooltip': 'Quà hàng ngày',
    'home_classic_game': 'Chơi Cổ Điển',
    'home_journey': 'Hành Trình',
    'home_collection': 'Bộ Sưu Tập',
    'home_leaderboard': 'Bảng Xếp Hạng',

    // Onboarding dialog
    'onboarding_step1_title': 'KÉO KHỐI',
    'onboarding_step1_desc':
        'Kéo một khối từ khay xuống bàn cờ để đặt nó vào chỗ trống.',
    'onboarding_step2_title': 'LẤP ĐẦY MỘT HÀNG',
    'onboarding_step2_desc':
        'Lấp đầy trọn một hàng hoặc cột để xóa nó và ghi điểm.',
    'onboarding_step3_title': 'DỌN SẠCH BÀN CỜ',
    'onboarding_step3_desc':
        'Dọn sạch toàn bộ ô cùng lúc để nhận thưởng Perfect Clear!',
    'onboarding_next': 'Tiếp theo',
    'onboarding_lets_play': 'Chơi ngay',

    // Force update dialog
    'force_update_title': 'Cần cập nhật',
    'force_update_message':
        'Đã có phiên bản mới của ứng dụng. Vui lòng cập nhật để tiếp tục chơi.',
    'force_update_button': 'Cập nhật ngay',

    // Collection screen
    'collection_title': 'Vườn Xuân',
    'collection_progress_label': 'Vườn Xuân @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Quà Hàng Ngày',
    'daily_reward_claim': 'Nhận quà',
    'daily_reward_claimed': 'Đã nhận',
    'daily_reward_close': 'Đóng',
    'daily_reward_day_label': 'Ngày @day',
    'daily_reward_day1': '50 xu',
    'daily_reward_day2': '100 xu',
    'daily_reward_day3': 'Mảnh ghép I',
    'daily_reward_day4': '150 xu',
    'daily_reward_day5': 'Mảnh ghép II',
    'daily_reward_day6': '250 xu',
    'daily_reward_day7': 'Mảnh ghép cao cấp',

    // Game view
    'game_title': 'Chơi Cổ Điển',
    'game_back_tooltip': 'Quay lại',

    // Game over dialog
    'game_over_title': 'Kết Thúc Ván',
    'game_over_score': 'Điểm: @score',
    'game_over_best': 'Kỷ lục: @score',
    'game_over_watch_ad': 'Xem QC để chơi tiếp',
    'game_over_new_game': 'Ván mới',
    'game_over_home': 'Trang chủ',

    // Level complete dialog
    'level_complete_title': 'Hoàn Thành Màn!',
    'level_complete_score': 'Điểm: @score',
    'level_complete_journey': 'Hành trình',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold điểm!',
    'perfect_clear_text': 'HOÀN HẢO!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Điểm',
    'best_label': 'Kỷ lục',

    // Leaderboard
    'leaderboard_title': 'Bảng Xếp Hạng',
    'leaderboard_no_scores': 'Chưa có điểm nào',
    'leaderboard_my_rank': 'Hạng của bạn: #@rank — @score điểm',
    'leaderboard_player_fallback': 'Người chơi',

    // Settings
    'settings_title': 'Cài Đặt',
    'settings_sound': 'Âm thanh',
    'settings_music': 'Nhạc nền',
    'settings_haptic': 'Rung',
    'settings_nickname': 'Biệt danh',
    'settings_nickname_not_set': 'Chưa đặt',
    'settings_notifications': 'Thông báo',
    'settings_restore_purchase': 'Khôi phục giao dịch',
    'settings_remove_ads': 'Xóa quảng cáo',
    'settings_rate_us': 'Đánh giá ứng dụng',
    'settings_privacy_policy': 'Chính sách bảo mật',
    'settings_terms': 'Điều khoản',
    'settings_nickname_hint': 'Nhập biệt danh của bạn',
    'settings_save': 'Lưu',
  };

  static const _es = {
    // Home screen
    'home_settings_tooltip': 'Ajustes',
    'home_daily_reward_tooltip': 'Recompensa diaria',
    'home_classic_game': 'Juego Clásico',
    'home_journey': 'Aventura',
    'home_collection': 'Colección',
    'home_leaderboard': 'Clasificación',

    // Onboarding dialog
    'onboarding_step1_title': 'ARRASTRA EL BLOQUE',
    'onboarding_step1_desc':
        'Arrastra un bloque de la bandeja al tablero para colocarlo.',
    'onboarding_step2_title': 'COMPLETA UNA LÍNEA',
    'onboarding_step2_desc':
        'Llena una fila o columna entera para eliminarla y sumar puntos.',
    'onboarding_step3_title': 'LIMPIA EL TABLERO',
    'onboarding_step3_desc':
        '¡Despeja todas las casillas a la vez para conseguir un bono Perfect Clear!',
    'onboarding_next': 'Siguiente',
    'onboarding_lets_play': '¡A jugar!',

    // Force update dialog
    'force_update_title': 'Actualización requerida',
    'force_update_message':
        'Hay una nueva versión de la app disponible. Actualiza para seguir jugando.',
    'force_update_button': 'Actualizar ahora',

    // Collection screen
    'collection_title': 'Jardín de Primavera',
    'collection_progress_label': 'Jardín de Primavera @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Recompensa Diaria',
    'daily_reward_claim': 'Reclamar',
    'daily_reward_claimed': 'Reclamado',
    'daily_reward_close': 'Cerrar',
    'daily_reward_day_label': 'Día @day',
    'daily_reward_day1': '50 monedas',
    'daily_reward_day2': '100 monedas',
    'daily_reward_day3': 'Fragmento I',
    'daily_reward_day4': '150 monedas',
    'daily_reward_day5': 'Fragmento II',
    'daily_reward_day6': '250 monedas',
    'daily_reward_day7': 'Pieza premium',

    // Game view
    'game_title': 'Juego Clásico',
    'game_back_tooltip': 'Atrás',

    // Game over dialog
    'game_over_title': 'Fin de la Partida',
    'game_over_score': 'Puntuación: @score',
    'game_over_best': 'Récord: @score',
    'game_over_watch_ad': 'Ver anuncio y continuar',
    'game_over_new_game': 'Nueva partida',
    'game_over_home': 'Inicio',

    // Level complete dialog
    'level_complete_title': '¡Nivel Completado!',
    'level_complete_score': 'Puntuación: @score',
    'level_complete_journey': 'Aventura',

    // Milestone toast / perfect clear
    'milestone_toast_points': '¡@threshold puntos!',
    'perfect_clear_text': '¡PERFECTO!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Puntos',
    'best_label': 'Récord',

    // Leaderboard
    'leaderboard_title': 'Clasificación',
    'leaderboard_no_scores': 'Aún no hay puntuaciones',
    'leaderboard_my_rank': 'Tu puesto: #@rank — @score',
    'leaderboard_player_fallback': 'Jugador',

    // Settings
    'settings_title': 'Ajustes',
    'settings_sound': 'Sonido',
    'settings_music': 'Música',
    'settings_haptic': 'Vibración',
    'settings_nickname': 'Apodo',
    'settings_nickname_not_set': 'Sin definir',
    'settings_notifications': 'Notificaciones',
    'settings_restore_purchase': 'Restaurar compra',
    'settings_remove_ads': 'Quitar anuncios',
    'settings_rate_us': 'Califícanos',
    'settings_privacy_policy': 'Política de privacidad',
    'settings_terms': 'Términos',
    'settings_nickname_hint': 'Escribe un apodo',
    'settings_save': 'Guardar',
  };

  static const _pt = {
    // Home screen
    'home_settings_tooltip': 'Configurações',
    'home_daily_reward_tooltip': 'Recompensa diária',
    'home_classic_game': 'Jogo Clássico',
    'home_journey': 'Jornada',
    'home_collection': 'Coleção',
    'home_leaderboard': 'Ranking',

    // Onboarding dialog
    'onboarding_step1_title': 'ARRASTE O BLOCO',
    'onboarding_step1_desc':
        'Arraste um bloco da bandeja até o tabuleiro para posicioná-lo.',
    'onboarding_step2_title': 'COMPLETE UMA LINHA',
    'onboarding_step2_desc':
        'Preencha uma linha ou coluna inteira para eliminá-la e ganhar pontos.',
    'onboarding_step3_title': 'LIMPE O TABULEIRO',
    'onboarding_step3_desc':
        'Limpe todas as células de uma vez e ganhe um bônus Perfect Clear!',
    'onboarding_next': 'Próximo',
    'onboarding_lets_play': 'Vamos jogar',

    // Force update dialog
    'force_update_title': 'Atualização necessária',
    'force_update_message':
        'Uma nova versão do app está disponível. Atualize para continuar jogando.',
    'force_update_button': 'Atualizar agora',

    // Collection screen
    'collection_title': 'Jardim de Primavera',
    'collection_progress_label': 'Jardim de Primavera @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Recompensa Diária',
    'daily_reward_claim': 'Resgatar',
    'daily_reward_claimed': 'Resgatado',
    'daily_reward_close': 'Fechar',
    'daily_reward_day_label': 'Dia @day',
    'daily_reward_day1': '50 moedas',
    'daily_reward_day2': '100 moedas',
    'daily_reward_day3': 'Fragmento I',
    'daily_reward_day4': '150 moedas',
    'daily_reward_day5': 'Fragmento II',
    'daily_reward_day6': '250 moedas',
    'daily_reward_day7': 'Peça premium',

    // Game view
    'game_title': 'Jogo Clássico',
    'game_back_tooltip': 'Voltar',

    // Game over dialog
    'game_over_title': 'Fim de Jogo',
    'game_over_score': 'Pontuação: @score',
    'game_over_best': 'Recorde: @score',
    'game_over_watch_ad': 'Assistir anúncio e continuar',
    'game_over_new_game': 'Novo jogo',
    'game_over_home': 'Início',

    // Level complete dialog
    'level_complete_title': 'Fase Concluída!',
    'level_complete_score': 'Pontuação: @score',
    'level_complete_journey': 'Jornada',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold pontos!',
    'perfect_clear_text': 'PERFEITO!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Pontos',
    'best_label': 'Recorde',

    // Leaderboard
    'leaderboard_title': 'Ranking',
    'leaderboard_no_scores': 'Ainda sem pontuações',
    'leaderboard_my_rank': 'Sua posição: #@rank — @score',
    'leaderboard_player_fallback': 'Jogador',

    // Settings
    'settings_title': 'Configurações',
    'settings_sound': 'Som',
    'settings_music': 'Música',
    'settings_haptic': 'Vibração',
    'settings_nickname': 'Apelido',
    'settings_nickname_not_set': 'Não definido',
    'settings_notifications': 'Notificações',
    'settings_restore_purchase': 'Restaurar compra',
    'settings_remove_ads': 'Remover anúncios',
    'settings_rate_us': 'Avalie-nos',
    'settings_privacy_policy': 'Política de privacidade',
    'settings_terms': 'Termos',
    'settings_nickname_hint': 'Digite um apelido',
    'settings_save': 'Salvar',
  };

  static const _fr = {
    // Home screen
    'home_settings_tooltip': 'Paramètres',
    'home_daily_reward_tooltip': 'Récompense quotidienne',
    'home_classic_game': 'Jeu Classique',
    'home_journey': 'Aventure',
    'home_collection': 'Collection',
    'home_leaderboard': 'Classement',

    // Onboarding dialog
    'onboarding_step1_title': 'GLISSE LE BLOC',
    'onboarding_step1_desc':
        'Fais glisser un bloc du plateau vers la grille pour le placer.',
    'onboarding_step2_title': 'COMPLÈTE UNE LIGNE',
    'onboarding_step2_desc':
        'Remplis entièrement une ligne ou une colonne pour l\'effacer et marquer des points.',
    'onboarding_step3_title': 'VIDE LA GRILLE',
    'onboarding_step3_desc':
        'Vide toutes les cases d\'un coup pour obtenir un bonus Perfect Clear !',
    'onboarding_next': 'Suivant',
    'onboarding_lets_play': "C'est parti",

    // Force update dialog
    'force_update_title': 'Mise à jour requise',
    'force_update_message':
        'Une nouvelle version de l\'application est disponible. Mets à jour pour continuer à jouer.',
    'force_update_button': 'Mettre à jour',

    // Collection screen
    'collection_title': 'Jardin de Printemps',
    'collection_progress_label': 'Jardin de Printemps @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Récompense Quotidienne',
    'daily_reward_claim': 'Réclamer',
    'daily_reward_claimed': 'Réclamé',
    'daily_reward_close': 'Fermer',
    'daily_reward_day_label': 'Jour @day',
    'daily_reward_day1': '50 pièces',
    'daily_reward_day2': '100 pièces',
    'daily_reward_day3': 'Fragment I',
    'daily_reward_day4': '150 pièces',
    'daily_reward_day5': 'Fragment II',
    'daily_reward_day6': '250 pièces',
    'daily_reward_day7': 'Pièce premium',

    // Game view
    'game_title': 'Jeu Classique',
    'game_back_tooltip': 'Retour',

    // Game over dialog
    'game_over_title': 'Partie Terminée',
    'game_over_score': 'Score : @score',
    'game_over_best': 'Meilleur score : @score',
    'game_over_watch_ad': 'Regarder une pub et continuer',
    'game_over_new_game': 'Nouvelle partie',
    'game_over_home': 'Accueil',

    // Level complete dialog
    'level_complete_title': 'Niveau Terminé !',
    'level_complete_score': 'Score : @score',
    'level_complete_journey': 'Aventure',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold points !',
    'perfect_clear_text': 'PARFAIT !',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Score',
    'best_label': 'Meilleur',

    // Leaderboard
    'leaderboard_title': 'Classement',
    'leaderboard_no_scores': 'Aucun score pour l\'instant',
    'leaderboard_my_rank': 'Ton rang : #@rank — @score',
    'leaderboard_player_fallback': 'Joueur',

    // Settings
    'settings_title': 'Paramètres',
    'settings_sound': 'Son',
    'settings_music': 'Musique',
    'settings_haptic': 'Vibration',
    'settings_nickname': 'Pseudo',
    'settings_nickname_not_set': 'Non défini',
    'settings_notifications': 'Notifications',
    'settings_restore_purchase': "Restaurer l'achat",
    'settings_remove_ads': 'Supprimer les pubs',
    'settings_rate_us': 'Notez-nous',
    'settings_privacy_policy': 'Politique de confidentialité',
    'settings_terms': 'Conditions',
    'settings_nickname_hint': 'Entre un pseudo',
    'settings_save': 'Enregistrer',
  };

  static const _de = {
    // Home screen
    'home_settings_tooltip': 'Einstellungen',
    'home_daily_reward_tooltip': 'Tägliche Belohnung',
    'home_classic_game': 'Klassisches Spiel',
    'home_journey': 'Reise',
    'home_collection': 'Sammlung',
    'home_leaderboard': 'Bestenliste',

    // Onboarding dialog
    'onboarding_step1_title': 'BLOCK ZIEHEN',
    'onboarding_step1_desc':
        'Ziehe einen Block aus dem Fach auf das Spielfeld, um ihn zu platzieren.',
    'onboarding_step2_title': 'REIHE VERVOLLSTÄNDIGEN',
    'onboarding_step2_desc':
        'Fülle eine ganze Reihe oder Spalte, um sie zu löschen und Punkte zu sammeln.',
    'onboarding_step3_title': 'FELD LEEREN',
    'onboarding_step3_desc':
        'Räume alle Felder auf einmal frei für einen Perfect-Clear-Bonus!',
    'onboarding_next': 'Weiter',
    'onboarding_lets_play': "Los geht's",

    // Force update dialog
    'force_update_title': 'Update erforderlich',
    'force_update_message':
        'Eine neue Version der App ist verfügbar. Bitte aktualisiere, um weiterzuspielen.',
    'force_update_button': 'Jetzt aktualisieren',

    // Collection screen
    'collection_title': 'Frühlingsgarten',
    'collection_progress_label': 'Frühlingsgarten @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Tägliche Belohnung',
    'daily_reward_claim': 'Abholen',
    'daily_reward_claimed': 'Abgeholt',
    'daily_reward_close': 'Schließen',
    'daily_reward_day_label': 'Tag @day',
    'daily_reward_day1': '50 Münzen',
    'daily_reward_day2': '100 Münzen',
    'daily_reward_day3': 'Fragment I',
    'daily_reward_day4': '150 Münzen',
    'daily_reward_day5': 'Fragment II',
    'daily_reward_day6': '250 Münzen',
    'daily_reward_day7': 'Premium-Teil',

    // Game view
    'game_title': 'Klassisches Spiel',
    'game_back_tooltip': 'Zurück',

    // Game over dialog
    'game_over_title': 'Spiel vorbei',
    'game_over_score': 'Punkte: @score',
    'game_over_best': 'Bestwert: @score',
    'game_over_watch_ad': 'Werbung ansehen & weiterspielen',
    'game_over_new_game': 'Neues Spiel',
    'game_over_home': 'Start',

    // Level complete dialog
    'level_complete_title': 'Level geschafft!',
    'level_complete_score': 'Punkte: @score',
    'level_complete_journey': 'Reise',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold Punkte!',
    'perfect_clear_text': 'PERFEKT!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Punkte',
    'best_label': 'Bestwert',

    // Leaderboard
    'leaderboard_title': 'Bestenliste',
    'leaderboard_no_scores': 'Noch keine Punkte',
    'leaderboard_my_rank': 'Dein Rang: #@rank — @score',
    'leaderboard_player_fallback': 'Spieler',

    // Settings
    'settings_title': 'Einstellungen',
    'settings_sound': 'Ton',
    'settings_music': 'Musik',
    'settings_haptic': 'Vibration',
    'settings_nickname': 'Spitzname',
    'settings_nickname_not_set': 'Nicht festgelegt',
    'settings_notifications': 'Benachrichtigungen',
    'settings_restore_purchase': 'Kauf wiederherstellen',
    'settings_remove_ads': 'Werbung entfernen',
    'settings_rate_us': 'Bewerte uns',
    'settings_privacy_policy': 'Datenschutzerklärung',
    'settings_terms': 'Nutzungsbedingungen',
    'settings_nickname_hint': 'Gib einen Spitznamen ein',
    'settings_save': 'Speichern',
  };

  static const _id = {
    // Home screen
    'home_settings_tooltip': 'Pengaturan',
    'home_daily_reward_tooltip': 'Hadiah Harian',
    'home_classic_game': 'Permainan Klasik',
    'home_journey': 'Perjalanan',
    'home_collection': 'Koleksi',
    'home_leaderboard': 'Peringkat',

    // Onboarding dialog
    'onboarding_step1_title': 'GESER BLOK',
    'onboarding_step1_desc':
        'Geser blok dari baki ke papan untuk menempatkannya.',
    'onboarding_step2_title': 'LENGKAPI SATU BARIS',
    'onboarding_step2_desc':
        'Isi penuh satu baris atau kolom untuk menghapusnya dan mendapat poin.',
    'onboarding_step3_title': 'BERSIHKAN PAPAN',
    'onboarding_step3_desc':
        'Bersihkan semua kotak sekaligus untuk mendapat bonus Perfect Clear!',
    'onboarding_next': 'Lanjut',
    'onboarding_lets_play': 'Ayo Main',

    // Force update dialog
    'force_update_title': 'Perlu Pembaruan',
    'force_update_message':
        'Versi baru aplikasi ini sudah tersedia. Perbarui untuk terus bermain.',
    'force_update_button': 'Perbarui Sekarang',

    // Collection screen
    'collection_title': 'Taman Musim Semi',
    'collection_progress_label': 'Taman Musim Semi @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'Hadiah Harian',
    'daily_reward_claim': 'Klaim',
    'daily_reward_claimed': 'Diklaim',
    'daily_reward_close': 'Tutup',
    'daily_reward_day_label': 'Hari @day',
    'daily_reward_day1': '50 koin',
    'daily_reward_day2': '100 koin',
    'daily_reward_day3': 'Fragmen I',
    'daily_reward_day4': '150 koin',
    'daily_reward_day5': 'Fragmen II',
    'daily_reward_day6': '250 koin',
    'daily_reward_day7': 'Keping premium',

    // Game view
    'game_title': 'Permainan Klasik',
    'game_back_tooltip': 'Kembali',

    // Game over dialog
    'game_over_title': 'Permainan Selesai',
    'game_over_score': 'Skor: @score',
    'game_over_best': 'Rekor: @score',
    'game_over_watch_ad': 'Tonton Iklan & Lanjut',
    'game_over_new_game': 'Main Baru',
    'game_over_home': 'Beranda',

    // Level complete dialog
    'level_complete_title': 'Level Selesai!',
    'level_complete_score': 'Skor: @score',
    'level_complete_journey': 'Perjalanan',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold poin!',
    'perfect_clear_text': 'SEMPURNA!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'Skor',
    'best_label': 'Rekor',

    // Leaderboard
    'leaderboard_title': 'Peringkat',
    'leaderboard_no_scores': 'Belum ada skor',
    'leaderboard_my_rank': 'Peringkatmu: #@rank — @score',
    'leaderboard_player_fallback': 'Pemain',

    // Settings
    'settings_title': 'Pengaturan',
    'settings_sound': 'Suara',
    'settings_music': 'Musik',
    'settings_haptic': 'Getaran',
    'settings_nickname': 'Nama Panggilan',
    'settings_nickname_not_set': 'Belum diatur',
    'settings_notifications': 'Notifikasi',
    'settings_restore_purchase': 'Pulihkan Pembelian',
    'settings_remove_ads': 'Hapus Iklan',
    'settings_rate_us': 'Beri Nilai',
    'settings_privacy_policy': 'Kebijakan Privasi',
    'settings_terms': 'Ketentuan',
    'settings_nickname_hint': 'Masukkan nama panggilan',
    'settings_save': 'Simpan',
  };

  static const _ja = {
    // Home screen
    'home_settings_tooltip': '設定',
    'home_daily_reward_tooltip': 'デイリー報酬',
    'home_classic_game': 'クラシックゲーム',
    'home_journey': 'ジャーニー',
    'home_collection': 'コレクション',
    'home_leaderboard': 'ランキング',

    // Onboarding dialog
    'onboarding_step1_title': 'ブロックをドラッグ',
    'onboarding_step1_desc': 'トレイのブロックをボードにドラッグして配置しよう。',
    'onboarding_step2_title': 'ラインを揃えよう',
    'onboarding_step2_desc': '横一列または縦一列を埋めると消えてポイントが入る。',
    'onboarding_step3_title': 'ボードを一掃',
    'onboarding_step3_desc': '一度に全てのマスを消すとパーフェクトクリアボーナス！',
    'onboarding_next': '次へ',
    'onboarding_lets_play': 'プレイ開始',

    // Force update dialog
    'force_update_title': 'アップデートが必要です',
    'force_update_message': '新しいバージョンが利用可能です。続けてプレイするにはアップデートしてください。',
    'force_update_button': '今すぐアップデート',

    // Collection screen
    'collection_title': '春の庭園',
    'collection_progress_label': '春の庭園 @unlocked/@total',

    // Daily reward
    'daily_reward_title': 'デイリー報酬',
    'daily_reward_claim': '受け取る',
    'daily_reward_claimed': '受取済み',
    'daily_reward_close': '閉じる',
    'daily_reward_day_label': '@day日目',
    'daily_reward_day1': 'コイン50枚',
    'daily_reward_day2': 'コイン100枚',
    'daily_reward_day3': 'フラグメントI',
    'daily_reward_day4': 'コイン150枚',
    'daily_reward_day5': 'フラグメントII',
    'daily_reward_day6': 'コイン250枚',
    'daily_reward_day7': 'プレミアムピース',

    // Game view
    'game_title': 'クラシックゲーム',
    'game_back_tooltip': '戻る',

    // Game over dialog
    'game_over_title': 'ゲームオーバー',
    'game_over_score': 'スコア：@score',
    'game_over_best': 'ベスト：@score',
    'game_over_watch_ad': '広告を見て続ける',
    'game_over_new_game': 'もう一度プレイ',
    'game_over_home': 'ホーム',

    // Level complete dialog
    'level_complete_title': 'レベルクリア！',
    'level_complete_score': 'スコア：@score',
    'level_complete_journey': 'ジャーニー',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold ポイント！',
    'perfect_clear_text': 'パーフェクト！',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': 'スコア',
    'best_label': 'ベスト',

    // Leaderboard
    'leaderboard_title': 'ランキング',
    'leaderboard_no_scores': 'まだスコアがありません',
    'leaderboard_my_rank': 'あなたの順位：#@rank — @score',
    'leaderboard_player_fallback': 'プレイヤー',

    // Settings
    'settings_title': '設定',
    'settings_sound': 'サウンド',
    'settings_music': '音楽',
    'settings_haptic': '振動',
    'settings_nickname': 'ニックネーム',
    'settings_nickname_not_set': '未設定',
    'settings_notifications': '通知',
    'settings_restore_purchase': '購入を復元',
    'settings_remove_ads': '広告を削除',
    'settings_rate_us': '評価する',
    'settings_privacy_policy': 'プライバシーポリシー',
    'settings_terms': '利用規約',
    'settings_nickname_hint': 'ニックネームを入力',
    'settings_save': '保存',
  };

  static const _ko = {
    // Home screen
    'home_settings_tooltip': '설정',
    'home_daily_reward_tooltip': '일일 보상',
    'home_classic_game': '클래식 게임',
    'home_journey': '여정',
    'home_collection': '컬렉션',
    'home_leaderboard': '리더보드',

    // Onboarding dialog
    'onboarding_step1_title': '블록을 드래그하세요',
    'onboarding_step1_desc': '트레이의 블록을 보드로 드래그해서 배치하세요.',
    'onboarding_step2_title': '한 줄을 완성하세요',
    'onboarding_step2_desc': '한 줄이나 한 칸을 가득 채우면 사라지고 점수를 얻어요.',
    'onboarding_step3_title': '보드를 깨끗이 비우세요',
    'onboarding_step3_desc': '모든 칸을 한 번에 비우면 퍼펙트 클리어 보너스!',
    'onboarding_next': '다음',
    'onboarding_lets_play': '시작하기',

    // Force update dialog
    'force_update_title': '업데이트 필요',
    'force_update_message': '새 버전이 출시되었어요. 계속 플레이하려면 업데이트해 주세요.',
    'force_update_button': '지금 업데이트',

    // Collection screen
    'collection_title': '봄의 정원',
    'collection_progress_label': '봄의 정원 @unlocked/@total',

    // Daily reward
    'daily_reward_title': '일일 보상',
    'daily_reward_claim': '받기',
    'daily_reward_claimed': '받음',
    'daily_reward_close': '닫기',
    'daily_reward_day_label': '@day일차',
    'daily_reward_day1': '코인 50개',
    'daily_reward_day2': '코인 100개',
    'daily_reward_day3': '조각 I',
    'daily_reward_day4': '코인 150개',
    'daily_reward_day5': '조각 II',
    'daily_reward_day6': '코인 250개',
    'daily_reward_day7': '프리미엄 조각',

    // Game view
    'game_title': '클래식 게임',
    'game_back_tooltip': '뒤로',

    // Game over dialog
    'game_over_title': '게임 오버',
    'game_over_score': '점수: @score',
    'game_over_best': '최고 기록: @score',
    'game_over_watch_ad': '광고 보고 계속하기',
    'game_over_new_game': '새 게임',
    'game_over_home': '홈',

    // Level complete dialog
    'level_complete_title': '레벨 완료!',
    'level_complete_score': '점수: @score',
    'level_complete_journey': '여정',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold점!',
    'perfect_clear_text': '퍼펙트!',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': '점수',
    'best_label': '최고 기록',

    // Leaderboard
    'leaderboard_title': '리더보드',
    'leaderboard_no_scores': '아직 점수가 없어요',
    'leaderboard_my_rank': '내 순위: #@rank — @score',
    'leaderboard_player_fallback': '플레이어',

    // Settings
    'settings_title': '설정',
    'settings_sound': '효과음',
    'settings_music': '음악',
    'settings_haptic': '진동',
    'settings_nickname': '닉네임',
    'settings_nickname_not_set': '설정 안 됨',
    'settings_notifications': '알림',
    'settings_restore_purchase': '구매 복원',
    'settings_remove_ads': '광고 제거',
    'settings_rate_us': '평가하기',
    'settings_privacy_policy': '개인정보 처리방침',
    'settings_terms': '이용약관',
    'settings_nickname_hint': '닉네임을 입력하세요',
    'settings_save': '저장',
  };

  static const _zh = {
    // Home screen
    'home_settings_tooltip': '设置',
    'home_daily_reward_tooltip': '每日奖励',
    'home_classic_game': '经典模式',
    'home_journey': '闯关模式',
    'home_collection': '收藏',
    'home_leaderboard': '排行榜',

    // Onboarding dialog
    'onboarding_step1_title': '拖动方块',
    'onboarding_step1_desc': '把托盘中的方块拖到棋盘上放置。',
    'onboarding_step2_title': '连成一行',
    'onboarding_step2_desc': '填满整行或整列即可消除并得分。',
    'onboarding_step3_title': '清空棋盘',
    'onboarding_step3_desc': '一次性清空所有格子，即可获得完美清空奖励！',
    'onboarding_next': '下一步',
    'onboarding_lets_play': '开始游戏',

    // Force update dialog
    'force_update_title': '需要更新',
    'force_update_message': '发现新版本，请更新后继续游戏。',
    'force_update_button': '立即更新',

    // Collection screen
    'collection_title': '春日花园',
    'collection_progress_label': '春日花园 @unlocked/@total',

    // Daily reward
    'daily_reward_title': '每日奖励',
    'daily_reward_claim': '领取',
    'daily_reward_claimed': '已领取',
    'daily_reward_close': '关闭',
    'daily_reward_day_label': '第@day天',
    'daily_reward_day1': '50 金币',
    'daily_reward_day2': '100 金币',
    'daily_reward_day3': '碎片 I',
    'daily_reward_day4': '150 金币',
    'daily_reward_day5': '碎片 II',
    'daily_reward_day6': '250 金币',
    'daily_reward_day7': '高级方块',

    // Game view
    'game_title': '经典模式',
    'game_back_tooltip': '返回',

    // Game over dialog
    'game_over_title': '游戏结束',
    'game_over_score': '得分：@score',
    'game_over_best': '最高分：@score',
    'game_over_watch_ad': '观看广告继续',
    'game_over_new_game': '重新开始',
    'game_over_home': '主页',

    // Level complete dialog
    'level_complete_title': '关卡完成！',
    'level_complete_score': '得分：@score',
    'level_complete_journey': '闯关模式',

    // Milestone toast / perfect clear
    'milestone_toast_points': '@threshold 分！',
    'perfect_clear_text': '完美！',

    // Combo / score widgets
    'combo_label': 'COMBO x@combo',
    'score_label': '得分',
    'best_label': '最高分',

    // Leaderboard
    'leaderboard_title': '排行榜',
    'leaderboard_no_scores': '暂无分数',
    'leaderboard_my_rank': '你的排名：#@rank — @score',
    'leaderboard_player_fallback': '玩家',

    // Settings
    'settings_title': '设置',
    'settings_sound': '音效',
    'settings_music': '音乐',
    'settings_haptic': '震动',
    'settings_nickname': '昵称',
    'settings_nickname_not_set': '未设置',
    'settings_notifications': '通知',
    'settings_restore_purchase': '恢复购买',
    'settings_remove_ads': '移除广告',
    'settings_rate_us': '给我们评分',
    'settings_privacy_policy': '隐私政策',
    'settings_terms': '服务条款',
    'settings_nickname_hint': '输入昵称',
    'settings_save': '保存',
  };
}
