// settings.typ

#let project(doc) = {
  // Page Setup
  set page(
    paper: "a4",
    margin: (inside: 3cm, outside: 2.5cm, y: 2.5cm),
    numbering: "1",
    number-align: center + bottom,
  )

  // Text Setup
  set text(
    font: "New Computer Modern",
    size: 11pt,
    lang: "fr",
    region: "ma",
  )

  // Paragraph Setup
  set par(
    justify: true,
    leading: 0.8em,
    first-line-indent: 1.5em,
  )

  // Heading Setup
  set heading(numbering: "1.1")
  show heading: set block(below: 1em, above: 1.5em)

  // Force table captions to appear at the top
  show figure.where(kind: table): set figure.caption(position: top)

  // Outline configuration
  show outline.entry: it => {
    if it.level == 1 and it.element.func() == heading {
      // Add space above Chapter titles
      v(0.8em, weak: false)
      strong(it)
    } else {
      // Standard look for sub-sections or figures
      it
    }
  }

  // Render the document content
  doc
}
