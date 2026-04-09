# Phase 6 — Tournament Module

**Duration:** Week 7–10  
**Priority:** P1

**Goal:** Player can browse tournaments at their booked stadiums, register a team, join a team via code, follow fixtures, and track standings.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/tournaments/<id>/` | GET | Tournament detail (public, no auth) |
| `/api/tournaments/<id>/fixtures/` | GET | Fixture list (public) |
| `/api/tournaments/<id>/standings/` | GET | Live standings (public) |
| `/api/tournaments/<id>/register/` | POST | Register new team (auth required) |
| `/api/tournaments/join/` | POST | Join team via join_code (auth required) |
| `/api/tournaments/<id>/my-team/` | GET | View own team detail |
| `/api/players/me/tournaments/` | GET | Player's tournament participation history |

---

## Screens

### Tournaments Tab (`/tournaments`)

**Sections:**
- "My Teams" — tournaments the player is registered in (if any)
- "At My Stadiums" — tournaments at stadiums the player has booked (discovery)
- "Open for Registration" — other active tournaments accepting registrations

Each item: `TournamentCard` with tournament name, stadium, format badge, team count, registration deadline.

---

### Tournament Detail (`/tournaments/:id`)

**Public page — no auth required.**

**Tabs:**

**Overview tab:**
- Tournament name, stadium, format (round-robin / knockout / group+knockout)
- Status badge: Registration Open · In Progress · Completed
- Teams registered / max teams
- Registration deadline
- Prize info and rules (expandable)
- Registration CTA button (if status is `registration_open` and player not yet registered):
  - "Register New Team" → registration form sheet
  - "Join with Code" → code entry sheet

**Fixtures tab:**
- `ListView.builder` of `FixtureCard` widgets
- Grouped by round/stage
- Each card: Team A vs Team B · Date · Score (if completed)
- Completed fixtures show result prominently

**Standings tab:**
- Shown only for round-robin and group stages
- `DataTable` or custom table: Pos · Team · P · W · D · L · GF · GA · GD · Pts
- Current player's team row highlighted

---

### Register Team Sheet (bottom sheet)

**Fields:**
- Team name (required)
- Number of players (min 5 for 5v5, min 7 for 7v7)

On submit: `POST /api/tournaments/<id>/register/`  
Success: show team `join_code` prominently — "Share this code with your teammates"  
Error handling: "Registration is full" / "Deadline passed"

---

### Join Team Sheet (bottom sheet)

**Fields:**
- 6-character join code input

On submit: `POST /api/tournaments/join/` with `{ join_code }`  
Success: refresh tournament detail → show "You've joined [team name]!"

---

### My Team Screen (`/tournaments/:id/my-team`)

**Content:**
- Team name
- Join code (share button → system share sheet)
- Captain label
- Player list: avatar + name + joined date
- Tournament status and next fixture for this team

---

## Deep Link: Tournament Share URL

Format: `https://hagzkora.com/tournaments/<id>/` (matches backend public URL)

go_router handles:
```dart
GoRoute(
  path: '/tournaments/:id',
  builder: (_, state) => TournamentDetailScreen(id: state.pathParameters['id']!),
)
```

Unauthenticated users can view tournament detail and fixtures.  
Registration/join actions prompt login if unauthenticated.

---

## State & Domain

```
domain/
  entities/
    tournament.dart       # id, name, format, status, maxTeams, registrationDeadline,
                          #  startDate, prizeInfo, rules, publicSlug
    tournament_team.dart  # id, name, captain, joinCode, players[]
    fixture.dart          # id, homeTeam, awayTeam, scheduledAt, homeScore, awayScore,
                          #  status, stage, roundNumber, groupName
    standing.dart         # team, played, won, drawn, lost, gf, ga, gd, points
  repositories/
    tournament_repository.dart  # abstract
  usecases/
    get_tournament_detail.dart
    get_fixtures.dart
    get_standings.dart
    register_team.dart
    join_team.dart
    get_my_team.dart
    get_my_tournaments.dart

data/
  models/
    tournament_dto.dart
    fixture_dto.dart
    standing_dto.dart
    register_team_request.dart
    join_team_request.dart
  datasources/
    tournament_remote_datasource.dart  # Retrofit
  repositories/
    tournament_repository_impl.dart

presentation/
  providers/
    tournament_detail_provider.dart
    fixtures_provider.dart
    standings_provider.dart
    my_tournaments_provider.dart
  screens/
    tournaments_tab_screen.dart
    tournament_detail_screen.dart
    my_team_screen.dart
  widgets/
    tournament_card.dart
    fixture_card.dart
    standings_table.dart
    register_team_sheet.dart
    join_team_sheet.dart
```

---

## Deliverable

Players can discover, register for, and join tournaments.  
Fixtures and live standings visible without authentication.  
Tournament share URL opens the correct tournament detail screen via deep link.  
Join code shareable via system share sheet.
