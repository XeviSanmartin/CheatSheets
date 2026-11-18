// Versió per a alumnes amb dislèxia. El contingut és el mateix que a C#/XuletaNulls.typ;
// el que canvia és la plantilla (tools/xuleta-dislexia.typ) i la maquetació:
// una sola columna, 12 punts, interlineat ample i fons crema.
// Compilar:  typst compile --font-path tools/fonts "C#/XuletaNulls-dislexia.typ"

#import "../tools/xuleta-dislexia.typ": *

#show: xuleta.with(
  serie: "Xuleta de C# · primer curs",
  title: "Els nulls",
  badge: "C#",
  mida-codi: 11pt,
  accent: rosa,
  tags: ("Mode Nullable ?", "Comprovar", "??  ??=  ?.", "Strings buits", "Errors CS86xx"),
)

#mapa(color: rosa)

// Pas del camí segur: número, títol i cos.
#let pas(n, title, body) = block(width: 100%, above: 5pt, below: 10pt)[
  #grid(
    columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
    rodona[#n], text(font: titular, size: 13pt, fill: rosa-f)[#title],
  )
  #body
]
// Fletxa cap avall entre els passos.
#let baixa = align(center, block(above: 3pt, below: 10pt,
  box(width: 15pt, height: 12pt, polygon(fill: rosa, (0pt, 0pt), (15pt, 0pt), (7.5pt, 12pt)))))

#seccio("Què vol dir null", color: rosa)

#card(1, "Mode Nullable: el compilador vigila", color: rosa)[
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
  amb `?`. Si sempre hi ha d'haver valor, deixa-la sense `?`. Posar `?` a tot només trasllada el
  problema més endavant.]
]

#card(2, "El camí segur, en tres passos", color: rosa)[
  #pas(1, "Declara-la amb ?")[
    ```cs
    string? nom = Console.ReadLine(); // pot ser null
    int? nota = null;                 // encara sense nota
    ```
  ]
  #baixa
  #pas(2, "Comprova-la")[
    ```cs
    if (nom != null)
    {
        Console.WriteLine(nom.Length);
    }
    ```
  ]
  #baixa
  #pas(3, "Usa-la tranquil·lament")[
    Dins de l'`if`, el compilador ja sap que hi ha valor.
    ```cs
    nom.Length // cap NullReferenceException
    ```
  ]
  #nota[Els tres passos són sempre els mateixos: declarar, comprovar i usar. Si te'n saltes el
  segon, el compilador t'atura.]
]

// Evita que el títol quedi sol al peu de la pàgina.
#pagebreak(weak: true)

#card(3, "Comprovar abans d'usar", color: rosa)[
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

#seccio("Els operadors de null", color: violeta)

#card(4, "Els operadors a la pràctica", color: violeta)[
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

#card(5, "Resum: els operadors de null", color: violeta)[
  #taula(
    (auto, auto, 1fr),
    th[Operador], th[Exemple], th[Què en surt],
    [`??` #linebreak() #text(size: 10.2pt)[fusió]], `nom ?? "Anònim"`, [Si és null, agafa el de la dreta. Mai és null.],
    [`??=` #linebreak() #text(size: 10.2pt)[fusió i assigna]], `intents ??= 3;`, [Assigna només si val null.],
    [`?.` #linebreak() #text(size: 10.2pt)[accés segur]], `text?.Length`, [Accedeix només si no és null; si no, dona null.],
    [`?[ ]` #linebreak() #text(size: 10.2pt)[índex segur]], `dades?[0]`, [Com `?.`, però amb índexs.],
    [#marca-error(w: 11.6pt) `!` #linebreak() #text(size: 10.2pt)[perdó de null]], `text!.Length`, [Calla el compilador i peta igual si era null.],
  )
  #avis[L'únic de la llista que no et protegeix és `!`. Fes-lo servir només quan estiguis segur al
  100%.]
]

// Evita que el títol quedi sol al peu de la pàgina.
#pagebreak(weak: true)

#card(6, "Números que poden faltar", color: violeta)[
  Un `int?` no és un `int`: fins que no li treguis el null, no el pots fer servir per calcular.
  ```cs
  int? nota = null;

  int suma = nota + 1;        // ERROR: int? no és int
  int suma2 = (nota ?? 0) + 1; // OK: 1
  ```
  #sub[Comparar i imprimir]
  #taula(
    (auto, 1fr),
    th[Si `nota` és null], th[Què passa],
    `nota > 5`, [És `false`. Cap comparació és certa amb null, ni `nota <= 5`.],
    `nota == null`, [És `true`. Aquesta és la comprovació bona.],
    `Console.WriteLine(nota)`, [Escriu una línia buida, no la paraula null.],
  )
  #avis[Amb null, `nota > 5` i `nota <= 5` són falsos tots dos alhora. Comprova primer que hi hagi
  valor i després compara.]
]

// La secció comença en una pàgina nova: així la targeta 7 hi cap sencera.
#pagebreak(weak: true)

#seccio("Textos i teclat", color: turquesa)

#card(7, "Strings: null, buit o espais", color: turquesa)[
  #let etiqueta(t) = text(size: 10pt, fill: ink.lighten(25%), t)
  #grid(
    columns: (1fr, 1fr, 1fr), column-gutter: 6pt, row-gutter: 3pt, align: center,
    `null`, `""`, `"   "`,
    box(width: 100%, height: 27pt, radius: 3pt, stroke: (paint: turquesa, dash: "dashed", thickness: 0.9pt),
      align(center + horizon, text(size: 10.2pt, fill: turquesa-f, weight: "bold")[no hi ha res])),
    box(width: 100%, height: 27pt, radius: 3pt, fill: turquesa.lighten(85%), stroke: 1pt + turquesa),
    box(width: 100%, height: 27pt, radius: 3pt, fill: turquesa.lighten(85%), stroke: 1pt + turquesa,
      align(center + horizon, text(font: mono, size: 13pt, fill: turquesa-f, weight: "bold")[· · ·])),
    etiqueta[no apunta enlloc], etiqueta[text buit, però existeix], etiqueta[només espais],
  )
  #taula(
    (auto, 1fr, 1fr),
    th[`s`], th[`IsNullOrEmpty`], th[`IsNullOrWhiteSpace`],
    `null`, align(center, si), align(center, si),
    `""`, align(center, si), align(center, si),
    `"   "`, align(center, no), align(center, si),
    `"Anna"`, align(center, no), align(center, no),
  )
  #nota[Les dues funcions ja comproven el null elles mateixes: no cal fer `if (s != null && ...)`.]
]

// Evita que el títol quedi sol al peu de la pàgina.
#pagebreak(weak: true)

#card(8, "Llegir del teclat amb seguretat", color: turquesa)[
  Amb el mode Nullable actiu, tot el que escriu l'usuari arriba com a text que pot no existir:
  `Console.ReadLine()` retorna `string?`, mai `string`.
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
  #sortida[Nom: #h(1em) Anna #linebreak() Hola, Anna!]
  #nota[Drecera quan el buit no importa: `string nom = Console.ReadLine() ?? "";`. El text pot
  quedar buit, però ja no és null i es pot usar directament.]
]

// Perquè la taula no es parteixi entre dues pàgines.
#pagebreak(weak: true)

#card(9, "Imprimir i comparar textos", color: turquesa)[
  Amb un `string?`, algunes coses funcionen encara que valgui null i altres peten. La diferència és
  si el null ha de fer alguna feina o només s'ha de mirar.
  #taula(
    (auto, auto, 1fr),
    th[Amb `nom` a null], th[], th[Per què],
    `Console.WriteLine(nom)`, align(center, si), [Escriu una línia buida.],
    `"Hola " + nom`, align(center, si), [Dona `"Hola "`: el null compta com a text buit.],
    `nom == "fi"`, align(center, si), [Dona `false`. Comparar amb `==` és segur.],
    `nom.Length`, align(center, no), [Peta: demanes una dada a algú que no hi és.],
    `nom.ToUpper()`, align(center, no), [Igual: primer comprova-ho o fes `nom?.ToUpper()`.],
  )
  #postit[La regla és curta: mirar un null va bé, demanar-li coses no. Tot el que porti un punt
  darrere del nom necessita que la variable tingui valor.]
]

#ample(title: [10 · Si el compilador et crida l'atenció], color: vermell, pos: bottom)[
  #taula(
    (auto, 1fr),
    th[Codi], th[Què vol dir],
    `CS8600`, [Assignes un possible null a una variable sense `?`.],
    `CS8602`, [Uses una variable que pot ser null sense comprovar-la.],
    `CS8625`, [Assignes `null` a un tipus que no l'admet.],
    `CS0165`, [Uses una variable abans de donar-li cap valor.],
  )
  #v(2pt)
  Amb `<WarningsAsErrors>Nullable</WarningsAsErrors>` aquests avisos són errors i el programa no
  compila. No els facis callar amb `!`: arregla el camí (declara amb `?`, comprova i després usa).
]
