Working Paper / Project:

# How the Nature of Political Preferences Shapes the Efficiency of Majority Rule Voting

## Relaxing Assumptions about Voter Utilities

### Overview
This paper analyzes how the assumptions of issue-based voting impact the expected efficiency of majority rules. We present simulational as well as experimental results to depict the underlying mechanisms linking voter utilities and social welfare.

### Abstract
Traditional models of issue voting assume that voters and candidates can be placed on a single policy dimension and the voters' utilities can be determined by the relative proximity of their ideal points to the respective candidates (cf. Downs 1957). In such a framework, simple majority elections between two candidates are generally expected to lead to desirable outcomes that maximize social welfare. The goal of this paper is to examine how the underlying assumption of voter utilities based on common policy dimensions affect the expected welfare outcomes of majority voting. More specifically, we present simulational studies as well as an experimental design in order to examine the efficiency of majority elections under different scenarios. We hope to illustrate how the assumptions underlying the ideal-point framework influence the expected social welfare outcomes of voting rules.

### Keywords
Utility Assumptions, Majority Voting, Efficiency

### Comments CBPE Talk
- further investigate efficient cases: what about the dispersion of outcomes?
- how does this relate to inequality of the outcomes?
- role of (endogenous) turnout?
- condorcet jury theorem is the wrong setup, since it focuses on _non-conflicting_ preferences with _incomplete_ information
- Comments Oleg
	1. Equilibrium can be derived for intransitive collective preferences if the order of voting (the "agenda") can be determined.
	2. How common is the intransitivity? It has already been examined in various papers (don't remember the references but you should be able to find out).
	3. You should probably avoid using the quadratic utility function. At the very least, use linear.
	4. What about other distributions (other than normal)?
	5. I would like to see a simple plot: proportion of "successful" runs (in terms of social utility aggregation) as a function of distribution parameters; perhaps, in addition to the heatmap.
	6. When you present this you may want to talk more about why slides 17 has asymmetric (around zero) results. I did not quite get that. In fact, my immediate reaction was that you have some kind of a bug in your code...

### Meeting Peter 12/10/2014: TO DOs
- major question: can ideal-point utilities represent preferences?
- inequality argument can be met with a social justice perspective from the beginning (i.e. if we want to redistribute money, it will increase the variance in utilities as well) -> inequality argument can be flipped the other way around...
- write up simulational results
- think about analytical solution for mean/median problem in normal distribution
- start writing about potential experimental investigations (i.e. including electoral abstention etc.)
- extensions for paper
	- endogenize turnout in the simulation (1. moving far away from both candidates decreases turnout, 2. large difference b/w both candidates increases turnout)
	- increase number of candidates
	- increase number of issues: 2 candidates, 5 issues, candidates and voters either approve or disapprove of both candidates -> binomial distribution!
		- same result as in continuous case?
		- comparison of voting in pieces on each dimension vs. voting in a bundle (i.e. one of the candidates)
		- likely conclusion: voting in pieces is better _unless_ agreement on one issue is cotingent on decision on other issue. issues should be broken apart as long as they are not connected or approval is conditional (essentially gets away from iid assumption)
		- check combinatorial auction paper that accounts for that
	- different voting rules: compare in simulation, e.g. primaries and general election