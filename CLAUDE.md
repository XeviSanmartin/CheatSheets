# CheatSheets — xuletes per a classe

Repositori de xuletes (cheatsheets) de programació: **C#** per a primer curs i **Kotlin** per a
segon. Cada xuleta s'escriu en **Typst** i es reparteix en paper com a **PDF**, en dues versions:
la normal i una adaptada per a alumnes amb **dislèxia**.

## Requeriments del material

- **Idioma: català**, sempre.
- **Públic**: a primer, alumnes que programen per primera vegada; a segon, alumnes que ja saben C#
  i passen a Kotlin. Exemples curts, executables i comentats.
- **No avançar temari**: a les xuletes de primer, res de classes, col·leccions, LINQ, excepcions
  pròpies, async, etc., tret que es demani explícitament. Si un concepte avançat és inevitable,
  resoldre'l amb una nota curta.
- **Una targeta = un concepte**. Prioritzar el que l'alumne es troba a la pràctica: paranys,
  missatges del compilador i patrons recomanats.
- **Format d'entrega: Typst → PDF** (decisió presa). El .docx i l'HTML antics es conserven com a
  referència, però ja no són l'entregable ni cal mantenir-los al dia.
- Objectiu de mida: **2–3 pàgines A4** per xuleta (versió normal).
- Disseny visual i atractiu: colors per targeta, esquemes (consola, rectes, barres, diagrames) i
  post-its per als avisos. Mantenir-lo quan s'afegeixin targetes o xuletes noves.
- **Cada xuleta té la seva versió per a dislèxia** (`<Nom>-dislexia.typ`) amb el mateix contingut.
  Quan es canviï el contingut d'una, cal fer el mateix canvi a l'altra.

## Context del curs de C#

Els projectes de classe porten un `Directory.Build.props` amb:

```xml
<Nullable>enable</Nullable>
<WarningsAsErrors>Nullable</WarningsAsErrors>
```

Tot el codi dels materials ha de compilar amb aquest mode actiu. En conseqüència:

- `Console.ReadLine()` retorna `string?`, mai `string`.
- `string nom = null;` i `int x = null;` són **errors**, no avisos.
- Cal comprovar `!= null` (o usar `??` / `?.`) abans d'usar una variable declarada amb `?`.
- `.HasValue` i `.Value` només existeixen als tipus per valor (`int?`, `double?`...), no als `string?`.

Ordre dels temes a la xuleta bàsica: E/S, tipus, TryParse, operadors, **tot el bloc de null**
(Nullable, comprovar, operadors de null, strings), i després condicionals, Math i funcions.
Els errors del compilador i les trampes tanquen la xuleta.

## Xuletes

| Xuleta | Curs | Contingut |
|---|---|---|
| `C#/XuletaNulls.typ` | 1r | Els nulls (es reparteix com a full 0). |
| `C#/XuletaBàsica.typ` | 1r | Conceptes bàsics (full 1). |
| `C#/XuletaBucles.typ` | 1r | Bucles i fitxers (full 2). |
| `C#/XuletaSimbols.typ` | 1r i 2n | Els símbols, un per un. Només existeix en versió per a dislèxia. |
| `Kotlin/XuletaKotlin.typ` | 2n | Kotlin per a programadors de C#. Aquí sí que hi ha classes, col·leccions, etc. |

Totes (menys `XuletaSimbols`) tenen la parella `-dislexia.typ` al costat.

## Estructura del repositori

| Fitxer | Què és |
|---|---|
| `tools/xuleta.typ` | Plantilla Typst normal (colors, targetes, caixes, taules, capçalera, mapa, tema del codi). |
| `tools/xuleta-dislexia.typ` | Plantilla per a dislèxia, amb la mateixa API (vegeu més avall). |
| `tools/fonts/` | Fonts lliures (OFL): Atkinson Hyperlegible (text), Lilita One (títols), JetBrains Mono (codi). |
| `<Llenguatge>/<Nom>.typ` | Contingut d'una xuleta. |
| `<Llenguatge>/<Nom>-dislexia.typ` | La mateixa xuleta per a alumnes amb dislèxia. |
| `<Llenguatge>/*.pdf`, `<Llenguatge>/PDF/` | PDF generats i recopilats per repartir (ignorats per git). |
| `C#/XuletaNulls-poster.svg` | Pòster A4 d'una pàgina sobre els nulls, editable amb Inkscape. |
| `.vscode/settings.json` | Configuració de Tinymist (carpeta de fonts i PDF en desar). |
| `tools/cheatsheet.js`, `tools/preview.ps1`, `*.js`, `*.docx`, `*.html` | Versió antiga en .docx/HTML. Només referència. |

## Com es treballa

- **Editar**: VS Code + extensió **Tinymist**, obrint la carpeta del repositori. La vista prèvia
  s'actualitza sola i el PDF es genera en desar. Si surten avisos de fonts, recarregar la finestra.
- **Compilar per línia d'ordres** (des de l'arrel del repositori; cal `--root .` perquè les
  xuletes importen la plantilla de `../tools/`):
  `typst compile --root . --font-path tools/fonts "C#/XuletaBàsica.typ"`
- **typst.app** (només si cal): pujar a l'arrel del projecte la xuleta, la plantilla de `tools/` i
  els `.ttf` de `tools/fonts/`, canviar l'import per `#import "xuleta.typ": *` (o
  `"xuleta-dislexia.typ"`) i marcar la xuleta com a fitxer principal.
- No usar fonts de sistema (Segoe UI, Consolas...): només les de `tools/fonts/`.
- **Revisar sempre el render abans de donar la feina per bona**, de les dues versions: línies de
  codi partides, targetes que salten de columna i deixen forats, columnes desequilibrades, post-its
  que surten de la targeta.

## API de les plantilles

Les dues plantilles exposen les mateixes funcions; una xuleta passa d'una a l'altra canviant
l'import (i ajustant la maquetació).

```typst
#import "../tools/xuleta.typ": *

#show: xuleta.with(
  serie: "Xuleta de C# · primer curs",
  title: "Conceptes bàsics",
  badge: "C#",                             // etiqueta de la capçalera
  tags: ("Variables", "Operadors", ...),
  // opcionals: subtitle, accent: violeta, mida-codi: 7.2pt, mida-text: 9pt
)

#mapa()                                    // mapa del full amb les seccions i la pàgina
#seccio("Fonaments", color: violeta)       // capçalera de secció (S1, S2...)

#card(1, "Títol", color: rosa)[          // color opcional; per defecte, segons el número
  Text amb `codi en línia`. Vegeu la #ref-targeta(3).   // "targeta 3 (pàg. 1)"
  #sub[Subapartat]
  ```cs
  int x = null;  // ERROR
  int? y = null; // OK
  ```
  #sortida[Hola món!]                     // consola amb la sortida del programa
  #taula((auto, 1fr), th[Col A], th[Col B], `a`, [b])
  #compara(("int x = 5;", "val x = 5"))   // taula C# / Kotlin
  #avis[Parany o error freqüent.]          // avís amb triangle i trama
  #nota[Aclariment o alternativa.]         // caixa lila amb una "i"
  #postit[Regla d'or.]                     // caixa amb estrella
]
#colbreak()
#ample(title: [Títol])[...]                // bloc a tota l'amplada, a dalt de la pàgina
```

- Peces gràfiques: `pill`, `si` / `no`, `rodona`, `fletxa`, `estrella`, `marca-ok`, `marca-error`.
- Colors: `violeta`, `blau`, `cian`, `turquesa`, `indi`, `taronja`, `rosa`, `vermell`, `verd`, `ink`.
  Cada un té una variant fosca per a text (`violeta-f`...); `fosc(c)` la retorna.
- Les línies de codi amb `// ERROR` surten marcades amb una creu i fons vermell, i les de `// OK`
  amb una marca i fons verd.
- El codi es mostra sense lligadures (`>=` no es converteix en un sol símbol).
- Les targetes de null van en `rosa`; la dels errors, en `vermell`.

### Criteris de disseny (no desfer-los sense motiu)

- **Contrast**: cap text blanc sobre un color clar.
- **Blanc i negre**: tots els senyals tenen forma, no només color (creu/marca al codi, SÍ ple contra
  NO amb vora discontínua, trama als avisos), perquè les xuletes s'imprimeixen sovint en B/N.
- **Navegació**: mapa del full, regleta de seccions al marge, nom de la secció al peu i
  referències creuades amb pàgina.
- Poca decoració: sense trames de fons, degradats ni post-its girats.

### Versió per a dislèxia (`tools/xuleta-dislexia.typ`)

- Una sola columna, línies curtes (uns 70 caràcters), text de 12 pt i codi d'uns 11 pt
  (`mida-codi: 11pt`).
- Interlineat ample i més espai entre lletres i paraules.
- Sense cursiva ni text tot en majúscules: el que destaca va en negreta.
- Fons crema (`paper`, `paper-targeta`, `paper-codi`) en lloc de blanc.
- Ocupa més pàgines que la normal; l'objectiu de 2–3 pàgines no s'hi aplica.

## Maquetació (versió normal)

- A4, marges d'1 cm, dues columnes. Les targetes no es parteixen entre columnes.
- Es reparteixen per columnes amb `#colbreak()` explícits. Si una targeta no hi cap, salta de
  columna i descol·loca tot el que ve després.
- Mesurar les targetes:
  `typst query --root . --font-path tools/fonts "C#/XuletaBàsica.typ" "<fi2>" --field value`
  (també hi ha `<inici2>`; cada resultat dona `num`, `page` i `y`). La columna útil va de 28 pt a
  uns 808 pt; a la primera pàgina comença més avall per la capçalera i el mapa, i a la pàgina on
  hi ha un `ample`, també.
- Evitar línies de codi de més de ~50 caràcters: es parteixen.
- **Evitar emojis**: dibuixar les icones amb la plantilla (el triangle d'avís ja ho fa).
