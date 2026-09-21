// Xuleta 1 de C#: conceptes bàsics (versió Typst).
// Compilar:  typst compile "C#/XuletaBàsica.typ"

#import "../tools/xuleta.typ": *

#show: xuleta.with(
  title: "Xuleta C# 1: Conceptes Bàsics",
  subtitle: "Variables · Operadors · Math · Condicionals · Funcions · Mode Nullable (?)",
)

// ================================================================
#card(1, "Estructura Bàsica i E/S")[
  ```cs
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
  ```
  Interpolació de text (molt més còmode que concatenar amb `+`):
  ```cs
  string nom = "Anna";
  int edat = 17;
  Console.WriteLine($"{nom} té {edat} anys");
  ```
]

// ================================================================
#card(2, "Constants, Variables i Tipus")[
  #taula(
    (auto, auto, 1fr),
    th[Tipus], th[Exemple], th[Conversió des de string],
    `int`, [10, -5], `Convert.ToInt32(s)`,
    `double`, [9.99], `Convert.ToDouble(s)`,
    `string`, ["Hola"], [—],
    `char`, ['A'], `Convert.ToChar(s)`,
    `bool`, [true], `Convert.ToBoolean(s)`,
  )
  #v(3pt)
  Constants: `const double PI = 3.1416;` — el seu valor no es pot canviar.

  #sub[Límits (MinValue / MaxValue)]
  ```cs
  int maxim = int.MaxValue; // 2.147.483.647
  int minim = int.MinValue; // -2.147.483.648
  ```

  #sub[Divisió entera: el parany clàssic]
  ```cs
  int a = 10 / 3;           // 3  (es perden els decimals!)
  double b = 10.0 / 3;      // 3,33...
  double c = (double)x / y; // amb variables int
  ```
  #avis[Si els dos operands són `int`, el resultat també és `int`. Cal que almenys un sigui `double`.]

  #sub[Conversió segura: TryParse]
  `Convert.ToInt32` peta si l'usuari escriu lletres. `TryParse` no: retorna `true`/`false`.
  ```cs
  string? entrada = Console.ReadLine();

  if (int.TryParse(entrada, out int num)) {
      Console.WriteLine($"Correcte: {num}");
  } else {
      Console.WriteLine("Això no és un número!");
  }
  ```
  #nota[`TryParse` accepta un `string?` sense queixar-se: ja preveu que pugui ser null.]
]

// ================================================================
#card(3, "Operadors i Precedència")[
  Ordre d'execució de dalt a baix (major prioritat primer).
  #taula(
    (auto, auto, 1fr),
    th[Prio.], th[Tipus], th[Operadors],
    [1 (Max)], [Parèntesis], `( )`,
    [2], [Unaris], [`++` `--` `!` (NOT) `-` (negatiu)],
    [3], [Multiplicatius], [`*` `/` `%` (mòdul)],
    [4], [Additius], [`+` `-`],
    [5], [Relacionals], [`<` `>` `<=` `>=`],
    [6], [Igualtat], [`==` `!=`],
    [7], [Lògic AND], `&&`,
    [8], [Lògic OR], `||`,
    [9], [Fusió amb null], `??`,
    [10], [Condicional ternari], `? :`,
    [11 (Min)], [Assignació], [`=` `+=` `-=` `*=` `??=`],
  )
  #v(3pt)
  #avis[El mòdul (%) dóna el residu de la divisió entera: 10 % 3 = 1. Útil per saber si un número és parell: `n % 2 == 0`.]

  #sub[Operador ternari (if compacte)]
  `condició ? valorSiCert : valorSiFals`
  ```cs
  string tipus = (edat >= 18) ? "Major" : "Menor";
  ```
]

// ================================================================
#card(4, "Math i Aleatoris")[
  #sub[Aleatoris]
  ```cs
  Random rnd = new Random();   // declarar 1 sol cop
  int dau = rnd.Next(1, 7);    // entre 1 i 6
  double r = rnd.NextDouble(); // entre 0.0 i 1.0
  ```
  #avis[`rnd.Next(1, 7)` inclou l'1 però MAI el 7: el límit superior queda fora.]

  #sub[Funcions habituals]
  - `Math.Abs(x)` — valor absolut.
  - `Math.Pow(b, e)` — potència (b elevat a e).
  - `Math.Sqrt(x)` — arrel quadrada.
  - `Math.Round(x, 2)` — arrodonir a 2 decimals.
  - `Math.Max(a, b)` / `Math.Min(a, b)` — el més gran / petit.

  #sub[Exemple: distància entre 2 punts]
  dist = √((x₂-x₁)² + (y₂-y₁)²)
  ```cs
  double dx = x2 - x1;
  double dy = y2 - y1;
  double dist = Math.Sqrt(Math.Pow(dx, 2)
                        + Math.Pow(dy, 2));
  ```
]

// ================================================================
#card(5, "Condicionals")[
  ```cs
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
  ```
  #avis[Per comparar si dos valors són iguals cal `==` (doble igual). Amb `=` li estaries assignant el valor!]
]

// ================================================================
#card(6, "Funcions (Mètodes)")[
  Permeten reutilitzar codi i separar la lògica.
  ```cs
  // 1. DEFINICIÓ (fora del Main)
  public static double CalculaArea(double radi)
  {
      return Math.PI * Math.Pow(radi, 2);
  }

  // 2. CRIDA (dins del Main)
  double area = CalculaArea(5.5);
  ```
  Si una funció no retorna res, el tipus de retorn és `void`.
  #nota[Si un paràmetre pot arribar buit, declara'l amb `?`: `void Saluda(string? nom)`.]
]

// ================================================================
// Bloc a tota l'amplada: resum dels operadors de null
#ample[
  #text(fill: primary, weight: "bold", size: 10pt)[Resum ràpid: operadors de null]
  #v(4pt)
  #taula(
    (auto, auto, 1fr, auto, 1fr),
    th[Operador], th[Nom], th[Què fa], th[Exemple], th[Resultat],
    `??`, [Fusió], [Si és null, agafa el de la dreta.], `nom ?? "Anònim"`, [Mai null.],
    `??=`, [Fusió + assigna], [Assigna només si val null.], `intents ??= 3;`, [Omple el forat un sol cop.],
    `?.`, [Accés segur], [Accedeix només si no és null.], `text?.Length`, [`null` si `text` és null.],
    `?[ ]`, [Índex segur], [Com `?.` però amb índexs.], `dades?[0]`, [`null` si `dades` és null.],
    `!`, [Perdó de null], [Calla el compilador, no comprova res.], `text!.Length`, [Peta igual si era null.],
  )
]

// ================================================================
#card(7, "Mode Nullable: el compilador vigila")[
  `null` vol dir «cap valor», «buit», «encara no assignat». No és ni `0` ni `""`.

  Als projectes de classe hi ha un fitxer `Directory.Build.props` que activa el mode Nullable:
  ```xml
  <Project>
    <PropertyGroup>
      <Nullable>enable</Nullable>
      <WarningsAsErrors>Nullable</WarningsAsErrors>
    </PropertyGroup>
  </Project>
  ```
  A partir d'aquí, una variable només pot valer `null` si el seu tipus acaba amb `?`. I els avisos de
  null passen a ser ERRORS: el programa no compila.
  #v(3pt)
  #taula(
    (auto, 1fr),
    th[Declaració], th[Pot ser null?],
    `int edat`, [NO], `int? edat`, [SÍ],
    `string nom`, [NO], `string? nom`, [SÍ],
  )
  ```cs
  int     a = null; // ERROR
  int?    b = null; // OK
  string  c = null; // ERROR
  string? d = null; // OK
  ```
  #postit[Regla d'or: si una dada pot no existir (encara no hi és, l'usuari no l'ha escrita...),
  declara-la amb `?`. Si sempre hi ha d'haver valor, deixa-la sense `?`.]
]

// ================================================================
#card(8, "Comprovar abans d'usar")[
  Una variable amb `?` no es pot usar directament: primer cal comprovar-la. El compilador segueix el
  teu codi i, dins de l'`if`, ja sap que hi ha valor.
  ```cs
  string? nom = Console.ReadLine();

  Console.WriteLine(nom.Length); // ERROR: pot ser null

  if (nom != null)
  {
      Console.WriteLine(nom.Length); // OK aquí dins
  }
  ```
  #sub[Només per a int?, double?, bool?, char?]
  #taula(
    (auto, 1fr),
    th[Membre], th[Què fa],
    `.HasValue`, [`true` si conté un valor.],
    `.Value`, [Retorna el valor. Peta si és null!],
  )
  ```cs
  int? nota = null;

  if (nota.HasValue)   // o bé: if (nota != null)
  {
      Console.WriteLine(nota.Value);
  }
  ```
  #avis[`.HasValue` i `.Value` NOMÉS existeixen als tipus per valor (`int?`, `double?`...).
  En un `string?` fes servir `!= null`.]
]

// ================================================================
#card(9, "Operadors de Null a la pràctica")[
  #sub[?? — valor per defecte]
  ```cs
  string? nom = Console.ReadLine();
  string segur = nom ?? "Anònim"; // mai null

  int? nota = null;
  int notaFinal = nota ?? 0;      // 0
  ```

  #sub[??= — assignar si està buit]
  ```cs
  int? intents = null;
  intents ??= 3; // ara val 3
  intents ??= 9; // segueix valent 3
  ```

  #sub[?. — accedir sense petar]
  ```cs
  string? text = Console.ReadLine();

  int? l1 = text?.Length;      // null si text és null
  int  l2 = text?.Length ?? 0; // 0 (combinat!)
  ```
  #avis[El `!` (com ara `text!.Length`) només calla el compilador: si de debò era null, peta igualment
  amb `NullReferenceException`. Fes-lo servir només quan estiguis segur al 100%.]
]

// ================================================================
#card(10, "Strings: null, buit o espais")[
  #taula(
    (auto, 1fr),
    th[Valor], th[Significat],
    `null`, [No apunta enlloc (no hi ha text).],
    `""`, [Text buit, però existeix.],
    `"   "`, [Només espais en blanc.],
  )
  ```cs
  string.IsNullOrEmpty(s);      // null o ""
  string.IsNullOrWhiteSpace(s); // + només espais
  ```
  Patró recomanat per llegir dades del teclat:
  ```cs
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
  ```
  #nota[Alternativa ràpida quan el buit no importa: `string nom = Console.ReadLine() ?? "";`]
]

// ================================================================
#colbreak() // equilibra l'última pàgina: aquesta targeta va a la columna dreta
#card(11, "Errors del Compilador i Trampes")[
  #taula(
    (auto, 1fr),
    th[Codi], th[Què t'està dient],
    `CS8600`, [Assignes un possible null a una variable sense `?`.],
    `CS8602`, [Uses una variable que pot ser null sense comprovar-la.],
    `CS8625`, [Assignes `null` a un tipus que no admet null.],
    `CS0165`, [Uses una variable abans de donar-li cap valor.],
  )
  #sub[Trampes freqüents]
  - `=` assigna, `==` compara.
  - `10 / 3` dóna `3`, no `3.33`: divisió entera.
  - `Console.ReadLine()` retorna `string?`, no `string`.
  - C\# distingeix majúscules: `Edat` ≠ `edat`.
  - Posar `?` a tot «perquè no es queixi» només trasllada el problema.
]
