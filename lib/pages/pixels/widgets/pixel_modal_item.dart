import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/pages/pixels/models/valorant_maps.dart';
import 'package:nerdvalorant/pages/pixels/models/valorant_agents.dart';

class PixelModalItem extends StatefulWidget {
  const PixelModalItem({Key? key, required this.filter}) : super(key: key);

  final Function filter;

  @override
  State<PixelModalItem> createState() => _PixelModalItemState();
}

class _PixelModalItemState extends State<PixelModalItem> {
  List<ValorantMap> maps = [
    ValorantMap(name: 'Bind', source: mapBind),
    ValorantMap(name: 'Split', source: mapSplit),
    ValorantMap(name: 'Pearl', source: mapPearl),
    ValorantMap(name: 'Haven', source: mapHaven),
    ValorantMap(name: 'Ascent', source: mapAscent),
    ValorantMap(name: 'Breeze', source: mapBreeze),
    ValorantMap(name: 'Icebox', source: mapIceBox),
    ValorantMap(name: 'Fracture', source: mapFracture),
  ];

  List<ValorantAgent> agents = [
    ValorantAgent(name: 'Jet', source: agentJet),
    ValorantAgent(name: 'Skye', source: agentSkye),
    ValorantAgent(name: 'Fade', source: agentFade),
    ValorantAgent(name: 'Kayo', source: agentKayo),
    ValorantAgent(name: 'Neon', source: agentNeon),
    ValorantAgent(name: 'Omen', source: agentOmen),
    ValorantAgent(name: 'Raze', source: agentRaze),
    ValorantAgent(name: 'Sage', source: agentSage),
    ValorantAgent(name: 'Sova', source: agentSova),
    ValorantAgent(name: 'Yoru', source: agentYoru),
    ValorantAgent(name: 'Astra', source: agentAstra),
    ValorantAgent(name: 'Reyna', source: agentReyna),
    ValorantAgent(name: 'Viper', source: agentViper),
    ValorantAgent(name: 'Breach', source: agentBreach),
    ValorantAgent(name: 'Cypher', source: agentCypher),
    ValorantAgent(name: 'Phoenix', source: agentPhoenix),
    ValorantAgent(name: 'Chamber', source: agentChamber),
    ValorantAgent(name: 'Killjoy', source: agentKilljoy),
    ValorantAgent(name: 'Brimstone', source: agentBrimstone),
  ];

  ValorantMap selectedMap = ValorantMap(name: '', source: '');
  ValorantAgent selectedAgent = ValorantAgent(name: '', source: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(screenBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Text(
                'SELECIONE O MAPA',
                style: modalTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var map in maps)
                      InkWell(
                        onTap: () => setState(() => selectedMap = map),
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenSize.width(2),
                              ),
                              child: Container(
                                width: ScreenSize.width(30),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(map.source),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenSize.width(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenSize.width(2),
                              ),
                              child: Container(
                                width: ScreenSize.width(30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: selectedMap == map
                                        ? [
                                            Colors.green.withOpacity(0),
                                            Colors.green.withOpacity(.5),
                                          ]
                                        : [
                                            Colors.black.withOpacity(0),
                                            Colors.black.withOpacity(.8),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenSize.width(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              map.name.toUpperCase(),
                              style: legendMapTextStyle,
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Text(
                'SELECIONE O AGENTE',
                style: modalTextStyle,
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var agent in agents)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width(1),
                        ),
                        child: InkWell(
                          onTap: () => setState(() => selectedAgent = agent),
                          splashColor: greenColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenSize.width(10),
                            ),
                          ),
                          child: Container(
                            width: ScreenSize.width(20),
                            decoration: BoxDecoration(
                              color: selectedAgent == agent
                                  ? greenColor
                                  : blackColor,
                              image: DecorationImage(
                                image: AssetImage(agent.source),
                                fit: BoxFit.cover,
                                opacity: selectedAgent == agent ? 1.0 : 0.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  ScreenSize.width(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Text(
                'VOCÊ ESTÁ?',
                style: modalTextStyle,
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => widget.filter(
                      [selectedAgent.name, selectedMap.name, 'Atacando'],
                    ),
                    icon: SvgPicture.asset(iconSword, height: 30),
                    label: Text(
                      '      ATACANDO      ',
                      style: buttonFilterTextStyle,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: whiteColor,
                      onPrimary: blackColor,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => widget.filter(
                      [selectedAgent.name, selectedMap.name, 'Defendendo'],
                    ),
                    icon: const Icon(
                      Ionicons.shield_outline,
                      size: 30,
                    ),
                    label: Text(
                      'DEFENDENDO',
                      style: buttonFilterTextStyle,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: whiteColor,
                      onPrimary: blackColor,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenSize.height(2),
              ),
              ElevatedButton.icon(
                onPressed: () => widget.filter(['']),
                icon: const Icon(
                  Ionicons.trash_outline,
                ),
                label: Text(
                  'LIMPAR FILTRO',
                  style: buttonClearFilterTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  primary: greenColor,
                  onPrimary: whiteColor,
                ),
              ),
              SizedBox(
                height: ScreenSize.height(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
