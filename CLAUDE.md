# CheatSheets — xuletes per a classe

Repositori de xuletes (cheatsheets) per a alumnes de **primer de programació**. Cada xuleta s'escriu
en **Typst** i es reparteix en paper com a **PDF**.

## Requeriments del material

- **Idioma: català**, sempre.
- **Públic**: alumnes que programen per primera vegada. Exemples curts, executables i comentats.
- **No avançar temari**: res de classes, col·leccions, LINQ, excepcions pròpies, async, etc., tret
  que es demani explícitament. Si un concepte avançat és inevitable, resoldre'l amb una nota curta.
- **Una targeta = un concepte**. Prioritzar el que l'alumne es troba a la pràctica: paranys,
  missatges del compilador i patrons recomanats.
- **Format d'entrega: Typst → PDF** (decisió presa). El .docx i l'HTML antics es conserven com a
  referència, però ja no són l'entregable ni cal mantenir-los al dia.
- Objectiu de mida: **2–3 pàgines A4** per xuleta.
- Disseny visual i atractiu: colors per targeta, esquemes (consola, rectes, barres, diagrames) i
  post-its per als avisos. Mantenir-lo quan s'afegeixin targetes o xuletes noves.

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

## Estructura del repositori

| Fitxer | Què és |
|---|---|
| `tools/xuleta.typ` | Plantilla Typst (colors, targetes, caixes, taules, capçalera, tema del codi). |
| `tools/fonts/` | Fonts lliures (OFL): Atkinson Hyperlegible (text), Lilita One (títols), JetBrains Mono (codi). |
| `<Llenguatge>/<Nom>.typ` | Contingut d'una xuleta (p. ex. `C#/XuletaBàsica.typ`). |
| `<Llenguatge>/<Nom>.pdf` | Resultat generat (ignorat per git, es pot regenerar sempre). |
| `C#/XuletaNulls-poster.svg` | Pòster A4 d'una pàgina sobre els nulls, editable amb Inkscape. |
| `.vscode/settings.json` | Configuració de Tinymist (carpeta de fonts i PDF en desar). |
| `tools/cheatsheet.js`, `*.js`, `*.docx`, `*.html` | Versió antiga en .docx/HTML. Només referència. |

## Com es treballa

- **Editar**: VS Code + extensió **Tinymist**, obrint la carpeta del repositori. La vista prèvia
  s'actualitza sola i el PDF es genera en desar. Si surten avisos de fonts, recarregar la finestra.
- **Compilar per línia d'ordres**: `typst compile --font-path tools/fonts "C#/XuletaBàsica.typ"`.
- **typst.app** (només si cal): pujar a l'arrel del projecte la xuleta, `tools/xuleta.typ` i els `.ttf`
  de `tools/fonts/`, canviar l'import per `#import "xuleta.typ": *` i marcar la xuleta com a fitxer
  principal.
- No usar fonts de sistema (Segoe UI, Consolas...): només les de `tools/fonts/`.
- **Revisar sempre el render abans de donar la feina per bona**: línies de codi partides, targetes
  que salten de columna i deixen forats, columnes desequilibrades, post-its que surten de la targeta.

## API de `tools/xuleta.typ`

```typst
#import "../tools/xuleta.typ": *

#show: xuleta.with(
  kicker: "Xuleta C# · 1",
  title: "Conceptes bàsics",
  tags: ("Variables", "Operadors", ...),
)

#card(1, "Títol", color: rosa)[          // color opcional; per defecte, segons el número
  Text amb `codi en línia`.
  #sub[Subapartat]
  ```cs
  int x = null;  // ERROR
  int? y = null; // OK
  ```
  #sortida[Hola món!]                     // consola amb la sortida del programa
  #taula((auto, 1fr), th[Col A], th[Col B], `a`, [b])
  #avis[Parany o error freqüent.]          // post-it groc
  #nota[Aclariment o alternativa.]         // caixa lila amb una "i"
  #postit[Regla d'or.]                     // post-it rosa amb estrella
]
#colbreak()
#ample(title: [Títol])[...]                // bloc a tota l'amplada, a dalt de la pàgina
```

- Peces gràfiques: `pill`, `si` / `no`, `rodona`, `fletxa`, `estrella`.
- Colors: `violeta`, `blau`, `cian`, `turquesa`, `indi`, `taronja`, `rosa`, `vermell`, `verd`, `ink`.
- Les línies de codi amb `// ERROR` surten amb fons vermell i les de `// OK` amb fons verd.
- El codi es mostra sense lligadures (`>=` no es converteix en un sol símbol).
- Les targetes de null van en `rosa`; la dels errors, en `vermell`.

## Maquetació

- A4, marges d'1 cm, dues columnes. Les targetes no es parteixen entre columnes.
- Es reparteixen per columnes amb `#colbreak()` explícits. Si una targeta no hi cap, salta de
  columna i descol·loca tot el que ve després.
- Mesurar les targetes:
  `typst query --font-path tools/fonts "C#/XuletaBàsica.typ" "<fi-targeta>" --field value`
  (també hi ha `<inici-targeta>`). La columna útil va de 28 pt a uns 808 pt; a la primera pàgina
  comença a uns 113 pt per la capçalera, i a la pàgina on hi ha un `ample`, més avall.
- Evitar línies de codi de més de ~50 caràcters: es parteixen.
- **Evitar emojis**: dibuixar les icones amb la plantilla (el triangle d'avís ja ho fa).
