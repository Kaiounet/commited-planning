// main.typ

// Import the template configuration
#import "settings.typ": project

// Apply the template to the whole document
#show: project

// Include the Title Page
#include "cover.typ"

// --- TABLE OF CONTENTS ---
#outline(
  title: [Table des matières],
  indent: auto,
  depth: 3,
)
#pagebreak()

// --- LISTS OF FIGURES & TABLES ---
// We group these on a new page.
// If the lists get too long later, add a #pagebreak() between them.

#heading(level: 1, numbering: none)[Liste des Illustrations]

#outline(
  title: [Figures], // Sub-header style
  target: figure.where(kind: image),
)

#v(1em) // Visual separation

#outline(
  title: [Tableaux], // Sub-header style
  target: figure.where(kind: table),
)

#pagebreak()

// Content (Artifacts includes the Proposal now)
#include "artifacts/lib.typ"

// Page Break before the Logs
#pagebreak()

// Include the Meetings Index
#include "meetings/lib.typ"
