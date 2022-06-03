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
    title: 'Bem vindo, pronto para aumentar suas vitórias?',
    description: [
      TextSpan(
        text: 'Supreenda seus inimigos utilizando nossos pixels e aumente suas',
        style: subtitleStyle,
      ),
      TextSpan(
        text: ' VITÓRIAS.',
        style: subtitleBoldStyle,
      ),
    ],
    icons: [
      iconAlbums,
      iconArrowForward,
      iconNerdValorant,
      iconArrowForward,
      iconTrophy,
    ],
  ),
  ScreenMedia(
    image: screenImageCypher,
    title: 'Mapa, agente, defender ou atacar',
    description: [
      TextSpan(
        text: 'Aplique o filtro e selecione o ',
        style: subtitleStyle,
      ),
      TextSpan(
        text: 'PIXEL ',
        style: subtitleBoldStyle,
      ),
      TextSpan(
        text: 'perfeito para a sua jogada.',
        style: subtitleStyle,
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
    title: 'Participe da nossa comunidade no Instagram',
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
      iconChatboxEllipses,
      iconArrowForward,
      iconInstagram,
      iconArrowForward,
      iconNerdValorant,
    ],
  )
];
