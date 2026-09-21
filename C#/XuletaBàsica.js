// Xuleta 1 de C#: conceptes bàsics.
// Generar:  node "C#/XuletaBàsica.js"

const path = require("path");
const { build, card, code, codeXml, dataTable, alert, info, body, subTitle, bullet } = require("../tools/cheatsheet");

const cards = [];

// ----------------------------------------------------------------
cards.push(card("1. Estructura Bàsica i E/S", [
  code(`
    static void Main(string[] args) {
        // SORTIDA
        Console.Write("Sense salt");
        Console.WriteLine("Amb salt");

        // ENTRADA: retorna string? (pot ser null!)
        string? s = Console.ReadLine();

        // Versió segura: mai serà null
        string t = Console.ReadLine() ?? "";

        Console.Clear();  // neteja la pantalla
    }
  `),
  body("Interpolació de text (molt més còmode que concatenar amb `+`):"),
  code(`
    string nom = "Anna";
    int edat = 17;
    Console.WriteLine($"{nom} té {edat} anys");
  `),
]));

// ----------------------------------------------------------------
cards.push(card("2. Constants, Variables i Tipus", [
  dataTable(
    ["Tipus", "Exemple", "Conversió des de string"],
    [
      ["`int`", "10, -5", "`Convert.ToInt32(s)`"],
      ["`double`", "9.99", "`Convert.ToDouble(s)`"],
      ["`string`", "\"Hola\"", "—"],
      ["`char`", "'A'", "`Convert.ToChar(s)`"],
      ["`bool`", "true", "`Convert.ToBoolean(s)`"],
    ],
    [1050, 1250, 2650]
  ),
  body("Constants: `const double PI = 3.1416;` — el seu valor no es pot canviar."),

  subTitle("Límits (MinValue / MaxValue)"),
  code(`
    int maxim = int.MaxValue; // 2.147.483.647
    int minim = int.MinValue; // -2.147.483.648
  `),

  subTitle("Divisió entera: el parany clàssic"),
  code(`
    int a = 10 / 3;      // 3  (es perden els decimals!)
    double b = 10.0 / 3; // 3,33...
    double c = (double)x / y; // amb variables int
  `),
  alert("Si els dos operands són `int`, el resultat també és `int`. Cal que almenys un sigui `double`."),

  subTitle("Conversió segura: TryParse"),
  body("`Convert.ToInt32` peta si l'usuari escriu lletres. `TryParse` no: retorna `true`/`false`."),
  code(`
    string? entrada = Console.ReadLine();

    if (int.TryParse(entrada, out int num)) {
        Console.WriteLine($"Correcte: {num}");
    } else {
        Console.WriteLine("Això no és un número!");
    }
  `),
  info("`TryParse` accepta un `string?` sense queixar-se: ja preveu que pugui ser null."),
]));

// ----------------------------------------------------------------
cards.push(card("3. Operadors i Precedència", [
  body("Ordre d'execució de dalt a baix (major prioritat primer)."),
  dataTable(
    ["Prio.", "Tipus", "Operadors"],
    [
      ["1 (Max)", "Parèntesis", "`( )`"],
      ["2", "Unaris", "`++`  `--`  `!` (NOT)  `-` (negatiu)"],
      ["3", "Multiplicatius", "`*`  `/`  `%` (mòdul)"],
      ["4", "Additius", "`+`  `-`"],
      ["5", "Relacionals", "`<`  `>`  `<=`  `>=`"],
      ["6", "Igualtat", "`==`  `!=`"],
      ["7", "Lògic AND", "`&&`"],
      ["8", "Lògic OR", "`||`"],
      ["9", "Fusió amb null", "`??`"],
      ["10", "Condicional ternari", "`? :`"],
      ["11 (Min)", "Assignació", "`=`  `+=`  `-=`  `*=`  `??=`"],
    ],
    [750, 1400, 2800]
  ),
  alert("El mòdul (%) dóna el residu de la divisió entera: 10 % 3 = 1. Útil per saber si un número és parell: `n % 2 == 0`."),

  subTitle("Operador ternari (if compacte)"),
  body("`condició ? valorSiCert : valorSiFals`"),
  code(`string tipus = (edat >= 18) ? "Major" : "Menor";`),
]));

// ----------------------------------------------------------------
cards.push(card("4. Math i Aleatoris", [
  subTitle("Aleatoris"),
  code(`
    Random rnd = new Random(); // declarar 1 sol cop
    int dau = rnd.Next(1, 7);  // entre 1 i 6
    double r = rnd.NextDouble(); // entre 0.0 i 1.0
  `),
  alert("`rnd.Next(1, 7)` inclou l'1 però MAI el 7: el límit superior queda fora."),

  subTitle("Funcions habituals"),
  bullet("`Math.Abs(x)` — valor absolut."),
  bullet("`Math.Pow(b, e)` — potència (b elevat a e)."),
  bullet("`Math.Sqrt(x)` — arrel quadrada."),
  bullet("`Math.Round(x, 2)` — arrodonir a 2 decimals."),
  bullet("`Math.Max(a, b)` / `Math.Min(a, b)` — el més gran / petit."),

  subTitle("Exemple: distància entre 2 punts"),
  body("dist = √((x₂-x₁)² + (y₂-y₁)²)"),
  code(`
    double dx = x2 - x1;
    double dy = y2 - y1;
    double dist = Math.Sqrt(Math.Pow(dx, 2)
                           + Math.Pow(dy, 2));
  `),
]));

// ----------------------------------------------------------------
cards.push(card("5. Condicionals", [
  code(`
    if (nota >= 9)
    {
        Console.WriteLine("Excel·lent");
    }
    else if (nota >= 5)
    {
        Console.WriteLine("Aprovat");
    }
    else
    {
        Console.WriteLine("Suspens");
    }
  `),
  alert("Per comparar si dos valors són iguals cal `==` (doble igual). Amb `=` li estaries assignant el valor!"),
]));

// ----------------------------------------------------------------
cards.push(card("6. Funcions (Mètodes)", [
  body("Permeten reutilitzar codi i separar la lògica."),
  code(`
    // 1. DEFINICIÓ (fora del Main)
    public static double CalculaArea(double radi)
    {
        return Math.PI * Math.Pow(radi, 2);
    }

    // 2. CRIDA (dins del Main)
    double area = CalculaArea(5.5);
  `),
  body("Si una funció no retorna res, el tipus de retorn és `void`."),
  info("Si un paràmetre pot arribar buit, declara'l amb `?`: `void Saluda(string? nom)`."),
]));

// ----------------------------------------------------------------
cards.push(card("7. Mode Nullable: el compilador vigila", [
  body("`null` vol dir «cap valor», «buit», «encara no assignat». No és ni `0` ni `\"\"`."),
  body("Als projectes de classe hi ha un fitxer `Directory.Build.props` que activa el mode Nullable:"),
  codeXml(`
    <Project>
      <PropertyGroup>
        <Nullable>enable</Nullable>
        <WarningsAsErrors>Nullable</WarningsAsErrors>
      </PropertyGroup>
    </Project>
  `),
  body("A partir d'aquí, una variable només pot valer `null` si el seu tipus acaba amb `?`. I els avisos de null passen a ser ERRORS: el programa no compila."),
  dataTable(
    ["Declaració", "Pot ser null?"],
    [
      ["`int edat`", "NO"],
      ["`int? edat`", "SÍ"],
      ["`string nom`", "NO"],
      ["`string? nom`", "SÍ"],
    ],
    [1900, 3000]
  ),
  code(`
    int     a = null; // ERROR
    int?    b = null; // OK
    string  c = null; // ERROR
    string? d = null; // OK
  `),
  alert("Regla d'or: si una dada pot no existir (encara no hi és, l'usuari no l'ha escrita...), declara-la amb `?`. Si sempre hi ha d'haver valor, deixa-la sense `?`."),
]));

// ----------------------------------------------------------------
cards.push(card("8. Comprovar abans d'usar", [
  body("Una variable amb `?` no es pot usar directament: primer cal comprovar-la. El compilador segueix el teu codi i, dins de l'`if`, ja sap que hi ha valor."),
  code(`
    string? nom = Console.ReadLine();

    Console.WriteLine(nom.Length); // ERROR: pot ser null

    if (nom != null)
    {
        Console.WriteLine(nom.Length); // OK aquí dins
    }
  `),

  subTitle("Només per a int?, double?, bool?, char?"),
  dataTable(
    ["Membre", "Què fa"],
    [
      ["`.HasValue`", "`true` si conté un valor."],
      ["`.Value`", "Retorna el valor. Peta si és null!"],
    ],
    [1300, 3600]
  ),
  code(`
    int? nota = null;

    if (nota.HasValue)   // o bé: if (nota != null)
    {
        Console.WriteLine(nota.Value);
    }
  `),
  alert("`.HasValue` i `.Value` NOMÉS existeixen als tipus per valor (`int?`, `double?`...). En un `string?` fes servir `!= null`."),
]));

// ----------------------------------------------------------------
cards.push(card("9. Operadors de Null (??, ??=, ?.)", [
  dataTable(
    ["Operador", "Nom", "Què fa"],
    [
      ["`??`", "Fusió", "Si és null, agafa el de la dreta."],
      ["`??=`", "Fusió + assigna", "Assigna només si val null."],
      ["`?.`", "Accés segur", "Accedeix només si no és null."],
      ["`?[ ]`", "Índex segur", "Com `?.` però amb índexs."],
      ["`!`", "Perdó de null", "Calla el compilador. No comprova res."],
    ],
    [700, 1450, 2750]
  ),

  subTitle("?? — valor per defecte"),
  code(`
    string? nom = Console.ReadLine();
    string segur = nom ?? "Anònim"; // mai null

    int? nota = null;
    int notaFinal = nota ?? 0; // 0
  `),

  subTitle("??= — assignar si està buit"),
  code(`
    int? intents = null;
    intents ??= 3; // ara val 3
    intents ??= 9; // segueix valent 3
  `),

  subTitle("?. — accedir sense petar"),
  code(`
    string? text = Console.ReadLine();

    int? l1 = text?.Length; // null si text és null
    int  l2 = text?.Length ?? 0; // 0 (combinat!)
  `),
  alert("El `!` (com ara `text!.Length`) només calla el compilador: si de debò era null, peta igualment amb `NullReferenceException`. Fes-lo servir només quan estiguis segur al 100%."),
]));

// ----------------------------------------------------------------
cards.push(card("10. Strings: null, buit o espais", [
  dataTable(
    ["Valor", "Significat"],
    [
      ["`null`", "No apunta enlloc (no hi ha text)."],
      ["`\"\"`", "Text buit, però existeix."],
      ["`\"   \"`", "Només espais en blanc."],
    ],
    [1000, 3900]
  ),
  code(`
    string.IsNullOrEmpty(s);      // null o ""
    string.IsNullOrWhiteSpace(s); // + només espais
  `),
  body("Patró recomanat per llegir dades del teclat:"),
  code(`
    Console.Write("Nom: ");
    string? nom = Console.ReadLine();

    if (string.IsNullOrWhiteSpace(nom))
    {
        Console.WriteLine("Nom no vàlid!");
    }
    else
    {
        Console.WriteLine($"Hola, {nom}!"); // ja no és null
    }
  `),
  info("Alternativa ràpida quan el buit no importa: `string nom = Console.ReadLine() ?? \"\";`"),
]));

// ----------------------------------------------------------------
cards.push(card("11. Errors del Compilador i Trampes", [
  dataTable(
    ["Codi", "Què t'està dient"],
    [
      ["`CS8600`", "Assignes un possible null a una variable sense `?`."],
      ["`CS8602`", "Uses una variable que pot ser null sense comprovar-la."],
      ["`CS8625`", "Assignes `null` a un tipus que no admet null."],
      ["`CS0165`", "Uses una variable abans de donar-li cap valor."],
    ],
    [900, 4000]
  ),
  subTitle("Trampes freqüents"),
  bullet("`=` assigna, `==` compara."),
  bullet("`10 / 3` dóna `3`, no `3.33`: divisió entera."),
  bullet("`Console.ReadLine()` retorna `string?`, no `string`."),
  bullet("C# distingeix majúscules: `Edat` ≠ `edat`."),
  bullet("Posar `?` a tot «perquè no es queixi» només trasllada el problema."),
]));

build({
  title: "Xuleta C# 1: Conceptes Bàsics",
  subtitle: "Variables · Operadors · Math · Condicionals · Funcions · Mode Nullable (?)",
  cards,
  output: path.join(__dirname, "XuletaBàsica.docx"),
});
