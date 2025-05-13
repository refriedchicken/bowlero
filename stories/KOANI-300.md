# Bowling Dice Game Ruby Gem (KOANI-300)

> **Progress:**
> _Awaiting initial implementation. Requirements and plan approved. Next step: begin development of v1 CLI gem._

## Overview

A single-player command-line bowling game Ruby gem that uses a custom dice mechanic to simulate bowling. The game features interactive play, emoji-rich output, and an ASCII table styled like a real bowling scorecard. The goal is to provide a fun, replayable bowling experience with future extensibility for multiplayer, leaderboards, and more.

## Requirements

- **Access:**  
  Any user who can install Ruby gems and run commands in the terminal. No special permissions required.

- **UI:**  
  - Command-line interface (CLI) with interactive prompts.
  - ASCII table styled like a real bowling scorecard.
  - Emoji usage for pins, balls, strikes, spares, splits (e.g., 🎳, 🦃, 🍌, etc.).
  - Menu with "Start Game" and "Exit" options.
  - Prompt for player name, with a random fun bowling pun name as default (user can override).

- **Data Model:**  
  - Game session: player name, frames, rolls, scores.
  - Dice logic: see “Dice Logic Specification” below.
  - Logging: error logs (plain text or JSON, best practice).

- **Navigation:**  
  - User starts by running the gem (e.g., `300bowling`).
  - Menu: Start Game, Exit.
  - Prompts for name, then game begins.
  - After game: show final score, prompt to play again or exit.
  - Option to play a single game or a "series" of three games.

- **Testing:**  
  - Unit tests for dice logic, scoring, and CLI interactions.
  - Manual testing for CLI flow and user experience.

- **Other:**  
  - Error handling: user-friendly messages, log errors to file.
  - Confirmation prompt on mid-game exit.
  - No platform-specific dependencies; should work on Mac, Linux, Windows.
  - Future: multiplayer, save/load, leaderboards, autoplay, command-line flags, debug mode.

## Dice Logic Specification

The bowling game uses a set of custom dice to simulate the outcome of each frame. The dice and their logic are as follows:

### Dice Used

1. **Strike Die**
   - Sides 1–5: Number of pins knocked down (1–5)
   - Side 6: “Strike” (all 10 pins knocked down, frame ends)

2. **Split Die**
   - Sides 1–5: Number of pins knocked down (1–5)
   - Side 6: “Split” (special split scenario, see below)

3. **Split Resolution Die** (used only if “Split” is rolled on the Split Die)
   - Sides 1–4: “Open” (split not converted, no spare)
   - Sides 5–6: “Spare” (split converted, all pins knocked down)

4. **Spare Resolution Die** (used if no Strike or Split is rolled)
   - Sides 1–4: “Spare” (all remaining pins knocked down)
   - Sides 5–6: “Open” (some pins left standing, no spare)

### Roll Sequence (Per Frame)

1. **First Roll:**
   - Roll both the Strike Die and the Split Die together.
   - If the Strike Die lands on “Strike,” it’s a strike (10 pins, frame ends).
   - Otherwise, sum the pins from both dice:
     - If the Split Die lands on 1–5, add that number to the Strike Die’s result (total 2–10 pins).
     - If the Split Die lands on “Split,” add 6 pins to the Strike Die’s result (total 7–11 pins).
   - If the total pins knocked down is 10 or more, it’s a strike (frame ends).
   - If not a strike, proceed to the second roll.

2. **Second Roll:**
   - If the first roll resulted in a “Split,” roll the Split Resolution Die:
     - “Spare”: All remaining pins knocked down (spare).
     - “Open”: Some pins left standing (open frame).
   - If the first roll did NOT result in a “Split,” roll the Spare Resolution Die:
     - “Spare”: All remaining pins knocked down (spare).
     - “Open”: Some pins left standing (open frame).

### Special Notes

- If the Strike Die is “Strike,” ignore the Split Die result.
- If the total pins from both dice (excluding “Strike” on Strike Die) is 10 or more, treat as a strike.
- If the Split Die is “Split,” always add 6 pins for that die, regardless of the Strike Die’s value.
- The second roll is always either the Split Resolution Die (if “Split” was rolled) or the Spare Resolution Die (otherwise).
- All outcomes are described to the player in plain language (e.g., “You knocked down 5 pins and left a split.”). Dice roll values are not shown unless a future debug mode is enabled.

## User Journey

- **How does a user get there?**  
  Installs the gem, runs `300bowling` in the terminal. Sees a menu with options.

- **What do they do when they are there?**  
  Selects "Start Game," enters (or accepts) a player name, chooses single game or series, plays through 10 frames, rolling dice per frame, sees results and score updates after each roll.

- **What happens if it goes right?**  
  User completes the game, sees a final scorecard with emojis and summary, and is prompted to play again or exit.

- **What happens if it goes wrong?**  
  Any errors (e.g., invalid input, unexpected exceptions) are caught, a friendly message is shown, and the error is logged for debugging. If user tries to exit mid-game, a confirmation prompt appears.

- **Where does it take them when they are done?**  
  After the game, user can choose to play again (with same or new name) or exit to the terminal.

## Implementation Phases

### Phase 1: CLI Gem MVP [ ]
- [ ] Set up gem structure and CLI entry point
- [ ] Implement menu system (Start Game, Exit)
- [ ] Implement player name prompt with random pun defaults
- [ ] Implement dice logic and frame/roll mechanics (see Dice Logic Specification)
- [ ] Implement bowling scoring logic (standard rules)
- [ ] Render ASCII bowling scorecard with emoji support
- [ ] Add confirmation prompt for mid-game exit
- [ ] Implement error handling and logging (best practice)
- [ ] Unit tests for core logic (dice, scoring, CLI)
- [ ] Manual test for CLI flow

### Phase 2: Polish & UX Enhancements [ ]
- [ ] Refine emoji usage (pins, balls, strikes, spares, splits, turkey, etc.)
- [ ] Improve scorecard styling to match real bowling cards
- [ ] Add option for single game or series of three games
- [ ] Add help/instructions (in-menu and `-h` flag)
- [ ] Review and update documentation

### Phase 3: Future Features (Not in v1) [ ]
- [ ] Multiplayer support
- [ ] Save/load game sessions
- [ ] Local/global leaderboards
- [ ] Autoplay/debug modes
- [ ] Command-line flags for advanced options
- [ ] Custom rules/equipment

## Key Files Modified

<!-- No files exist yet; to be updated as implementation progresses. -->

## Current Status

Requirements and plan approved. Ready for initial gem scaffolding and CLI implementation. No blockers.

## Recent Progress

- Requirements clarified and confirmed with stakeholder
- User journey and dice mechanics defined
- Plan and phases outlined

## Next Steps for Next Agent

> ### Handoff Note for Next Agent
> Begin with gem scaffolding and CLI entry point. Focus on single-player, single-session MVP. Use best practices for error handling and logging. Emoji and scorecard polish can follow once core logic is in place. Refer to the Dice Logic Specification for implementation details.

- [ ] Scaffold gem and CLI
- [ ] Implement menu and player name prompt
- [ ] Build dice and scoring logic
- [ ] Render scorecard with emojis

## Technical Details & Decisions

- Dice logic: See Dice Logic Specification above for full details.
- Scorecard: ASCII table, styled after real bowling cards, with emoji overlays.
- Logging: Use Ruby’s Logger or similar, log to file in current directory, plain text for simplicity.
- CLI: Use Thor or OptionParser for CLI entry, but keep initial version minimal and interactive.
- Player names: Array of 10 bowling pun names, randomly assigned if user skips input.

## Migration/Data Mapping (if applicable)

| Old Field/Model | New Field/Model | Notes |
|-----------------|-----------------|-------|
| N/A             | N/A             | First version, no migration needed |

## Success Criteria

1. User can install gem, run `300bowling`, and play a full single-player game with correct scoring and dice logic.
2. Output includes ASCII scorecard and emojis for key events.
3. Errors are handled gracefully and logged.
4. User can exit or replay at end of game, with confirmation on mid-game exit.

## Task Checklist

- [ ] Gem scaffolding and CLI entry
- [ ] Menu and player name prompt
- [ ] Dice and scoring logic
- [ ] Scorecard rendering with emojis
- [ ] Error handling and logging
- [ ] Unit and manual tests

## Known Issues / Next Steps

- No multiplayer, save/load, or leaderboards in v1.
- Emoji rendering may vary by terminal.
- Future: add debug mode, custom rules, and more polish.

## Future Considerations

- Multiplayer support (local and online)
- Save/load and resume games
- Leaderboards (local and global)
- Autoplay/debug modes
- Command-line flags for advanced options
- Custom rules/equipment
- Accessibility improvements

## Testing

### Model Specs
- [ ] Dice logic: correct mapping of rolls to bowling events
- [ ] Scoring: standard bowling rules, including strikes/spares

### Controller/Request Specs
- [ ] CLI menu navigation
- [ ] Player name prompt and defaults

### Integration/Feature Specs
- [ ] Full game flow: start, play, score, end, replay/exit
- [ ] Error handling and logging

---

## Progress Log
- 2024-06-07: Plan drafted and approved (by PM/Stakeholder)
- 2024-06-07: Ready for initial implementation