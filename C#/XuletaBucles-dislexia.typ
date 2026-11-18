// Versió per a alumnes amb dislèxia. El contingut és el mateix que a C#/XuletaBucles.typ;
// el que canvia és la plantilla (tools/xuleta-dislexia.typ) i la maquetació.
// Versió per a alumnes amb dislèxia (una columna, 12 pt, fons crema).
// Compilar:  typst compile --font-path tools/fonts "C#/XuletaBucles-dislexia.typ"

#import "../tools/xuleta-dislexia.typ": *

#show: xuleta.with(
  serie: "Xuleta de C# · primer curs",
  title: "Bucles i fitxers",
  badge: "C#",
  mida-codi: 11pt,
  accent: turquesa,
  tags: ("while", "for", "do…while", "Cerca", "Aniuats", "Fitxers", "Comptadors"),
)

// Mapa del full: seccions amb pàgina (calculada sola) i llegenda de les caixes.
#mapa(color: turquesa)

// Caixa de color amb text centrat (per als diagrames).
#let caixa(body, fill: turquesa, color: auto, h: 22.5pt, stroke: none, size: 10.9pt) = box(
  width: 100%, height: h, radius: 3pt, fill: fill, stroke: stroke,
  align(center + horizon, text(weight: "bold", size: size,
    fill: if color == auto { text-sobre(fill) } else { color }, body)),
)
// Pas numerat dels esquemes
#let pas(n, t, c: turquesa) = grid(
  columns: (auto, 1fr), column-gutter: 5pt, align: horizon,
  box(fill: fosc(c), radius: 3pt, inset: (x: 4pt, y: 1.5pt),
    text(font: mono, size: 10pt, weight: "bold", fill: white)[#n]),
  text(size: 11.3pt)[#t],
)

#seccio("Els esquemes de bucle", color: turquesa)

#card(1, "while: el recorregut", color: turquesa)[
  Fes-lo servir quan *no* saps quantes voltes faràs: llegeixes fins que arriba una marca de final.
  #block(above: 6pt, below: 6pt, grid(
    columns: 1, row-gutter: 3pt,
    pas(1, [*Lectura inicial*, abans del bucle]),
    pas(2, [*Condició*: mentre no sigui la marca de final]),
    pas(3, [*Tractament* de la dada que acabes de llegir]),
    pas(4, [*Lectura següent*, l'última línia del bucle]),
  ))
  ```cs
  const int MARCA_FI = 0;
  int comptador = 0;

  // 1. LECTURA INICIAL
  int n = Convert.ToInt32(Console.ReadLine());

  while (n != MARCA_FI)   // 2. CONDICIÓ
  {
      comptador++;        // 3. TRACTAMENT

      // 4. LECTURA SEGÜENT
      n = Convert.ToInt32(Console.ReadLine());
  }
  Console.WriteLine($"Has escrit {comptador} números");
  ```
  #avis[Si t'oblides la lectura del pas 4, la condició no canvia mai: *bucle infinit*.]
  #nota[La marca de final no es tracta: el bucle surt abans de comptar-la.]
]

#card(2, "for: el comptador", color: turquesa)[
  Fes-lo servir quan *sí* que saps quantes voltes vols fer.
  ```cs
  const int VOLTES = 10;

  // (inicialització; condició; pas)
  for (int i = 0; i < VOLTES; i++)
  {
      Console.WriteLine($"Volta {i}");
  }
  ```
  #sub[Compte amb els índexs]
  #let tira(etiqueta, vals, marca) = (
    align(horizon, etiqueta),
    grid(columns: (1fr,) * 6, column-gutter: 1.5pt,
      ..vals.map(v => caixa(fill: turquesa, h: 16.5pt, size: 10pt)[#v]),
      ..(if marca != none { (caixa(fill: vermell.lighten(86%), color: vermell-f, h: 16.5pt,
        size: 10pt, stroke: (paint: vermell-f, dash: "dashed", thickness: 0.7pt))[#marca],) } else { () }),
      ..range(6 - vals.len() - (if marca != none { 1 } else { 0 })).map(_ => []),
    ),
  )
  #block(above: 5pt, below: 5pt, grid(
    columns: (auto, 1fr), column-gutter: 5pt, row-gutter: 3pt,
    ..tira(`i < 5`, range(0, 5), none),
    ..tira(`i <= 5`, range(0, 6), none),
  ))
  #taula(
    (auto, 1fr),
    th[Condició], th[Quantes voltes],
    `i < N`, [N voltes: del 0 al N-1.],
    `i <= N`, [N+1 voltes: del 0 al N. Normalment *no* és el que vols.],
  )
  #avis[Un `;` just després del `for` o del `while` tanca el bucle buit: el `for` no fa res i el
  `while` es penja. Mira que la línia acabi amb `)` i no amb `);`.]
]

#card(3, "do…while: almenys una vegada", color: turquesa)[
  La condició es comprova *al final*, així que el cos sempre s'executa un cop com a mínim. És
  l'esquema dels menús i de tornar a preguntar.
  ```cs
  int opcio;

  do
  {
      Console.WriteLine("1. Jugar");
      Console.WriteLine("0. Sortir");
      opcio = Convert.ToInt32(Console.ReadLine());
  }
  while (opcio != 0);
  ```
  #taula(
    (auto, 1fr),
    th[Bucle], th[Quan comprova la condició],
    `while`, [Abans d'entrar: pot fer *zero* voltes.],
    [`do…while`], [Després del cos: fa *com a mínim una* volta.],
  )
  #avis[El `do…while` acaba amb punt i coma: `while (opcio != 0);`. És l'únic cas en què el `;`
  darrere d'un `while` hi ha de ser.]
]

#card(4, "Esquema de cerca", color: turquesa)[
  Busques un element i pares quan el trobes *o* quan s'acaben les dades. Les dues condicions van
  juntes amb `&&`.
  ```cs
  const int MARCA_FI = 0;
  const int BUSCAT = 777;

  // LlegeixNumero(): la teva funció de llegir del teclat
  int n = LlegeixNumero();

  // mentre NO s'acabin les dades I NO l'hagi trobat
  while (n != MARCA_FI && n != BUSCAT)
  {
      n = LlegeixNumero();
  }

  if (n == BUSCAT)
      Console.WriteLine("Trobat!");
  else
      Console.WriteLine("No hi és.");
  ```
  #nota[Quan surts del bucle, mira *per què* has sortit: si la dada val `BUSCAT` l'has trobat, i
  si val la marca de final, no hi era.]
  #sub[Amb una bandera (si has de tractar les dades)]
  ```cs
  bool trobat = false;
  int n = LlegeixNumero();

  while (n != MARCA_FI && !trobat)
  {
      if (n == BUSCAT) trobat = true;
      else n = LlegeixNumero();
  }
  ```
]

#card(5, "Demanar fins que sigui vàlid", color: turquesa)[
  El bucle de validació: no deixis continuar el programa fins que la dada sigui correcta.
  ```cs
  int edat;
  Console.Write("Edat: ");

  while (!int.TryParse(Console.ReadLine(), out edat))
  {
      Console.Write("Això no és un número. Edat: ");
  }
  ```
  I si, a més, ha d'estar dins d'un rang:
  ```cs
  int nota;

  do
  {
      Console.Write("Nota (0-10): ");
  }
  while (!int.TryParse(Console.ReadLine(), out nota)
         || nota < 0 || nota > 10);
  ```
  #nota[`TryParse` deixa el número a `edat` i retorna `true` o `false`: per això el pots posar
  directament a la condició. El tens explicat a la xuleta de conceptes bàsics.]
]

#card(6, "Bucles aniuats", color: turquesa)[
  Un bucle dins d'un altre: taules, graelles i figures. Per *cada* volta del de fora, el de dins
  fa *totes* les seves voltes.
  ```cs
  for (int i = 1; i <= 5; i++)
  {
      Console.WriteLine($"Taula del {i}:");

      for (int j = 1; j <= 10; j++)
      {
          Console.WriteLine($"  {i} x {j} = {i * j}");
      }
  }
  ```
  #block(above: 6pt, below: 5pt, grid(
    columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
    text(size: 11pt)[5 voltes #sym.times 10 voltes],
    grid(columns: (1fr,) * 10, column-gutter: 1.2pt, row-gutter: 1.2pt,
      ..range(50).map(_ => box(width: 100%, height: 5pt, radius: 1pt, fill: turquesa.lighten(45%)))),
  ))
  #text(size: 11pt, fill: ink-suau)[50 línies de sortida: cada quadret és una volta del bucle de dins.]
  #avis[Fes servir una variable diferent a cada bucle (`i`, `j`). Si tots dos fan servir `i`, el
  de dins trenca el compte del de fora.]
]

#seccio("Fitxers de text", color: blau)

#card(7, "Llegir un fitxer línia a línia", color: blau)[
  ```cs
  using System.IO;   // a dalt del fitxer
  ```
  El patró és el mateix `while` de la #ref-targeta(1), però la marca de final ara és `null`:
  quan no queden línies, `ReadLine()` retorna `null`.
  #block(above: 5pt, below: 5pt, grid(
    columns: (auto, auto, auto, auto), column-gutter: 3pt, align: horizon,
    caixa(fill: blau.lighten(80%), color: blau-f, h: 19.5pt, size: 10pt)[línia 1],
    caixa(fill: blau.lighten(80%), color: blau-f, h: 19.5pt, size: 10pt)[línia 2],
    caixa(fill: blau.lighten(80%), color: blau-f, h: 19.5pt, size: 10pt)[línia 3],
    box(radius: 3pt, inset: (x: 5pt, y: 2.5pt),
      stroke: (paint: vermell-f, thickness: 0.8pt, dash: "dashed"),
      text(font: mono, size: 10pt, weight: "bold", fill: vermell-f)[null]),
  ))
  ```cs
  StreamReader sr = new StreamReader("dades.txt");

  string? linia = sr.ReadLine();   // lectura inicial

  while (linia != null)
  {
      Console.WriteLine(linia);    // tractament
      linia = sr.ReadLine();       // lectura següent
  }

  sr.Close();   // tanca sempre el fitxer
  ```
  #avis[Amb el mode Nullable, `ReadLine()` retorna `string?`: `string linia = sr.ReadLine();` no
  compila. Declara-la amb `?`.]
]

#card(8, "Llegir sabent quantes línies hi ha", color: blau)[
  Quan la primera línia del fitxer diu quantes dades vénen, ja pots fer servir un `for`.
  #sortida[3 \ 10 \ 20 \ 30]
  ```cs
  StreamReader sr = new StreamReader("dades.txt");

  int total = Convert.ToInt32(sr.ReadLine());
  int suma = 0;

  for (int i = 0; i < total; i++)
  {
      suma += Convert.ToInt32(sr.ReadLine());
  }

  sr.Close();
  Console.WriteLine($"Suma: {suma}");
  ```
  #nota[La primera lectura es menja la línia del total; el `for` comença a llegir les dades de
  debò.]
]

#card(9, "Escriure en un fitxer", color: blau)[
  ```cs
  StreamWriter sw = new StreamWriter("sortida.txt");

  sw.WriteLine("Primera línia");
  sw.WriteLine($"Resultat: {suma}");

  sw.Close();   // sense Close, el fitxer queda buit!
  ```
  #taula(
    (1fr, auto),
    th[Vull...], th[Codi],
    [Començar de zero (esborra el que hi havia)], `new StreamWriter("f.txt")`,
    [Afegir al final del que ja hi ha], `new StreamWriter("f.txt", true)`,
  )
  #sub[Amb `using`: es tanca sol]
  ```cs
  using (StreamWriter sw = new StreamWriter("f.txt"))
  {
      sw.WriteLine("Hola");
  }   // aquí es tanca, encara que hi hagi un error
  ```
  #avis[`Close()` no és opcional. El text s'acumula a memòria i no arriba al disc fins que tanques
  el fitxer.]
]

#card(10, "Paranys dels fitxers", color: blau)[
  #taula(
    (auto, 1fr),
    th[Problema], th[Què passa i com evitar-ho],
    [No existeix], [`FileNotFoundException`: comprova-ho abans amb `File.Exists("f.txt")`.],
    [Ruta relativa], [El programa busca el fitxer a la carpeta de l'executable (`bin\Debug\...`), no al costat del codi.],
    [Fitxer obert], [Si no fas `Close()`, no el pots tornar a obrir ni veuràs el que has escrit.],
    [Línia buida], [Una línia buida és `""`, no `null`: el fitxer encara no s'ha acabat.],
  )
  ```cs
  if (!File.Exists("dades.txt"))
  {
      Console.WriteLine("No trobo el fitxer!");
      return;
  }
  ```
  #nota[Per llegir números del fitxer, `Convert.ToInt32` peta si la línia no és un número. Dins
  d'un bucle de lectura val més `int.TryParse`.]
]

#seccio("Comptadors, acumuladors i trucs", color: taronja)

#card(11, "Comptar, acumular, màxim i mínim", color: taronja)[
  #taula(
    (auto, 1fr),
    th[Patró], th[Per a què serveix],
    `comptador++`, [Compta elements: 1, 2, 3...],
    `suma += valor`, [Acumula valors: preus, notes...],
    [`suma / comptador`], [Mitjana. Declara la suma com a `double`, o tindràs divisió entera.],
  )
  ```cs
  int comptador = 0;
  double suma = 0;
  int maxim = int.MinValue;   // comença pel pitjor valor
  int minim = int.MaxValue;

  int n = Convert.ToInt32(Console.ReadLine());
  while (n != 0)
  {
      comptador++;
      suma += n;
      if (n > maxim) maxim = n;
      if (n < minim) minim = n;

      n = Convert.ToInt32(Console.ReadLine());
  }

  if (comptador > 0)
      Console.WriteLine($"Mitjana: {suma / comptador}");
  ```
  #avis[Si no entra cap dada, `comptador` val 0 i la mitjana peta (divisió per zero). Comprova-ho
  sempre abans de dividir.]
  #nota[Comença el màxim a `int.MinValue` i el mínim a `int.MaxValue`: així la primera dada sempre
  els substitueix.]
]

#card(12, "Separar xifres i intercanviar", color: taronja)[
  #sub[Xifra a xifra, de dreta a esquerra]
  ```cs
  int num = 123;

  while (num > 0)
  {
      int xifra = num % 10;  // última xifra: 3, 2, 1
      num = num / 10;        // treu-la: 12, 1, 0

      Console.WriteLine(xifra);
  }
  ```
  #sortida[3 \ 2 \ 1]
  #nota[`% 10` et dona l'última xifra i `/ 10` l'elimina. El bucle s'acaba sol quan el número
  arriba a 0.]
  #sub[Intercanviar dos valors]
  ```cs
  int aux = a;
  a = b;
  b = aux;
  ```
  #avis[Sense la variable auxiliar perds un dels dos valors: `a = b;` ja esborra el que hi havia a
  `a`.]
]

#ample(title: [13 · Quin esquema necessito?], color: vermell)[
  #set text(size: 11.9pt)
  #taula(
    (1fr, auto),
    th[La situació], th[L'esquema],
    [Sé quantes voltes he de fer], [`for` (#ref-targeta(2))],
    [Llegeixo fins a una marca de final], [`while` (#ref-targeta(1))],
    [Com a mínim una volta (menús)], [`do…while` (#ref-targeta(3))],
    [Busco una dada concreta], [cerca amb `&&` (#ref-targeta(4))],
    [Recorro un fitxer sencer], [`while` amb `null` (#ref-targeta(7))],
    [Taules, graelles o figures], [aniuats (#ref-targeta(6))],
  )
  #text(font: titular, size: 13.8pt, fill: vermell-f)[Per què es penja el programa?]
  #v(-3pt)
  - Falta la lectura dins del bucle: la condició no canvia mai.
  - Hi ha un `;` just darrere del `while (...)` o del `for (...)`.
  - Oblides `i++`, o modifiques `i` dins del cos sense voler.
  - La condició no es pot complir mai: `while (i >= 0)` amb `i++`.
  #v(1pt)
  #text(size: 11.3pt, fill: ink-suau)[Atura'l amb Ctrl+C i mira quina de les quatre parts de
  l'esquema t'has deixat.]
]
