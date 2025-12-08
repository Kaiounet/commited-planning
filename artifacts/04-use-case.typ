= Analyse Fonctionnelle et Cas d'Utilisation

L'analyse fonctionnelle vise à identifier les interactions entre les utilisateurs (acteurs) et le système *Commit Ed*. Nous avons modélisé ces interactions via le formalisme UML (Unified Modeling Language) pour délimiter précisément le périmètre du projet.

== Identification des Acteurs

Avant de présenter le diagramme global, il est nécessaire de définir les rôles interagissant avec la plateforme. Nous distinguons les acteurs primaires (utilisateurs humains) des acteurs secondaires (systèmes externes).

*Acteurs Primaires (Initiateurs)* :
- *L'Étudiant* : Cœur de cible du projet. Il cherche à pratiquer, soumettre son code et obtenir un feedback rapide.
- *Le Professeur* : Il orchestre le cours, crée les devoirs, configure les environnements techniques et valide les notes.
- *L'Administrateur* : Il assure la maintenance du système, la gestion des comptes utilisateurs et la surveillance des logs.
- *Le Visiteur* : Représente un utilisateur non authentifié souhaitant s'inscrire.

*Acteurs Secondaires (Systèmes Tiers)* :
- *GitHub API* : Utilisé pour l'automatisation des flux Git (Fork, Clone, Pull Request).
- *Docker Engine* : Sollicité par le système pour créer les environnements d'exécution isolés (Sandboxing).

== Diagramme des Cas d'Utilisation Global

Le diagramme suivant illustre l'ensemble des fonctionnalités du système, regroupées par modules logiques. Il met en évidence la centralisation des fonctionnalités communes autour de l'acteur abstrait "Utilisateur Authentifié".

#figure(
  image("/assets/images/use-case.png", width: 89%),
  caption: [Diagramme des Cas d'Utilisation Global de Commit Ed],
) <fig-usecase>

== Description des Modules Fonctionnels

Le système est découpé en plusieurs zones de responsabilité, comme illustré dans la @fig-usecase.

=== Gestion d'Accès et Socle Commun
Tous les acteurs héritent de fonctionnalités transversales via l'entité *Utilisateur Authentifié*. Cela inclut l'authentification sécurisée (JWT), la gestion du profil et l'accès aux ressources partagées de la classe. Cette factorisation simplifie la gestion des droits.

=== Administration Pédagogique (Zone Professeur)
Ce module concentre les outils de création de contenu. Le cas d'utilisation "Gérer les Classes" englobe le cycle de vie complet (Création, Modification, Archivage). Le professeur dispose également d'outils avancés comme la prédiction de difficulté, propulsée par notre service interne d'Intelligence Artificielle.

=== Workflow Étudiant (Zone Critique)
C'est le cœur de la valeur ajoutée "Dev-First". Contrairement aux LMS classiques, le workflow étudiant est étroitement lié aux outils professionnels :
- *Démarrer un Devoir* déclenche automatiquement un "Fork" sur GitHub.
- *Soumettre Code* n'est pas un simple upload, mais une détection de "Push" Git qui active le moteur d'intégration continue.

=== Moteur d'Exécution et Systèmes Externes
Les cas d'utilisation techniques, tels que l'exécution en Sandbox, sont isolés. Ils agissent comme une interface entre la logique métier et les acteurs secondaires (Docker, GitHub), garantissant que la complexité technique est masquée pour l'utilisateur final.