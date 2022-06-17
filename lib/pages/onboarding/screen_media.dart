import 'package:flutter/material.dart';
import 'package:nerdvalorant/pages/onboarding/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class ScreenMedia {
  final String image;
  final String title;
  final List<TextSpan> description;
  final List<String> icons;

  ScreenMedia({
    required this.image,
    required this.title,
    required this.description,
    required this.icons,
  });
}

List<ScreenMedia> screenMedia = [
  ScreenMedia(
    image: screenImageViper,
    title: 'ERRANDO MUITO PIXEL EM PARTIDAS DECISIVAS?',
    description: [
      TextSpan(
        text:
            'Supreenda seus adversários, utilize nosso aplicativo e aumente suas ',
        style: subtitleStyle,
      ),
      TextSpan(
        text: 'VITÓRIAS.',
        style: subtitleBoldStyle,
      ),
    ],
    icons: [
      iconNerdValorant,
      iconArrowForward,
      iconAlbums,
      iconArrowForward,
      iconTrophy,
    ],
  ),
  ScreenMedia(
    image: screenImageCypher,
    title: 'BASTA SELECIONAR O MAPA, AGENTE E O MODO DE JOGO',
    description: [
      TextSpan(
        text:
            'Fácil né? tempo suficiente para comprar armas, habilidades e escolher uns ',
        style: subtitleStyle,
      ),
      TextSpan(
        text: 'PIXELS.',
        style: subtitleBoldStyle,
      ),
    ],
    icons: [
      iconMap,
      iconArrowForward,
      iconPerson,
      iconArrowForward,
      iconShieldAndSword,
    ],
  ),
  ScreenMedia(
    image: screenImageKilljoy,
    title: 'GOSTOU? ENTÃO FAÇA PARTE DESTA COMUNIDADE',
    description: [
      TextSpan(
        text: 'Siga-nos no instagram e fique por dentro das novidades ',
        style: subtitleStyle,
      ),
      TextSpan(
        text: '@nerdvalorantoficial.',
        style: subtitleBoldStyle,
      ),
    ],
    icons: [
      iconInstagram,
      iconArrowForward,
      iconChatboxEllipses,
      iconArrowForward,
      iconNerdValorant,
    ],
  )
];
