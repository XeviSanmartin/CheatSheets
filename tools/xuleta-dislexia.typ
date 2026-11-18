// Plantilla de les xuletes, versió per a alumnes amb dislèxia.
//
// Variant de tools/xuleta.typ amb la mateixa API: card, sub, taula, avis, nota, postit,
// sortida, seccio, mapa, ample, compara, ref-targeta...
//
// Què canvia:
//  - Una sola columna, línies curtes (uns 70 caràcters) i text de 12 punts.
//  - Interlineat ample i més espai entre lletres i entre paraules.
//  - Sense cursiva enlloc i sense text tot en majúscules; el que destaca va en negreta.
//  - Fons crema en lloc de blanc, per reduir l'enlluernament.
//  - Codi en JetBrains Mono, que distingeix 0 de O i l de 1 i de I.
//
// Criteris que es mantenen de la plantilla normal:
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

// Paper crema i caixes crema clar (a la plantilla normal, blanc).
#let paper = rgb("#fbf4e4")
#let paper-targeta = rgb("#fffdf7")
#let paper-codi = rgb("#fff9ec")

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
      <key>background</key><string>#FFF9EC</string>
    </dict></dict>
    <dict>
      <key>name</key><string>Comentari</string>
      <key>scope</key><string>comment, punctuation.definition.comment</string>
      <key>settings</key><dict><key>foreground</key><string>#5a5f70</string><key>fontStyle</key><string></string></dict>
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
#let _check(c: rgb("#1d6b2d"), w: 10pt) = box(width: w, height: w, baseline: w * 0.18)[
  #place(line(start: (w * 0.1, w * 0.52), end: (w * 0.4, w * 0.82), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
  #place(line(start: (w * 0.38, w * 0.82), end: (w * 0.92, w * 0.14), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
]
#let _cross(c: rgb("#a32020"), w: 10pt) = box(width: w, height: w, baseline: w * 0.18)[
  #place(line(start: (w * 0.14, w * 0.14), end: (w * 0.86, w * 0.86), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
  #place(line(start: (w * 0.86, w * 0.14), end: (w * 0.14, w * 0.86), stroke: (paint: c, thickness: 1.4pt, cap: "round")))
]
#let _triangle(c) = box(width: 16pt, height: 14.5pt, baseline: 3pt)[
  #place(polygon(
    fill: c, stroke: (paint: c, thickness: 2pt, join: "round"),
    (8pt, 1.5pt), (15pt, 13.4pt), (1pt, 13.4pt),
  ))
  #place(center + bottom, dy: -1pt, text(font: lletra, fill: white, weight: "bold", size: 10pt)[!])
]
#let estrella(r: 7pt, fill: rgb("#b8860b")) = {
  let punts = range(10).map(i => {
    let radi = if calc.even(i) { r } else { r * 0.45 }
    let a = -90deg + i * 36deg
    (r + radi * calc.cos(a), r + radi * calc.sin(a))
  })
  box(width: 2 * r, height: 2 * r, baseline: r * 0.3, place(polygon(fill: fill, ..punts)))
}
#let fletxa(w: 22pt, c: ink-suau) = box(width: w, height: 8pt, baseline: -1pt)[
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
#let marca-ok(w: 10pt) = _check(w: w)
#let marca-error(w: 10pt) = _cross(w: w)

// ---------- PECES ----------
#let rodona(body, fill: ink, color: white, r: 8pt, size: 11pt) = box(baseline: r * 0.35)[
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
#let pill(body, fill: auto, color: auto, base: violeta, size: 10pt) = {
  let f = if fill == auto { base.lighten(84%) } else { fill }
  let c = if color != auto { color } else if fill == auto { fosc(base) } else { text-sobre(f) }
  box(fill: f, radius: 3pt, inset: (x: 6pt, y: 3pt), baseline: 2pt,
    text(fill: c, weight: "bold", size: size, body))
}

// SÍ i NO: es distingeixen per forma (ple contra vora discontínua) i per icona.
#let si = box(
  fill: verd.lighten(86%), radius: 3pt, inset: (x: 5pt, y: 2.5pt), baseline: 2pt,
  stroke: 0.8pt + verd-f,
)[#_check(w: 9pt) #h(2pt) #text(fill: verd-f, weight: "bold", size: 10pt)[Sí]]
#let no = box(
  radius: 3pt, inset: (x: 5pt, y: 2.5pt), baseline: 2pt,
  stroke: (paint: vermell-f, thickness: 0.8pt, dash: "dashed"),
)[#_cross(w: 9pt) #h(2pt) #text(fill: vermell-f, weight: "bold", size: 10pt)[No]]

// ---------- CAIXES ----------
#let avis(body) = block(
  width: 100%, above: 11pt, below: 10pt, fill: rgb("#fff3cd"),
  radius: (left: 0pt, right: 4pt), inset: (x: 10pt, y: 9pt),
  // La franja ratllada de l'esquerra marca l'avís també en blanc i negre.
  stroke: (left: (paint: _ratlles(rgb("#c98f08")), thickness: 7pt), rest: 0.8pt + rgb("#d9a521")),
)[
  #grid(
    columns: (auto, 1fr), column-gutter: 8pt, align: (horizon, horizon),
    _triangle(rgb("#8a6508")),
    text(size: 11.5pt, fill: rgb("#5c3d00"), weight: "bold", body),
  )
]

#let nota(body) = block(
  width: 100%, above: 10pt, below: 10pt, fill: rgb("#f2efff"),
  stroke: (left: 3pt + violeta-f, rest: 0.6pt + violeta.lighten(60%)),
  radius: (left: 0pt, right: 4pt), inset: (x: 10pt, y: 8pt),
)[
  #grid(
    columns: (auto, 1fr), column-gutter: 8pt, align: (horizon, horizon),
    rodona(r: 8pt, size: 11pt, fill: violeta-f)[i],
    text(size: 11.5pt, fill: violeta-f.darken(10%), body),
  )
]

// Regla d'or: marc doble, sense girs ni cintes.
#let postit(body) = block(
  width: 100%, above: 13pt, below: 11pt, fill: rgb("#ffeef4"), radius: 5pt,
  stroke: 1.6pt + rosa-f, inset: (x: 11pt, y: 10pt),
)[
  #block(below: 5pt)[
    #estrella(r: 7pt, fill: rosa-f) #h(4pt)
    #text(font: titular, fill: rosa-f, size: 14pt)[Regla d'or]
  ]
  #text(size: 11.5pt, fill: rosa-f.darken(20%), weight: "bold", body)
]

#let sortida(body) = block(
  width: 100%, above: 7pt, below: 8pt, fill: rgb("#2b2a3d"), radius: 4pt, inset: (x: 9pt, y: 7pt),
)[
  #text(font: mono, size: 8.5pt, fill: rgb("#c3c1dd"), tracking: 0.5pt)[Consola] \
  #text(font: mono, size: 11pt, fill: rgb("#eef6e4"), body)
]

// ---------- SECCIONS ----------
#let _seccions = state("xuleta2-seccions", ())

#let seccio(title, color: violeta) = {
  _seccions.update(s => s + ((title: title, color: color),))
  context {
    let n = _seccions.get().len()
    [#metadata((num: n, title: title))<seccio2>]
    block(
      width: 100%, above: 14pt, below: 10pt, sticky: true, breakable: false,
      fill: color.lighten(88%), radius: 4pt, inset: (x: 10pt, y: 8pt),
      stroke: 0.9pt + color.lighten(40%),
    )[
      #grid(columns: (auto, 1fr), column-gutter: 9pt, align: horizon,
        box(fill: fosc(color), radius: 3pt, inset: (x: 6pt, y: 3pt),
          text(font: mono, size: 10pt, weight: "bold", fill: white)[S#n]),
        text(font: titular, size: 17pt, fill: fosc(color))[#title],
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
    width: 100%, breakable: true, above: 0pt, below: 13pt,
    fill: paper-targeta, radius: 5pt, stroke: 0.8pt + filet.darken(8%),
    inset: (x: 11pt, top: 9pt, bottom: 10pt),
  )[
    #_accent.update(c)
    // sticky: el títol no es queda sol al peu de la pàgina.
    #block(below: 8pt, width: 100%, sticky: true)[
      #grid(columns: (auto, 1fr), column-gutter: 9pt, align: horizon,
        box(fill: ink, radius: 4pt, inset: (x: 7pt, y: 4pt),
          text(font: titular, size: 14pt, fill: white)[#num]),
        text(font: titular, size: 18pt, fill: cf)[#title],
      )
      #v(-4pt)
      #box(width: 100%, height: 3pt, radius: 1.5pt, fill: c)
    ]
    #body
    #context [#metadata((num: num, page: here().page(), y: here().position().y))<fi2>]
  ]
}

#let sub(title) = context {
  let c = fosc(_accent.get())
  block(above: 12pt, below: 6pt, sticky: true)[
    #text(font: titular, fill: c, size: 13.5pt)[#title]
    #v(-7pt)
    #box(width: 100%, height: 0.8pt, fill: c.lighten(65%))
  ]
}

// ---------- BLOC A TOTA L'AMPLADA ----------
// En una sola columna no cal que floti: és un bloc normal, amb el mateix aspecte.
#let ample(title: none, color: violeta, pos: top, body) = block(
  width: 100%, fill: paper-targeta, radius: 5pt, above: 13pt, below: 13pt,
  stroke: 1pt + color.lighten(50%), inset: (x: 11pt, y: 10pt), breakable: true,
)[
  #_accent.update(color)
  #if title != none {
    block(below: 8pt, width: 100%)[
      #text(font: titular, fill: fosc(color), size: 18pt, title)
      #v(-4pt)
      #box(width: 100%, height: 2pt, fill: color)
    ]
  }
  #body
]

// ---------- TAULES ----------
// Capçalera: text fosc sobre tinta clara (a la v1 era blanc sobre el color, per sota de 4,5:1).
#let taula(cols, ..files) = context {
  let c = _accent.get()
  block(
    width: 100%, radius: 4pt, clip: true, stroke: 0.7pt + c.lighten(55%), above: 9pt, below: 9pt,
    table(
      columns: cols,
      inset: (x: 8pt, y: 6pt),
      stroke: (x, y) => if y == 0 { (bottom: 1pt + fosc(c)) } else { (top: 0.4pt + c.lighten(80%)) },
      align: horizon,
      fill: (x, y) => if y == 0 { c.lighten(88%) } else if calc.even(y) { c.lighten(95%) } else { paper-targeta },
      // La primera fila és capçalera: no es queda sola al peu i es repeteix si la taula es parteix.
      table.header(..files.pos().slice(0, cols.len())),
      ..files.pos().slice(cols.len()),
    ),
  )
}
#let th(body) = context text(fill: fosc(_accent.get()), weight: "bold", body)

#let compara(esquerra: "C#", dreta: "Kotlin", ..parells) = context {
  let c = _accent.get()
  let cel(t, col) = text(font: mono, size: 10.5pt, fill: col, weight: "bold", features: (calt: 0), t)
  block(
    width: 100%, radius: 4pt, clip: true, stroke: 0.7pt + c.lighten(55%), above: 9pt, below: 9pt,
    table(
      columns: (1fr, 1fr), inset: (x: 8pt, y: 6pt), align: horizon,
      stroke: (x, y) => if y == 0 { (bottom: 1pt + fosc(c)) } else { (top: 0.4pt + c.lighten(80%)) },
      fill: (x, y) => if y == 0 { c.lighten(88%) } else if calc.even(y) { c.lighten(95%) } else { paper-targeta },
      table.header(text(fill: fosc(c), weight: "bold")[#esquerra], text(fill: fosc(c), weight: "bold")[#dreta]),
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
      box(fill: ink, radius: 3pt, inset: (x: 5pt, y: 2.5pt),
        text(font: mono, size: 9.5pt, weight: "bold", fill: white)[S#m.value.num]),
      text(size: 11pt, weight: "bold")[#m.value.title],
      text(size: 11pt, fill: ink-suau)[pàg. #m.location().page()],
    )).flatten()
    let n = seccions.len()
    let cols = 2
    grid(
      columns: (1fr,) * cols, column-gutter: 16pt, row-gutter: 7pt,
      ..range(n).map(i => grid(
        columns: (auto, 1fr, auto), column-gutter: 8pt, align: horizon,
        files.at(i * 3), files.at(i * 3 + 1), files.at(i * 3 + 2),
      )),
    )
  }
  #if llegenda {
    v(7pt)
    block(width: 100%, inset: (top: 9pt), stroke: (top: 0.8pt + filet))[
      #grid(
        columns: (auto, 1fr, auto, 1fr), column-gutter: 9pt, row-gutter: 7pt,
        align: horizon,
        _triangle(rgb("#8a6508")), text(size: 10.5pt)[parany o cosa que peta],
        rodona(r: 8pt, size: 11pt, fill: violeta-f)[i], text(size: 10.5pt)[aclariment],
        estrella(r: 7pt, fill: rosa-f), text(size: 10.5pt)[regla d'or],
        _cross(w: 10pt), text(size: 10.5pt)[línia que *no* compila],
        _check(w: 10pt), text(size: 10.5pt)[línia correcta],
        box(fill: rgb("#2b2a3d"), radius: 3pt, inset: (x: 5pt, y: 2pt),
          text(font: mono, size: 8.5pt, fill: rgb("#eef6e4"))[Consola]),
        text(size: 10.5pt)[el que surt per pantalla],
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
  mida-codi: 11pt,      // JetBrains Mono: hi caben uns 60 caràcters per línia
  mida-text: 12pt,      // mida mínima recomanada per a lectura amb dislèxia
  accent: violeta,
  marge-dret: 32mm,     // marge ample a la dreta, per a la regleta de seccions
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
    place(right + top, dx: -8mm, dy: 32mm, block(width: 11mm)[
      #stack(spacing: 5pt, ..range(1, total + 1).map(i => box(
        width: 100%, height: 19pt, radius: 3pt,
        fill: if i == actual { ink } else { rgb("#efe9db") },
        stroke: if i == actual { none } else { 0.5pt + filet },
        align(center + horizon, text(
          font: mono, size: 9.5pt, weight: "bold",
          fill: if i == actual { white } else { ink-suau },
        )[S#i]),
      )))
    ])
  }

  set page(
    paper: "a4", margin: (left: 26mm, right: marge-dret, top: 18mm, bottom: 20mm),
    fill: paper,
    background: regleta,
    footer: context {
      let pag = here().page()
      let seccions = query(<seccio2>).filter(m => m.location().page() <= pag)
      let nom = if seccions.len() == 0 { "" } else { seccions.last().value.title }
      set text(size: 10pt, fill: ink-suau)
      grid(
        columns: (auto, 1fr, auto), column-gutter: 9pt, align: horizon,
        box(fill: ink, radius: 3pt, inset: (x: 7pt, y: 3pt),
          text(size: 9.5pt, weight: "bold", fill: white)[#badge]),
        grid(columns: (auto, 1fr), column-gutter: 9pt, align: horizon,
          text(fill: ink, weight: "bold")[#title],
          if nom != "" { text(fill: ink-suau)[#nom] } else { [] }),
        box(fill: rgb("#efe9db"), radius: 3pt, inset: (x: 7pt, y: 3pt),
          text(size: 9.5pt, weight: "bold", fill: ink)[
            #counter(page).display("1 / 1", both: true)
          ]),
      )
    },
  )
  // Text: més gran, amb més espai entre lletres, entre paraules i entre línies.
  set text(font: lletra, size: mida-text, fill: ink, lang: "ca",
    tracking: 0.25pt, spacing: 115%)
  set smartquote(enabled: false)
  set par(justify: false, leading: 0.9em, spacing: 1.1em, linebreaks: "simple")
  set list(marker: text(fill: ink-suau)[•], spacing: 1em, indent: 4pt, body-indent: 7pt)
  // Res de cursiva: el que es vol destacar, en negreta.
  show emph: it => strong(it.body)

  // Codi
  set raw(theme: _tema-codi)
  show raw: set text(font: mono, size: mida-codi, ligatures: false, features: (calt: 0),
    tracking: 0.2pt)
  show raw.where(block: true): it => context {
    let c = _accent.get()
    block(
      width: 100%, fill: paper-codi, above: 8pt, below: 8pt,
      stroke: (left: 3pt + c, rest: 0.6pt + c.lighten(65%)),
      radius: (left: 0pt, right: 4pt), inset: (x: 9pt, y: 8pt),
    )[
      // Interlineat una mica més ajustat dins del codi: les línies ja són curtes.
      #set par(leading: 0.72em)
      #it
    ]
  }
  show raw.where(block: false): it => box(
    fill: rgb("#f1eeff"), radius: 3pt, inset: (x: 3pt), outset: (y: 3pt),
    text(fill: violeta-f, weight: "bold", it),
  )
  // Línies marcades: fons + marca dibuixada, perquè també es vegi en blanc i negre.
  show raw.line: it => if it.text.contains("// ERROR") {
    box(fill: rgb("#ffe4e7"), width: 100%, outset: (y: 2.5pt, x: 3pt), radius: 2pt)[
      #place(right + horizon, dx: 2pt, _cross(w: 10pt))
      #it
    ]
  } else if it.text.contains("// OK") {
    box(fill: rgb("#e3f5e8"), width: 100%, outset: (y: 2.5pt, x: 3pt), radius: 2pt)[
      #place(right + horizon, dx: 2pt, _check(w: 10pt))
      #it
    ]
  } else { it }

  // Capçalera
  block(width: 100%, inset: (bottom: 9pt), below: 16pt, stroke: (bottom: 3pt + accent))[
    #grid(
      columns: (auto, 1fr), column-gutter: 14pt, align: horizon,
      box(fill: ink, radius: 6pt, inset: (x: 12pt, y: 10pt),
        text(font: titular, size: 24pt, fill: white)[#badge]),
      [
        // El títol s'encongeix (fins a 20 pt) perquè càpiga en una sola línia.
        #layout(sz => {
          let mida = 28pt
          while mida > 20pt and measure(text(font: titular, size: mida)[#title]).width > sz.width {
            mida -= 1pt
          }
          text(font: titular, size: mida, fill: ink)[#title]
        })
        #if subtitle != none {
          v(-4pt)
          text(size: 12pt, fill: ink-suau)[#subtitle]
        }
        #if serie != "" {
          v(-2pt)
          text(size: 10.5pt, fill: ink-suau)[#serie]
        }
        #if tags.len() > 0 {
          v(-2pt)
          tags.map(t => pill(base: accent, size: 10pt)[#t]).join(h(5pt))
        }
      ],
    )
  ]

  doc
}
