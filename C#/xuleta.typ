// Plantilla de les xuletes.
//
// Criteris de disseny (venen d'una revisió de disseny; no els desfacis sense motiu):
//  - Contrast: cap text blanc sobre un color clar. Els títols i les capçaleres de taula van en
//    tinta fosca sobre tinta clara; els números de targeta, en blanc sobre tinta gairebé negra.
//  - Blanc i negre: tots els senyals tenen forma, no només color (marques ✓/✗ dibuixades a les
//    línies de codi, SÍ ple contra NO amb vora discontínua, trama diagonal als avisos).
//  - Navegació: mapa del full amb números de pàgina automàtics, regleta de seccions al marge
//    dret, nom de la secció al peu i referències creuades amb pàgina (`ref-targeta`).
//  - Menys decoració i menys tinta: sense trama de fons, sense degradats, sense post-its girats.
//
// Compilar:  typst compile --font-path tools/fonts "C#/XuletaBàsica.typ"

// ---------- COLORS ----------
// Cada color té una variant fosca per a text (totes per sobre de 4,5:1 sobre blanc).
#let violeta = rgb("#6c5ce7")
#let violeta-f = rgb("#4a37b8")
#let blau = rgb("#1c7ed6")
#let blau-f = rgb("#15609f")
#let cian = rgb("#1098ad")
#let cian-f = rgb("#0a6e7d")
#let turquesa = rgb("#0c9f7c")
#let turquesa-f = rgb("#076f57")
#let indi = rgb("#4c6ef5")
#let indi-f = rgb("#2f4bc4")
#let taronja = rgb("#f76707")
#let taronja-f = rgb("#a74705")
#let rosa = rgb("#e64980")
#let rosa-f = rgb("#a82a58")
#let vermell = rgb("#e03131")
#let vermell-f = rgb("#a32020")
#let verd = rgb("#2f9e44")
#let verd-f = rgb("#1d6b2d")
#let ink = rgb("#23212e")
#let ink-suau = rgb("#5d5a70")
#let filet = rgb("#d8d5e6")

#let paleta = (violeta, blau, cian, turquesa, indi, taronja)

// Parella clar/fosc de cada color, per no haver de recordar el nom de la variant.
#let _fosc = (
  "#6c5ce7": violeta-f, "#1c7ed6": blau-f, "#1098ad": cian-f, "#0c9f7c": turquesa-f,
  "#4c6ef5": indi-f, "#f76707": taronja-f, "#e64980": rosa-f, "#e03131": vermell-f,
  "#2f9e44": verd-f,
)
#let fosc(c) = _fosc.at(c.to-hex().slice(0, 7), default: c.darken(35%))

#let lletra = "Atkinson Hyperlegible"
#let titular = "Lilita One"
#let mono = "JetBrains Mono"

#let _accent = state("xuleta-accent", violeta)

// Colors del ressaltat de codi. Els comentaris pugen a 4,6:1 (a la v1 eren 3,07:1).
#let _tema-codi = bytes(```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key><string>Xuleta2</string>
  <key>settings</key>
  <array>
    <dict><key>settings</key><dict>
      <key>foreground</key><string>#23212e</string>
      <key>background</key><string>#FFFFFF</string>
    </dict></dict>
    <dict>
      <key>name</key><string>Comentari</string>
      <key>scope</key><string>comment, punctuation.definition.comment</string>
      <key>settings</key><dict><key>foreground</key><string>#65697c</string><key>fontStyle</key><string>italic</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Text</string>
      <key>scope</key><string>string, punctuation.definition.string, constant.character</string>
      <key>settings</key><dict><key>foreground</key><string>#a8380a</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Interpolació</string>
      <key>scope</key><string>meta.interpolation, punctuation.section.interpolation</string>
      <key>settings</key><dict><key>foreground</key><string>#23212e</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Número</string>
      <key>scope</key><string>constant.numeric</string>
      <key>settings</key><dict><key>foreground</key><string>#a81d4c</string></dict>
    </dict>
    <dict>
      <key>name</key><string>true false null</string>
      <key>scope</key><string>constant.language</string>
      <key>settings</key><dict><key>foreground</key><string>#b03a0c</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Paraula clau</string>
      <key>scope</key><string>keyword, storage.modifier, keyword.control, keyword.other, storage.type.modifier</string>
      <key>settings</key><dict><key>foreground</key><string>#1746b8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Operadors</string>
      <key>scope</key><string>keyword.operator</string>
      <key>settings</key><dict><key>foreground</key><string>#4a3bbd</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Tipus</string>
      <key>scope</key><string>storage.type, support.type, keyword.type</string>
      <key>settings</key><dict><key>foreground</key><string>#1746b8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Classes</string>
      <key>scope</key><string>entity.name.type, support.class, variable.other.class, support.type.class</string>
      <key>settings</key><dict><key>foreground</key><string>#0a6457</string></dict>
    </dict>
    <dict>
      <key>name</key><string>Funcions</string>
      <key>scope</key><string>entity.name.function, variable.function, support.function, meta.function-call</string>
      <key>settings</key><dict><key>foreground</key><string>#872ea0</string></dict>
    </dict>
    <dict>
      <key>name</key><string>XML</string>
      <key>scope</key><string>entity.name.tag</string>
      <key>settings</key><dict><key>foreground</key><string>#1746b8</string><key>fontStyle</key><string>bold</string></dict>
    </dict>
  </array>
</dict>
</plist>
```.text)

// ---------- ICONES DIBUIXADES (res d'emojis: s'imprimeixen igual a tot arreu) ----------
#let _check(c: rgb("#1d6b2d"), w: 7pt) = box(width: w, height: w, baseline: w * 0.18)[
  #place(line(start: (w * 0.1, w * 0.52), end: (w * 0.4, w * 0.82), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
  #place(line(start: (w * 0.38, w * 0.82), end: (w * 0.92, w * 0.14), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
]
#let _cross(c: rgb("#a32020"), w: 7pt) = box(width: w, height: w, baseline: w * 0.18)[
  #place(line(start: (w * 0.14, w * 0.14), end: (w * 0.86, w * 0.86), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
  #place(line(start: (w * 0.86, w * 0.14), end: (w * 0.14, w * 0.86), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
]
#let _triangle(c) = box(width: 11pt, height: 10pt, baseline: 2pt)[
  #place(polygon(
    fill: c, stroke: (paint: c, thickness: 1.6pt, join: "round"),
    (5.5pt, 1pt), (10.2pt, 9.2pt), (0.8pt, 9.2pt),
  ))
  #place(center + bottom, dy: -0.6pt, text(font: lletra, fill: white, weight: "bold", size: 7pt)[!])
]
#let estrella(r: 5pt, fill: rgb("#b8860b")) = {
  let punts = range(10).map(i => {
    let radi = if calc.even(i) { r } else { r * 0.45 }
    let a = -90deg + i * 36deg
    (r + radi * calc.cos(a), r + radi * calc.sin(a))
  })
  box(width: 2 * r, height: 2 * r, baseline: r * 0.3, place(polygon(fill: fill, ..punts)))
}
#let fletxa(w: 16pt, c: ink-suau) = box(width: w, height: 6pt, baseline: -1pt)[
  #place(horizon, line(length: w - 3pt, stroke: 1pt + c))
  #place(right + horizon, polygon(fill: c, (0pt, -2.8pt), (4pt, 0pt), (0pt, 2.8pt)))
]
// Trama diagonal: marca els avisos també en blanc i negre.
#let _ratlles(c) = tiling(size: (4pt, 4pt))[
  #place(line(start: (-1pt, 5pt), end: (5pt, -1pt), stroke: 1.1pt + c))
  #place(line(start: (-1pt, 1pt), end: (1pt, -1pt), stroke: 1.1pt + c))
  #place(line(start: (3pt, 5pt), end: (5pt, 3pt), stroke: 1.1pt + c))
]

// Marques públiques, per fer-les servir també dins del contingut.
#let marca-ok(w: 7pt) = _check(w: w)
#let marca-error(w: 7pt) = _cross(w: w)

// ---------- PECES ----------
#let rodona(body, fill: ink, color: white, r: 6pt, size: 8pt) = box(baseline: r * 0.35)[
  #circle(radius: r, fill: fill, inset: 0pt)[
    #set align(center + horizon)
    #text(font: titular, fill: color, size: size, body)
  ]
]

// Luminància relativa (WCAG), per triar text blanc o tinta fosca sobre qualsevol fons.
#let _canal(v) = if v <= 0.03928 { v / 12.92 } else { calc.pow((v + 0.055) / 1.055, 2.4) }
#let lluminositat(c) = {
  let p = c.to-hex()
  let r = int(p.slice(1, 3), base: 16) / 255
  let g = int(p.slice(3, 5), base: 16) / 255
  let b = int(p.slice(5, 7), base: 16) / 255
  0.2126 * _canal(r) + 0.7152 * _canal(g) + 0.0722 * _canal(b)
}
// Text que es llegeix sobre un fons: blanc si el fons és fosc, tinta si és clar.
#let text-sobre(c) = if lluminositat(c) < 0.2 { white } else { ink }

// Etiqueta. Per defecte, tinta fosca sobre tinta clara.
#let pill(body, fill: auto, color: auto, base: violeta, size: 7pt) = {
  let f = if fill == auto { base.lighten(84%) } else { fill }
  let c = if color != auto { color } else if fill == auto { fosc(base) } else { text-sobre(f) }
  box(fill: f, radius: 3pt, inset: (x: 5pt, y: 2pt), baseline: 1.5pt,
    text(fill: c, weight: "bold", size: size, body))
}

// SÍ i NO: es distingeixen per forma (ple contra vora discontínua) i per icona.
#let si = box(
  fill: verd.lighten(86%), radius: 3pt, inset: (x: 4pt, y: 1.5pt), baseline: 1.5pt,
  stroke: 0.8pt + verd-f,
)[#_check(w: 6pt) #h(1pt) #text(fill: verd-f, weight: "bold", size: 7pt)[SÍ]]
#let no = box(
  radius: 3pt, inset: (x: 4pt, y: 1.5pt), baseline: 1.5pt,
  stroke: (paint: vermell-f, thickness: 0.8pt, dash: "dashed"),
)[#_cross(w: 6pt) #h(1pt) #text(fill: vermell-f, weight: "bold", size: 7pt)[NO]]

// ---------- CAIXES ----------
#let avis(body) = block(
  width: 100%, above: 8pt, below: 7pt, fill: rgb("#fff8e1"),
  radius: (left: 0pt, right: 3pt), inset: (x: 7pt, y: 6pt),
  // La franja ratllada de l'esquerra marca l'avís també en blanc i negre.
  stroke: (left: (paint: _ratlles(rgb("#c98f08")), thickness: 4.5pt), rest: 0.7pt + rgb("#e0b33a")),
)[
  #grid(
    columns: (auto, 1fr), column-gutter: 5pt, align: (horizon, horizon),
    _triangle(rgb("#b8860b")),
    text(size: 8pt, fill: rgb("#6b4700"), weight: "bold", body),
  )
]

#let nota(body) = block(
  width: 100%, above: 6pt, below: 6pt, fill: rgb("#f4f2ff"),
  stroke: (left: 1pt + violeta-f, rest: 0.5pt + violeta.lighten(65%)),
  radius: (left: 0pt, right: 3pt), inset: (x: 7pt, y: 5pt),
)[
  #grid(
    columns: (auto, 1fr), column-gutter: 5pt, align: (horizon, horizon),
    rodona(r: 5.5pt, size: 8pt, fill: violeta-f)[i],
    text(size: 8pt, fill: violeta-f.darken(10%), body),
  )
]

// Regla d'or: marc doble, sense girs ni cintes.
#let postit(body) = block(
  width: 100%, above: 10pt, below: 8pt, fill: rgb("#fff0f5"), radius: 4pt,
  stroke: 1.2pt + rosa-f, inset: (x: 8pt, y: 7pt),
)[
  #block(below: 3pt)[
    #estrella(r: 5pt, fill: rosa-f) #h(2pt)
    #text(font: titular, fill: rosa-f, size: 10pt, tracking: 0.6pt)[REGLA D'OR]
  ]
  #text(size: 8.2pt, fill: rosa-f.darken(20%), weight: "bold", body)
]

#let sortida(body) = block(
  width: 100%, above: 4pt, below: 5pt, fill: rgb("#2b2a3d"), radius: 3pt, inset: (x: 6pt, y: 4pt),
)[
  #text(font: mono, size: 6.4pt, fill: rgb("#b9b7d6"), tracking: 0.4pt)[CONSOLA] \
  #text(font: mono, size: 6.9pt, fill: rgb("#eef6e4"), body)
]

// ---------- SECCIONS ----------
#let _seccions = state("xuleta2-seccions", ())

#let seccio(title, color: violeta) = {
  _seccions.update(s => s + ((title: title, color: color),))
  context {
    let n = _seccions.get().len()
    [#metadata((num: n, title: title))<seccio2>]
    block(
      width: 100%, above: 4pt, below: 7pt, sticky: true, breakable: false,
      fill: color.lighten(90%), radius: 3pt, inset: (x: 7pt, y: 5pt),
      stroke: 0.7pt + color.lighten(45%),
    )[
      #grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
        box(fill: fosc(color), radius: 2pt, inset: (x: 4pt, y: 1.5pt),
          text(font: mono, size: 7pt, weight: "bold", fill: white)[S#n]),
        text(font: titular, size: 12pt, fill: fosc(color), tracking: 0.3pt)[#upper(title)],
      )
    ]
  }
}

// ---------- TARGETA ----------
#let card(num, title, color: auto, body) = {
  let c = if color == auto { paleta.at(calc.rem(num - 1, paleta.len())) } else { color }
  let cf = fosc(c)
  [#metadata((num: num, title: title))<targeta2>]
  // Marques per mesurar l'alçada de cada targeta amb `typst query` i repartir les columnes.
  [#context [#metadata((num: num, page: here().page(), y: here().position().y))<inici2>]]
  block(
    width: 100%, breakable: false, above: 0pt, below: 7.5pt,
    fill: white, radius: 4pt, stroke: 0.7pt + filet,
    inset: (x: 7pt, top: 5.5pt, bottom: 6pt),
  )[
    #_accent.update(c)
    #block(below: 5pt, width: 100%)[
      #grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
        box(fill: ink, radius: 3pt, inset: (x: 4.5pt, y: 2.5pt),
          text(font: titular, size: 9.5pt, fill: white)[#num]),
        text(font: titular, size: 12pt, fill: cf)[#title],
      )
      #v(-3.5pt)
      #box(width: 100%, height: 2.2pt, radius: 1.1pt, fill: c)
    ]
    #body
    #context [#metadata((num: num, page: here().page(), y: here().position().y))<fi2>]
  ]
}

#let sub(title) = context {
  let c = fosc(_accent.get())
  block(above: 7pt, below: 3.5pt, sticky: true)[
    #text(font: titular, fill: c, size: 9.5pt)[#title]
    #v(-6.5pt)
    #box(width: 100%, height: 0.6pt, fill: c.lighten(70%))
  ]
}

// ---------- BLOC A TOTA L'AMPLADA ----------
#let ample(title: none, color: violeta, pos: top, body) = place(
  pos, scope: "parent", float: true, clearance: 9pt,
  block(
    width: 100%, fill: white, radius: 5pt,
    stroke: 0.9pt + color.lighten(55%), inset: (x: 9pt, y: 8pt),
  )[
    #_accent.update(color)
    #if title != none {
      block(below: 6pt, width: 100%)[
        #text(font: titular, fill: fosc(color), size: 13pt, title)
        #v(-4pt)
        #box(width: 100%, height: 1.5pt, fill: color)
      ]
    }
    #body
  ],
)

// ---------- TAULES ----------
// Capçalera: text fosc sobre tinta clara (a la v1 era blanc sobre el color, per sota de 4,5:1).
#let taula(cols, ..files) = context {
  let c = _accent.get()
  block(
    width: 100%, radius: 3pt, clip: true, stroke: 0.6pt + c.lighten(60%), above: 5pt, below: 5pt,
    table(
      columns: cols,
      inset: (x: 4.5pt, y: 2.6pt),
      stroke: (x, y) => if y == 0 { (bottom: 1pt + fosc(c)) } else { (top: 0.4pt + c.lighten(80%)) },
      align: horizon,
      fill: (x, y) => if y == 0 { c.lighten(88%) } else if calc.even(y) { c.lighten(95%) } else { white },
      ..files,
    ),
  )
}
#let th(body) = context text(fill: fosc(_accent.get()), weight: "bold", body)

#let compara(esquerra: "C#", dreta: "Kotlin", ..parells) = context {
  let c = _accent.get()
  let cel(t, col) = text(font: mono, size: 6.8pt, fill: col, weight: "bold", features: (calt: 0), t)
  block(
    width: 100%, radius: 3pt, clip: true, stroke: 0.6pt + c.lighten(60%), above: 5pt, below: 5pt,
    table(
      columns: (1fr, 1fr), inset: (x: 4.5pt, y: 2.6pt), align: horizon,
      stroke: (x, y) => if y == 0 { (bottom: 1pt + fosc(c)) } else { (top: 0.4pt + c.lighten(80%)) },
      fill: (x, y) => if y == 0 { c.lighten(88%) } else if calc.even(y) { c.lighten(95%) } else { white },
      text(fill: fosc(c), weight: "bold")[#esquerra], text(fill: fosc(c), weight: "bold")[#dreta],
      ..parells.pos().map(((a, b)) => (cel(a, ink-suau.darken(10%)), cel(b, fosc(c)))).flatten(),
    ),
  )
}

// ---------- REFERÈNCIES CREUADES ----------
// ref-targeta(8) escriu "targeta 8 (pàg. 3)" amb la pàgina calculada automàticament.
#let ref-targeta(n) = context {
  let t = query(<targeta2>).find(m => m.value.num == n)
  if t == none { [targeta #n] } else {
    [targeta #n (pàg. #t.location().page())]
  }
}

// ---------- MAPA DEL FULL ----------
#let mapa(title: [Mapa del full], color: violeta, llegenda: true) = ample(title: title, color: color)[
  #context {
    let seccions = query(<seccio2>)
    let files = seccions.map(m => (
      box(fill: ink, radius: 2pt, inset: (x: 3.5pt, y: 1.5pt),
        text(font: mono, size: 6.6pt, weight: "bold", fill: white)[S#m.value.num]),
      text(size: 8pt, weight: "bold")[#m.value.title],
      text(size: 8pt, fill: ink-suau)[pàg. #m.location().page()],
    )).flatten()
    let n = seccions.len()
    let cols = if n > 5 { 3 } else { 2 }
    grid(
      columns: (1fr,) * cols, column-gutter: 10pt, row-gutter: 3.5pt,
      ..range(n).map(i => grid(
        columns: (auto, 1fr, auto), column-gutter: 5pt, align: horizon,
        files.at(i * 3), files.at(i * 3 + 1), files.at(i * 3 + 2),
      )),
    )
  }
  #if llegenda {
    v(4pt)
    block(width: 100%, inset: (top: 5pt), stroke: (top: 0.6pt + filet))[
      #grid(
        columns: (auto, 1fr, auto, 1fr, auto, 1fr), column-gutter: 5pt, row-gutter: 3pt,
        align: horizon,
        _triangle(rgb("#b8860b")), text(size: 7.4pt)[parany o cosa que peta],
        rodona(r: 5.5pt, size: 8pt, fill: violeta-f)[i], text(size: 7.4pt)[aclariment],
        estrella(r: 5pt, fill: rosa-f), text(size: 7.4pt)[regla d'or],
        _cross(w: 7pt), text(size: 7.4pt)[línia de codi que *no* compila],
        _check(w: 7pt), text(size: 7.4pt)[línia correcta],
        box(fill: rgb("#2b2a3d"), radius: 2pt, inset: (x: 3pt, y: 1pt),
          text(font: mono, size: 6pt, fill: rgb("#eef6e4"))[CONSOLA]),
        text(size: 7.4pt)[el que surt per pantalla],
      )
    ]
  }
]

// ---------- DOCUMENT ----------
#let xuleta(
  title: "",
  serie: "",            // p. ex. "Xuleta de C# · primer curs"
  subtitle: none,
  tags: (),
  badge: "C#",
  mida-codi: 7.2pt,
  mida-text: 9pt,
  accent: violeta,
  doc,
) = {
  set document(title: if serie != "" { serie + ": " + title } else { title })

  // Regleta de seccions al marge dret: marca en quina secció ets sense dependre del color.
  let regleta = context {
    let pag = here().page()
    let seccions = query(<seccio2>)
    if seccions.len() == 0 { return }
    let actual = seccions.filter(m => m.location().page() <= pag)
    let actual = if actual.len() == 0 { 0 } else { actual.last().value.num }
    let total = seccions.len()
    let alt = 13pt
    place(right + top, dx: -3.2mm, dy: 30mm, block(width: 6.4mm)[
      #stack(spacing: 2.5pt, ..range(1, total + 1).map(i => {
        let m = seccions.find(x => x.value.num == i)
        let c = if m == none { violeta } else { violeta }
        box(
          width: 100%, height: alt, radius: 2pt,
          fill: if i == actual { ink } else { rgb("#eceaf5") },
          align(center + horizon, text(
            font: mono, size: 6.2pt, weight: "bold",
            fill: if i == actual { white } else { ink-suau },
          )[S#i]),
        )
      }))
    ])
  }

  set page(
    paper: "a4", margin: (left: 10mm, right: 12mm, top: 10mm, bottom: 12mm), columns: 2,
    background: regleta,
    footer: context {
      let pag = here().page()
      let seccions = query(<seccio2>).filter(m => m.location().page() <= pag)
      let nom = if seccions.len() == 0 { "" } else { seccions.last().value.title }
      set text(size: 7pt, fill: ink-suau)
      grid(
        columns: (auto, 1fr, auto), column-gutter: 6pt, align: horizon,
        box(fill: ink, radius: 3pt, inset: (x: 5pt, y: 2pt),
          text(size: 6.6pt, weight: "bold", fill: white)[#badge]),
        grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
          text(fill: ink, weight: "bold")[#title],
          if nom != "" { text(fill: ink-suau)[#upper(nom)] } else { [] }),
        box(fill: rgb("#eceaf5"), radius: 3pt, inset: (x: 5pt, y: 2pt),
          text(size: 6.6pt, weight: "bold", fill: ink)[
            #counter(page).display("1 / 1", both: true)
          ]),
      )
    },
  )
  set columns(gutter: 10pt)
  set text(font: lletra, size: mida-text, fill: ink, lang: "ca")
  set smartquote(enabled: false)
  set par(justify: false, leading: 0.52em, spacing: 0.62em)
  set list(marker: text(fill: ink-suau)[•], spacing: 0.6em, indent: 2pt, body-indent: 4pt)

  // Codi
  set raw(theme: _tema-codi)
  show raw: set text(font: mono, size: mida-codi, ligatures: false, features: (calt: 0))
  show raw.where(block: true): it => context {
    let c = _accent.get()
    block(
      width: 100%, fill: rgb("#fbfaff"), above: 4.5pt, below: 4.5pt,
      stroke: (left: 1pt + c, rest: 0.5pt + c.lighten(72%)),
      radius: (left: 0pt, right: 3pt), inset: (x: 6pt, y: 4pt),
    )[#it]
  }
  show raw.where(block: false): it => box(
    fill: rgb("#f1eeff"), radius: 2pt, inset: (x: 2pt), outset: (y: 1.6pt),
    text(fill: violeta-f, weight: "bold", it),
  )
  // Línies marcades: fons + marca dibuixada, perquè també es vegi en blanc i negre.
  show raw.line: it => if it.text.contains("// ERROR") {
    box(fill: rgb("#ffeef0"), width: 100%, outset: (y: 1.4pt, x: 2pt), radius: 1.5pt)[
      #place(right + horizon, dx: 1pt, _cross(w: 6.5pt))
      #it
    ]
  } else if it.text.contains("// OK") {
    box(fill: rgb("#ecf8ef"), width: 100%, outset: (y: 1.4pt, x: 2pt), radius: 1.5pt)[
      #place(right + horizon, dx: 1pt, _check(w: 6.5pt))
      #it
    ]
  } else { it }

  // Capçalera
  place(
    top, scope: "parent", float: true, clearance: 10pt,
    block(width: 100%, inset: (bottom: 6pt), stroke: (bottom: 2.5pt + accent))[
      #grid(
        columns: (auto, 1fr, auto), column-gutter: 12pt, align: bottom,
        box(fill: ink, radius: 5pt, inset: (x: 10pt, y: 8pt),
          text(font: titular, size: 19pt, fill: white)[#badge]),
        [
          #text(font: titular, size: 23pt, fill: ink)[#title]
          #if subtitle != none {
            v(-9pt)
            text(size: 9pt, fill: ink-suau)[#subtitle]
          }
          #if tags.len() > 0 {
            v(-3pt)
            tags.map(t => pill(base: accent, size: 7.2pt)[#t]).join(h(3pt))
          }
        ],
        text(font: lletra, size: 7.5pt, fill: ink-suau)[#serie],
      )
    ],
  )

  doc
}
