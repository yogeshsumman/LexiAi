# Agent Headshot Redesign Plan

Replace animal emoji mascots with sophisticated, photorealistic AI-generated
headshots that read as "modern corporate law firm": professional, diverse,
approachable.

## Art direction (consistent across all 8)

- Square 1:1, head-and-shoulders crop, eyes to camera
- Soft key light + gentle fill ("softbox studio"), no harsh shadows
- Shallow depth of field; softly blurred modern office / neutral studio backdrop
- Business attire appropriate to practice area; genuine slight smile
- One consistent color grade across the set so the roster feels like one firm
- Master at 1024x1024, export to `assets/agents/<id>.jpg` at 768px, JPEG q85

## Diversity matrix

Balanced gender split, ages 28–55+, multiple ethnicities and backgrounds.
Each agent's prompt below already encodes this.

## Per-agent generation prompts

Use with any photoreal model (Midjourney v7, DALL·E 3, Flux, SDXL).
Append `--ar 1:1 --style raw` for Midjourney; keep seed/character reference
consistent if your tool supports it.

| ID | Agent | Prompt core |
|----|-------|-------------|
| a1 | Amelia Hart | Corporate headshot portrait of a confident Black British woman in her mid-40s, senior partner presence, charcoal tailored blazer with pearl earrings, warm assured expression |
| a2 | Marcus Chen | Corporate headshot portrait of a Chinese-American man in his late 30s, IP attorney, navy suit open collar and thin rectangular glasses, sharp friendly gaze |
| a3 | Sofia Rossi | Corporate headshot portrait of an Italian woman in her early 40s, family lawyer, cream silk blouse, shoulder-length auburn hair, genuinely warm smile |
| a4 | James Okafor | Corporate headshot portrait of a Nigerian man in his mid-30s, criminal defense attorney, charcoal suit with burgundy tie, calm resolute expression |
| a5 | Priya Sharma | Corporate headshot portrait of an Indian woman in her late 30s, tax and estates counsel, deep green blazer, subtle gold jewelry, poised approachable smile |
| a6 | Elena Petrova | Corporate headshot portrait of an Eastern European woman in her 50s, immigration partner, grey pantsuit, elegant silver-streaked hair, kind authoritative look |
| a7 | Noah Kim | Corporate headshot portrait of a Korean man in his late 20s, employment associate, navy crew-neck sweater over white shirt, bright easygoing smile |
| a8 | Isabella Cruz | Corporate headshot portrait of a Brazilian woman in her early 40s, real estate partner, tan blazer over white blouse, confident engaging smile |

Common suffix for every prompt:

> softbox studio lighting, shallow depth of field, blurred modern law office
> background, photorealistic, editorial corporate photography, shot on 85mm
> lens f/2, natural skin texture, professional color grade --ar 1:1

## Rollout

1. Generate masters (1024px), review as a set for consistency, re-roll outliers.
2. Export to `assets/agents/a1.jpg` … `a8.jpg`, **overwriting the placeholder
   gradients** shipped in those paths (filenames already match).
3. Hot restart the app - no code changes needed; `AgentAvatar` picks them up.

## Code changes shipped with this plan

- `LegalAgent`: `emoji` replaced by `photo` asset path
- `AgentAvatar`: renders the headshot (`BoxFit.cover` circle); falls back to a
  brand-gradient monogram if an image is missing or fails to load
- All call sites updated (home, agents list, detail, chat, video-call stage)
- `assets/agents/` registered in `pubspec.yaml`

## Ethics & compliance notes

- Disclose that agents are AI personas (e.g., in About/agent detail footer)
- Never model on a real person's likeness; check your generator's commercial
  license terms (Midjourney requires a paid plan for commercial use)
- Keep personas consistent: store seeds/prompts alongside brand assets so
  future agents match the set

## Optional follow-ups

- Home header still shows an emoji avatar for the user (`👩‍⚖️`) - swap for the
  signed-in user's initials or profile photo
- Onboarding illustrations still use emoji heroes (⚖️ 📹 💬); consider Lottie
  line-art to match the premium tone
