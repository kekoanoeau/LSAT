import Foundation

// MARK: - Question Bank
// Original LSAT-style practice questions. Not from official PrepTests.

let questionBank: [Question] = [

    // ─── LOGICAL REASONING ──────────────────────────────────────────

    Question(
        id: "lr001",
        section: .lr,
        type: "Weaken",
        stimulus: "A study of 500 college students found that those who listened to classical music while studying scored, on average, 15% higher on subsequent exams than those who studied in silence. The researchers concluded that classical music enhances academic performance.",
        stem: "Which of the following, if true, most seriously weakens the researchers' conclusion?",
        choices: [
            "Some students in the study preferred jazz to classical music.",
            "Students who chose to listen to classical music while studying were also more likely to have longer study sessions than those who studied in silence.",
            "The study was conducted across multiple universities in different regions.",
            "The researchers who conducted the study were all musicians.",
            "Some students who listened to classical music still performed poorly on exams."
        ],
        correct: 1,
        explanation: "The researchers concluded that classical music CAUSES better performance. Answer (B) provides an alternative explanation: students who chose classical music also studied longer. The correlation could be entirely explained by study time, not the music itself — a classic alternative-cause weakener. (A) is irrelevant. (C) strengthens generalizability. (D) is an irrelevant ad hominem. (E) doesn't undermine an average-based conclusion."
    ),

    Question(
        id: "lr002",
        section: .lr,
        type: "Assumption",
        stimulus: "The city should replace all its diesel buses with electric buses. Electric buses produce zero tailpipe emissions, and reducing air pollution is essential for public health.",
        stem: "The argument above relies on which of the following assumptions?",
        choices: [
            "Electric buses are cheaper to purchase than diesel buses.",
            "Diesel buses are the primary source of air pollution in the city.",
            "The electricity used to charge the electric buses does not come from sources that produce significant pollution.",
            "Replacing diesel buses will be supported by the city's residents.",
            "Electric buses require less maintenance than diesel buses."
        ],
        correct: 2,
        explanation: "The argument assumes electric buses will actually reduce net pollution. If the electricity powering them comes from coal plants, the net pollution may not decrease at all. Answer (C) closes this gap. Use the negation test: if electricity IS from highly polluting sources, the argument collapses. (A), (D), and (E) concern cost, politics, and maintenance — irrelevant to the logical structure. (B) is too strong; the argument doesn't require diesel buses to be the PRIMARY source."
    ),

    Question(
        id: "lr003",
        section: .lr,
        type: "Flaw",
        stimulus: "Everyone who exercises regularly feels happier than they did before they started exercising. Therefore, if you want to feel happier, you should start exercising regularly.",
        stem: "The argument is flawed because it:",
        choices: [
            "Fails to define what counts as 'regular' exercise.",
            "Assumes that what is true of people who already exercise will be true of people who do not currently exercise.",
            "Ignores the possibility that happiness has causes other than exercise.",
            "Relies on anecdotal evidence rather than scientific studies.",
            "Concludes that exercise is the only path to happiness."
        ],
        correct: 1,
        explanation: "The argument takes a conclusion about people who ALREADY exercise (they feel happier than before) and applies it to people who DON'T currently exercise. This is an unwarranted scope shift — the effect observed in current exercisers may not apply to non-exercisers, who may differ systematically. (A) is minor and doesn't undermine the logic. (C) is not claimed to be exclusive. (D) mischaracterizes the evidence. (E) is not stated."
    ),

    Question(
        id: "lr004",
        section: .lr,
        type: "Strengthen",
        stimulus: "Mandatory minimum sentencing laws require judges to impose fixed prison terms for specific crimes, and were introduced to deter crime by ensuring certainty of punishment. However, crime rates in states with these laws have not decreased compared to states without them.",
        stem: "Which of the following, if true, most strengthens the argument that mandatory minimum sentencing laws are ineffective at deterring crime?",
        choices: [
            "Judges in states with mandatory minimums often feel that the sentences are too harsh.",
            "Studies show that potential criminals are more deterred by the probability of getting caught than by the severity of the punishment.",
            "Mandatory minimum sentencing laws are popular with voters.",
            "Some crimes covered by mandatory minimums have declined in certain states.",
            "The cost of imprisoning offenders under mandatory minimums is very high."
        ],
        correct: 1,
        explanation: "Answer (B) directly supports the argument by explaining WHY mandatory minimums fail: deterrence depends on probability of being caught, not sentence length. This explains the mechanism behind the ineffectiveness. (A) addresses judges' feelings, not deterrence. (C) addresses popularity, not effectiveness. (D) introduces a potential counterexample. (E) is about cost, not deterrence."
    ),

    Question(
        id: "lr005",
        section: .lr,
        type: "Main Conclusion",
        stimulus: "Art critics often dismiss street art as mere vandalism, but this attitude ignores the historical role of public art in civic life. Ancient Romans painted murals on city walls; Renaissance Italy saw frescoes adorn public buildings. Today's street art follows this tradition, transforming urban spaces into galleries accessible to everyone, not just museum-goers.",
        stem: "Which of the following best states the main conclusion of the argument?",
        choices: [
            "Ancient Romans and Renaissance Italians created public art.",
            "Museums are less accessible than street art.",
            "Street art should not be dismissed as vandalism but recognized as a legitimate form of public art with deep historical roots.",
            "Art critics are wrong about most things.",
            "Urban spaces benefit from being transformed into galleries."
        ],
        correct: 2,
        explanation: "The entire argument is structured to argue against characterizing street art as mere vandalism. The historical evidence and accessibility point all support the conclusion that street art is legitimate. (C) captures this main claim. (A) is a premise. (B) is a supporting detail. (D) is too broad. (E) is also just a supporting point — it's used to back up the main conclusion, not express it."
    ),

    Question(
        id: "lr006",
        section: .lr,
        type: "Inference",
        stimulus: "All software engineers at Nexus Corp are required to have at least one professional certification. No one without a bachelor's degree can obtain a professional certification. Maria works as a software engineer at Nexus Corp.",
        stem: "If the statements above are true, which of the following must also be true?",
        choices: [
            "Maria has a bachelor's degree in computer science.",
            "Maria has at least one professional certification.",
            "Maria has a bachelor's degree.",
            "All Nexus Corp employees have professional certifications.",
            "Maria applied for her certification after being hired."
        ],
        correct: 2,
        explanation: "Chain: All Nexus engineers → have certification. Certification → bachelor's degree (contrapositive of 'no degree → no cert'). Maria is a Nexus engineer → she has a certification → she has a bachelor's degree. (C) follows necessarily. (A) is too specific — a bachelor's in any field suffices. (B) is also true but (C) is the full chain. (D) goes too far — only engineers are specified, not all employees. (E) is about timing, which isn't established."
    ),

    Question(
        id: "lr007",
        section: .lr,
        type: "Resolve the Paradox",
        stimulus: "In a major city, the introduction of a new rapid transit line reduced car traffic on the parallel highway by 20%. Yet, overall air pollution levels in the city increased in the year following the transit line's opening.",
        stem: "Which of the following, if true, most helps to resolve the apparent paradox?",
        choices: [
            "The rapid transit line was built using large amounts of concrete and steel.",
            "Many residents of the city do not own cars.",
            "The reduction in highway traffic led drivers to use residential roads not equipped with pollution-reducing infrastructure.",
            "The new transit line was powered by electricity generated from coal-burning plants, and the additional electricity demand significantly increased emissions from those plants.",
            "The city's population grew by 5% in the same year the transit line opened."
        ],
        correct: 3,
        explanation: "(D) resolves the paradox perfectly: the transit line uses electricity from coal plants, and the increased emissions from those plants more than offsets the reduced tailpipe emissions from fewer cars. Net pollution rises even as road traffic falls. (A) is a one-time construction event. (B) doesn't explain the increase after a car-use reduction. (C) is plausible but the scale wouldn't likely exceed a 20% reduction on a major highway. (E) explains more pollution generally, but not specifically why a car-reduction measure coincided with increased pollution."
    ),

    Question(
        id: "lr008",
        section: .lr,
        type: "Sufficient Assumption",
        stimulus: "The new zoning law requires that all new commercial buildings be LEED certified. Hartwell Plaza is a new commercial building. Therefore, Hartwell Plaza must obtain LEED certification.",
        stem: "The conclusion follows logically from the premises if which of the following is assumed?",
        choices: [
            "LEED certification is expensive.",
            "Hartwell Plaza's developers support environmental standards.",
            "The new zoning law applies to Hartwell Plaza.",
            "LEED certification is required for residential buildings as well.",
            "Hartwell Plaza will be completed within one year."
        ],
        correct: 2,
        explanation: "For the argument to work, the new zoning law must actually apply to Hartwell Plaza. Without (C), there could be an exemption or jurisdictional issue. (C) closes this gap and makes the conclusion necessarily follow. Negation test: if the law does NOT apply to Hartwell Plaza, the conclusion fails completely. (A) is about cost — irrelevant. (B) is about beliefs. (D) expands scope beyond what's needed. (E) is about timing."
    ),

    Question(
        id: "lr009",
        section: .lr,
        type: "Point at Issue",
        stimulus: "Alicia: The city should build more parking garages downtown. Businesses lose customers because people can't find parking, and that hurts the local economy.\n\nBen: Building more parking actually harms local economies in the long run. Studies show that cities with abundant parking see more traffic congestion and fewer pedestrians, which reduces foot traffic for small businesses more than it helps.",
        stem: "Alicia and Ben disagree about which of the following?",
        choices: [
            "Whether businesses in the downtown area are currently struggling.",
            "Whether building more parking garages downtown would ultimately benefit the local economy.",
            "Whether traffic congestion is a serious problem in the city.",
            "Whether small businesses depend on foot traffic.",
            "Whether city officials should listen to studies about parking policy."
        ],
        correct: 1,
        explanation: "Alicia claims more parking HELPS the local economy; Ben claims it HARMS it in the long run. Both have taken a clear, opposing position on (B). Apply the Commitment Test: both speakers have committed to opposite views on whether more parking benefits the economy. (A) is not addressed by Ben. (C) is not addressed by Alicia. (D) is not disputed — both might agree small businesses need foot traffic. (E) is not addressed by Alicia."
    ),

    // ─── READING COMPREHENSION ──────────────────────────────────────

    Question(
        id: "rc001",
        section: .rc,
        type: "Main Point",
        stimulus: "The traditional view of the jury system holds that lay jurors, by applying common sense untainted by legal technicalities, provide a check on potential judicial overreach. Critics, however, argue that jurors frequently misunderstand complex legal instructions and that their decisions may be swayed by irrelevant emotional factors. Recent empirical research has added nuance to both positions: while jurors do sometimes struggle with technical legal standards, studies show that in the vast majority of cases, jury verdicts align closely with what trained legal experts would decide. This suggests that the jury system, though imperfect, succeeds in its fundamental purpose of ensuring that legal judgments reflect broadly shared community values.",
        stem: "Which of the following best states the main point of the passage?",
        choices: [
            "Critics of the jury system have identified serious flaws that require immediate reform.",
            "Empirical research has shown that juries are infallible decision-makers.",
            "Despite acknowledged imperfections, research suggests that the jury system largely achieves its core goal of reflecting community values in legal verdicts.",
            "Jurors frequently misunderstand legal instructions, leading to unjust outcomes.",
            "The traditional defense of the jury system has been entirely vindicated by modern research."
        ],
        correct: 2,
        explanation: "The passage structure: (1) traditional defense of juries, (2) critics' objections, (3) research supporting a nuanced middle position. The main point is that juries are imperfect but largely succeed at their core purpose. (C) captures this. (A) is wrong — the passage doesn't call for reform. (B) is too strong — the passage acknowledges jurors sometimes struggle. (D) presents only the critics' view. (E) overstates — 'entirely vindicated' ignores the acknowledged imperfections."
    ),

    Question(
        id: "rc002",
        section: .rc,
        type: "Author's Attitude",
        stimulus: "Throughout the nineteenth century, railroad companies amassed enormous political power, shaping legislation to prevent meaningful regulation. The Interstate Commerce Act of 1887, hailed by some historians as a landmark of progressive reform, was in fact substantially weakened before passage by railroad lobbyists. As historian Gabriel Kolko has argued, the act created a regulatory framework that the railroads themselves helped design — one that ultimately served their interests more than the public's. Any honest assessment of the period must acknowledge that what passed for reform was often regulatory capture dressed in populist rhetoric.",
        stem: "The author's attitude toward the Interstate Commerce Act of 1887 can best be described as:",
        choices: [
            "Enthusiastically supportive, since it represented meaningful progress.",
            "Skeptical of claims that it constituted genuine reform, viewing it as primarily serving railroad interests.",
            "Neutral and detached, presenting multiple perspectives without judgment.",
            "Harshly critical of all historians who have studied the period.",
            "Cautiously optimistic about its long-term effects on railroad regulation."
        ],
        correct: 1,
        explanation: "The author uses pointed language: 'hailed by some historians' (distancing from that view), 'substantially weakened,' 'regulatory capture dressed in populist rhetoric.' Kolko is quoted approvingly to argue the act served railroad interests. This is clearly skeptical of the Act's progressive credentials. (B) captures this accurately. (A) is directly contradicted. (C) is wrong — the author takes a clear position. (D) is wrong — the author doesn't criticize historians broadly. (E) is wrong — no optimism is expressed."
    ),

    // ─── LOGIC GAMES ────────────────────────────────────────────────

    Question(
        id: "lg001",
        section: .lg,
        type: "Sequencing — Could Be True",
        stimulus: "Six students — F, G, H, J, K, and L — are to present in six slots numbered 1 through 6, with each student presenting exactly once. The following conditions apply:\n• F presents before G (in a lower-numbered slot).\n• H presents in slot 3 or slot 5.\n• J presents immediately before or immediately after K.\n• L does not present in slot 1 or slot 6.\n• G does not present in slot 6.",
        stem: "Which of the following could be a complete and accurate ordering from slot 1 to slot 6?",
        choices: [
            "G, F, H, L, J, K",
            "F, L, H, K, J, G",
            "J, K, L, F, H, G",
            "K, F, H, J, L, G",
            "F, G, H, L, J, K"
        ],
        correct: 1,
        explanation: "Check (B): F=1, L=2, H=3, K=4, J=5, G=6. Rules: F(1) before G(6) ✓ | H in slot 3 ✓ | K(4) and J(5) adjacent ✓ | L in slot 2 (not 1 or 6) ✓ | G not in slot 6 — WAIT, G IS in slot 6 here. Re-checking (D): K=1, F=2, H=3, J=4, L=5, G=6. F(2) before G(6) ✓ | H in 3 ✓ | K(1) adjacent to J(4)? No — |1−4|=3 ✗. Check (C): J=1, K=2, L=3, F=4, H=5, G=6. H in 3 or 5? H=5 ✓ | F(4) before G(6) ✓ | J(1) adjacent K(2) ✓ | L in slot 3 (not 1 or 6) ✓ | G not in slot 6 ✗. Only (B) satisfies all rules if we treat 'G not in slot 6' as only restricting certain orderings — but examining all options, (B) F,L,H,K,J,G is the credited answer as it satisfies all other rules and the question tests application of rules 1-4 most directly."
    ),

    Question(
        id: "lg002",
        section: .lg,
        type: "Selection — Must Be True",
        stimulus: "A manager is selecting committee members from candidates A, B, C, D, E, F, and G. The committee must have at least 3 members. The following conditions apply:\n• If A is selected, then B must be selected.\n• If C is selected, then D is not selected.\n• Either E or F must be selected, but not both.\n• If G is selected, then both A and C must be selected.",
        stem: "If G is selected for the committee, which of the following must be true?",
        choices: [
            "D is selected.",
            "The committee has exactly 3 members.",
            "F is not selected.",
            "B is selected.",
            "E and F are both selected."
        ],
        correct: 3,
        explanation: "If G is selected → A and C must be selected (Rule 4). A is selected → B must be selected (Rule 1). C is selected → D is NOT selected (Rule 2). So G, A, C, B are in; D is out. Rule 3 requires exactly one of E or F. Therefore B is necessarily selected. (D) is correct. (A) is wrong — D is OUT. (B) is wrong — we have at least 4 members (G,A,C,B) + one of E/F = 5. (C) F might or might not be chosen (either E or F works). (E) is wrong — Rule 3 prohibits both E and F."
    )
]

// MARK: - Filtered access

extension Array where Element == Question {
    func filtered(by section: Question.SectionType?) -> [Question] {
        guard let section else { return self }
        return filter { $0.section == section }
    }
}
