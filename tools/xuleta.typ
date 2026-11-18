// Plantilla de xuletes en Typst.
// Ús: veure ../C#/XuletaBàsica.typ
//
// Compilar en local (cal indicar on són les fonts):
//   typst compile --font-path tools/fonts "C#/XuletaBàsica.typ"
// A typst.app: puja aquest fitxer, el de la xuleta i les fonts (tools/fonts/*.ttf) a l'arrel
// del projecte i, a la xuleta, canvia l'import per  #import "xuleta.typ": *
// La web detecta sola les fonts de dins del projecte.
//
// Fonts (llicència OFL, incloses a tools/fonts):
//   Atkinson Hyperlegible — text (dissenyada per llegir-se fàcil)
//   Lilita One            — títols
//   JetBrains Mono        — codi

// ---------- COLORS ----------
#let violeta = rgb("#6c5ce7")
#let blau = rgb("#1c7ed6")
#let turquesa = rgb("#0c9f7c")
#let taronja = rgb("#f76707")
#let rosa = rgb("#e64980")
#let indi = rgb("#4c6ef5")
#let cian = rgb("#1098ad")
#let vermell = rgb("#e03131")
#let verd = rgb("#2f9e44")
#let ink = rgb("#26243a")

// Cada targeta agafa un color d'aquesta llista segons el número (o el que li passis).
#let paleta = (violeta, blau, cian, turquesa, indi, taronja)

#let lletra = "Atkinson Hyperlegible"
#let titular = "Lilita One"
#let mono = "JetBrains Mono"

// Color de la targeta actual: el fan servir sub(), taula() i els blocs de codi.
#let _accent = state("xuleta-accent", violeta)

// Colors del ressaltat de codi (tema TextMate). Va aquí dins perquè la plantilla sigui un sol
// fitxer i funcioni igual a typst.app sense haver de pujar res més.
#let _tema-codi = bytes(```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Colors del codi de les xuletes (fons clar, colors vius però llegibles en paper). -->
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key><string>Xuleta</string>
  <key>settings</key>
  <array>
    <dict><key>settings</key><dict>
      <key>foreground</key><string>#26243a</string>
      <key>background</key><string>#FFFFFF</string>
    </dict></dict>
    <dict>
      <key>name</key><string>Comentari</string>
      <key>scope</key><string>comment, punctuation.definition.comment</string>
      <key>settings</key><dict><key>foreground</key><string>#8a8fa3</string><key>fontStyle</key><string>italic</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Text</string>
      <key>scope</key><string>string, punctuation.definition.string, constant.character</string>
      <key>settings</key><dict><key>foreground</key><string>#c2410c</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Interpolació</string>
      <key>scope</key><string>meta.interpolation, punctuation.section.interpolation, string.quoted.double.interpolated meta.interpolation</string>
      <key>settings</key><dict><key>foreground</key><string>#26243a</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Número</string>
      <key>scope</key><string>constant.numeric</string>
      <key>settings</key><dict><key>foreground</key><string>#c2255c</string></dict>
    </dict>
    <dict>
      <key>name</key><string>true false null</string>
      <key>scope</key><string>constant.language</string>
      <key>settings</key><dict><key>foreground</key><string>#d9480f</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Paraula clau</string>
      <key>scope</key><string>keyword, storage.modifier, keyword.control, keyword.operator.new, keyword.other</string>
      <key>settings</key><dict><key>foreground</key><string>#1d4ed8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Operadors</string>
      <key>scope</key><string>keyword.operator</string>
      <key>settings</key><dict><key>foreground</key><string>#5b4bd6</string><key>fontStyle</key><string></string></dict>
    </dict>
    <dict>
      <key>name</key><string>Tipus primitius</string>
      <key>scope</key><string>storage.type, support.type, keyword.type</string>
      <key>settings</key><dict><key>foreground</key><string>#1d4ed8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Classes</string>
      <key>scope</key><string>entity.name.type, support.class, variable.other.class, support.type.class</string>
      <key>settings</key><dict><key>foreground</key><string>#0f8a7e</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Funcions</string>
      <key>scope</key><string>entity.name.function, variable.function, support.function, meta.function-call</string>
      <key>settings</key><dict><key>foreground</key><string>#9c36b5</string></dict>
    </dict>
    <dict>
      <key>name</key><string>XML</string>
      <key>scope</key><string>entity.name.tag</string>
      <key>settings</key><dict><key>foreground</key><string>#1d4ed8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
  </array>
</dict>
</plist>
```.text)

// ---------- PETITES PECES GRÀFIQUES ----------

// Triangle d'avís dibuixat (sense emojis: s'imprimeix igual a tot arreu).
#let _triangle(c) = box(width: 11pt, height: 10pt, baseline: 2pt)[
  #place(polygon(
    fill: c, stroke: (paint: c, thickness: 1.6pt, join: "round"),
    (5.5pt, 1pt), (10.2pt, 9.2pt), (0.8pt, 9.2pt),
  ))
  #place(center + bottom, dy: -0.6pt, text(font: lletra, fill: white, weight: "bold", size: 7pt)[!])
]

// Rodona amb una lletra o número a dins.
#let rodona(body, fill: violeta, color: white, r: 6pt, size: 8pt) = box(baseline: r * 0.35)[
  #circle(radius: r, fill: fill, inset: 0pt)[
    #set align(center + horizon)
    #text(font: titular, fill: color, size: size, body)
  ]
]

// Estrella de cinc puntes.
#let estrella(r: 5pt, fill: rgb("#fab005")) = {
  let punts = range(10).map(i => {
    let radi = if calc.even(i) { r } else { r * 0.45 }
    let a = -90deg + i * 36deg
    (r + radi * calc.cos(a), r + radi * calc.sin(a))
  })
  box(width: 2 * r, height: 2 * r, baseline: r * 0.3, place(polygon(fill: fill, ..punts)))
}

// Tros de cinta adhesiva (per als post-its).
#let _cinta = place(top + center, dy: -13pt, rotate(-3deg,
  rect(width: 36pt, height: 9pt, fill: rgb(200, 194, 230, 140), stroke: none)))

// Etiqueta arrodonida (per a tags, resultats...).
#let pill(body, fill: violeta, color: white, size: 7pt) = box(
  fill: fill, radius: 20pt, inset: (x: 5pt, y: 2pt), baseline: 1.5pt,
  text(fill: color, weight: "bold", size: size, body),
)

// Etiquetes SÍ / NO per a taules de veritat.
#let si = pill(fill: verd.lighten(80%), color: verd.darken(25%))[SÍ]
#let no = pill(fill: vermell.lighten(82%), color: vermell.darken(15%))[NO]

// Fletxa horitzontal per als diagrames.
#let fletxa(w: 16pt, c: ink.lighten(40%)) = box(width: w, height: 6pt, baseline: -1pt)[
  #place(horizon, line(length: w - 3pt, stroke: 1pt + c))
  #place(right + horizon, polygon(fill: c, (0pt, -2.8pt), (4pt, 0pt), (0pt, 2.8pt)))
]

// ---------- CAIXES ----------

// Avís: parany, error freqüent, cosa que peta. Post-it groc una mica tort.
#let avis(body, angle: -1deg) = block(above: 10pt, below: 7pt, inset: (x: 3pt), rotate(angle, reflow: true,
  block(
    width: 100%, fill: rgb("#fff3bf"), stroke: 0.6pt + rgb("#fcc419"),
    radius: 3pt, inset: (x: 7pt, top: 8pt, bottom: 6pt),
  )[
    #_cinta
    #grid(
      columns: (auto, 1fr), column-gutter: 5pt, align: (horizon, horizon),
      _triangle(rgb("#f08c00")),
      text(size: 8pt, fill: rgb("#7a4a00"), weight: "bold", body),
    )
  ],
))

// Nota: aclariment o alternativa.
#let nota(body) = block(
  width: 100%, above: 6pt, below: 6pt, fill: rgb("#f3f0ff"),
  stroke: (left: 3pt + violeta), radius: (left: 2pt, right: 5pt), inset: (x: 7pt, y: 5pt),
)[
  #grid(
    columns: (auto, 1fr), column-gutter: 5pt, align: (horizon, horizon),
    rodona(r: 5.5pt, size: 8pt)[i],
    text(size: 8pt, fill: violeta.darken(30%), body),
  )
]

// Regla d'or: post-it destacat, amb cinta i estrella.
#let postit(body, angle: 1.4deg) = block(above: 13pt, below: 6pt, inset: (x: 3pt), rotate(angle, reflow: true,
  block(
    width: 100%, fill: rgb("#ffdeeb"), stroke: 0.8pt + rosa.lighten(30%),
    radius: 3pt, inset: (x: 8pt, top: 9pt, bottom: 7pt),
  )[
    #_cinta
    #estrella() #h(2pt) #text(font: titular, fill: rosa.darken(20%), size: 10pt)[REGLA D'OR]
    #v(-2pt)
    #text(size: 8.2pt, fill: rosa.darken(45%), weight: "bold", body)
  ],
))

// Consola: com es veu la sortida del programa.
#let sortida(body) = block(
  width: 100%, above: 4pt, below: 5pt, fill: rgb("#2b2a3d"), radius: 4pt, inset: (x: 6pt, y: 4pt),
)[
  #text(font: mono, size: 6.3pt, fill: rgb("#a5a3c7"))[CONSOLA] \
  #text(font: mono, size: 6.9pt, fill: rgb("#e9f5db"), body)
]

// ---------- TARGETA ----------
#let card(num, title, color: auto, body) = {
  let c = if color == auto { paleta.at(calc.rem(num - 1, paleta.len())) } else { color }
  // Marques de posició: permeten mesurar les targetes amb `typst query` per ajustar la maquetació.
  [#context [#metadata((num: num, page: here().page(), y: here().position().y))<inici-targeta>]]
  block(
    width: 100%, breakable: false, above: 0pt, below: 9pt,
    fill: white, radius: 7pt,
    stroke: (bottom: 2pt + c.lighten(55%), rest: 0.7pt + c.lighten(55%)),
  )[
    // Capçalera de color
    #block(
      width: 100%, fill: c, radius: (top: 6.5pt), inset: (x: 7pt, y: 5pt), below: 0pt, clip: true,
    )[
      #place(right + horizon, dx: 16pt, circle(radius: 20pt, fill: white.transparentize(86%)))
      #place(right + horizon, dx: -14pt, dy: 9pt, circle(radius: 9pt, fill: white.transparentize(90%)))
      #grid(
        columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
        circle(radius: 8pt, fill: white, inset: 0pt)[
          #set align(center + horizon)
          #text(font: titular, fill: c, size: 10pt)[#num]
        ],
        text(font: titular, fill: white, size: 12pt)[#title],
      )
    ]
    #block(width: 100%, inset: (x: 7pt, top: 6pt, bottom: 7pt), above: 0pt)[
      #_accent.update(c)
      #body
      #context [#metadata((num: num, page: here().page(), y: here().position().y))<fi-targeta>]
    ]
  ]
}

// Apartat dins d'una targeta
#let sub(title) = context {
  let c = _accent.get()
  block(above: 8pt, below: 4pt, sticky: true)[
    #box(width: 3pt, height: 9pt, radius: 1.5pt, fill: c, baseline: 1.2pt)
    #h(2pt)
    #text(font: titular, fill: c.darken(15%), size: 9.5pt)[#title]
  ]
}

// ---------- BLOC QUE OCUPA LES DUES COLUMNES ----------
#let ample(title: none, color: violeta, pos: top, body) = place(
  pos, scope: "parent", float: true, clearance: 8pt,
  block(
    width: 100%, fill: color.lighten(93%), radius: 8pt,
    stroke: 0.8pt + color.lighten(55%), inset: (x: 9pt, y: 8pt),
  )[
    #_accent.update(color)
    #if title != none {
      block(below: 6pt, text(font: titular, fill: color.darken(10%), size: 13pt, title))
    }
    #body
  ],
)

// ---------- TAULA ----------
#let taula(cols, ..files) = context {
  let c = _accent.get()
  block(
    width: 100%, radius: 4pt, clip: true, stroke: 0.6pt + c.lighten(60%), above: 5pt, below: 5pt,
    table(
      columns: cols,
      inset: (x: 4.5pt, y: 3pt),
      stroke: none,
      align: horizon,
      fill: (x, y) => if y == 0 { c } else if calc.even(y) { c.lighten(92%) } else { white },
      ..files,
    ),
  )
}

#let th(body) = text(fill: white, weight: "bold", body)

// ---------- DOCUMENT ----------
#let xuleta(
  title: "",
  kicker: "",          // text petit damunt del títol (p. ex. "Xuleta C# · 1")
  subtitle: none,
  tags: (),            // temes, es mostren com a etiquetes
  badge: "C#",         // text de la insígnia de l'esquerra
  doc,
) = {
  set document(title: if kicker != "" { kicker + ": " + title } else { title })
  set page(
    paper: "a4", margin: (x: 1cm, top: 1cm, bottom: 1.2cm), columns: 2,
    background: rect(
      width: 100%, height: 100%, stroke: none,
      fill: tiling(size: (12pt, 12pt))[
        #place(dx: 5.5pt, dy: 5.5pt, circle(radius: 0.5pt, fill: rgb("#dcd7f3")))
      ],
    ),
    footer: context {
      set text(size: 6.8pt, fill: violeta.darken(10%))
      pill(fill: violeta.lighten(85%), color: violeta.darken(20%), size: 6.5pt)[#badge]
      h(4pt)
      [#kicker · #title]
      h(1fr)
      pill(fill: violeta, size: 6.5pt)[#counter(page).display("1 / 1", both: true)]
    },
  )
  set columns(gutter: 10pt)
  set text(font: lletra, size: 8.9pt, fill: ink, lang: "ca")
  set smartquote(enabled: false)
  set par(justify: false, leading: 0.5em, spacing: 0.65em)
  show link: set text(fill: violeta)
  set list(
    marker: context text(fill: _accent.get())[●], spacing: 0.6em, indent: 2pt, body-indent: 4pt,
  )

  // Codi
  set raw(theme: _tema-codi)
  // Sense lligadures: que >= es vegi com >= i no com un sol símbol
  show raw: set text(font: mono, size: 7.4pt, ligatures: false, features: (calt: 0))
  show raw.where(block: true): it => context {
    let c = _accent.get()
    block(
      width: 100%, fill: rgb("#faf9ff"), above: 5pt, below: 5pt,
      stroke: (left: 2.5pt + c, rest: 0.5pt + c.lighten(70%)),
      radius: (left: 2pt, right: 4pt), inset: (x: 6pt, y: 4.5pt),
    )[#it]
  }
  show raw.where(block: false): it => box(
    fill: rgb("#f1edff"), radius: 2pt, inset: (x: 2pt), outset: (y: 1.6pt),
    text(fill: rgb("#5f3dc4"), weight: "bold", it),
  )
  // Línies de codi marcades: // ERROR (fons vermell) i // OK (fons verd)
  show raw.line: it => if it.text.contains("// ERROR") {
    box(fill: rgb("#ffe3e3"), width: 100%, outset: (y: 1.4pt, x: 2pt), radius: 1.5pt, it)
  } else if it.text.contains("// OK") {
    box(fill: rgb("#e6fcf5"), width: 100%, outset: (y: 1.4pt, x: 2pt), radius: 1.5pt, it)
  } else { it }

  // Capçalera a tota l'amplada
  place(
    top, scope: "parent", float: true, clearance: 11pt,
    block(
      width: 100%, radius: 10pt, clip: true, inset: (x: 13pt, y: 11pt),
      fill: gradient.linear(violeta, rgb("#845ef7"), rgb("#4dabf7"), angle: 0deg),
    )[
      // Bombolles decoratives
      #place(right + top, dx: 30pt, dy: -40pt, circle(radius: 55pt, fill: white.transparentize(88%)))
      #place(right + bottom, dx: -70pt, dy: 30pt, circle(radius: 30pt, fill: white.transparentize(90%)))
      #place(right + top, dx: -150pt, dy: -8pt, circle(radius: 10pt, fill: white.transparentize(88%)))
      #place(right + horizon, dx: -12pt, text(font: mono, size: 30pt, weight: "bold",
        fill: white.transparentize(55%))[{ }])
      #grid(
        columns: (auto, 1fr), column-gutter: 12pt, align: horizon,
        rotate(-6deg, box(
          width: 46pt, height: 46pt, radius: 10pt, fill: white,
          stroke: 2pt + white.transparentize(40%),
          align(center + horizon, text(font: titular, size: 22pt, fill: violeta)[#badge]),
        )),
        [
          #text(size: 8pt, weight: "bold", fill: white.transparentize(15%), tracking: 1.2pt)[#upper(kicker)]
          #v(-8pt)
          #text(font: titular, size: 24pt, fill: white)[#title]
          #if subtitle != none {
            v(-8pt)
            text(size: 9pt, fill: white.transparentize(10%))[#subtitle]
          }
          #if tags.len() > 0 {
            v(-3pt)
            tags.map(t => pill(fill: white.transparentize(78%), size: 7.2pt)[#t]).join(h(3pt))
          }
        ],
      )
    ],
  )

  doc
}
