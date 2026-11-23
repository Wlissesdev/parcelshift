# Technical design — Parcel Shift

## MVP boundary
A stylized, server-generated route with two alternating lane barriers; repeated 120-second delivery shifts; 3 mutation gates; 4 parcel mutations that change parcel size and courier movement; a pickup kiosk and depot; optional teammate stabilization; session-only score, combo, grade, and mutation journal. No DataStore, paid items, trading, shop, or permanent-loss mechanic. All gameplay objects are created by `GameServer.server.lua`, so the project opens without hand-built Studio assets.

## Runtime layout

- `src/shared/ReplicatedStorage/GameConfig.luau`: immutable tuning and mutation definitions under `ReplicatedStorage`.
- `src/server/ServerScriptService/GameServer.server.luau`: world construction, shift clock, prompts, job state, authoritative scoring, validation, cleanup, and status events under `ServerScriptService`.
- `src/client/StarterPlayerScripts/GameClient.client.luau`: HUD only; it never decides rewards or job completion under `StarterPlayer/StarterPlayerScripts`.
- `ParcelShiftEvent` is a server-to-client `RemoteEvent`; there are no client-to-server gameplay remotes in this slice.

## World and route
The server builds a start plaza at the origin and a short straight route with three wide gates at increasing Z distances. Each gate has a visible color, label, and a server-side touch handler. A pickup pedestal starts a delivery; the depot ends it. Route beacons, colored gate arches, marked open lanes, a parcel kiosk, and a glowing depot establish direction and readable landmarks. These are still procedural blockout art; custom meshes, animation, audio, and authored environment assets are the next production pass.

## Job state machine
`Idle -> Carrying -> Delivered` or `Expired/Cancelled -> Idle`.

A player can own one job at a time. A job stores the parcel instance, gate bitset, mutations encountered, start timestamp, and a unique job token. Repeated touch events are ignored after the gate bit is set. Delivery only succeeds once for the current token. Character death, leaving, and shift end remove the parcel and clear the job. The pickup prompt remains available for the next run.

## Mutation rules
Three gates select from four definitions using a deterministic per-job sequence offset, ensuring variety without random paid rolls. Giant and Tiny alter parcel dimensions; Bouncy applies a brief upward impulse; Floaty applies a small, capped forward/up impulse. Visual changes are readable and temporary to the current parcel. The mutation journal is session-only and counts unique types encountered. Effects are bounded so they do not create an unavoidable route failure.

## Trust and validation
The server owns every state transition and score change. Prompt handlers confirm active shift, living character, no existing job, and expected world instance. Gate handlers check active job, current character, distance to the gate, and per-job gate state. Depot checks active job, distance, shift time, and job token. All award and cleanup code runs server-side. The client receives display state only. If a future client-to-server action is added, validate type, state, distance, ownership, and rate on the server; never trust a client-reported reward or ProximityPrompt trigger.

## Scoring and session data
`leaderstats` contains `Deliveries` and `RouteScore` for the current server session. A delivery grants a base score, with a small bonus for crossing all three gates. Unique mutation count, combo chain, best combo, and current job status are held in server memory. Teammate stabilization is optional and grants a capped assist bonus. These are score and discovery measures, not spendable currency. No persistence is needed until repeat play is demonstrated.

## Mobile and accessibility
Use `ProximityPrompt` for pickup and depot interactions so Roblox supplies touch, keyboard, and gamepad input. Keep prompts close, labels short, gates broad, and the route legible from third person. Avoid precision jumps and timed button sequences in the first slice. HUD text must fit narrow screens and avoid depending on hover or keyboard-only controls.

## HUD events
Server sends a compact payload with `kind`, `shiftSeconds`, `jobState`, `gateCount`, `lastMutation`, `uniqueMutationCount`, and delivery summary. Client renders timer, route progress, journal count, and the last result. The client does not send any of these values back.

## Analytics plan after publishing
Instrument join, first pickup, first gate, first delivery, drop/expiry, and repeat delivery as server funnel steps. Compare solo and co-op completion, time to first mutation, time to first delivery, and return sessions. Studio playtests are for mechanics and device usability; Roblox funnel events must be reviewed in a published experience. Use results to decide if persistence or new districts are warranted.

## Acceptance checks

1. A new player can see and pick up the parcel promptly without a menu.
2. Carrying a parcel displays visibly; each gate mutates it once and updates HUD.
3. A valid depot arrival awards exactly one delivery; repeated touches do not duplicate score.
4. A player without an active job cannot score by touching the depot.
5. Shift end, death, and leaving clean up job state and parcel.
6. Multiple players can carry independent parcels concurrently.
7. Prompts are usable on touch devices; route does not require precision input.
8. The route remains completable solo; co-op is a helpful social layer, not a gate.

## Known validation limit
This workspace has no Roblox Studio or Rojo installation available. The source and project JSON can be reviewed here, but the acceptance checks still require an actual Studio server/client playtest before publication.



