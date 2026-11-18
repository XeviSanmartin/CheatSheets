// Xuleta de símbols, pensada per a alumnes amb dislèxia (una columna, 12 pt, fons crema).
// Serveix per a C# (primer) i per a Kotlin (segon).
// Compilar:  typst compile --font-path tools/fonts "Comu/XuletaSimbols.typ"

#import "../tools/xuleta-dislexia.typ": *

#show: xuleta.with(
  serie: "Xuleta comuna · C# i Kotlin",
  title: "Els símbols, un per un",
  badge: "{ }",
  mida-codi: 11pt,
  accent: indi,
  tags: ("Comparació", "Lògics", "Parèntesis", "S'assemblen", "Aritmètics", "Fletxes", "En veu alta"),
)

#mapa(color: indi)

// Símbol gran, sempre a la primera columna.
#let simbol(t, c: indi) = box(
  fill: c.lighten(88%), radius: 4pt, inset: (x: 8pt, y: 5pt),
  text(font: mono, size: 16pt, weight: "bold", fill: fosc(c), features: (calt: 0))[#t],
)
// Cel·la d'exemple: el codi i, a sota, com es llegeix en veu alta.
#let exemple(codi, lectura) = [#codi \ #text(size: 11pt, fill: ink-suau)[«#lectura»]]
// Com es llegeix en veu alta.
#let veu(t) = text(size: 11pt, style: "normal")[«#t»]

#seccio("Comparació i assignació", color: indi)

#card(1, "Comparar dos valors", color: indi)[
  #taula(
    (auto, auto, 1fr),
    th[Símbol], th[Com es diu], th[Exemple i com es llegeix],
    simbol("<"), [Menor que], [`edat < 18` \
      #veu[l'edat és menor que 18]],
    simbol(">"), [Major que], [`nota > 5` \
      #veu[la nota és major que 5]],
    simbol("<="), [Menor o igual que], [`edat <= 17` \
      #veu[l'edat és menor o igual que 17]],
    simbol(">="), [Major o igual que], [`edat >= 18` \
      #veu[l'edat és major o igual que 18]],
    simbol("=="), [És igual a (compara)], [`dia == 7` \
      #veu[el dia és igual a 7]],
    simbol("!="), [És diferent de], [`n != 0` \
      #veu[la ena és diferent de zero]],
    simbol("=", c: vermell), [Assigna (guarda un valor)], [`n = 0` \
      #veu[la ena es queda amb zero]],
  )
  #postit[`=` guarda i `==` compara. Si escrius `if (n = 0)`, no estàs comparant: estàs guardant
  un zero dins de la ena. És l'error més habitual de tots.]
  #sub[Per recordar cap on va la punta]
  #block(above: 8pt, below: 8pt, grid(
    columns: (1fr, 1fr), column-gutter: 14pt,
    box(fill: indi.lighten(92%), radius: 5pt, inset: 10pt)[
      #text(size: 12pt)[*La punta assenyala el petit.*]
      #v(2pt)
      #text(font: mono, size: 15pt, weight: "bold")[3 \< 8] #h(6pt) #text(size: 11pt)[la punta mira el 3]
    ],
    box(fill: indi.lighten(92%), radius: 5pt, inset: 10pt)[
      #text(size: 12pt)[*La boca oberta es menja el gran.*]
      #v(2pt)
      #text(font: mono, size: 15pt, weight: "bold")[8 \> 3] #h(6pt) #text(size: 11pt)[la boca mira el 8]
    ],
  ))
]

#seccio("Operadors lògics", color: turquesa)

#card(2, "Unir condicions", color: turquesa)[
  #taula(
    (auto, auto, 1fr),
    th[Símbol], th[Com es diu], th[Exemple i com es llegeix],
    simbol("&&", c: turquesa), [I], [`edat >= 18 && te_carnet` \
      #veu[l'edat és major o igual que 18 i té carnet]],
    simbol("||", c: turquesa), [O], [`dia == 6 || dia == 7` \
      #veu[el dia és 6 o el dia és 7]],
    simbol("!", c: turquesa), [No], [`!trobat` \
      #veu[no s'ha trobat]],
  )
  #taula(
    (auto, 1fr),
    th[Operador], th[Quan és cert],
    `&&`, [Quan es compleixen *les dues* condicions.],
    `||`, [Quan se'n compleix *almenys una*.],
    `!`, [Quan la condició *no* es compleix: inverteix el resultat.],
  )
  #avis[`&&` i `||` van sempre dobles. Un de sol (`&`, `|`) és una operació de bits i fa una
  altra cosa.]
]

#seccio("Parèntesis, claudàtors, claus i angles", color: blau)

#card(3, "Cada parella té la seva feina", color: blau)[
  Els noms s'assemblen molt, i per això es confonen. Mira la forma, no el nom.
  #taula(
    (auto, auto, 1fr),
    th[Símbol], th[Com es diu], th[Exemple i per a què serveix],
    simbol("( )", c: blau), [Parèntesis], [`Suma(a, b)` \
      Crides a funcions i condicions de l'`if` i del `while`.],
    simbol("[ ]", c: blau), [Claudàtors], [`notes[0]` \
      Índexs: la posició dins d'un array o d'una llista.],
    simbol("{ }", c: blau), [Claus], [`{ ... }` \
      Blocs de codi: el cos d'un `if`, d'un bucle o d'una funció.],
    simbol("< >", c: blau), [Angles], [`List<int>` \
      Tipus genèrics. Aquí *no* volen dir menor ni major.],
  )
  #nota[Els angles `<` i `>` tenen dues feines molt diferents: comparar números i, enganxats a un
  tipus, dir de quina mena són els elements. Mira sempre què tenen a l'esquerra.]
]

#seccio("Caràcters que s'assemblen", color: rosa)

#card(4, "Mira'ls de prop", color: rosa)[
  #let parella(a, b, exp) = (
    box(fill: rosa.lighten(90%), radius: 4pt, inset: (x: 8pt, y: 5pt),
      text(font: mono, size: 17pt, weight: "bold", fill: rosa-f, features: (calt: 0))[#a]),
    box(fill: rosa.lighten(90%), radius: 4pt, inset: (x: 8pt, y: 5pt),
      text(font: mono, size: 17pt, weight: "bold", fill: rosa-f, features: (calt: 0))[#b]),
    text(size: 11.5pt)[#exp],
  )
  #block(above: 8pt, below: 8pt, grid(
    columns: (auto, auto, 1fr), column-gutter: 9pt, row-gutter: 9pt, align: horizon,
    ..parella(`'a'`, `"a"`, [Cometa simple: un *caràcter*. Cometes dobles: un *text*.]),
    ..parella(`;`, `:`, [Punt i coma: tanca una instrucció. Dos punts: tipus o herència.]),
    ..parella(`/`, `\`, [Barra: divideix. Barra invertida: escapaments com `\n`.]),
    ..parella(`|`, `l`, [Barra vertical. No és la ela, ni la i majúscula, ni l'u.]),
    ..parella(`0`, `O`, [Zero (més estret). O majúscula (més rodona).]),
  ))
  #taula(
    (auto, auto, 1fr),
    th[Es confon], th[Amb], th[Com distingir-los],
    `1`, [`l` i `I`], [L'u porta una base i un peu; la ela és una ratlla neta.],
    `0`, `O`, [El zero és més estret i va amb números.],
    `|`, [`l`, `I` i `1`], [La barra vertical va sempre doblada: `||`.],
  )
  #postit[La font JetBrains Mono de les xuletes dibuixa aquests caràcters diferents a posta.
  Fes-la servir també a l'editor.]
]

#seccio("Aritmètics menys intuïtius", color: taronja)

#card(5, "Els que no fan el que sembla", color: taronja)[
  #taula(
    (auto, auto, 1fr),
    th[Símbol], th[Com es diu], th[Exemple, què fa i com es llegeix],
    simbol("%", c: taronja), [Residu (mòdul)], [`7 % 2` \
      Dona 1, el que sobra de la divisió. #veu[set mòdul dos]],
    simbol("/", c: taronja), [Divisió], [`7 / 2` \
      Amb enters dona *3*, no 3,5. #veu[set dividit entre dos]],
    simbol("++", c: taronja), [Incrementar], [`i++` \
      Suma 1 a la i. #veu[la i augmenta en u]],
    simbol("--", c: taronja), [Decrementar], [`i--` \
      Resta 1 a la i. #veu[la i disminueix en u]],
    simbol("+=", c: taronja), [Sumar i guardar], [`x += 3` \
      És `x = x + 3`. #veu[la x es queda amb x més tres]],
    simbol("-=", c: taronja), [Restar i guardar], [`x -= 3` \
      És `x = x - 3`. #veu[la x es queda amb x menys tres]],
  )
  #avis[`%` no és cap percentatge: és el que sobra d'una divisió. `10 % 3` fa `1`, perquè el 3 hi
  cap tres vegades i sobra 1.]
  #nota[Si vols decimals, un dels dos números ha de ser `double`: `7.0 / 2` dona 3,5.]
]

#seccio("Fletxes i operadors compostos", color: violeta)

#card(6, "Els que porten més d'un símbol", color: violeta)[
  #taula(
    (auto, auto, 1fr),
    th[Símbol], th[Com es diu], th[Exemple i què vol dir],
    simbol("=>"), [Fletxa de C\#], [`x => x * 2` \
      Lambda o cos d'expressió. *No* és `>=`.],
    simbol("->"), [Fletxa de Kotlin], [`1 -> "U"` \
      Lambda o branca del `when`.],
    simbol("?."), [Accés segur], [`text?.Length` \
      Entra només si no és nul; si ho és, dona nul.],
    simbol("??"), [Valor per defecte (C\#)], [`nom ?? "Anònim"` \
      Si és nul, agafa el de la dreta.],
    simbol("?:"), [Valor per defecte (Kotlin)], [`nom ?: "Anònim"` \
      El mateix que `??` de C\#. Se'n diu «Elvis».],
    simbol("!!", c: vermell), [Perdó de nul (Kotlin)], [`text!!.length` \
      «Estic segur que no és nul». Si ho és, peta.],
  )
  #avis[`=>` i `>=` porten els mateixos dos símbols en ordre diferent. `>=` compara i `=>` obre
  una lambda. Mira sempre quin va primer.]
]

#seccio("Llegir el codi en veu alta", color: cian)

#card(7, "Digues la frase sencera", color: cian)[
  Llegir el símbol pel seu nom no ajuda gaire. Llegeix tota la línia com una frase.
  #taula(
    (1fr, 1fr),
    th[El codi], th[Com es llegeix],
    `if (edat >= 18)`, veu[si l'edat és major o igual que 18],
    `while (n != 0)`, veu[mentre la ena sigui diferent de zero],
    `for (int i = 0; i < 10; i++)`,
      veu[per a la i des de zero mentre sigui menor que 10, i augmentant d'u en u],
    `suma += nota`, veu[la suma es queda amb la suma més la nota],
    `if (n % 2 == 0)`, veu[si el residu de dividir la ena entre dos és igual a zero],
    `nom ?? "Anònim"`, veu[el nom o, si és nul, Anònim],
    `notes[0]`, veu[la nota de la posició zero],
    `List<int>`, veu[una llista d'enters],
  )
  #postit[Si no pots llegir una línia en veu alta com una frase, segurament no l'has entesa
  encara. Torna-hi a poc a poc, símbol per símbol.]
]

#ample(title: [8 · Majúscules, minúscules i noms enganxats], color: vermell)[
  #taula(
    (auto, 1fr),
    th[Compte amb...], th[Què passa],
    [`Console` / `console`], [No són el mateix. C\# i Kotlin distingeixen majúscules i minúscules,
      i el compilador no perdona.],
    [`WriteLine` / `Writeline`], [Igual: la ela ha d'anar en majúscula.],
    [camelCase], [Els noms van enganxats i cada paraula nova comença en majúscula:
      `notaFinal`, `comptadorDeVoltes`. Llegeix-los paraula per paraula.],
  )
  #nota[Un truc per als noms llargs: digue'ls en veu alta separant les paraules, com si hi
  haguessin espais. `nomDeLAlumne` es llegeix «nom de l'alumne».]
]
