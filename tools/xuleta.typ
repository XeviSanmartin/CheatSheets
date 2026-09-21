// Plantilla de xuletes en Typst.
// Ús: veure ../C#/XuletaBàsica.typ
// Compilar:  typst compile "C#/XuletaBàsica.typ"

#let primary = rgb("#6c5ce7")
#let primary-dark = rgb("#4a3fb8")
#let ink = rgb("#2d3436")
#let soft = rgb("#e6e2fb")

// ---------- CAIXES ----------

// Avís: parany, error freqüent, cosa que peta. Va lleugerament tort.
#let avis(body, angle: -1.2deg) = rotate(
  angle, reflow: true,
  block(
    width: 100%, fill: rgb("#fff8e1"), stroke: 0.6pt + rgb("#f0c56a"),
    radius: 3pt, inset: (x: 6pt, y: 5pt),
  )[
    #text(size: 8pt, fill: rgb("#8a6100"), weight: "bold")[
      #box(baseline: 1pt, text(size: 9pt)[⚠]) #h(2pt) #body
    ]
  ],
)

// Nota: aclariment o alternativa.
#let nota(body) = block(
  width: 100%, fill: rgb("#f3f1fe"), stroke: (left: 2pt + primary, rest: 0.5pt + rgb("#d6d1fa")),
  radius: 3pt, inset: (x: 6pt, y: 5pt),
)[
  #text(size: 8pt, fill: primary-dark)[
    #text(weight: "bold")[NOTA] #h(3pt) #body
  ]
]

// Regla d'or: post-it destacat, més tort encara.
#let postit(body, angle: 1.6deg) = rotate(
  angle, reflow: true,
  block(
    width: 100%, fill: rgb("#efe9ff"), stroke: 1pt + primary,
    radius: 4pt, inset: (x: 7pt, y: 6pt),
  )[
    #text(size: 8pt, fill: primary-dark, weight: "bold", body)
  ],
)

// ---------- TARGETA ----------
#let card(num, title, body) = block(
  width: 100%, breakable: false, above: 0pt, below: 7pt,
  fill: white, stroke: (top: 2.5pt + primary, rest: 0.5pt + rgb("#e0e0e0")),
  radius: (top: 1pt, bottom: 4pt), inset: (x: 7pt, y: 6pt),
)[
  #block(below: 5pt, stroke: (bottom: 0.8pt + soft), inset: (bottom: 3pt), width: 100%)[
    #box(
      fill: primary, radius: 3pt, inset: (x: 4pt, y: 1.5pt), baseline: 1.5pt,
      text(fill: white, weight: "bold", size: 8pt)[#num],
    )
    #h(3pt)
    #text(fill: primary, weight: "bold", size: 10pt)[#title]
  ]
  #body
]

// Apartat dins d'una targeta
#let sub(title) = block(above: 5pt, below: 2pt)[
  #text(fill: primary, weight: "bold", size: 8.5pt)[#title]
]

// ---------- BLOC QUE OCUPA LES DUES COLUMNES ----------
#let ample(body, pos: top) = place(
  pos, scope: "parent", float: true,
  block(
    width: 100%, fill: white, stroke: (top: 2.5pt + primary, rest: 0.5pt + rgb("#e0e0e0")),
    radius: (bottom: 4pt), inset: (x: 8pt, y: 7pt), below: 8pt,
  )[#body],
)

// ---------- TAULA ----------
#let taula(cols, ..files) = table(
  columns: cols,
  inset: (x: 4pt, y: 2.6pt),
  stroke: 0.4pt + rgb("#dddddd"),
  fill: (x, y) => if y == 0 { rgb("#efedfc") } else { white },
  ..files,
)

#let th(body) = text(fill: primary, weight: "bold", body)

// ---------- DOCUMENT ----------
#let xuleta(title: "", subtitle: "", doc) = {
  set page(
    paper: "a4", margin: 1cm, columns: 2,
    footer: context text(size: 6.5pt, fill: rgb("#9b93c7"))[
      #title #h(1fr) #counter(page).display("1 / 1", both: true)
    ],
  )
  set text(font: ("Segoe UI", "Arial"), size: 8.5pt, fill: ink, lang: "ca")
  set smartquote(enabled: false)
  set par(justify: false, leading: 0.5em, spacing: 0.6em)
  show link: set text(fill: primary)

  // Codi: font mono, fons clar i filet morat a l'esquerra
  show raw.where(block: true): it => block(
    width: 100%, fill: rgb("#fbfbfe"),
    stroke: (left: 1.8pt + primary, rest: 0.4pt + rgb("#cfcfcf")),
    radius: 2pt, inset: (x: 5pt, y: 4pt), above: 4pt, below: 4pt,
  )[#it]
  show raw: set text(font: ("Consolas", "Courier New"), size: 7.2pt)
  show raw.where(block: false): it => text(fill: rgb("#c0341d"), weight: "bold", it)
  // Les línies de codi marcades amb ERROR surten sobre fons vermellós
  show raw.line: it => if it.text.contains("ERROR") {
    box(fill: rgb("#ffe2de"), width: 100%, outset: (y: 1.4pt), inset: (x: 1.5pt), it)
  } else { it }

  set list(marker: text(fill: primary)[•], spacing: 0.55em, indent: 3pt, body-indent: 4pt)

  // Capçalera a tota l'amplada
  place(
    top, scope: "parent", float: true,
    block(
      width: 100%, fill: gradient.linear(primary, rgb("#a29bfe"), angle: 12deg),
      radius: 5pt, inset: (x: 10pt, y: 9pt), below: 9pt,
    )[
      #align(center)[
        #text(size: 17pt, weight: "bold", fill: white)[#title]
        #v(-5pt)
        #text(size: 9pt, fill: rgb("#eeeaff"))[#subtitle]
      ]
    ],
  )

  doc
}
