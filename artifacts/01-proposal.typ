// proposal.typ

= Proposition de Projet

== Problématique

Les plateformes éducatives actuelles (type Google Classroom) manquent de spécificité pour l'enseignement de l'informatique. Elles traitent le code comme du texte brut, ignorant tout l'écosystème de développement (Tests, Versioning, Qualité).

Le besoin est de créer une plateforme qui intègre le workflow professionnel (Git, GitHub) directement dans le processus pédagogique, tout en offrant aux professeurs des outils d'analyse automatisés pour suivre la progression réelle des étudiants.

== Méthodologie et Organisation

Pour mener à bien ce projet complexe en équipe, nous adoptons une approche rigoureuse :
- *Méthodologie Scrum :* Développement itératif par "Sprints" courts pour valider chaque module fonctionnalité par fonctionnalité.
- *Collaboration DevOps :* Utilisation intensive de Git & GitHub pour la gestion de versions.
- *Documentation Centralisée :* Mise en place d'un portail `/docs` (type Swagger/OpenAPI) pour documenter nos APIs et faciliter l'interconnexion de nos micro-services.

== Plan de Développement (Roadmap)

Le projet suivra 5 phases distinctes pour assurer une montée en charge progressive :

/ Phase 1 - Le Socle "Classroom": Implémentation des fonctionnalités fondamentales : gestion des utilisateurs, création de classes, publication de devoirs simples et soumission de fichiers.

/ Phase 2 - Statistiques de Base: Développement d'un dashboard permettant au professeur de visualiser les taux de soumission, les retards et l'engagement basique des étudiants.

/ Phase 3 - Intégration GitHub (GitOps): L'automatisation du workflow technique. Le professeur publie un "Template", l'étudiant "Fork" le projet, et la soumission se fait via un "Push". La plateforme gère les liaisons API avec GitHub.

/ Phase 4 - Analyse de Code (IA vs Fallback): Deux approches sont envisagées :
  - _Plan A (Agentique) :_ Un agent IA analyse le code étudiant (respect des principes SOLID, Clean Code) et génère un rapport automatique.
  - _Plan B (Fallback) :_ Un système de notation paramétrique permettant au professeur d'évaluer manuellement le code sur des métriques précises.

/ Phase 5 - Modèle Prédictif (ML): Développement d'un modèle ML en Python qui croise les rapports d'analyse et les notes pour prédire les difficultés futures des étudiants et suggérer des actions correctives.

== Architecture & Stack Technologique

Nous avons opté pour une architecture *Micro-services* afin de découpler les responsabilités métier. Cette approche "Polyglotte" nous permet d'appliquer le principe du *"Best Tool for the Job"* (le meilleur outil pour la tâche) plutôt que de nous enfermer dans un écosystème unique.

L'architecture globale est illustrée dans la @architecture.

#figure(
  image("/images/microservice-architecture-style.webp", width: 90%),
  caption: [Diagramme d'Architecture Micro-services],
) <architecture>

=== Justification des Choix Technologiques

Chaque micro-service a des contraintes spécifiques (performance, rapidité de développement, écosystème IA) qui ont dicté le choix de la technologie :

#figure(
  table(
    columns: (1.2fr, 2.5fr),
    inset: 12pt,
    align: (x, y) => if x == 0 { left + horizon } else { left + top },
    stroke: 0.5pt + luma(150),

    table.header([*Service & Techno*], [*Justification du Choix*]),

    // --- FRONTEND ---
    [*Frontend* \ _React.js_],
    [
      *Pourquoi React ?* \
      Son architecture à base de composants et le DOM virtuel offrent une fluidité indispensable pour une SPA. \
      *Pourquoi ici ?* \
      Le dashboard nécessite une gestion d'état complexe (temps réel, graphiques) que React gère nativement.
    ],

    // --- CORE ---
    [*Service Core* \ _Symfony (PHP)_],
    [
      *Pourquoi Symfony ?* \
      Framework mature pour le développement rapide avec un ORM (Doctrine) puissant. \
      *Pourquoi pour le Core ?* \
      Ce service gère la logique "administrative". Symfony permet de développer ces CRUD 2x plus vite qu'en Java.
    ],

    // --- ORCHESTRATOR ---
    [*Service Orchestrator* \ _Spring Boot (Java)_],
    [
      *Pourquoi Spring ?* \
      L'écosystème Java est inégalé pour la stabilité, le typage fort et la gestion du multithreading. \
      *Pourquoi pour l'Orchestrator ?* \
      Ce service est le moteur critique (Git, Docker, I/O intensifs). La robustesse de la JVM est impérative ici.
    ],

    // --- ANALYTICS ---
    [*Service Analytics* \ _ASP.NET Core (C\#)_],
    [
      *Pourquoi .NET ?* \
      Performance d'exécution proche du C++ et la bibliothèque LINQ, atout majeur pour la data. \
      *Pourquoi pour l'Analytics ?* \
      LINQ nous permet d'écrire des requêtes de filtrage complexes de manière plus lisible et performante que du SQL pur.
    ],

    // --- INTELLIGENCE ---
    [*Service Intelligence* \ _Python (FastAPI)_],
    [
      *Pourquoi Python ?* \
      La lingua franca de l'IA et de la Data Science (Pandas, Scikit-learn). \
      // *Pourquoi pour l'IA ?* \
      // Aucun autre langage ne possède les bibliothèques pour notre agent d'analyse. FastAPI est choisi pour sa légèreté.
    ],

    // --- INFRA ---
    [*Infrastructure* \ _Docker & Oracle_],
    [
      *Docker :* \
      Indispensable pour l'isolation et la création de "Sandboxes" éphémères pour le code étudiant.\
      *Oracle Database :* \
      Choisi pour sa conformité ACID stricte et pour simuler un environnement "Grand Compte".
    ],
  ),
  caption: [Matrice de décision technologique],
) <tech-stack>

== Répartition Prévisionnelle des Tâches

- *Membre 1 :* Architecture Frontend & Intégration UX.
- *Membre 2 :* Backend Core (Symfony) & Base de données.
- *Membre 3 :* Backend Orchestrator (Spring) & Intégration GitHub API.
- *Membre 4 :* Services Analytics (.NET) & Intelligence Artificielle (Python).
