# CheatSheets — xuletes per a classe

Repositori de xuletes (cheatsheets) per a alumnes de **primer de programació**. Cada xuleta es
genera com a fitxer **.docx** a partir d'un script de Node.

## Requeriments del material

- **Idioma: català**, sempre.
- **Públic**: alumnes que programen per primera vegada. Exemples curts, executables i comentats.
- **No avançar temari**: res de classes, col·leccions, LINQ, excepcions pròpies, async, etc., tret
  que es demani explícitament. Si un concepte avançat és inevitable, resoldre'l amb una nota curta.
- **Una targeta = un concepte**. Prioritzar el que l'alumne es troba a la pràctica: paranys,
  missatges del compilador i patrons recomanats.
- **Format d'entrega: .docx**, no HTML (l'HTML costa d'imprimir i les xuletes es reparteixen en
  paper). Els `.html` antics es conserven al repositori com a referència, però no són l'entregable.
- Objectiu de mida: **2–3 pàgines A4** per xuleta.

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

## Com es genera una xuleta

```bash
npm install
node "C#/XuletaBàsica.js"
```

Per revisar el resultat (cal Word instal·lat i `pip install pymupdf`):

```bash
powershell -File tools/preview.ps1 -In "C#/XuletaBàsica.docx"
```

Genera un PNG per pàgina al directori temporal. **Revisar sempre el render abans de donar la feina
per bona**: comentaris tallats a mitja línia, files de taula que ocupen dues línies sense necessitat,
targetes que queden penjades o columnes desequilibrades.

## Estructura del repositori

| Fitxer | Què és |
|---|---|
| `tools/cheatsheet.js` | Llibreria de generació (disseny, targetes, codi, taules, avisos). |
| `tools/preview.ps1` | Converteix el .docx a PDF i el rasteritza per revisar-lo. |
| `<Llenguatge>/<Nom>.js` | Contingut d'una xuleta. |
| `<Llenguatge>/<Nom>.docx` | Resultat generat (es pot regenerar sempre). |

## API de `tools/cheatsheet.js`

```js
const { build, card, code, codeXml, cl, dataTable, alert, info, body, subTitle, bullet } = require("../tools/cheatsheet");

card("1. Títol", [
  body("Text normal amb `codi` entre cometes invertides."),
  subTitle("Subapartat"),
  code(`int x = 10;   // ressaltat automàtic`),
  dataTable(["Col A", "Col B"], [["a", "b"]], [1500, 3400]),
  alert("Parany o error freqüent."),
  info("Aclariment o alternativa."),
  bullet("Element de llista."),
]);

build({ title, subtitle, cards, output });
```

- `code()` ressalta la sintaxi de C# sol; un comentari que contingui `ERROR` surt en vermell.
- `codeXml()` per a fragments de `.props` / `.csproj`; `cl()` per posar colors a mà.
- Les amplades de `dataTable` van en twips i **han de sumar 4900 com a màxim** (amplada útil d'una
  targeta). Ajustar-les perquè cada fila càpiga en una sola línia sempre que es pugui.

## Disseny (no canviar sense motiu)

- A4, marges d'1 cm, dues columnes, targetes blanques amb filet morat a dalt.
- Les targetes no es parteixen entre columnes; l'última pàgina queda amb les columnes equilibrades.
- **Evitar emojis** excepte el `⚠️` dels avisos: Word els imprimeix en blanc i negre i queden lletjos.
- Caixa groga (`alert`) per a paranys i coses que peten; caixa morada (`info`) per a aclariments.
