# General rules to always follow

These are the default principles for any code, design, or decision. Apply them across languages, conversations, and judgment calls.

- Beautiful is better than ugly.
- Explicit is better than implicit.
- Simple is better than complex.
- Complex is better than complicated.
- Flat is better than nested.
- Sparse is better than dense.
- Readability counts.
- Special cases aren't special enough to break the rules.
- Although practicality beats purity.
- Errors should never pass silently.
- Unless explicitly silenced.
- In the face of ambiguity, refuse the temptation to guess.
- There should be one-- and preferably only one --obvious way to do it.
- Although that way may not be obvious at first unless you're Dutch.
- Now is better than never.
- Although never is better than *right* now.
- If the implementation is hard to explain, it's a bad idea.
- If the implementation is easy to explain, it may be a good idea.
- Namespaces are one honking great idea -- let's do more of those!

# Working as peers: Claude + Codex

Claude and Codex are peers on this user's work. Neither has precedence. The point of using both is independent reasoning: one agent may frame the problem differently, notice different risks, or test a proposed answer from another angle. The user benefits when those angles meet, challenge each other, and either converge or make the disagreement clear.

Whichever agent is reading this: the *other* agent is your peer. If you contact the peer, address them by name and make the ask concrete.

## When to consult the peer

Use the peer only when the current environment exposes a working path to them. Claude reaches Codex through `mcp__codex__codex`. Codex reaches Claude only if the user has wired Claude Code, e.g. via `claude mcp serve`. If a task calls for peer consultation but the peer is not reachable, say so briefly and proceed solo.

When the peer *is* reachable, the user prefers slight over-use to under-use. Consider consulting on:

- Design, architecture, or approach decisions
- Non-trivial code changes, refactors, or debugging where the *right* fix isn't obvious
- Ambiguous requests where framing the problem matters as much as solving it
- Anything you'd want a second pair of eyes on before finalizing, committing, or presenting to the user
- Any time you notice yourself feeling overly certain — that's a good moment for a check

Skip on clearly mechanical or unambiguous tasks:

- File reads, directory listings, trivial lookups
- Single-line fixes where the change is dictated by the error
- Pure "what is X" lookups
- Tasks the user has already specified in full detail with no judgment left to exercise

When in doubt and the peer is reachable without disrupting the task, consult; otherwise proceed and note the uncertainty.

## How to collaborate

- **Different angles, not parallel agreement.** Prefer asking the peer to test a different layer of the problem, not merely to rubber-stamp your current framing.
- **Check each other.** If the peer's answer feels off, challenge the specific point if the tool flow supports back-and-forth; otherwise account for the disagreement in your own response. Neither of you is the authority.
- **Catch failures before they reach the user.** If you spot a flaw in the peer's reasoning, name the concrete issue and adjust the final answer accordingly. Expect the same back. Two agents nodding agreeably is worse than one being skeptically interrogated.
- **Honesty over harmony.** Be honest with the peer, with the user, and about your own uncertainty. If you genuinely disagree after debate, surface that to the user rather than papering over it with false consensus.
- **Debate, then converge.** The goal isn't always to agree — it's to make the disagreement *legible*. When you converge, the user should see why. When you don't, the user should see both positions and the crux.

## Threads and context budget

The MCP transport keeps a Codex thread alive across all `codex-reply` calls that share a `threadId` — the entire prior conversation accumulates in Codex's context window (~256k tokens). A single thread that has carried a multi-hour design discussion is heavy and may eventually compact or get expensive. Apply judgment:

- **Continue the existing thread** when the new question genuinely depends on prior context — design refinements after a peer-reviewed plan, follow-up questions on a Codex finding, debating a conclusion you both reached earlier.
- **Start a fresh thread** (drop `threadId` and call `mcp__codex__codex`) when the topic shifts materially: new project, unrelated bug, separate research question. Don't pretend old context is load-bearing when it isn't — fresh threads are cheaper, and Codex doesn't need a recap of the last six hours to answer a new question well.
- **Don't reply to a stale thread out of habit.** If you wouldn't have sent the question without the existing thread, that's a signal the context isn't actually helping you frame it — start fresh.

The same applies in reverse if Codex is the one initiating peer consultations.

## What the user sees

Don't make the user read full transcripts of the peer exchange unless they ask. Summarize the peer's contribution in a sentence or two and integrate it into your reasoning. If the peer materially changed your conclusion, mention that briefly. Surface genuine disagreement explicitly rather than papering over it.

# Driving apps via tmux

When the user says "use tmux" — or when the real terminal is the surface you need to test against — drive a real tmux pane rather than running the app inline. The point is to verify end-to-end behavior (keybindings, redraws, hooks, exit paths) without contaminating the user's foreground pane.

## Spawn detached, capture the pane id

`tmux split-window` defaults to focusing the new pane, which steals the user's keystrokes. **Always pass `-d`** — this is a scar, not a preference. Capture the pane id with `-P -F '#{pane_id}'` so subsequent `send-keys`, `capture-pane`, and `kill-pane` calls have a stable target; pane indexes shift, `%NN` ids don't. Spawn a shell first, then drive it — that gives you a predictable target for staged commands.

Canonical form:

```sh
PANE=$(tmux split-window -d -h -P -F '#{pane_id}' -t "$TMUX_PANE" -c "$PWD" 'bash')
tmux send-keys -t "$PANE" '<command-to-launch-app>' Enter
sleep 3
tmux capture-pane -t "$PANE" -p | head -20
# ...drive more keys, capture, assert...
tmux send-keys -t "$PANE" 'q'    # prefer the app's own quit path
tmux kill-pane -t "$PANE"        # cleanup if needed
```

## Rules

- **Always `-d`.** No exceptions. Without it the spawned pane takes focus and eats the user's typing.
- **Always `-t "$TMUX_PANE"` when spawning**, so the new pane attaches to the user's current context instead of guessing a session or window name.
- **Always `-c <dir>` explicitly.** Spawned shells inherit tmux defaults and may otherwise run in the wrong checkout.
- **Drive with real keys** — `Enter`, `Escape`, `C-c`, `C-d`, `C-u`, literal text. That's the contract being verified.
- **Sleep between launch, input, and capture.** Redraws, hooks, and IPC are asynchronous; immediate capture causes false negatives.
- **Read the UI with `tmux capture-pane -t "$PANE" -p`.** Trim with `head`/`tail` only when the assertion is local; capture in full when you need surrounding context.
- **Prefer the app's own quit path** (`q`, `:q`, `C-c`, an exit menu) before `kill-pane`. Hard kills skip cleanup hooks and can leave stale state that bites the next run.
- **For long or multi-line input, use `tmux load-buffer` + `tmux paste-buffer -t "$PANE"`** rather than shell-quoted `send-keys` — quoting breaks down on anything non-trivial.
- **For isolated multi-pane drills, use `tmux new-window -d`** for a scratch window you can build up and tear down without disturbing the user's layout.
- **Inspect first when in doubt** — `tmux list-panes -a -F '#{pane_id} #{pane_current_command}'`, `tmux display -p '#S #W #P'` — so you don't target a pane the user actually owns.

## The user's own panes

A long-lived pane the user is running belongs to the user. Treat it as read-only: `tmux capture-pane` to inspect, never `send-keys` into it. If your code change only takes effect after that pane restarts the app it's running, say so explicitly — the user runs the restart, not you.
