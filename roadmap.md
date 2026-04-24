# SHRUTI — Roadmap

> Update completion status as features ship. Mark `[x]` when done.

---

## Phase 0 — Foundation
**Goal:** Runnable Flutter skeleton + API connected

- [x] Flutter project init with suggested repo structure
- [x] `pubspec.yaml` — add Riverpod, http, shared_preferences, google_fonts
- [x] `app_theme.dart` — palette, Cinzel + Inter fonts, parchment texture
- [x] `question.dart` model — full JSON data model
- [x] `api_service.dart` — GET /questions, /questions/daily-insight, /questions/{id}
- [ ] FastAPI backend running on localhost:8000 with SQLite
- [ ] Hot reload working end-to-end (app → API → DB)

---

## Phase 1 — Core Screens (v1 Ship Target)
**Goal:** Full user flow functional, no auth, local progress

### Onboarding
- [x] 3-slide onboarding (first launch only)
- [ ] Rama-Sita line-art illustration on slide 1
- [x] "No account required" messaging
- [x] Store `onboarding_complete` flag in shared_preferences

### Home Screen
- [x] Parchment background + shloka watermark (6-8% opacity)
- [x] "Today's Quest" card — daily insight question from `/questions/daily-insight`
- [x] Greeting text ("Begin your journey…")
- [x] Bottom nav: Home | Quiz | Journey | Explore

### Quiz Screen
- [x] Full-screen question card (Cinzel heading, Inter options)
- [x] 4 option tiles — tap to select
- [x] Submit → reveal correct/wrong
- [x] Correct: gold glow + explanation
- [x] Wrong: muted grey fade + explanation
- [x] Swipe right → next question
- [x] Fetch questions by story phase via `/questions?story_phase=X`
- [x] No timer

### Journey Screen
- [x] Visual story arc map (scroll/map feel, not progress bar)
- [x] 6 phases: Early Life → Exile → Sita Haran → Search → Lanka War → Return
- [x] Per-phase: X answered / Y total
- [x] Phase unlock logic (answer N questions to unlock next)
- [x] Progress persisted in shared_preferences

### Explore / Library Screen
- [x] Browse by story phase or difficulty
- [x] Question card: chapter title + difficulty badge + story phase tag
- [x] Tap → study mode (full Q+A, no quiz flow)

### Progress Persistence
- [x] `progress_service.dart` — read/write answered question IDs
- [x] Streak tracking (days in a row)
- [x] Story phase completion percentages

---

## Phase 2 — Polish + Performance
**Goal:** App feels premium, handles edge cases

- [ ] Loading skeletons (parchment shimmer while API fetches)
- [ ] Offline fallback — cache last fetched questions locally
- [ ] Error states — API down, empty results
- [ ] Animations — card flip on answer reveal, phase unlock celebration
- [ ] Dark mode (Deep Forest `#2C4A2E` background)
- [ ] Accessibility — font scaling, contrast ratios
- [ ] App icon + splash screen

---

## Phase 3 — Growth Features
**Goal:** Retention, shareability, wider reach

- [ ] Push notifications — "Today's Insight is ready"
- [ ] Share card — shareable image of question + answer
- [ ] Streak badges + milestone celebrations
- [ ] Difficulty filter in quiz start flow
- [ ] Search within Explore screen

---

## Phase 4 — Platform Expansion
**Goal:** More content, more users

- [ ] Mahabharata content + story phases
- [ ] Hindi language toggle
- [ ] User accounts (optional, for cross-device sync)
- [ ] Leaderboards (opt-in)
- [ ] Personalized recommendations (based on engagement_score patterns)

---

## Phase 5 — Monetization
**Goal:** Sustainable

- [ ] Premium content tier (advanced questions, rare daily insights)
- [ ] Ad-free paid version
- [ ] Institutional licensing (schools, cultural orgs)

---

## Decisions Log

| Decision | Choice | Reason |
|---|---|---|
| Platform | Flutter | Cross-platform, smooth animations |
| Backend | FastAPI + SQLite | Thin layer, existing DB, swap Postgres later |
| State | Riverpod | Clean, testable, scales |
| Auth | None (v1) | Ship fast, local progress only |
| Content | LLM pipeline + human review | Quality > quantity |

---

*Last updated: 2026-04-23*
