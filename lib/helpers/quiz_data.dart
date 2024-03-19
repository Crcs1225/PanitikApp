import '../models/db_model.dart';

final List<List<Question>> questions = [
  [
    Question(
      workId: 1,
      question: "Ano ang pangalan ng mitikong ibon sa 'Ibong Adarna'?",
      choices: ["Ibong Adarna", "Haribon", "Maya", "Tikbalang"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Sino ang may akda ng 'Ibong Adarna'?",
      choices: [
        "Jose Rizal",
        "Francisco Balagtas",
        "Pedro Paterno",
        "Anonymous"
      ],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 1,
      question: "Anong kulay ang unang pakpak ng Ibong Adarna?",
      choices: ["Pula", "Berde", "Asul", "Puti"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang pamagat ng kaharian na pinamumunuan ni Haring Fernando sa 'Ibong Adarna'?",
      choices: [
        "Kaharian ng Berbanya",
        "Kaharian ng Lireo",
        "Kaharian ng Amihan",
        "Kaharian ng Enchancia"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Sino ang pinakabunso na prinsipe sa 'Ibong Adarna'?",
      choices: [
        "Prinsipe Alfonso",
        "Prinsipe Pedro",
        "Prinsipe Diego",
        "Prinsipe Juan"
      ],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 1,
      question: "Ano ang kapangyarihan ng awit ng Ibong Adarna ayon sa alamat?",
      choices: [
        "Pagpapagaling",
        "Paghahaginit",
        "Pagdadala ng Swerte",
        "Pang-aakit ng Tulog"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Saan natagpuan ni Don Juan ang Ibong Adarna?",
      choices: [
        "Bundok Tabor",
        "Bundok Mayon",
        "Bundok Arayat",
        "Bundok Makiling"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Ano ang ginamit ni Don Juan upang hulihin ang Ibong Adarna?",
      choices: [
        "Gintong Lambat",
        "Gintong Kulungan",
        "Pilak na Pana",
        "Gintong Mansanas"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      workId: 1,
      question: "Sino ang pinakamaganda sa mga anak ni Haring Fernando?",
      choices: ["Maria", "Leonora", "Donya Juana", "Donya Leonor"],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang ginawa ni Don Pedro upang taksilin ang kanyang mga kapatid?",
      choices: [
        "Pinatay Sila",
        "Iniwan Sila",
        "Nanakaw ang Kanilang Pera",
        "Ginawang Bato"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang ginawa ni Don Diego upang taksilin ang kanyang mga kapatid?",
      choices: [
        "Nagnakaw ng Bigay",
        "Nanakaw ng Kanilang Ginto",
        "Kumuha ng Lahat ng Karangalan",
        "Nagsalita Laban sa Kanila"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang ginawa ni Don Juan upang taksilin ang kanyang mga kapatid?",
      choices: [
        "Iniwan Sila",
        "Nanakaw ang Kanilang mga Kabayo",
        "Binalita ang Kanilang Mga Sekreto",
        "Pumatay Sa Kanila Habang Sila'y Natutulog"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question:
          "Sino ang tumulong kay Don Juan sa pagpapagaling kay Haring Fernando sa kanyang sakit?",
      choices: ["Ermitanyo", "Donya Maria", "Mangkukulam", "Salamangkero"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Ano ang lihim sa awit ng Ibong Adarna?",
      choices: [
        "Pitong Tono",
        "Pitong Kulay",
        "Pitong Saknong",
        "Pitong Salita"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang ginawa ni Don Juan upang mapapakanta ang Ibong Adarna?",
      choices: [
        "Sumayaw",
        "Magpatugtog ng Musika",
        "Magdasal",
        "Magtuktok sa mga Pakpak Nito"
      ],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang nangyari sa mga kapatid ni Don Juan nang kumanta ang Ibong Adarna?",
      choices: [
        "Natulog",
        "Naging Bato",
        "Sumayaw Nang Hindi Makontrol",
        "Nagkasakit"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question:
          "Ilang beses sinubukan ni Don Juan na hulihin ang Ibong Adarna?",
      choices: ["Tatlo", "Lima", "Pito", "Siyam"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question: "Ano ang pangalan ng kabayo ni Don Juan?",
      choices: ["Balong", "Alitaptap", "Sibulan", "Bituin"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 1,
      question:
          "Sino ang tumulong kay Don Juan nang siya'y magkasakit pagkatapos ng kanyang misyon?",
      choices: ["Ermitanyo", "Ibong Adarna", "Donya Maria", "Mangkukulam"],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 1,
      question:
          "Ano ang ginawa ni Don Juan matapos ibalik ang Ibong Adarna sa kanyang ama?",
      choices: [
        "Naging Hari",
        "Naging Pari",
        "Naging Magsasaka",
        "Iniwan ang Kaharian"
      ],
      correctAnswerIndex: 0,
    ),
    // Add more questions here...
  ],
  [
    //Questions for Florante and Laura
    Question(
      workId: 2,
      question: "Sino ang pangunahing karakter sa 'Florante at Laura'?",
      choices: ["Florante", "Laura", "Aladin", "Flerida"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang pangalan ng antagonist sa 'Florante at Laura'?",
      choices: ["Adolfo", "Aladin", "Flerida", "Duke Briseo"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang sumulat ng 'Florante at Laura'?",
      choices: [
        "Jose Rizal",
        "Francisco Balagtas",
        "Pedro Paterno",
        "Anonymous"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      workId: 2,
      question: "Ano ang pangalan ng ama ni Florante?",
      choices: [
        "Duke Briseo",
        "Haring Linceo",
        "Haring Linio",
        "Haring Linceus"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang pag-ibig na interes ni Florante?",
      choices: ["Laura", "Flerida", "Aladin", "Adolfo"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang pamagat ng kaharian na pinamumunuan ni Haring Linceo?",
      choices: [
        "Kaharian ng Albania",
        "Kaharian ng Berbanya",
        "Kaharian ng Lireo",
        "Kaharian ng Amihan"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang pangalan ng gubat kung saan ipinatapon si Florante?",
      choices: ["Crocus", "Dioskouroi", "Crotona", "Bulgaria"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang nagligtas kay Florante mula sa leon?",
      choices: ["Aladin", "Adolfo", "Menandro", "Antenor"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang propesyon ng kaibigan ni Florante na si Menandro?",
      choices: ["Sundalo", "Mang-aawit", "Negosyante", "Iskolar"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang kapalaran ni Adolfo sa dulo ng kuwento?",
      choices: [
        "Namamatay sa Labanan",
        "Pinarusahan ng Hari",
        "Ipinatapon ng Hari",
        "Nagbabalik-loob at humihingi ng tawad"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang ama ni Laura?",
      choices: [
        "Haring Linceo",
        "Duke Briseo",
        "Haring Linio",
        "Haring Linceus"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang ginawa ni Florante matapos bumalik sa Albania?",
      choices: [
        "Naging Hari",
        "Iniwan ang Kaharian",
        "Naging Pari",
        "Naghiganti"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang pamagat ng kaharian na pinamumunuan ni Haring Linio?",
      choices: [
        "Kaharian ng Macedonia",
        "Kaharian ng Byzantium",
        "Kaharian ng Thessaly",
        "Kaharian ng England"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang hari ng Persia sa 'Florante at Laura'?",
      choices: [
        "Haring Linceo",
        "Haring Linio",
        "Haring Linceus",
        "Haring Menandro"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang ginawa ni Adolfo upang taksilin si Florante?",
      choices: [
        "Pinalabas na Nagkasala Siya",
        "Binalaan Siya",
        "Kinidnap si Laura",
        "Nagnakaw ng Kaharian"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang kasama ni Florante sa kanyang pagtatapon?",
      choices: ["Aladin", "Adolfo", "Antenor", "Menandro"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question:
          "Ano ang pamagat ng kaharian na pinamumunuan ni Haring Menandro?",
      choices: [
        "Kaharian ng Persia",
        "Kaharian ng Macedon",
        "Kaharian ng Carthage",
        "Kaharian ng Thrace"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang nais ni Adolfo mula kay Laura?",
      choices: [
        "Ang Kamay Niya sa Kasal",
        "Ang Kanyang Kaharian",
        "Ang Kanyang Kayamanan",
        "Ang Kanyang Tapat na Pagmamahal"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Sino ang tunay na ama ni Flerida?",
      choices: ["Adolfo", "Florante", "Menandro", "Aladin"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 2,
      question: "Ano ang propesyon ng ama ni Adolfo, si Duke Briseo?",
      choices: ["Heneral", "Mang-aawit", "Negosyante", "Iskolar"],
      correctAnswerIndex: 0,
    ),
  ],
  [
    // Questions for 'El Filibusterismo'
    Question(
      workId: 3,
      question: "Sino ang sumulat ng 'El Filibusterismo'?",
      choices: [
        "Jose Rizal",
        "Francisco Balagtas",
        "Pedro Paterno",
        "Anonymous"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang kasunod na aklat ng 'Noli Me Tangere'?",
      choices: [
        "El Filibusterismo",
        "Florante at Laura",
        "Ibong Adarna",
        "El Fili"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Sino ang pangunahing tauhan sa 'El Filibusterismo'?",
      choices: ["Juan Crisostomo Ibarra", "Isagani", "Padre Salvi", "Elias"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang pangalan ng anti-hero sa 'El Filibusterismo'?",
      choices: ["Simoun", "Basilio", "Tasyo", "Kabesang Tales"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang pen name ni Simoun sa 'El Filibusterismo'?",
      choices: ["Crisostomo Ibarra", "Ibarra Jr.", "Crispin", "Don Custodio"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Sino ang anak na babae ni Kapitan Tiago sa 'El Filibusterismo'?",
      choices: ["Paulita Gomez", "Maria Clara", "Consolacion", "Julia"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang propesyon ni Padre Florentino?",
      choices: ["Paring Pari", "Doktor", "Abogado", "Guro"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang hanapbuhay ng karakter na si Kabesang Tales?",
      choices: ["Magsasaka", "Mangingisda", "Panday", "Guro"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang tunay na pangalan ni Basilio?",
      choices: ["Sisa", "Tano", "Crispin", "Isagani"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Sino ang guro ni Isagani?",
      choices: ["Padre Florentino", "Elias", "Tasyo", "Simoun"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Ano ang pangalan ng rebolusyonaryong samahan sa 'El Filibusterismo'?",
      choices: [
        "La Liga Filipina",
        "Kataastaasang Kagalanggalangang Katipunan ng mga Anak ng Bayan",
        "Katipunan",
        "Cuerpo de Vigilancia"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Sino ang nagplano ng pagsisimula ng rebolusyon sa 'El Filibusterismo'?",
      choices: ["Simoun", "Padre Salvi", "Don Custodio", "Don Rafael"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang hanapbuhay ng karakter na si Juli?",
      choices: [
        "Mang-aawit",
        "Mananayaw",
        "Nagtitinda sa Kalsada",
        "Babaeng Pananggalang"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Ano ang pangalan ng paaralan na itinatag ni Basilio sa 'El Filibusterismo'?",
      choices: [
        "San Diego Academy",
        "Colegio de San Juan de Letran",
        "Escuela Pia",
        "Paaralan ng Sining at Kalakalan"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang kapalaran ni Simoun sa dulo ng 'El Filibusterismo'?",
      choices: [
        "Namamatay sa Pagpapatiwakal",
        "Nakakatakas Patungo sa Ibang Bansa",
        "Inaaresto at Pinarusahan",
        "Nagpapatawad sa Kanyang mga Kaaway"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Sino ang karakter na kilala sa kanyang hula tungkol sa paparating na rebolusyon?",
      choices: ["Tasyo", "Simoun", "Don Custodio", "Padre Florentino"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang kapalaran ni Juli sa dulo ng 'El Filibusterismo'?",
      choices: [
        "Pinatay ni Simoun",
        "Inaresto at Binaril",
        "Namamatay sa Sakit",
        "Nagbabagong-loob at Sumapi sa Rebolusyon"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Sino ang karakter na kilala sa kanyang nobelang 'Pag-ibig at Paghihiganti'?",
      choices: ["Padre Florentino", "Tasyo", "Simoun", "Padre Salvi"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question: "Ano ang kapalaran ni Juanito Pelaez sa 'El Filibusterismo'?",
      choices: [
        "Sumapi sa Rebolusyon",
        "Namatay sa Labanan",
        "Inaresto at Binaril",
        "Lumisan sa Bansa"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 3,
      question:
          "Sino ang nagligtas kay Basilio mula sa pagkakakulong sa 'El Filibusterismo'?",
      choices: ["Padre Florentino", "Simoun", "Don Rafael", "Don Custodio"],
      correctAnswerIndex: 0,
    ),
  ],
  [
    // Questions for 'Noli Me Tangere'
    Question(
      workId: 4,
      question: "Sino ang sumulat ng 'Noli Me Tangere'?",
      choices: [
        "Jose Rizal",
        "Francisco Balagtas",
        "Pedro Paterno",
        "Anonymous"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang pamagat ng aklat na nagsimula ng himagsikan sa Pilipinas?",
      choices: [
        "Noli Me Tangere",
        "El Filibusterismo",
        "Ibong Adarna",
        "Florante at Laura"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question: "Sino ang pangunahing tauhan sa 'Noli Me Tangere'?",
      choices: ["Juan Crisostomo Ibarra", "Isagani", "Padre Salvi", "Elias"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang pangalan ng karakter na kumakatawan sa elitistang uri sa 'Noli Me Tangere'?",
      choices: [
        "Don Rafael Ibarra",
        "Padre Damaso",
        "Maria Clara",
        "Kapitan Tiago"
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      workId: 4,
      question: "Ano ang trabaho ng karakter na si Elias sa 'Noli Me Tangere'?",
      choices: ["Mangingisda", "Magsasaka", "Rebolusyonaryo", "Guro"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question: "Sino ang minamahal ni Maria Clara sa 'Noli Me Tangere'?",
      choices: ["Ibarra", "Elias", "Crisostomo", "Damaso"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question: "Ano ang palayaw ni Basilio sa 'Noli Me Tangere'?",
      choices: ["Tano", "Crispin", "Sisa", "Elias"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question: "Ano ang propesyon ni Padre Damaso sa 'Noli Me Tangere'?",
      choices: ["Pari", "Doktor", "Abogado", "Politiko"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question: "Sino ang ama ni Maria Clara sa 'Noli Me Tangere'?",
      choices: ["Ibarra", "Elias", "Crisostomo", "Damaso"],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 4,
      question: "Ano ang kapalaran ni Elias sa dulo ng 'Noli Me Tangere'?",
      choices: [
        "Namamatay sa Lawa",
        "Nakatakas Papuntang Ibang Bansa",
        "Inaaresto at Binaril",
        "Namatay sa Duelo"
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang tunay na pangalan ng mga anak ni Sisa sa 'Noli Me Tangere'?",
      choices: [
        "Tano At Crispin",
        "Juan At Pedro",
        "Basilio At Crispin",
        "Juan At Simoun"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 4,
      question:
          "Sino ang karakter na kilala sa kanyang mga mapanlikhaing pananaw at kritisismo sa mga prayle?",
      choices: ["Tasyo", "Ibarra", "Elias", "Crispin"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang pangalang-tusang ginamit ni Juan Crisostomo Ibarra sa 'Noli Me Tangere'?",
      choices: ["Ibarra Jr.", "Crisostomo Ibarra", "Crispin", "Don Custodio"],
      correctAnswerIndex: 1,
    ),
    Question(
      workId: 4,
      question: "Ano ang hanapbuhay ni Pilosopo Tasyo?",
      choices: ["Guro", "Pilosopo", "Doktor", "Abogado"],
      correctAnswerIndex: 1,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang kapalaran ni Juan Crisostomo Ibarra sa dulo ng 'Noli Me Tangere'?",
      choices: [
        "Namamatay sa Pagpapatiwakal",
        "Nakatakas Papuntang Ibang Bansa",
        "Inaaresto at Pinarusahan",
        "Nagpapatawad sa Kanyang mga Kaaway"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang pangalan ng pagtitipon sa lipunan sa 'Noli Me Tangere' kung saan tinalakay ang mga isyu sa lipunan?",
      choices: [
        "Cafe Havanna",
        "Cafe Restaurant",
        "Cafe Social",
        "Cafe Madrid"
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      workId: 4,
      question:
          "Sino ang kaibigan ni Elias at tumulong kay Ibarra na makatakas?",
      choices: ["Tasyo", "Crisostomo", "Basilio", "Sandoval"],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang kapalaran ni Maria Clara sa dulo ng 'Noli Me Tangere'?",
      choices: [
        "Namamatay Dahil sa Sakit",
        "Nakatakas Papuntang Ibang Bansa",
        "Namamatay sa Pagpapatiwakal",
        "Namamatay sa Isang Kumbento"
      ],
      correctAnswerIndex: 3,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang pangalan ng bayan kung saan naganap ang karamihan ng mga pangyayari sa 'Noli Me Tangere'?",
      choices: ["San Diego", "San Felipe", "San Juan", "San Francisco"],
      correctAnswerIndex: 0,
    ),
    Question(
      workId: 4,
      question:
          "Ano ang kapalaran ni Padre Salvi sa dulo ng 'Noli Me Tangere'?",
      choices: [
        "Nakatakas Papuntang Ibang Bansa",
        "Namamatay sa Kamay ni Elias",
        "Inaaresto at Pinarusahan",
        "Ikinukulong at Ini-exkomunikado ng Simbahan"
      ],
      correctAnswerIndex: 2,
    ),
  ],
];
