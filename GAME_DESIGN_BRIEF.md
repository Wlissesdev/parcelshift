# GAME DESIGN BRIEF — Parcel Shift

## Research note

This brief follows the Roblox Viral Game Agent V2.0 prompt. The earlier prototype, Don't Wake the Giant, is being retired as the product concept. Its code demonstrated a small round loop, but the concept depended on a generic theft/chase scenario and had no strong collection, mastery, content pipeline, or reason to return.

Roblox discovery guidance describes a personalized system that evaluates player behavior after discovery. Play-through, early bounce, play days, playtime, intentional co-play, qualified sessions, and spend signals all matter; no single signal guarantees distribution. The practical target is a satisfying first session and repeatable play, not a claim that a design will go viral. See [Roblox Discovery](https://create.roblox.com/docs/discovery) and [Creator Analytics](https://create.roblox.com/docs/production/analytics).

The Roblox charts are dynamic. The October 2026 snapshot surfaced both social simulation/collection and cooperative survival formats, including Grow a Garden and 99 Nights in the Forest. That is a format signal, not evidence that those genres alone cause growth. The game pages show the core actions plainly: Grow a Garden presents buying, planting, harvesting, selling, offline growth, and showing finds to friends; Steal a Brainrot presents buying, stealing, passive income, rebirth, and troll gear; 99 Nights in the Forest leads with building a camp with friends while something watches. Sources: [Roblox charts](https://www.roblox.com/charts?nl=true&nu=true), [Grow a Garden](https://www.roblox.com/games/126884695634066/Grow-a-Garden), [Steal a Brainrot](https://www.roblox.com/games/109983668079237/Steal-a-Brainrot), [99 Nights in the Forest](https://www.roblox.com/games/79546208627805/99-Nights-in-the-Forest).

### Benchmark matrix

| Reference | Why players click/stay | Useful principle | What Parcel Shift avoids copying |
|---|---|---|---|
| Grow a Garden | One clear action, visible growth, collection, offline return, and recurring content | Make the first action obvious; let collection become visible social status | Farming, seed restocks, idle waiting, garden layout |
| Steal a Brainrot | Valuable visible collection, passive income, theft, defense, rebirth, and social conflict | Make an item feel valuable and let other players change the moment | Brainrot characters, conveyor buying, base theft, slap/troll loop, rebirth clone |
| 99 Nights in the Forest | One-line co-op survival premise, shared danger, long-form stories | Make a friend useful in the core activity and give the group a shared threat | Forest horror, night counter, camp-building survival loop |
| Package Panic! / Pack an Order! | Collect, sort or secure packages, then deliver; one has explicit theft and upgrades, the other timed co-op warehouse work | Delivery is easy to understand, but the space is occupied | Warehouse management, package theft, order-packing, generic delivery simulator |

Sources: [Package Panic!](https://www.roblox.com/games/81908265157463/Package-Panic), [Pack an Order!](https://www.roblox.com/games/133880823575739/Pack-an-Order). The market gap is an inference from these public descriptions: a short, cooperative physics challenge where a parcel changes its rules during the route, rather than a warehouse job or a theft economy.

## Concept shortlist and selection

Scores are comparative design hypotheses, not market measurements. The V score follows the skill prompt's informal formula F + S + C + R + P + L: fantasy, social, clipability, replayability, progression, and live-ops potential.

| Concept | Core sentence | V / 60 | Decision |
|---|---|---:|---|
| Parcel Shift | Deliver a parcel whose size, weight, bounce, or gravity changes as you run the route | 49 | Selected: clear, visual, co-op friendly, and content can be data-driven |
| Oddity Lab | Find and catalogue objects that behave impossibly | 43 | Good collection hook, but anomaly-hunt titles already exist and the first action is less obvious |
| Sky Scrap Crew | Salvage floating junk and build a vehicle with friends | 42 | Strong visual sandbox, but construction and physics raise the MVP cost before fun is proven |

## Name and pitch

**Working title:** Parcel Shift. The search found no exact Roblox title match in the quick title search, but naming and trademark clearance are not complete.

**One-line pitch:** Deliver a parcel across a chaotic route while its physical rules keep changing.

**Phrase test:** Neste jogo, você entrega pacotes que mudam de tamanho, peso e gravidade no meio do caminho.

**Fantasy:** You are a courier trusted with impossible packages. You and nearby players improvise when the parcel changes shape or physics before reaching the drop-off.

**Target player:** Roblox players who like short obstacle challenges, collecting cosmetic variants, and playing with friends. It must also work solo and on touch screens.

**Positioning:** A co-op physics delivery challenge with collection and route mastery, not a conventional warehouse simulator.

## Viral core mechanic

**Parcel Shift:** crossing a visible shift gate transforms the parcel in a way the player can immediately see and feel: giant, tiny, bouncy, or floaty. The route then asks the player to adapt. A delivery is valuable because of the parcel's mutation path, not because of a random paid roll.

A friend can make the run better by opening a shortcut, activating a route switch, or stabilizing a teammate's parcel. Solo players receive a short fallback interaction so co-play is an advantage, never a hard gate.

### Five-second test

- See: a courier holding an oversized box beside a bright route and green delivery dock.
- Valuable: the parcel has a clear mutation label and a visible stamp book.
- Dangerous: a gate ahead shows the next physical shift.
- Action: approach the parcel and hold the on-screen prompt.
- Reward: deliver it to earn a route grade and record a new mutation in the collection.

## Loops

**Core loop:** take a parcel → cross three shift gates → adapt to its new behavior → deliver before the shift ends → earn a grade and mutation record → take another route.

**Meta loop:** complete deliveries → collect mutation stamps and route medals → improve courier mastery → unlock new districts and parcel cosmetics → attempt higher-difficulty routes.

**Social loop:** run beside friends → open shortcuts or stabilize a parcel → chain deliveries within the same shift → compare route grades and rare mutation paths.

**Retention:** short term, “one more delivery”; medium term, complete the mutation album and beat a route medal; long term, rotating districts, weekly route events, harder variants, and visible courier status. These are hypotheses to validate, not implemented promises.

**Emergent-story test:** a parcel becomes huge at the final gate, blocks the shortcut, bounces over the barrier, and a friend helps recover it before the shift ends. The system should create these moments without a scripted cutscene.

## Progression, collection, and economy

**MVP progression:** session delivery count, route grade, and a mutation journal. No permanent item is lost when a player fails. The first MVP is for testing the core; persistence comes after a successful playtest.

**Collection:** four readable parcel mutations in the vertical slice. Each entry records the player's best delivered grade. Later content can add parcel skins and district variants without changing the route system.

**Economy plan after validation:**

- Sources: successful deliveries, route medals, and group-chain bonuses.
- Sinks: earned-only cosmetics, handcart looks, parcel wraps, and route emotes.
- Avoid selling faster movement or better mutation odds until the free core is proven fun.
- No paid random rolls, permanent-loss theft, or pressure sales in the MVP.

**Monetization:** deferred. If retention and player feedback support it, test transparent cosmetics and durable personalization first. Keep a free path to comparable status. Paid random items are out of scope.

## Discovery package test

### Titles

1. **Parcel Shift** — selected; distinctive and names the mechanic.
2. **Unstable Delivery** — clearest description, less memorable.
3. **Box Glitch!** — punchy, but too broad and less searchable.

### Thumbnail concepts

1. An avatar sprinting with a box larger than the avatar; the delivery dock is visible in the same frame.
2. A box floating above two friends as one grabs its handle; a shift gate glows behind them.
3. A tiny box entering a gate and an enormous box exiting; one expressive avatar gives scale.

Use one readable situation per image, original assets, and accurate gameplay. Roblox recommends metadata that is unique and true to the experience; discovery guidance also recommends testing thumbnail variations against qualified play-through, not guessing.

### First-three-second video hooks

1. “We had eight seconds left when the box became bigger than the door.”
2. “My friend changed the shortcut and flipped our parcel upside down.”
3. “This package changes physics every time you pass a gate.”

**Opening shot:** start with the parcel already changing size, show the courier and dock for scale, then show the next gate. No logo animation or menu before the first action.

## Idea score

| Fantasy | Core | Simplicity | Visual | Social | Progression | Collection | Surprise | Return | Monetization | Live Ops | Cost |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 9 | 9 | 9 | 10 | 8 | 7 | 7 | 9 | 8 | 6 | 8 | 8 |

The score is a comparison aid only. Biggest risks: physical effects may feel random instead of skillful; delivery games are an occupied format; a long route may delay first reward. The MVP counters these with deterministic, clearly signposted gates, a 60–90 second route, and a visible progress bar.

## MVP and acceptance criteria

**Vertical slice:** one stylized route with two alternating lane barriers, one pickup kiosk, three shift gates, four parcel mutations, an optional teammate-stabilize action, one drop-off, a grade, a session combo/scoreboard, a four-stamp discovery book, and a responsive HUD. A shift lasts two minutes. No shop, DataStore, paid items, vehicles, trading, or battle pass.

- First action within 10 seconds of joining.
- First mutation visible within 30 seconds.
- First delivery possible within 90 seconds.
- Every run can be completed solo; friends can stabilize a parcel for a capped score bonus.
- Server validates parcel ownership, shift state, distance, mutation count, reward, and delivery cooldown.
- Touch users can pick up and interact through native ProximityPrompt buttons.
- Failure costs only the active parcel run, never collected progress.

## Analytics hypothesis

Track a server-side onboarding funnel: joined → picked up first parcel → crossed first gate → completed first delivery. Track parcel mutation, delivery, dropped parcel, solo/co-op, and route grade events. Use the data to decide whether onboarding, a particular mutation, or route length is the problem. Roblox documents funnel events as server-only and intended to locate drop-off; they do not run from Studio, so analytics are wired only after publishing.

## Roadmap

1. **P0:** vertical slice and first-session playtest.
2. **P1:** stabilize physics, tune route time, validate mobile controls and co-op assist.
3. **P2:** versioned DataStore for delivery records and mutation journal; collection UI.
4. **P2:** one new district and reusable route/mutation config pipeline.
5. **P3:** earned cosmetics and a transparent cosmetic store, only after retention evidence.
6. **P4:** scheduled route events, update announcements, and thumbnail experiments.

## Research sources

- [Roblox Discovery](https://create.roblox.com/docs/discovery)
- [Roblox recommended strategies](https://create.roblox.com/docs/get-started/strategies)
- [Roblox analytics funnels](https://create.roblox.com/docs/production/analytics/funnel-events)
- [Roblox client-server security](https://create.roblox.com/docs/scripting/security/client-server-boundary)
- [Roblox mobile input](https://create.roblox.com/docs/input/mobile)
- [Roblox ProximityPrompts](https://create.roblox.com/docs/ui/proximity-prompts)
- [Roblox events and updates](https://create.roblox.com/docs/production/promotion/experience-events)

