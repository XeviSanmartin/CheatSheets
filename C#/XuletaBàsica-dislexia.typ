// Versió per a alumnes amb dislèxia. El contingut és el mateix que a C#/XuletaBàsica.typ;
// el que canvia és la plantilla (tools/xuleta-dislexia.typ) i la maquetació.
// Versió per a alumnes amb dislèxia (una columna, 12 pt, fons crema).
// Compilar:  typst compile --font-path tools/fonts "C#/XuletaBàsica-dislexia.typ"

#import "../tools/xuleta-dislexia.typ": *

#show: xuleta.with(
  serie: "Xuleta de C# · primer curs",
  title: "Conceptes bàsics",
  badge: "C#",
  mida-codi: 11pt,
  accent: violeta,
  tags: ("Variables", "Operadors", "Mode Nullable ?", "Condicionals", "Math", "Funcions"),
)

// Mapa del full: seccions amb pàgina (calculada sola) i llegenda de les caixes.
#mapa()

// Caixa de color amb text centrat (per als diagrames).
#let caixa(body, fill: violeta, color: auto, h: 22.5pt, stroke: none, size: 10.9pt) = box(
  width: 100%, height: h, radius: 3pt, fill: fill, stroke: stroke,
  align(center + horizon, text(weight: "bold", size: size,
    fill: if color == auto { text-sobre(fill) } else { color }, body)),
)

#seccio("Fonaments", color: violeta)

#card(1, "Estructura bàsica i E/S")[
  ```cs
  static void Main(string[] args)
  {
      // el programa comença aquí
  }
  ```
  #sub[Sortida]
  ```cs
  Console.Write("Hola ");     // sense salt de línia
  Console.WriteLine("món!"); // amb salt de línia
  Console.WriteLine("Adéu");
  ```
  #sortida[Hola món! \ Adéu]

  #sub[Entrada]
  ```cs
  // ReadLine retorna string? (pot ser null!)
  string? s = Console.ReadLine();

  // Versió segura: mai serà null
  string t = Console.ReadLine() ?? "";

  Console.Clear();  // neteja la pantalla
  ```
  #sub[Interpolació: text amb variables]
  Molt més còmode que concatenar amb `+`. Fixa't en el `$` de davant.
  ```cs
  string nom = "Anna";
  int edat = 17;
  Console.WriteLine($"{nom} té {edat} anys");
  ```
  #sortida[Anna té 17 anys]
]

#card(2, "Constants, variables i tipus")[
  #taula(
    (auto, auto, 1fr),
    th[Tipus], th[Exemple], th[Conversió des de string],
    `int`, [10, -5], `Convert.ToInt32(s)`,
    `double`, [9.99], `Convert.ToDouble(s)`,
    `string`, ["Hola"], [—],
    `char`, ['A'], `Convert.ToChar(s)`,
    `bool`, [true], `Convert.ToBoolean(s)`,
  )
  Constants: `const double PI = 3.1416;` — el seu valor no es pot canviar.
  #nota[`Convert.ToInt32` peta si l'usuari escriu lletres. Per llegir números del teclat, fes
  servir `TryParse`: #ref-targeta(3).]

  #sub[Límits (MinValue / MaxValue)]
  ```cs
  int maxim = int.MaxValue; // 2.147.483.647
  int minim = int.MinValue; // -2.147.483.648
  ```

  #sub[Divisió entera: el parany clàssic]
  #grid(
    columns: (auto, auto, auto, 1fr), column-gutter: 5pt, row-gutter: 5pt, align: horizon,
    `10 / 3`, fletxa(), pill(fill: vermell.lighten(86%), color: vermell-f)[#marca-error(w: 6pt) 3], text(size: 10.9pt)[els decimals es perden!],
    `10.0 / 3`, fletxa(), pill(fill: verd.lighten(84%), color: verd-f)[#marca-ok(w: 6pt) 3,33...], text(size: 10.9pt)[un dels dos és `double`],
  )
  ```cs
  double c = (double)x / y; // amb variables int
  ```
  #avis[Si els dos operands són `int`, el resultat també és `int`. Cal que almenys un sigui `double`.]
]

#card(3, "Llegir números: TryParse")[
  `Convert.ToInt32` peta si l'usuari escriu lletres. `TryParse` no: retorna `true` o `false`.
  ```cs
  string? entrada = Console.ReadLine();

  if (int.TryParse(entrada, out int num))
  {
      Console.WriteLine($"Correcte: {num}");
  }
  else
  {
      Console.WriteLine("Això no és un número!");
  }
  ```
  Dues execucions del mateix programa:
  #grid(columns: (1fr, 1fr), column-gutter: 6pt,
    sortida[42 \ Correcte: 42],
    sortida[hola \ Això no és un número!],
  )
  Amb decimals funciona igual: `double.TryParse(entrada, out double preu)`.
  #nota[`TryParse` accepta un `string?` sense queixar-se: ja preveu que pugui ser null.]
]

#card(4, "Operadors i precedència")[
  Si no hi ha parèntesis, l'ordre de dalt mana sobre el de baix.
  #postit[El 90% dels casos: *( )* → *\* / %* → *+ −* → *comparacions* → *&& i ||* → *=*.]
  #let nivells = (
    ("Parèntesis", [`( )`]),
    ("Unaris", [`++` `--` `!` `-` (negatiu)]),
    ("Multiplicatius", [`*` `/` `%` (mòdul)]),
    ("Additius", [`+` `-`]),
    ("Relacionals", [`<` `>` `<=` `>=`]),
    ("Igualtat", [`==` `!=`]),
    ("I lògic (AND)", [`&&`]),
    ("O lògic (OR)", [`||`]),
    ("Fusió amb null", [`??`]),
    ("Ternari", [`? :`]),
    ("Assignació", [`=` `+=` `-=` `*=` `??=`]),
  )
  #let escala = gradient.linear(turquesa.darken(35%), turquesa.lighten(35%))
  #taula(
    (auto, auto, 1fr),
    th[Prioritat], th[Tipus], th[Operadors],
    ..nivells.enumerate().map(((i, n)) => (
      rodona(r: 5.5pt, size: 10.2pt, fill: escala.sample(i * 10%))[#(i + 1)],
      n.at(0),
      n.at(1),
    )).flatten(),
  )
  #avis[El mòdul `%` dona el residu de la divisió entera: `10 % 3` és `1`. Serveix per saber si un número és parell: `n % 2 == 0`.]

  #sub[Operador ternari (un if en una línia)]
  `condició ? valorSiCert : valorSiFals`
  ```cs
  string tipus = (edat >= 18) ? "Major" : "Menor";
  ```
]

#seccio("Els nulls", color: rosa)

#card(5, "Mode Nullable: el compilador vigila", color: rosa)[
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
  A partir d'aquí, una variable només pot valer `null` si el seu tipus acaba amb `?`. I els avisos
  de null passen a ser *errors*: el programa no compila.
  #taula(
    (1fr, auto, auto),
    th[Pot valer null?], th[Sense `?`], th[Amb `?`],
    [Número], [`int edat` #h(2pt) #no], [`int? edat` #h(2pt) #si],
    [Text], [`string nom` #h(2pt) #no], [`string? nom` #h(2pt) #si],
  )
  ```cs
  int     a = null; // ERROR
  int?    b = null; // OK
  string  c = null; // ERROR
  string? d = null; // OK
  ```
  #postit[Si una dada pot no existir (encara no hi és, l'usuari no l'ha escrita...), declara-la
  amb `?`. Si sempre hi ha d'haver valor, deixa-la sense `?`.]
]

#card(6, "Comprovar abans d'usar", color: rosa)[
  Una variable amb `?` no es pot usar directament perquè podria ser null: primer cal comprovar-la.
  El compilador segueix el teu codi i, dins de l'`if`, ja sap que hi ha valor.
  ```cs
  string? nom = Console.ReadLine();

  Console.WriteLine(nom.Length); // ERROR

  if (nom != null)
  {
      Console.WriteLine(nom.Length); // OK
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

#card(7, "Operadors de null a la pràctica", color: rosa)[
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
  #avis[El `!` (com a `text!.Length`) només calla el compilador: si de debò era null, peta igualment
  amb `NullReferenceException`. Fes-lo servir només quan n'estiguis segur al 100%.]
]

// Resum dels operadors de null, dins de la mateixa columna (abans era una franja flotant).
#card(8, "Resum: els operadors de null", color: rosa)[
  #taula(
    (auto, auto, 1fr),
    th[Operador], th[Exemple], th[Què en surt],
    [`??` #linebreak() #text(size: 10.2pt)[fusió]], `nom ?? "Anònim"`, [Si és null, agafa el de la dreta. Mai és null.],
    [`??=` #linebreak() #text(size: 10.2pt)[fusió i assigna]], `intents ??= 3;`, [Assigna només si val null.],
    [`?.` #linebreak() #text(size: 10.2pt)[accés segur]], `text?.Length`, [Accedeix només si no és null; si no, dona null.],
    [`?[ ]` #linebreak() #text(size: 10.2pt)[índex segur]], `dades?[0]`, [Com `?.`, però amb índexs.],
    [#marca-error(w: 8pt) `!` #linebreak() #text(size: 10.2pt)[perdó de null]], `text!.Length`, [Calla el compilador i peta igual si era null.],
  )
  #avis[L'únic de la llista que no et protegeix és `!`. Fes-lo servir només quan estiguis segur al 100%.]
]

#card(9, "Strings: null, buit o espais", color: rosa)[
  #let etiqueta(t) = text(size: 10pt, fill: ink.lighten(25%), t)
  #grid(
    columns: (1fr, 1fr, 1fr), column-gutter: 6pt, row-gutter: 3pt, align: center,
    `null`, `""`, `"   "`,
    box(width: 100%, height: 18pt, radius: 3pt, stroke: (paint: rosa, dash: "dashed", thickness: 0.9pt),
      align(center + horizon, text(size: 10.2pt, fill: rosa, weight: "bold")[no hi ha res])),
    box(width: 100%, height: 18pt, radius: 3pt, fill: rosa.lighten(85%), stroke: 1pt + rosa),
    box(width: 100%, height: 18pt, radius: 3pt, fill: rosa.lighten(85%), stroke: 1pt + rosa,
      align(center + horizon, text(font: mono, size: 13pt, fill: rosa, weight: "bold")[· · ·])),
    etiqueta[no apunta enlloc], etiqueta[text buit, però existeix], etiqueta[només espais],
  )
  #taula(
    (1fr, auto, auto),
    th[Si `s` val...], th[`IsNullOrEmpty(s)`], th[`IsNullOrWhiteSpace(s)`],
    `null`, align(center, si), align(center, si),
    `""`, align(center, si), align(center, si),
    `"   "`, align(center, no), align(center, si),
    `"Anna"`, align(center, no), align(center, no),
  )
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
      Console.WriteLine($"Hola, {nom}!"); // segur
  }
  ```
  #nota[Alternativa ràpida quan el buit no importa: `string nom = Console.ReadLine() ?? "";`]
]

#seccio("Control, funcions i errors", color: indi)

#card(10, "Math i aleatoris", color: taronja)[
  #sub[Aleatoris]
  ```cs
  Random rnd = new Random();   // declarar 1 sol cop
  int dau = rnd.Next(1, 7);    // entre 1 i 6
  double r = rnd.NextDouble(); // entre 0.0 i 1.0
  ```
  // Recta de valors de rnd.Next(1, 7)
  #block(above: 6pt, below: 4pt)[
    #grid(
      columns: (1fr,) * 7, column-gutter: 2.5pt, row-gutter: 3pt,
      ..range(1, 7).map(i => caixa(fill: taronja)[#i]),
      caixa(fill: vermell.lighten(88%), color: vermell, stroke: (paint: vermell, dash: "dashed", thickness: 0.8pt))[#strike(stroke: 1.2pt)[7]],
      grid.cell(colspan: 6, align(center, text(size: 10.2pt, fill: taronja.darken(20%), weight: "bold")[
        `rnd.Next(1, 7)` pot donar qualsevol d'aquests
      ])),
      align(center, text(size: 10.2pt, fill: vermell, weight: "bold")[MAI]),
    )
  ]
  #avis[`rnd.Next(1, 7)` inclou l'1 però MAI el 7: el límit superior queda fora.]

  #sub[Funcions habituals]
  #taula(
    (1fr, auto, auto),
    th[Què fa], th[Exemple], th[Dona],
    [Valor absolut], `Math.Abs(-5)`, [5],
    [Potència ($2^3$)], `Math.Pow(2, 3)`, [8],
    [Arrel quadrada], `Math.Sqrt(16)`, [4],
    [Arrodonir a 2 decimals], `Math.Round(3.14159, 2)`, [3,14],
    [El més gran], `Math.Max(4, 9)`, [9],
    [El més petit], `Math.Min(4, 9)`, [4],
  )

  #sub[Exemple: distància entre 2 punts]
  $ "dist" = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2) $
  ```cs
  double dx = x2 - x1;
  double dy = y2 - y1;
  double dist = Math.Sqrt(Math.Pow(dx, 2)
                        + Math.Pow(dy, 2));
  ```
]

#card(11, "Condicionals", color: indi)[
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
  Es comprova de dalt a baix i s'entra només al *primer* bloc que es compleix:
  #block(above: 5pt, below: 4pt)[
    #grid(
      columns: (5fr, 4fr, 1.6fr), column-gutter: 1.5pt, row-gutter: 2pt,
      caixa(fill: vermell.lighten(15%))[Suspens],
      caixa(fill: verd)[Aprovat],
      caixa(fill: indi.darken(10%))[Excel·lent],
      text(size: 10pt)[0], text(size: 10pt)[5], grid(columns: (1fr, auto), text(size: 10pt)[9], text(size: 10pt)[10]),
    )
  ]
  #avis[Per comparar si dos valors són iguals cal `==` (doble igual). Amb `=` li estaries assignant el valor!]

  #sub[Combinar condicions]
  #taula(
    (auto, auto, 1fr),
    th[Operador], th[Es llegeix], th[És cert quan...],
    `&&`, [I], [es compleixen *les dues*],
    `||`, [O], [se'n compleix *almenys una*],
    `!`, [NO], [la condició és falsa],
  )
  ```cs
  bool notable = nota >= 7 && nota < 9;
  bool capDeSetmana = dia == 6 || dia == 7;
  bool suspes = !(nota >= 5);    // igual que nota < 5

  if (capDeSetmana && !suspes)
  {
      Console.WriteLine("A descansar!");
  }
  ```
]

#card(12, "Funcions (mètodes)", color: turquesa)[
  Permeten reutilitzar codi i separar la lògica. Una funció rep dades i en torna un resultat:
  #block(above: 6pt, below: 6pt, align(center, grid(
    columns: 5, column-gutter: 4pt, align: horizon,
    stack(spacing: 3pt, pill(fill: turquesa.lighten(80%), color: turquesa-f, size: 11.6pt)[5.5],
      text(size: 10pt, fill: ink.lighten(30%))[paràmetre]),
    fletxa(),
    box(fill: turquesa-f, radius: 5pt, inset: (x: 8pt, y: 6pt),
      text(font: mono, size: 10.9pt, weight: "bold", fill: white)[CalculaArea]),
    fletxa(),
    stack(spacing: 3pt, pill(fill: turquesa.lighten(80%), color: turquesa-f, size: 11.6pt)[95,03],
      text(size: 10pt, fill: ink.lighten(30%))[valor de retorn]),
  )))
  ```cs
  // 1. DEFINICIÓ (fora del Main)
  public static double CalculaArea(double radi)
  {
      return Math.PI * Math.Pow(radi, 2);
  }

  // 2. CRIDA (dins del Main)
  double area = CalculaArea(5.5);
  ```
  #sub[Funcions que no retornen res: void]
  ```cs
  public static void Saluda(string nom)
  {
      Console.WriteLine($"Hola, {nom}!");
  }

  Saluda("Anna");   // no cal guardar res
  ```
  #sortida[Hola, Anna!]
  #nota[Si un paràmetre pot arribar buit, declara'l amb `?`: `void Saluda(string? nom)`.]
]

#pagebreak(weak: true)

#ample(title: [13 · Errors del compilador i trampes], color: vermell)[
  #taula(
    (auto, 1fr),
    th[Codi], th[Què t'està dient],
    pill(fill: vermell-f)[CS8600], [Assignes un possible null a una variable sense `?`.],
    pill(fill: vermell-f)[CS8602], [Uses una variable que pot ser null sense comprovar-la.],
    pill(fill: vermell-f)[CS8625], [Assignes `null` a un tipus que no admet null.],
    pill(fill: vermell-f)[CS0165], [Uses una variable abans de donar-li cap valor.],
  )
  #text(font: titular, size: 13.8pt, fill: vermell-f)[Trampes freqüents]
  #v(-3pt)
  - `=` assigna i `==` compara; `10 / 3` dona `3`, no `3.33`.
  - `Console.ReadLine()` retorna `string?`, no `string`.
  - C\# distingeix majúscules: `Edat` i `edat` són variables diferents.
  - Posar `?` a tot «perquè no es queixi» només trasllada el problema.
]
