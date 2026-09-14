# Evidence

Why this skill is built the way it is. Every design choice below traces to a source that was checked, not to a plausible-sounding rule.

## The problem this skill addresses

**Inert knowledge** — knowledge that is present, relevant, and not activated when the situation calls for it.

- Whitehead, *The Aims of Education and Other Essays* (1929) — the origin of the term: inert ideas are "ideas that are merely received into the mind without being utilised, or tested, or thrown into fresh combinations." https://archive.org/stream/in.ernet.dli.2015.190420/2015.190420.The-Aims-Of-Education-And-Other-Essay_djvu.txt
- Bransford, Brown & Cocking (eds.), *How People Learn* (expanded ed., National Research Council, 2000), ch. 2 — the mechanism: "experts' knowledge is 'conditionalized' — it includes a specification of the contexts in which it is useful"; "Knowledge that is not conditionalized is often 'inert' because it is not activated, even though it is relevant." https://www.nationalacademies.org/read/9853/chapter/5
- Gick & Holyoak, "Analogical Problem Solving", *Cognitive Psychology* 12, 306–355 (1980) — the size of the gap: ~10% solved Duncker's radiation problem cold, ~30% after reading a structurally identical story, near-ceiling once hinted to use it. The distance between 30% and ceiling is the recognition deficit, not a knowledge deficit. https://pdf.retrievalpractice.org/transfer/Gick_Holyoak_1980.pdf

## Why drills run on the user's own material

- Sala & Gobet, *Collabra: Psychology* 5(1):18 (2019), and *Perspectives on Psychological Science* 18(1) (2023) — far transfer from generic cognitive training is essentially absent. Nothing generalises for free, so a drill built on invented scenarios trains recognition of invented scenarios. https://doi.org/10.1525/collabra.203
- Pan & Rickard, *Psychological Bulletin* 144(7), 710–756 (2018) — retrieval practice transfers reliably to near variants and degrades with distance. Practice has to resemble the real triggering situation. https://pdf.retrievalpractice.org/transfer/Pan_Rickard_2018.pdf
- Morris, Bransford & Franks, *JVLVB* 16, 519–533 (1977) — transfer-appropriate processing: retrieval succeeds when processing at retrieval matches processing at encoding. This, rather than encoding specificity alone, supports practising on situations instead of content. https://doi.org/10.1016/S0022-5371(77)80016-9

## Why the drills are interleaved

- Brunmair & Richter, "Similarity matters", *Psychological Bulletin* 145(11), 1029–1052 (2019) — meta-analysis, g = 0.42, strongest for **confusable categories** and weak for maths. Spec, Verifier and Environment are confusable categories, which is where the effect is largest. https://doi.org/10.1037/bul0000209
- Hatala, Brooks & Norman, *Adv. Health Sci. Educ.* 8(1), 17–26 (2003) — mixed practice produced 46% vs 30% diagnostic accuracy on ECG interpretation. Same content, different ordering. https://pubmed.ncbi.nlm.nih.gov/12652166/
- Chase & Simon, "Perception in Chess", *Cognitive Psychology* 4, 55–81 (1973) — expertise as a stock of recognisable patterns; the advantage disappears on random boards. Recognition is learned from situations, not from rules about situations. https://andymatuschak.org/prompts/Chase1973.pdf

## Why relapse detection is worth the bookkeeping

- Pan & Rickard (above) — the closer the cue to the original situation, the better it transfers. "You did this in <repo> on <date>" is the closest cue available.
- Fisher, Goddu & Keil, *JEP: General* 144(3), 674–687 (2015), nine experiments — access to external knowledge inflates people's estimate of what they know internally. A dated record of a mistake they made is harder to argue with than a self-assessment. https://www.apa.org/pubs/journals/releases/xge-0000070.pdf

## The known limits of this design

State these rather than papering over them.

- **No study supports the specific mechanism.** Nothing was found testing whether offloading knowledge to tools or AI degrades the ability to recognise *when* that knowledge is needed. The nearest real evidence concerns monitoring automated processes, not invoking a personal method library: Bainbridge, "Ironies of Automation", *Automatica* 19(6), 775–779 (1983) — automating execution leaves the human the harder job of noticing when to intervene, while the skill decays from disuse; her conclusion is that operators need *more* training, not less. https://doi.org/10.1016/0005-1098(83)90046-8
- **Practice alone may not be enough.** Parasuraman & Manzey, *Human Factors* 52(3), 381–410 (2010) — complacency and automation bias appear in experts as well as novices and are not removed by simple practice or by instructions. https://doi.org/10.1177/0018720810376055
- **Environment matters as much as the learner.** Blume, Ford, Baldwin & Huang, *Journal of Management* 36(4), 1065–1105 (2010) — transfer of training depends substantially on the work environment. A user-invoked skill puts the whole loop behind the user remembering it exists, which is a deliberate trade, not an oversight.
- **Do not cite these.** Sparrow, Liu & Wegner (2011) on "Google effects" failed to replicate (Camerer et al., 2018). Situational judgment tests have solid validity as *selection* instruments, which is not evidence that SJT-style practice *builds* judgment. "Deliberate practice" explains far less variance than the popular framing claims (Macnamara, Hambrick & Oswald, *Psychological Science* 25(8), 2014: 26% in games, 4% in education, <1% in professions).
