// Llibreria per generar xuletes (cheatsheets) en format .docx.
// Ús: veure ../C#/XuletaBàsica.js

const fs = require("fs");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  WidthType, BorderStyle, ShadingType, AlignmentType, SectionType, VerticalAlign,
} = require("docx");

// ---------- PALETA ----------
const PRIMARY = "6C5CE7";
const DARK = "2D3436";
const GREY = "E0E0E0";

const COLORS = {
  kw: { color: "0000FF", bold: true },   // paraules clau
  str: { color: "A31515" },              // literals de text
  num: { color: "098658" },              // números
  cls: { color: "2B91AF" },              // tipus i classes
  func: { color: "74531F", bold: true }, // mètodes
  com: { color: "008000", italic: true },// comentaris
  err: { color: "C0341D", bold: true },  // comentaris que marquen un error
};

const MONO = "Consolas";
const SANS = "Segoe UI";
const CODE_SIZE = 15;   // 7,5 pt
const BODY_SIZE = 17;   // 8,5 pt

// ---------- GEOMETRIA (A4, marges 1 cm, 2 columnes) ----------
const PAGE_W = 11906, PAGE_H = 16838;
const MARGIN = 567;
const COL_GAP = 340;
const COL_W = Math.floor((PAGE_W - 2 * MARGIN - COL_GAP) / 2);
const CARD_W = COL_W;
const INNER_W = CARD_W - 300;   // amplada útil dins d'una targeta

const NONE = { style: BorderStyle.NONE, size: 0, color: "FFFFFF" };
const thin = (color = GREY) => ({ style: BorderStyle.SINGLE, size: 4, color });

// ---------- TEXT ----------
function t(text, opts = {}) {
  return new TextRun({
    text,
    font: opts.mono ? MONO : SANS,
    size: opts.size || BODY_SIZE,
    color: opts.color || DARK,
    bold: !!opts.bold,
    italics: !!opts.italic,
  });
}

// Text amb `codi` entre cometes invertides
function rich(text, opts = {}) {
  const runs = [];
  String(text).split(/(`[^`]+`)/).forEach((frag) => {
    if (!frag) return;
    if (frag.startsWith("`") && frag.endsWith("`")) {
      runs.push(new TextRun({
        text: frag.slice(1, -1), font: MONO, size: CODE_SIZE + 1,
        color: COLORS.err.color, bold: true,
      }));
    } else {
      runs.push(t(frag, opts));
    }
  });
  return runs;
}

function p(runs, opts = {}) {
  return new Paragraph({
    children: Array.isArray(runs) ? runs : [runs],
    spacing: { before: opts.before ?? 40, after: opts.after ?? 40, line: opts.line ?? 220 },
    alignment: opts.align,
    keepLines: true,
    keepNext: opts.keepNext,
  });
}

function body(text, opts = {}) {
  return p(rich(text, opts), opts);
}

function subTitle(text) {
  return p(t(text, { bold: true, color: PRIMARY, size: BODY_SIZE + 1 }), {
    before: 120, after: 40, keepNext: true,
  });
}

function bullet(text) {
  return new Paragraph({
    children: rich(text),
    bullet: { level: 0 },
    spacing: { before: 20, after: 20, line: 210 },
    keepLines: true,
  });
}

// ---------- CODI ----------
const KEYWORDS = new Set([
  "abstract", "as", "base", "bool", "break", "byte", "case", "catch", "char", "checked",
  "class", "const", "continue", "decimal", "default", "delegate", "do", "double", "else",
  "enum", "event", "explicit", "extern", "false", "finally", "fixed", "float", "for",
  "foreach", "goto", "if", "implicit", "in", "int", "interface", "internal", "is", "lock",
  "long", "namespace", "new", "null", "object", "operator", "out", "override", "params",
  "private", "protected", "public", "readonly", "ref", "return", "sbyte", "sealed", "short",
  "sizeof", "static", "string", "struct", "switch", "this", "throw", "true", "try",
  "typeof", "uint", "ulong", "unchecked", "unsafe", "ushort", "using", "var", "virtual",
  "void", "while",
]);

const TOKEN = /(\/\/[^\n]*)|(\$?@?"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])')|(\b\d+(?:[.,]\d+)?\b)|([A-Za-z_]\w*)/g;

function runFor(text, kind) {
  const st = COLORS[kind] || {};
  return new TextRun({
    text, font: MONO, size: CODE_SIZE,
    color: st.color || "1A1A1A", bold: !!st.bold, italics: !!st.italic,
  });
}

// Ressaltat automàtic d'una línia de C#
function highlight(line) {
  const runs = [];
  let last = 0, m;
  TOKEN.lastIndex = 0;
  while ((m = TOKEN.exec(line)) !== null) {
    if (m.index > last) runs.push(runFor(line.slice(last, m.index)));
    const [text, comment, str, num, ident] = m;
    if (comment !== undefined) {
      runs.push(runFor(text, /ERROR|💥|NO COMPILA/.test(text) ? "err" : "com"));
    } else if (str !== undefined) {
      runs.push(runFor(text, "str"));
    } else if (num !== undefined) {
      runs.push(runFor(text, "num"));
    } else {
      const rest = line.slice(m.index + text.length);
      const isCall = /^\s*\(/.test(rest);
      if (KEYWORDS.has(ident)) runs.push(runFor(text, "kw"));
      else if (isCall) runs.push(runFor(text, "func"));
      else if (/^[A-Z]/.test(ident)) runs.push(runFor(text, "cls"));
      else runs.push(runFor(text));
    }
    last = m.index + text.length;
  }
  if (last < line.length) runs.push(runFor(line.slice(last)));
  return runs;
}

function highlightXml(line) {
  const runs = [];
  let last = 0, m;
  const re = /<\/?[^>]+>/g;
  while ((m = re.exec(line)) !== null) {
    if (m.index > last) runs.push(runFor(line.slice(last, m.index), "str"));
    runs.push(runFor(m[0], "cls"));
    last = m.index + m[0].length;
  }
  if (last < line.length) runs.push(runFor(line.slice(last), "str"));
  return runs;
}

function dedent(src) {
  const lines = String(src).replace(/\t/g, "    ").split("\n");
  while (lines.length && !lines[0].trim()) lines.shift();
  while (lines.length && !lines[lines.length - 1].trim()) lines.pop();
  const indents = lines.filter((l) => l.trim()).map((l) => l.match(/^ */)[0].length);
  const pad = indents.length ? Math.min(...indents) : 0;
  return lines.map((l) => l.slice(pad));
}

function codeParagraph(runs) {
  return new Paragraph({
    children: runs,
    spacing: { before: 0, after: 0, line: 200 },
    keepLines: true,
  });
}

// Línia de codi amb colors posats a mà: cl([["int", "kw"], [" x;"]])
function cl(parts) {
  return codeParagraph(parts.map(([text, kind]) => runFor(text, kind)));
}

function codeBox(paragraphs) {
  return new Table({
    columnWidths: [INNER_W],
    width: { size: INNER_W, type: WidthType.DXA },
    margins: { top: 60, bottom: 60, left: 100, right: 60 },
    rows: [
      new TableRow({
        cantSplit: true,
        children: [
          new TableCell({
            width: { size: INNER_W, type: WidthType.DXA },
            shading: { type: ShadingType.CLEAR, fill: "FBFBFE", color: "auto" },
            borders: {
              top: thin("CCCCCC"), bottom: thin("CCCCCC"), right: thin("CCCCCC"),
              left: { style: BorderStyle.SINGLE, size: 18, color: PRIMARY },
            },
            children: paragraphs,
          }),
        ],
      }),
    ],
  });
}

// Bloc de codi C#: accepta un text (ressaltat automàtic) o línies fetes amb cl()
function code(src) {
  if (Array.isArray(src)) return codeBox(src);
  return codeBox(dedent(src).map((line) => codeParagraph(highlight(line))));
}

function codeXml(src) {
  return codeBox(dedent(src).map((line) => codeParagraph(highlightXml(line))));
}

// ---------- CAIXES ----------
function box(children, fill, border) {
  return new Table({
    columnWidths: [INNER_W],
    width: { size: INNER_W, type: WidthType.DXA },
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    rows: [
      new TableRow({
        cantSplit: true,
        children: [
          new TableCell({
            width: { size: INNER_W, type: WidthType.DXA },
            shading: { type: ShadingType.CLEAR, fill, color: "auto" },
            borders: { top: thin(border), bottom: thin(border), left: thin(border), right: thin(border) },
            children,
          }),
        ],
      }),
    ],
  });
}

// Avís groc: paranys, errors habituals, coses que peten
function alert(text) {
  return box([
    new Paragraph({
      children: [
        new TextRun({ text: "⚠️ ", font: SANS, size: BODY_SIZE }),
        ...rich(text, { bold: true, color: "8A6100" }),
      ],
      spacing: { before: 0, after: 0, line: 210 },
      keepLines: true,
    }),
  ], "FFF8E1", "FFE082");
}

// Nota morada: aclariments i alternatives
function info(text) {
  return box([
    new Paragraph({
      children: [
        new TextRun({ text: "NOTA:  ", font: SANS, size: BODY_SIZE, bold: true, color: "4A3FB8" }),
        ...rich(text, { bold: true, color: "4A3FB8" }),
      ],
      spacing: { before: 0, after: 0, line: 210 },
      keepLines: true,
    }),
  ], "F3F1FE", "D6D1FA");
}

// ---------- TAULES ----------
// widths en twips; han de sumar <= INNER_W (4900 aprox.)
function dataTable(headers, rows, widths) {
  const total = widths.reduce((a, b) => a + b, 0);
  const mkCell = (content, w, isHeader) =>
    new TableCell({
      width: { size: w, type: WidthType.DXA },
      shading: {
        type: ShadingType.CLEAR,
        fill: isHeader ? "EFEDFC" : "FFFFFF",
        color: "auto",
      },
      borders: { top: thin("DDDDDD"), bottom: thin("DDDDDD"), left: thin("DDDDDD"), right: thin("DDDDDD") },
      verticalAlign: VerticalAlign.CENTER,
      children: [
        new Paragraph({
          children: isHeader
            ? [t(content, { bold: true, color: PRIMARY, size: BODY_SIZE })]
            : rich(content, { size: BODY_SIZE }),
          spacing: { before: 20, after: 20, line: 200 },
          keepLines: true,
        }),
      ],
    });

  return new Table({
    columnWidths: widths,
    width: { size: total, type: WidthType.DXA },
    margins: { top: 30, bottom: 30, left: 80, right: 80 },
    rows: [
      new TableRow({
        tableHeader: true, cantSplit: true,
        children: headers.map((h, i) => mkCell(h, widths[i], true)),
      }),
      ...rows.map((r) => new TableRow({
        cantSplit: true,
        children: r.map((c, i) => mkCell(c, widths[i], false)),
      })),
    ],
  });
}

// ---------- TARGETA ----------
function card(title, children) {
  return [
    new Table({
      columnWidths: [CARD_W],
      width: { size: CARD_W, type: WidthType.DXA },
      margins: { top: 100, bottom: 120, left: 140, right: 140 },
      rows: [
        new TableRow({
          cantSplit: true,   // la targeta no es parteix entre columnes
          children: [
            new TableCell({
              width: { size: CARD_W, type: WidthType.DXA },
              shading: { type: ShadingType.CLEAR, fill: "FFFFFF", color: "auto" },
              borders: {
                top: { style: BorderStyle.SINGLE, size: 24, color: PRIMARY },
                bottom: thin(GREY), left: thin(GREY), right: thin(GREY),
              },
              children: [
                new Paragraph({
                  children: [t(title, { bold: true, color: PRIMARY, size: 22 })],
                  spacing: { before: 0, after: 80, line: 240 },
                  border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: "EDEBFB" } },
                  keepNext: true, keepLines: true,
                }),
                ...children,
              ],
            }),
          ],
        }),
      ],
    }),
    new Paragraph({ children: [], spacing: { before: 0, after: 100, line: 120 } }),
  ];
}

// ---------- DOCUMENT ----------
function banner(title, subtitle) {
  const W = PAGE_W - 2 * MARGIN;
  return new Table({
    columnWidths: [W],
    width: { size: W, type: WidthType.DXA },
    margins: { top: 140, bottom: 140, left: 200, right: 200 },
    rows: [
      new TableRow({
        cantSplit: true,
        children: [
          new TableCell({
            width: { size: W, type: WidthType.DXA },
            shading: { type: ShadingType.CLEAR, fill: PRIMARY, color: "auto" },
            borders: { top: NONE, bottom: NONE, left: NONE, right: NONE },
            children: [
              new Paragraph({
                children: [new TextRun({ text: title, font: SANS, size: 34, bold: true, color: "FFFFFF" })],
                alignment: AlignmentType.CENTER,
                spacing: { before: 0, after: 40, line: 300 },
              }),
              new Paragraph({
                children: [new TextRun({ text: subtitle, font: SANS, size: 19, color: "EDEAFF" })],
                alignment: AlignmentType.CENTER,
                spacing: { before: 0, after: 0, line: 240 },
              }),
            ],
          }),
        ],
      }),
    ],
  });
}

const pageProps = {
  size: { width: PAGE_W, height: PAGE_H },
  margin: { top: MARGIN, bottom: MARGIN, left: MARGIN, right: MARGIN },
};

// build({ title, subtitle, cards, output })
function build({ title, subtitle = "", cards = [], output }) {
  const doc = new Document({
    styles: { default: { document: { run: { font: SANS, size: BODY_SIZE, color: DARK } } } },
    sections: [
      {
        properties: { page: pageProps },
        children: [banner(title, subtitle), new Paragraph({ children: [], spacing: { before: 0, after: 120, line: 120 } })],
      },
      {
        properties: { type: SectionType.CONTINUOUS, page: pageProps, column: { count: 2, space: COL_GAP, equalWidth: true } },
        children: cards.flat(),
      },
      {
        // Secció buida: fa que Word equilibri les columnes de l'última pàgina
        properties: { type: SectionType.CONTINUOUS, page: pageProps, column: { count: 1 } },
        children: [new Paragraph({ children: [], spacing: { before: 0, after: 0, line: 20 } })],
      },
    ],
  });

  return Packer.toBuffer(doc).then((buf) => {
    fs.writeFileSync(output, buf);
    console.log("Generat:", output);
  });
}

module.exports = {
  build, card, code, codeXml, cl, dataTable, alert, info, body, subTitle, bullet,
  INNER_W, PRIMARY,
};
