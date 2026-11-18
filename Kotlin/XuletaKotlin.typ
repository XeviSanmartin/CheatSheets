// Compilar:  typst compile --font-path tools/fonts "Kotlin/XuletaKotlin.typ"

#import "../tools/xuleta.typ": *

#show: xuleta.with(
  serie: "Xuleta de Kotlin · segon curs",
  title: "Kotlin per a programadors de C#",
  badge: "Kt",
  mida-codi: 6.75pt,
  mida-text: 8.7pt,
  accent: violeta,
  tags: ("Bàsics", "Control", "Nulls", "Funcions", "Col·leccions", "Classes", "Consola",
         "Excepcions i fitxers", "Competitiva"),
)

// Mapa del full: seccions amb pàgina (calculada sola) i llegenda de les caixes.
#mapa()

// Caixa de color amb text centrat (per als diagrames).
#let caixa(body, fill: violeta, color: auto, h: 15pt, stroke: none, size: 7.5pt) = box(
  width: 100%, height: h, radius: 3pt, fill: fill, stroke: stroke,
  align(center + horizon, text(weight: "bold", size: size,
    fill: if color == auto { text-sobre(fill) } else { color }, body)),
)
// Casella del buffer de teclat
#let cas(t, fill: cian.lighten(80%), color: cian-f) = box(
  width: 13pt, height: 13pt, radius: 2pt, fill: fill, stroke: 0.5pt + cian.lighten(30%),
  align(center + horizon, text(font: mono, size: 6.8pt, weight: "bold", fill: color, t)),
)
#let buit = box(width: 13pt, height: 13pt, radius: 2pt, stroke: (paint: cian.lighten(40%), dash: "dotted"))

// Diccionari ràpid a tota l'amplada, a la primera pàgina
#ample(title: [Diccionari ràpid: de C\# a Kotlin], color: violeta)[
  #let d(a, b, c) = (text(size: 7.3pt, a), text(font: mono, size: 6.6pt, features: (calt: 0), fill: ink-suau.darken(10%), b), text(font: mono, size: 6.6pt, features: (calt: 0), weight: "bold", fill: violeta-f, c))
  #grid(
    columns: (1fr, 1fr), column-gutter: 10pt,
    taula(
      (auto, 1fr, 1fr),
      th[Què], th[C\#], th[Kotlin],
      ..d[Escriure][Console.WriteLine(x)][println(x)],
      ..d[Llegir línia][Console.ReadLine()][readlnOrNull()],
      ..d[Interpolació][\$"Hola {nom}"][\"Hola \$nom\"],
      ..d[Variable / const.][var x / const][var x / val x],
      ..d[Tipus darrere][int x = 1;][val x: Int = 1],
      ..d[Sense retorn][void][Unit (o res)],
      ..d[Ternari][c ? a : b][if (c) a else b],
      ..d[switch][switch / case][when / ->],
      ..d[for][for (i=0; i\<n; i++)][for (i in 0 until n)],
      ..d[foreach][foreach (var x in l)][for (x in l)],
    ),
    taula(
      (auto, 1fr, 1fr),
      th[Què], th[C\#], th[Kotlin],
      ..d[Fusió amb null][a ?? b][a ?: b],
      ..d[Perdó de null][a!.Length][a!!.length],
      ..d[Crear objecte][new Persona()][Persona()],
      ..d[Herència][class B : A][class B : A()],
      ..d[Mètode virtual][virtual / override][open / override],
      ..d[static][static][companion object],
      ..d[Llista][List\<int\>][MutableList\<Int\>],
      ..d[Diccionari][Dictionary\<K, V\>][MutableMap\<K, V\>],
      ..d[LINQ][Where / Select][filter / map],
      ..d[using][using (...) { }][x.use { }],
    ),
  )
]

#seccio("Coses bàsiques", color: violeta)

#card(1, "Hola món i main", color: violeta)[
  ```kotlin
  fun main() {
      println("Hola món!")   // amb salt de línia
      print("Sense salt")    // sense salt de línia
  }
  ```
  Si necessites els arguments del programa:
  ```kotlin
  fun main(args: Array<String>) {
      println("Arguments: ${args.joinToString()}")
  }
  ```
  #nota[No cal cap classe: `main` i qualsevol funció poden anar soltes al fitxer. Tampoc no cal
  posar `;` al final de cada línia.]

  #sub[Plantilles de text]
  ```kotlin
  val nom = "Anna"
  println("Hola, $nom!")              // variable
  println("Té ${nom.length} lletres") // expressió
  ```
  #sortida[Hola, Anna! \ Té 4 lletres]

  #sub[Text de diverses línies]
  ```kotlin
  val menu = """
      1. Jugar
      2. Sortir
  """.trimIndent()   // treu el sagnat comú
  ```
]

#card(2, "Variables i tipus", color: violeta)[
  ```kotlin
  val pi = 3.1416     // val: no es pot reassignar
  var comptador = 0   // var: sí que es pot
  var mida: Int = 1   // tipus explícit (darrere!)
  var llargada = 2    // tipus inferit: Int

  val distancia: Int  // assignació diferida
  distancia = 12      // (tot això, dins d'una funció)
  ```
  Constants de compilació (fora de qualsevol funció):
  ```kotlin
  const val MAX_INTENTS = 3
  ```
  #postit[Per defecte, fes servir `val`. Canvia a `var` només si de debò l'has de reassignar.]
  #taula(
    (auto, auto, 1fr),
    th[Kotlin], th[C\#], th[Exemple],
    `Int`, `int`, `42`,
    `Long`, `long`, `42L`,
    `Double`, `double`, `3.14`,
    `Float`, `float`, `3.14f`,
    `Boolean`, `bool`, `true`,
    `Char`, `char`, `'A'`,
    `String`, `string`, `"Hola"`,
    `Any`, `object`, [el pare de tots els tipus],
    `Unit`, `void`, [funció que no retorna res],
  )
  #sub[Conversions]
  ```kotlin
  val n = "42".toInt()          // peta si no és número
  val m = "hola".toIntOrNull()  // null si no ho és
  val d = n.toDouble()          // 42.0
  val l: Long = n.toLong()      // cal convertir
  val t = n.toString()          // "42"
  ```
  #avis[Kotlin no converteix sol entre tipus numèrics: `val l: Long = n` és un error. Cal `n.toLong()`.]
]

#card(3, "Operadors: el que canvia", color: violeta)[
  Els aritmètics, `&&`, `||`, `!`, `++` i `--` són com a C\#. La divisió entera també: `10 / 3` és `3`.
  #taula(
    (auto, 1fr),
    th[Operador], th[Què fa],
    [`==` `!=`], [Compara el *contingut* (crida `equals`), també en strings i objectes.],
    [`===` `!==`], [Mira si és el *mateix objecte* (referència).],
    [`..` `until`], [Rangs: `1..5`, `0 until n`.],
    [`in` `!in`], [Pertinença: `x in 1..10`, `"A" in llista`.],
    [`is` `!is`], [Comprova el tipus i fa _smart cast_.],
    [`as` `as?`], [Converteix de tipus; `as?` dona null si no pot.],
    [`?.` `?:` `!!`], [Nulls: vegeu la #ref-targeta(8).],
    [`and` `or` `xor`], [Operacions de bits (a C\#: `&` `|` `^`).],
    [`shl` `shr` `inv()`], [Desplaçaments i negació de bits (`<<` `>>` `~`).],
  )
  #sub[No hi ha ternari: if és una expressió]
  ```kotlin
  val tipus = if (edat >= 18) "Major" else "Menor"
  ```
  #sub[Smart cast]
  Després de comprovar el tipus amb `is`, la variable ja és d'aquell tipus:
  ```kotlin
  fun descriu(x: Any): String {
      if (x is String) {
          return "Text de ${x.length} lletres"
      }
      return "Una altra cosa"
  }
  ```
  #nota[A C\# faries `x is string s` i usaries `s`. A Kotlin fas servir directament `x`.]
]

#card(4, "Strings i caràcters", color: violeta)[
  #taula(
    (auto, 1fr),
    th[Codi], th[Resultat],
    `s.length`, [nombre de caràcters],
    `s[0]`, [primer caràcter (`Char`)],
    `s.uppercase()` + ` s.lowercase()`, [majúscules / minúscules],
    `s.trim()`, [treu espais del principi i del final],
    `s.substring(1, 3)`, [del 1 al 3 (el 3 no inclòs)],
    `s.split(" ")`, [llista de trossos],
    `s.contains("ol")`, [`true` / `false` (també `"ol" in s`)],
    `s.replace("a", "e")`, [canvia totes les «a»],
    `s.reversed()`, [text del revés],
    `s.toCharArray()`, [`CharArray` amb els caràcters],
  )
  #sub[Caràcters]
  ```kotlin
  val c = '7'
  c.isDigit()        // true
  c.isLetter()       // false
  c.digitToInt()     // 7
  'a'.code           // 97 (codi Unicode)
  97.toChar()        // 'a'
  'a'.uppercaseChar() // 'A'
  ```
  #sub[Recórrer un text]
  ```kotlin
  for (c in "Hola") print("[$c]")
  ```
  #sortida[[H][o][l][a]]
]

#card(5, "Math i aleatoris", color: violeta)[
  ```kotlin
  import kotlin.math.*

  sqrt(16.0)       // 4.0
  2.0.pow(3)       // 8.0
  abs(-5)          // 5
  max(4, 9)        // 9 (també min)
  round(2.6)       // 3.0
  PI               // 3.141592...
  ```
  ```kotlin
  import kotlin.random.Random

  val dau = Random.nextInt(1, 7)  // de 1 a 6
  val dau2 = (1..6).random()      // de 1 a 6
  ```
  #avis[Com a C\#, a `nextInt(1, 7)` el 7 queda fora. Amb el rang `1..6` els dos extrems hi són.]
]

#seccio("Estructures de control", color: turquesa)

#card(6, "if i when", color: turquesa)[
  `if` pot retornar un valor:
  ```kotlin
  fun mesGran(a: Int, b: Int) = if (a > b) a else b

  if (edat >= 18) {
      println("Major d'edat")
  } else {
      println("Menor d'edat")
  }
  ```
  #sub[when: el switch de Kotlin]
  ```kotlin
  when (numero) {
      1 -> {
          println("U")               // igualtat
      }
      2 -> println("Dos")            // igualtat
      3, 4, 5 -> println("De 3 a 5") // diversos valors
      in 6..18 -> println("De 6 a 18") // rang
      !in 0..120 -> println("Impossible")
      else -> println("Més de 18")
  }
  ```
  Per tipus:
  ```kotlin
  when (valor) {
      is Int -> println("Enter")
      is String -> println("Text de ${valor.length}")
      else -> println("Una altra cosa")
  }
  ```
  Sense argument, com una cadena de `if`, i retornant un valor:
  ```kotlin
  fun signeACadena(x: Int) = when {
      x < 0 -> "Negatiu"
      x == 0 -> "Zero"
      else -> "Positiu"
  }
  ```
  #nota[A diferència del `switch` de C\#, només s'executa la primera branca que encaixa: no cal res més per sortir-ne.]
]

#card(7, "Bucles", color: turquesa)[
  `while` i `do ... while` són iguals que a C\#:
  ```kotlin
  while (mida > 0) { mida-- }
  do { mida-- } while (mida > 0)
  ```
  #sub[for amb rangs]
  #let fila(codi, vals, total: 11) = (
    align(horizon, codi),
    grid(columns: (1fr,) * total, column-gutter: 1.5pt,
      ..vals.map(v => caixa(fill: turquesa, h: 11pt, size: 6.5pt)[#v]),
      ..range(total - vals.len()).map(_ => []),
    ),
  )
  #grid(
    columns: (auto, 1fr), column-gutter: 5pt, row-gutter: 3pt,
    ..fila(`0..10`, range(0, 11)),
    ..fila(`0 until 10`, range(0, 10)),
    ..fila(`0..10 step 2`, range(0, 11, step: 2)),
    ..fila(`10 downTo 0`, range(10, -1, step: -1)),
  )
  ```kotlin
  for (index in 0..10) println(index)      // 0 - 10
  for (index in 0 until 10) println(index) // 0 - 9
  for (i in 0 until 10 step 2) { }  // 0, 2, 4, 6, 8
  for (i in 10 downTo 1) { }        // 10, 9, ..., 1
  (0..10).forEach { println("L'element és $it") }
  ```
  #sub[Recórrer una llista]
  ```kotlin
  val llista = listOf("A", "B", "C")
  for (element in llista) println(element)
  ```
  Si necessites l'índex de cada element:
  ```kotlin
  for (index in llista.indices) println(llista[index])
  for ((index, element) in llista.withIndex()) {
      println("$element és a la posició $index")
  }
  llista.forEachIndexed { index, element ->
      println("$element és a la posició $index")
  }
  ```
]

#seccio("Nulls", color: rosa)

#card(8, "Tipus anul·lables i operadors", color: rosa)[
  Com a C\# amb el mode Nullable: només pot valer `null` un tipus acabat en `?`. Però a Kotlin
  no és un avís que es pugui desactivar: és part del llenguatge.
  #compara(
    ("string? s", "val s: String?"),
    ("s?.Length", "s?.length"),
    ("s ?? \"\"", "s ?: \"\""),
    ("s!.Length", "s!!.length"),
    ("x.HasValue", "x != null"),
  )
  ```kotlin
  val cadena: String? = readlnOrNull()
  val talla: Int? = cadena?.length  // null si és null
  var mida = cadena?.length ?: 0    // 0 si és null
  mida = cadena!!.length            // peta si és null
  ```
  #sub[Elvis amb return o throw]
  ```kotlin
  fun llargada(cadena: String?): Int {
      val mida = cadena?.length ?: return -1
      return mida
  }

  val num = text.toIntOrNull()
      ?: throw IllegalArgumentException("No és un número")
  ```
  #sub[let: fer alguna cosa només si no és null]
  ```kotlin
  cadena?.let {
      println("Té ${it.length} lletres")
  }
  ```
  #avis[`!!` llança `NullPointerException` en aquell mateix moment si el valor és null. No és per
  callar el compilador: és per dir «si és null, que peti».]
]

#card(9, "Inicialització tardana", color: rosa)[
  Quan una propietat no pot tenir valor en el moment de crear-la:
  ```kotlin
  fun inicialitzaPersona(): Persona {
      return Persona("Joan")
  }
  ```
  #sub[Si és immutable: by lazy]
  ```kotlin
  val joan: Persona by lazy { inicialitzaPersona() }
  // Executa la funció el primer cop que s'usa
  // la variable. Després, sempre retorna el valor.
  ```
  #sub[Si és mutable: lateinit]
  ```kotlin
  lateinit var persona: Persona

  persona = inicialitzaPersona()
  ```
  #avis[Si llegeixes una `lateinit` abans d'assignar-la, peta (`UninitializedPropertyAccessException`).
  No es pot fer servir amb `Int`, `Double`... ni amb tipus `?`.]
]

#seccio("Funcions", color: indi)

#card(10, "Declaració de funcions", color: indi)[
  ```kotlin
  fun escriuNom() {
      print("Joan")
  }

  fun escriuNom(): Unit {  // Unit equival a void
      print("Joan")
  }

  fun escriuNom(persona: Persona) {
      print(persona.nom)
  }

  fun saluda(persona: Persona): String {
      return "Hola, ${persona.nom}"
  }
  ```
  #sub[Funcions d'expressió única]
  ```kotlin
  fun multiplicacio(a: Int, b: Int) = a * b

  fun saluda(persona: Persona): String =
      "Hola, ${persona.nom}"

  fun saluda(persona: Persona) = "Hola, ${persona.nom}"
  ```
  #sub[Paràmetres per defecte i amb nom]
  ```kotlin
  fun saluda(persona: Persona,
             salutacio: String = "Benvingut"): String {
      return "$salutacio, ${persona.nom}"
  }

  var holaJ = saluda(Persona("Joan"))
  // retorna "Benvingut, Joan"
  var holaM = saluda(Persona("Marta"), "Benvinguda")
  // retorna "Benvinguda, Marta"
  var holaP = saluda(salutacio = "Ei",
                     persona = Persona("Pau"))
  // arguments amb nom, en qualsevol ordre
  ```
  #sub[Nombre variable d'arguments]
  ```kotlin
  fun suma(vararg nums: Int) = nums.sum()
  suma(1, 2, 3)   // 6
  ```
  #nota[Els paràmetres són `val`: no es poden modificar. No hi ha `ref` ni `out`: si has de
  retornar dues coses, retorna un `Pair` o una data class.]
]

#card(11, "Lambdes", color: indi)[
  ```kotlin
  val suma: (Int, Int) -> Int = { x, y ->
      val z = x + y  // després de la fletxa, el codi
      z              // es retorna l'última expressió
  }                  // (no cal ni es pot posar return)

  val multiplica: (Int, Int) -> Int = { x, y -> x * y }
  val resta = { x: Int, y: Int -> x - y } // tipus inferit
  val quadrat: (Int) -> Int = { it * it } // 1 param.: it
  ```
  #compara(
    ("Func<int, int, int>", "(Int, Int) -> Int"),
    ("(x, y) => x + y", "{ x, y -> x + y }"),
    ("x => x * x", "{ it * it }"),
  )
  #sub[Maneres de cridar-les]
  ```kotlin
  suma.invoke(3, 5)
  suma(3, 5)
  ```
  #sub[Passar una lambda a una funció]
  ```kotlin
  fun opera(x: Int, y: Int,
            operacio: (Int, Int) -> Int) = operacio(x, y)

  fun opera2(x: Int, y: Int,
             operacio: (Int, Int) -> Int): Int {
      return operacio(x, y)
  }

  opera(2, 3, suma)
  opera(2, 3, { x, y -> x + y })
  opera(2, 3, ::multiplicacio)  // referència a funció
  ```
  Si l'últim paràmetre és una lambda, es pot escriure fora dels parèntesis:
  ```kotlin
  opera(2, 3) { x, y ->
      // aquí pots posar tot el codi que calgui
      x * y
  }
  ```
]

#card(12, "Extensions i funcions d'àmbit", color: indi)[
  #sub[Funcions d'extensió]
  Afegeixen mètodes a una classe que no és teva (com els mètodes d'extensió de C\#, però sense
  classe `static`):
  ```kotlin
  fun String.esPalindrom() = this == this.reversed()

  "radar".esPalindrom()   // true
  ```
  #sub[let, apply, also, run, with]
  #taula(
    (auto, auto, auto, 1fr),
    th[Funció], th[Objecte], th[Retorna], th[Ús típic],
    `let`, `it`, [la lambda], [fer alguna cosa si no és null],
    `apply`, `this`, [l'objecte], [configurar un objecte],
    `also`, `it`, [l'objecte], [fer-hi alguna cosa de més (log)],
    `run`, `this`, [la lambda], [calcular a partir de l'objecte],
    `with(x)`, `this`, [la lambda], [moltes crides al mateix objecte],
  )
  ```kotlin
  val p = Persona("Anna", 20).apply {
      edat = 21            // this.edat
  }
  val lletres = nom?.let { it.length } ?: 0
  val llista = mutableListOf(1, 2).also {
      println("Creada amb ${it.size} elements")
  }
  ```
]

#seccio("Col·leccions", color: taronja)

#card(13, "Creació i accés", color: taronja)[
  ```kotlin
  val numArray = arrayOf(1, 2, 3)   // mida fixa
  val zeros = IntArray(5)           // [0, 0, 0, 0, 0]
  val numList = listOf(1, 2, 3)     // només lectura
  val mutableNumList = mutableListOf(1, 2, 3)
  mutableNumList.add(4)
  mutableNumList.removeAt(0)
  ```
  #sub[Accés]
  ```kotlin
  val primerItem = numList[0]
  val primer = numList.first()        // peta si és buida
  val primerONull = numList.firstOrNull()
  val quants = numList.size
  val hiEs = 2 in numList             // contains
  ```
  #sub[Maps]
  ```kotlin
  val cartes = mutableMapOf(
      "Jota" to 11, "Reina" to 12, "Rei" to 13)
  val valorJ = cartes["Jota"]  // 11 (Int?, pot ser null)
  cartes["As"] = 1
  for ((c, v) in cartes) println("$c val $v")
  ```
  #sub[Mutabilitat]
  ```kotlin
  val llistaImmutable = listOf(1, 2, 3)
  val llistaMutable = llistaImmutable.toMutableList()
  val mapImmutable =
      mapOf("Jota" to 11, "Reina" to 12, "Rei" to 13)
  val mapMutable = mapImmutable.toMutableMap()
  ```
  #compara(
    ("List<int>", "MutableList<Int>"),
    ("Dictionary<string, int>", "MutableMap<String, Int>"),
    ("int[]", "IntArray / Array<Int>"),
    (".Count / .Length", ".size"),
  )
  #avis[`val` només impedeix reassignar la variable. Una `MutableList` declarada amb `val` es pot
  modificar igualment (`add`, `remove`...).]
]

#card(14, "Iteració i literals", color: taronja)[
  ```kotlin
  for (element in llistaImmutable) {
      print(element)
  }

  llistaImmutable.forEach {
      print(it)
  }

  llistaImmutable.forEachIndexed { index, element ->
      print("L'element de la posició $index és: $element")
  }
  ```
  #sub[Literals]
  #taula(
    (1fr, auto),
    th[Expressió], th[Tipus],
    `listOf(1, 2, 3, 4)`, `List<Int>`,
    `mutableListOf(1, 2, 3, 4)`, `MutableList<Int>`,
    `setOf("A", "B", "C")`, `Set<String>`,
    `mutableSetOf("A", "B", "C")`, `MutableSet<String>`,
    `arrayOf('a', 'b', 'c')`, `Array<Char>`,
    `1 to "A"`, `Pair<Int, String>`,
    `mapOf(1 to "A", 2 to "B")`, `Map<Int, String>`,
    `mutableMapOf(1 to "A")`, `MutableMap<Int, String>`,
    `sequenceOf(4, 3, 2, 1, 0)`, `Sequence<Int>`,
    `List(4) { it * 2 }`, [`List<Int>`: 0, 2, 4, 6],
    `generateSequence(4) { it + 2 }`, [`Sequence<Int>` infinita],
  )
  ```kotlin
  val (numero, lletra) = 1 to "A"   // desestructuració
  ```
]

#card(15, "Filtres i operacions (el LINQ de Kotlin)", color: taronja)[
  ```kotlin
  val numList = listOf(1, 2, 3, 4, 5, 6)

  val nombresParells = numList.filter { it % 2 == 0 }
  val conteParells = numList.any { it % 2 == 0 }
  val noConteParells = numList.none { it % 2 == 0 }
  val totsSenars = numList.all { it % 2 != 0 }
  val primerParell: Int = numList.first { it % 2 == 0 }
  val primerParellONull: Int? =
      numList.firstOrNull { it % 2 == 0 }
  val deu = numList.map { it * 10 } // [10, 20, ...]
  val suma = numList.sum()          // 21
  val text = numList.joinToString(", ")
  ```
  ```kotlin
  data class Treballador(
      val nom: String, val cognom: String,
      val salari: Int, val baixa: Boolean)

  val treballadors = mutableListOf(
      Treballador("Joan", "Petit", 18000, false))

  treballadors.filter { !it.baixa && it.salari > 15000 }
  treballadors.sortedByDescending { it.salari }
  treballadors.take(10)          // els 10 primers
  treballadors.sortedWith(
      compareBy({ it.cognom }, { it.nom }))
  treballadors.groupBy { it.cognom } // Map<String, List>
  treballadors.sumOf { it.salari }
  treballadors.maxByOrNull { it.salari }
  ```
  #compara(
    esquerra: "C# (LINQ)",
    ("Where(x => ...)", "filter { ... } (llista nova)"),
    ("Select(x => ...)", "map { ... }"),
    ("Any / All", "any / all / none"),
    ("First / FirstOrDefault", "first / firstOrNull"),
    ("OrderBy / OrderByDescending", "sortedBy / sortedByDescending"),
    ("Sum / Max", "sum, sumOf / max, maxOf"),
    ("GroupBy / Take", "groupBy / take"),
    ("string.Join(\", \", l)", "l.joinToString(\", \")"),
  )
]

#seccio("Classes", color: blau)

#card(16, "Classes i constructors", color: blau)[
  El constructor primari va a la capçalera de la classe, com si fossin els paràmetres d'una funció.
  Les propietats de només lectura es declaren amb `val` i les modificables amb `var`.
  ```kotlin
  class Persona constructor(val nom: String,
                            var edat: Int)

  // Sense anotacions ni modificadors, "constructor"
  // es pot ometre:
  class Persona(val nom: String, var edat: Int)
  // nom és de només lectura i edat és modificable

  val p = Persona("Joan", 23)   // sense new!
  p.edat = 24
  ```
  El constructor primari no pot contenir codi, però es pot posar codi d'inicialització en un
  bloc `init`:
  ```kotlin
  class Persona(val nom: String) {
      init {
          println("S'ha creat en/na $nom")
      }
  }
  ```
  Pot haver-hi constructors secundaris, que porten la paraula `constructor` i han de cridar el
  primari amb `this(...)`:
  ```kotlin
  class Persona(val nom: String) {
      var fills: MutableList<Persona> = mutableListOf()

      constructor(nom: String, pare: Persona)
              : this(nom) {
          pare.fills.add(this)
      }
  }
  ```
]

#card(17, "Propietats i visibilitat", color: blau)[
  ```kotlin
  var valor = 1  // getter i setter per defecte
  val numero: Int? // només getter: s'ha d'inicialitzar
                   // al constructor o a init
  val enterInferit = 1  // de tipus Int, només getter
  ```
  #sub[Getter i setter personalitzats]
  Si vols canviar el comportament per defecte o el modificador d'accés. Al paràmetre del setter
  se li sol dir `value`, però pot tenir qualsevol nom.
  ```kotlin
  class Rectangle(val amplada: Int, val alcada: Int) {
      val area: Int
          get() = amplada * alcada  // es calcula cada cop
  }
  ```
  Per accedir al valor guardat (_backing field_) es fa servir `field`:
  ```kotlin
  var edat = 0   // aquest valor va directe al field
      set(value) {
          if (value >= 0)
              field = value
      }

  var dataText = ""
      private set  // només es canvia des de dins
  ```
  #compara(
    ("public int Edat { get; private set; }", "var edat = 0\n  private set"),
  )
  #taula(
    (auto, 1fr),
    th[Modificador], th[Visible des de...],
    `public`, [tot arreu. *És el valor per defecte* (a C\#, `private`).],
    `private`, [la mateixa classe (o fitxer, si és de nivell superior)],
    `protected`, [la classe i les seves subclasses],
    `internal`, [el mateix mòdul (com l'`internal` de C\#)],
  )
]

#card(18, "Herència, abstractes i interfícies", color: blau)[
  ```kotlin
  open class Persona(val nom: String) {
      open fun saluda() = "Hola, em dic $nom"
      // per defecte és final: cal open per sobreescriure
  }

  class PersonaAnglesa(nom: String) : Persona(nom) {
      override fun saluda() = "Hi, $nom here"
  }
  ```
  #avis[Les classes i els mètodes són `final` per defecte. Si no poses `open`, no se'n pot
  heretar ni sobreescriure'ls.]
  #sub[Classes abstractes]
  ```kotlin
  abstract class Animal(val nom: String) {
      abstract fun so(): String
  }

  class Gos(nom: String) : Animal(nom) {
      override fun so() = "Bup!"
  }
  ```
  #sub[Interfícies]
  ```kotlin
  interface Forma {
      fun area(): Double
      fun descripcio() = "Àrea: ${area()}" // amb cos
  }

  class Cercle(val radi: Double) : Forma {
      override fun area() = PI * radi * radi  // kotlin.math
  }
  ```
  #nota[Després dels `:` va la classe pare *amb parèntesis* (se'n crida el constructor) i les
  interfícies *sense*: `class B : A(), Forma`.]
]

#card(19, "Data classes", color: blau)[
  Si fem servir classes normals:
  ```kotlin
  class Persona(val nom: String, val edat: Int)

  val persona1 = Persona("Joan", 23)
  val persona2 = Persona("Joan", 23)

  persona1 == persona2 // false: equals no està
                       // sobreescrit (objectes diferents)
  print(persona1)      // Persona@567d299b
  ```
  Amb `data class`, Kotlin genera sol:
  - un `toString` que mostra el valor de cada camp;
  - un `equals` que retorna cert si tots els camps són iguals (i el `hashCode`);
  - el mètode `copy`, que crea un objecte idèntic canviant només els camps que li indiquem;
  - la desestructuració: assignar cada camp a una variable en una sola sentència.

  Se solen declarar amb `val` (immutables) i gairebé sense codi.
  ```kotlin
  data class Persona(val nom: String, val edat: Int)

  val persona1 = Persona("Joan", 23)
  val persona2 = Persona("Joan", 23)

  persona1 == persona2   // true: mateix contingut
  persona1 === persona2  // false: objectes diferents
  print(persona1)        // Persona(nom=Joan, edat=23)
  val persona3 = persona1.copy(nom = "Pere")
  print(persona3)        // Persona(nom=Pere, edat=23)

  val (cadena, enter) = persona3
  print(cadena)          // Pere
  print(enter)           // 23
  ```
  #nota[És com un `record` de C\#.]
]

#card(20, "Enums", color: blau)[
  ```kotlin
  enum class Dia {
      DILLUNS, DIMARTS, DIMECRES, DIJOUS,
      DIVENDRES, DISSABTE, DIUMENGE
  }

  val dia: Dia = Dia.DIMARTS
  ```
  Amb propietats:
  ```kotlin
  enum class FormaDePagament(val nom: String,
                             val comissio: Double) {
      EFECTIU("Efectiu", 0.0),
      XEC("Xec", 0.50),
      TRANSFERENCIA("Transferència", 0.0),
      CONTRAREEMBORSAMENT("Contrareemborsament", 1.5),
      TELEMATIC("PayPal", 0.1)
  }

  val formaDePagament = FormaDePagament.XEC
  print(formaDePagament.nom)       // Xec
  print(formaDePagament.comissio)  // 0.5
  print(formaDePagament.name)      // XEC
  print(formaDePagament.ordinal)   // 1
  ```
  ```kotlin
  // entries: Kotlin 1.9+. Abans: FormaDePagament.values()
  for (f in FormaDePagament.entries) println(f.nom)

  val festiu = when (dia) {
      Dia.DISSABTE, Dia.DIUMENGE -> true
      else -> false
  }
  ```
]

#card(21, "object i companion object", color: blau)[
  Kotlin no té `static`. En el seu lloc:
  ```kotlin
  object Configuracio {     // una sola instància
      var idioma = "ca"
      fun descripcio() = "Idioma: $idioma"
  }
  Configuracio.idioma = "en"

  class Comptador {
      companion object {    // com els static de C#
          var total = 0
          fun crea(): Comptador {
              total++
              return Comptador()
          }
      }
  }
  Comptador.crea()
  println(Comptador.total)  // 1
  ```
  #nota[Les funcions i constants que a C\# posaries en una classe `static` d'utilitats, a Kotlin
  solen anar directament al fitxer, fora de cap classe.]
]

#seccio("Entrada i sortida per consola", color: cian)

#card(22, "stdin, stdout i stderr", color: cian)[
  Tot programa de consola té tres canals (_fluxos_) oberts des que arrenca:
  #block(above: 6pt, below: 6pt, grid(
    columns: (1fr, auto, 1.2fr, auto, 1fr), column-gutter: 4pt, row-gutter: 4pt, align: horizon,
    caixa(fill: cian.lighten(75%), color: cian.darken(40%), h: 28pt)[Teclat \ o fitxer],
    fletxa(c: cian),
    grid.cell(rowspan: 2, box(width: 100%, height: 60pt, radius: 5pt, fill: cian,
      align(center + horizon, text(font: titular, size: 11pt, fill: white)[Programa]))),
    fletxa(c: verd),
    caixa(fill: verd.lighten(80%), color: verd.darken(30%), h: 28pt)[stdout \ pantalla],
    align(center, text(size: 6.8pt, weight: "bold", fill: cian.darken(30%))[stdin (0)]),
    [],
    fletxa(c: vermell),
    caixa(fill: vermell.lighten(85%), color: vermell.darken(15%), h: 28pt)[stderr \ pantalla],
  ))
  #taula(
    (auto, auto, 1fr),
    th[Flux], th[Per a...], th[En Kotlin],
    [stdin (0)], [llegir dades], [`readln()`, #raw("Scanner(System.`in`)")],
    [stdout (1)], [els resultats], [`print()`, `println()`],
    [stderr (2)], [errors i avisos], [`System.err.println()`],
  )
  ```kotlin
  fun main() {
      println("Resultat: 42")            // stdout
      System.err.println("Avís: buit")   // stderr
  }
  ```
  Per defecte, stdout i stderr surten tots dos per la pantalla. Però es poden redirigir per
  separat des de la consola:
  ```bash
  java -jar prog.jar < dades.txt > res.txt 2> err.txt
  ```
  - `< dades.txt`: stdin llegeix del fitxer en lloc del teclat.
  - `> res.txt`: stdout va al fitxer (`>>` hi afegeix al final).
  - `2> err.txt`: stderr va a un altre fitxer. Els errors no embruten els resultats.

  #nota[Fi de l'entrada: quan stdin s'acaba, `readlnOrNull()` retorna `null`. Des del teclat es
  provoca amb Ctrl+D (Linux, Mac) o Ctrl+Z i Enter (Windows).]
  #avis[stdout té buffer i stderr no: si escrius als dos alhora, els missatges poden sortir
  barrejats en un ordre diferent del del codi.]
]

#card(23, "El buffer del teclat", color: cian)[
  El programa no llegeix directament del teclat: llegeix d'un *buffer*, una cua de caràcters.
  - Mentre escrius, el terminal es guarda la línia: el programa encara no rep res.
  - Quan prems *Enter*, tota la línia passa al buffer, *amb el salt de línia* `\n` al final.
  - Cada lectura agafa del principi del buffer el que necessita. El que sobra s'hi queda per a
    la lectura següent.
  - Si el buffer és buit, el programa s'atura i espera.

  #sub[Exemple: l'usuari escriu «17» i prem Enter]
  #let pas(codi, caselles, resultat) = (
    align(horizon, codi),
    align(horizon, stack(dir: ltr, spacing: 1.5pt, ..caselles)),
    align(horizon, resultat),
  )
  #block(above: 5pt, below: 5pt, grid(
    columns: (auto, 1fr, auto), column-gutter: 6pt, row-gutter: 5pt,
    text(size: 6.8pt, weight: "bold")[Lectura], text(size: 6.8pt, weight: "bold")[Buffer després],
    text(size: 6.8pt, weight: "bold")[Retorna],
    ..pas([_(Enter)_], (cas[1], cas[7], cas[\\n]), []),
    ..pas(`nextInt()`, (cas[\\n], buit, buit), pill(fill: verd.lighten(84%), color: verd-f)[#marca-ok(w: 6pt) 17]),
    ..pas(`nextLine()`, (buit, buit, buit), pill(fill: vermell.lighten(86%), color: vermell-f)[#marca-error(w: 6pt) buit]),
  ))
  ```kotlin
  val sc = Scanner(System.`in`)
  print("Edat: ")
  val edat = sc.nextInt()   // agafa 17, deixa el \n
  print("Nom: ")
  val nom = sc.nextLine()   // "" !! troba el \n
  ```
  #avis[Després de `nextInt()` o `nextDouble()`, el `\n` es queda al buffer i el `nextLine()`
  següent retorna un text buit sense esperar l'usuari. Solució: fes un `sc.nextLine()` de més,
  o llegeix sempre línies senceres i converteix-les.]
  #nota[A Windows, l'Enter pot arribar com a dos caràcters: `\r\n`.]
]

#card(24, "Llegir de la consola", color: cian)[
  Es pot fer servir la classe `Scanner` de Java, que permet llegir diferents tipus de dades:
  ```kotlin
  import java.util.Scanner

  fun main(args: Array<String>) {
      val input = Scanner(System.`in`) // `in`: reservada
      val a = input.nextInt()
      val b = input.nextInt()
      println(a + b)
  }
  ```
  #taula(
    (auto, 1fr),
    th[Mètode], th[Llegeix],
    `nextInt()`, [el número següent (salta espais i salts de línia)],
    `nextDouble()`, [un decimal, segons l'idioma del sistema],
    `next()`, [la paraula següent],
    `nextLine()`, [la resta de la línia actual],
    `hasNextInt()`, [`true` si el que ve és un enter (no el consumeix)],
    `hasNext()`, [`true` si queda alguna cosa per llegir],
  )
  O amb les funcions pròpies de Kotlin, que llegeixen una línia sencera com a `String`:
  ```kotlin
  fun main(args: Array<String>) {
      val lectura = readlnOrNull()   // String?
      val cadena: String = lectura ?: ""
      val valor: Int = cadena.toIntOrNull() ?: 0
      println(valor)
  }
  ```
  #compara(
    ("Console.ReadLine()", "readlnOrNull() / readln()"),
    ("int.TryParse(s, out n)", "s.toIntOrNull()"),
  )
  #nota[`readln()` retorna `String` i peta si l'entrada s'ha acabat; `readlnOrNull()` hi retorna
  `null`.]
]

#card(25, "Llegir caràcter a caràcter", color: cian)[
  Amb `Scanner`, canviant el separador perquè cada `next()` torni un sol caràcter. Aquest
  programa compta els caràcters fins que troba un punt:
  ```kotlin
  import java.util.Scanner

  fun main() {
      val entrada = Scanner(System.`in`)
      entrada.useDelimiter("")
      var caracterActual: Char = entrada.next()[0]
      var nChars = 1

      while (caracterActual != '.') {
          caracterActual = entrada.next()[0]
          nChars++
      }

      print("S'han llegit $nChars caràcters")
  }
  ```
  - `useDelimiter("")`: normalment `next()` retorna paraules separades per espais. Amb un
    separador buit, cada `next()` retorna un `String` d'un sol caràcter.
  - `next()[0]`: agafa el primer (i únic) caràcter del `String` i el converteix en `Char`.
  - Es compten tots els caràcters llegits, *punt inclòs*. També els espais i els salts de línia.
  #grid(columns: (1fr, 1fr), column-gutter: 6pt,
    sortida[Hola. \ S'han llegit 5 caràcters],
    sortida[Hi \ ha. \ S'han llegit 6 caràcters],
  )
  #avis[Pel buffer del teclat, el programa no rep res fins que prems Enter, encara que ja hagis
  escrit el punt. I si l'entrada s'acaba sense cap punt, `next()` peta
  (`NoSuchElementException`): protegeix-ho amb `entrada.hasNext()`.]
  #sub[Alternativa: System.in.read()]
  ```kotlin
  var codi = System.`in`.read()  // Int; -1 si s'acaba
  var n = 0
  while (codi != -1 && codi.toChar() != '.') {
      n++                        // no compta el punt
      codi = System.`in`.read()
  }
  ```
  #nota[`read()` llegeix *bytes*, no caràcters: una lletra accentuada (UTF-8) en compta dos.
  `Scanner` sí que treballa amb caràcters.]
]

#seccio("Excepcions i fitxers", color: vermell)

#card(26, "Excepcions", color: vermell)[
  Com a C\#, però `try` també és una expressió que retorna un valor:
  ```kotlin
  val numero = try {
      "abc".toInt()
  } catch (e: NumberFormatException) {
      0
  } finally {
      println("Sempre s'executa")
  }
  ```
  ```kotlin
  throw IllegalArgumentException("Valor no vàlid")

  require(edat >= 0) { "L'edat no pot ser negativa" }
  // si no es compleix: IllegalArgumentException
  check(connectat) { "No estàs connectat" }
  // si no es compleix: IllegalStateException
  ```
  #nota[No hi ha excepcions comprovades (_checked_): mai cal declarar `throws`.]
]

#card(27, "Fitxers", color: vermell)[
  #sub[Llegir-ho tot de cop]
  ```kotlin
  import java.io.File

  fun main(args: Array<String>) {
      val text = File("exemple.txt").readText()
      println(text)
  }
  ```
  Amb un `BufferedReader` o un `InputStream`:
  ```kotlin
  import java.io.BufferedReader
  import java.io.InputStream

  val bufferedReader: BufferedReader =
      File("exemple.txt").bufferedReader()
  val inputString = bufferedReader.use { it.readText() }

  val inputStream: InputStream =
      File("exemple.txt").inputStream()
  val tot = inputStream.bufferedReader()
      .use { it.readText() }
  ```
  #sub[Llegir línia a línia]
  ```kotlin
  val lineList = mutableListOf<String>()

  // Amb InputStream
  inputStream.bufferedReader()
      .forEachLine { lineList.add(it) }

  // Amb File directament
  File("exemple.txt").useLines { lines ->
      lines.forEach { lineList.add(it) }
  }

  lineList.forEach { println("> " + it) }

  val linies = File("exemple.txt").readLines()
  ```
  #sub[Escriure]
  ```kotlin
  File("sortida.txt").writeText("Hola\n")   // sobreescriu
  File("sortida.txt").appendText("Adéu\n")  // afegeix
  File("sortida.txt").printWriter().use { out ->
      out.println("Línia 1")
      out.println("Línia 2")
  }
  if (File("dades.txt").exists()) { /* ... */ }
  ```
  #nota[`use` és el `using` de C\#: tanca el fitxer en acabar, encara que hi hagi una excepció.]
  #compara(
    ("File.ReadAllText(r)", "File(r).readText()"),
    ("File.ReadAllLines(r)", "File(r).readLines()"),
    ("File.WriteAllText(r, t)", "File(r).writeText(t)"),
    ("File.AppendAllText(r, t)", "File(r).appendText(t)"),
  )
]

#seccio("Programació competitiva", color: verd)

#card(28, "Lectura ràpida de l'entrada", color: verd)[
  A les competicions les dades arriben per stdin i cal llegir-ne moltes, i ràpid. Aquestes
  funcions es copien a dalt del programa.
  #sub[Línia a línia (amb readLine)]
  ```kotlin
  private fun llegir() = readLine()!!   // no en diguis readln:
  private fun llegirInt() = llegir().toInt()  // xocaria amb
  private fun llegirBigInt(radix: Int = 10) = // la de Kotlin
      llegir().toBigInteger(radix)

  private fun lineSequence(limit: Int = Int.MAX_VALUE) =
      generateSequence { readLine() }
          .constrainOnce().take(limit)

  private fun llegirTrossos() = llegir().split(' ')
  private fun llegirInts() =
      llegirTrossos().map { it.toInt() }

  private fun llegirIntArray() = llegirTrossos().run {
      IntArray(size) { get(it).toInt() }
  }
  private fun llegirIntArrayN(n: Int) =
      IntArray(n) { llegirInt() }
  private fun llegirIntArray2d(rows: Int, cols: Int) =
      Array(rows) {
          llegirIntArray().also { require(it.size == cols) }
      }
  ```
  #taula(
    (auto, 1fr),
    th[Funció], th[Llegeix],
    `llegirInt()`, [una línia amb un número],
    `llegirInts()`, [una línia de números separats per espais (`List<Int>`); `llegirIntArray()`, igual però `IntArray`],
    `llegirIntArrayN(n)`, [`n` línies amb un número cadascuna],
    `llegirIntArray2d(f, c)`, [`f` línies de `c` números (matriu)],
  )
  #avis[No en diguis `readln()`: Kotlin ja en té una de pròpia (#ref-targeta(24)) i el teu programa
  no compilaria. Hi ha la mateixa família per a cada tipus: canvia `Int` per `Byte`, `Short`,
  `Long`, `Float` o `Double`.]
]

#card(29, "Lectura per paraules (només JVM)", color: verd)[
  Llegeix caràcter a caràcter amb `System.in.read()` i talla per espais i salts de línia. És una
  mica més ràpid que `Scanner`, i permet tenir diversos números a la mateixa línia.
  ```kotlin
  private fun isWhiteSpace(c: Char) = c in " \r\n\t"

  private fun readString() = generateSequence {
          System.`in`.read().toChar()
      }
      .dropWhile { isWhiteSpace(it) }  // salta espais
      .takeWhile { !isWhiteSpace(it) } // fins al següent
      .joinToString("")

  private fun llegirNum() = readString().toInt()
  private fun llegirLong() = readString().toLong()
  private fun llegirDouble() = readString().toDouble()

  private fun llegirNums(n: Int) =
      generateSequence { llegirNum() }.take(n)
  private fun llegirDoubles(n: Int) =
      generateSequence { llegirDouble() }.take(n)
  ```
  #sortida[3 \ 10 20 \ 30]
  Amb aquesta entrada, `llegirNum()` dona `3` i després `llegirNums(3).toList()` dona
  `[10, 20, 30]`, encara que estiguin en línies diferents.
]
