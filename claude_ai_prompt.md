# SHRUTI — Flutter App: UI & Navigation Context

## What is this?
**SHRUTI** ("From Questions to Wisdom") — a quiz app for the Ramayana epic.
Built in Flutter + Riverpod. Backend: FastAPI on SQLite at `localhost:8000`.
No auth. Local progress via `shared_preferences`.

---

## Tech Stack
- **Flutter** (Dart), state: **Riverpod**
- **Fonts:** Cinzel (headings), Inter/Lato (body)
- **Design palette:** Parchment `#F5E6C8` bg · Saffron `#E8821A` CTA · Temple Red `#8B1A1A` headers · Gold `#C9A84C` correct answers · Sandalwood `#A0785A` secondary text
- **Backend:** FastAPI, endpoints: `GET /questions`, `GET /questions/daily-insight`, `GET /questions/{id}`

---

## Navigation Architecture

```
AppEntry (checks onboarding flag via SharedPreferences)
  ├── OnboardingScreen   ← first launch only, 3 slides, PageView
  └── MainShell          ← BottomNavigationBar (IndexedStack)
        ├── [0] HomeScreen
        ├── [1] QuizScreen       ← also reachable via push from Home + Journey
        ├── [2] JourneyScreen    ← pushes QuizScreen(storyPhase:) on phase tap
        └── [3] ExploreScreen
```

**Key nav behaviors:**
- `IndexedStack` keeps all 4 tabs alive (no rebuild on tab switch)
- `QuizScreen` has two modes: standalone (tab) or pushed with `storyPhase` arg
- Phase chips on Home → `Navigator.push(QuizScreen(storyPhase: phase))`
- Journey phase tiles → `Navigator.push(QuizScreen(storyPhase: phase))`
- When `QuizScreen` pushed with `storyPhase`, Complete button does `Navigator.pop()`
- When `QuizScreen` opened as tab (no phase), Complete shows "Play again" in-place

---

## Screen-by-Screen Breakdown

### 1. Onboarding (`onboarding_screen.dart`)
- **3 slides** via `PageView`: What is Shruti → How it works → Begin Journey
- Each slide: circular icon, title, italic subtitle, body text
- Bottom: animated dot indicator + Next/Begin Journey button + Skip (slides 1-2)
- On complete: writes `onboardingComplete = true` to SharedPreferences, triggers `AppEntry` rebuild
- **Current state:** Fully functional. Uses generic `Icons.*` (no Rama-Sita illustration yet)

### 2. Home Screen (`home_screen.dart`)
- **Background:** Parchment + Sanskrit shloka watermark at 7% opacity (hardcoded verse)
- **Header:** "SHRUTI" in Temple Red + "What do you seek today?" italic tagline
- **Today's Quest card:** fetches `DailyInsightCard` from `/questions/daily-insight`
- **Phase Quick Access:** `Wrap` of `ActionChip`s for all 6 story phases → pushes QuizScreen
- **Loading:** spinner skeleton. **Error:** wifi_off icon + "Backend running on localhost:8000" hint
- **Current state:** No user name personalization. Greeting is static.

### 3. Quiz Screen (`quiz_screen.dart`)
- Loads 10 questions from `/questions?story_phase=X&limit=10`
- **AppBar:** phase name + "X / Y" counter top-right
- **Progress:** `LinearProgressIndicator` (saffron, 3px height) below AppBar
- **Question card:** story phase label → question text → 4 `OptionTile`s
- **Flow:** tap option → select (highlighted) → Submit → reveal correct/wrong → explanation card animates in
  - Correct: gold border + "Well remembered!" + sparkle icon
  - Wrong: sandalwood border + "The truth revealed" + info icon
- **Navigation:** swipe-left gesture (velocity > 300) advances when revealed. Also "Next question →" button.
- **Last question:** "Complete" button → if pushed screen: pop back. If tab: show completion screen.
- **Completion screen:** gold star icon, "Well done!", play again reloads questions
- **Error/empty:** wifi_off state with error message
- **Current state:** No difficulty filter UI in quiz mode. No animation on reveal (opacity starts at 1.0, effectively no animation despite `AnimatedOpacity`).

### 4. Journey Screen (`journey_screen.dart`)
- **Stats row:** 2 cards — "Questions Answered" (total count) + "Day Streak"
- **Story Arc:** `PhaseMap` widget showing 6 phases in order
  - Each phase: answered count / total count (fetched from `/questions` all)
  - Tap phase → pushes `QuizScreen(storyPhase: phase)`
- Progress data from `SharedPreferences` (set of answered question IDs)
- **Current state:** `PhaseMap` widget exists but the visual "scroll/map" feel depends on its implementation. Stats are functional.

### 5. Explore Screen (`explore_screen.dart`)
- **Filter bar (2 rows):**
  - Row 1: horizontal scroll chips — "All phases" + 6 story phase chips
  - Row 2: easy (green) / medium (saffron) / hard (temple red) difficulty chips
- **Question list:** `ListView` of expandable `_QuestionCard`s
  - Collapsed: difficulty badge + phase label + star icon (if daily insight) + 2-line question preview
  - Expanded: all 4 options (correct highlighted in gold circle) + explanation in parchment box
- **Current state:** Read-only study mode. No "Start quiz from here" CTA on individual cards.

---

## Data Model (Question)
```dart
class Question {
  int id;
  String question;
  String optionA, optionB, optionC, optionD;
  String correctAnswer;   // "A" | "B" | "C" | "D"
  String explanation;     // 4-6 sentence immersive narrative
  String difficulty;      // "easy" | "medium" | "hard"
  String storyPhase;      // one of 6 phases + "Other"
  String narrativeArc;
  String chapterTitle;
  int engagementScore;    // 1-10
  bool isDailyInsight;
}
```

---

## Story Phases (ordered)
1. Early Life of Rama
2. Exile Phase
3. Sita Haran
4. Search for Sita
5. Lanka War
6. Return and Reunion
7. Other

---

## Progress Service (local)
Stores in SharedPreferences:
- `onboardingComplete` (bool)
- `answeredIds` (Set<int> — IDs of questions answered)
- `streakDays` (int — consecutive days)

---

## Known Gaps / Not Yet Built
- No Rama-Sita illustration (using icons as placeholder)
- `AnimatedOpacity` on explanation card has no actual animation (opacity fixed at 1.0)
- No difficulty filter when entering quiz from phase chip
- No "Start Quiz" CTA from Explore screen cards
- Daily insight rotates daily — no backend rotation logic confirmed
- No dark mode polish (theme exists, not tested)
- Journey `PhaseMap` widget — visual map style not confirmed (may be plain list)
- No streak increment logic verified (when/how streak increments)

---

## What I want to discuss

> Use this section to steer the conversation. Replace or add bullets.

- [ ] How should the Journey screen's story arc map look and feel? (scroll, vertical path, illustrated?)
- [ ] Should Explore screen cards have a "Quiz this phase" button, or keep it read-only?
- [ ] What's the right animation strategy for answer reveal? (slide up, fade, bounce?)
- [ ] How to handle the daily insight rotation on the backend?
- [ ] What comes after v1? (leaderboards, Mahabharata, Hindi, personalization?)
- [ ] Should there be a difficulty selector before starting a quiz?
- [ ] How to make the parchment aesthetic stronger without slowing the app?
