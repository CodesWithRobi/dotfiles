---
name: ste-writing
description: Rewrite prose (docs, READMEs, PR descriptions, error messages, release notes, comments — never code) into ASD-STE100 Simplified Technical English to remove "AI slop". Use when asked to make writing not sound like AI, make docs clear or plain, enforce a controlled writing style, or write technical documentation that reads human. Two modes — strict (procedures/safety) and STE-flavored (general prose).
---

# ste-writing

Write prose in ASD-STE100 Simplified Technical English. This applies to documentation, READMEs, pull-request text, error messages, release notes, and comments. It does not apply to code, identifiers, or command syntax. It is not for marketing copy, essays, or anything that needs a voice — STE strips voice on purpose.

## Rules

### Sentences
- Keep sentences short. Aim for 20 words or fewer.
- One idea per sentence.
- Do not use more than two clauses per sentence.

### Words
- Use one word for one meaning. Do not use synonyms.
- Prefer the simple word over the complex word.
- Use technical terms only when the reader will know them.
- Do not use jargon, slang, or figurative language.
- Avoid words that end in -ion, -ment, -ance, -ence unless they are standard technical terms.

### Voice
- Use active voice. Do not use passive voice.
- Write in the imperative mood for procedures: "Click Save" not "The Save button should be clicked."
- Address the reader directly as "you" when needed.

### Structure
- Use headings, lists, and short paragraphs.
- Do not use long blocks of text.
- Put the most important information first.
- Use horizontal rules to separate major sections.

### Word list (use these, not their synonyms)
- use → not utilize
- start → not initiate, commence
- end → not terminate, conclude
- show → not demonstrate, illustrate
- help → not assist, facilitate
- need → not require
- choose → not select (unless in a UI context)
- buy → not purchase
- send → not transmit
- ask → not inquire
- tell → not inform, notify
- change → not modify, alter
- keep → not retain
- give → not provide, supply
- fix → not resolve, address
- set up → not configure, establish (as a verb)

### Forbidden constructions
- Do not use "in order to" — use "to".
- Do not use "the fact that" — rephrase.
- Do not use "is able to" — use "can".
- Do not use "make a decision" — use "decide".
- Do not use "carry out" — use "do" or the specific verb.
- Do not use "a number of" — use "several" or a specific number.
- Do not use "due to the fact that" — use "because".
- Do not use "at the present time" — use "now".
- Do not use "in the event that" — use "if".
- Do not use "has the ability to" — use "can".

## Modes

### Strict
Full STE compliance. Use for procedures, safety-critical docs, and when the user explicitly asks for plain or controlled writing.

### STE-flavored
Apply the spirit of STE (short sentences, active voice, simple words, no jargon) without rigid word-list adherence. Use for READMEs, general docs, and blog posts where readability matters but the text still needs a natural flow.

## Process

1. Read the source text end-to-end.
2. Identify the mode (strict or STE-flavored) based on context or user request.
3. Rewrite section by section, applying the rules.
4. Preserve the original meaning. Do not add or remove information.
5. Preserve formatting (headings, lists, code blocks, links).
6. Output only the rewritten text — no commentary unless asked.
