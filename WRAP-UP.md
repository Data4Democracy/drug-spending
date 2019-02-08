# Lessons Learned
Start of project: pretty much right after D4D formed; gather Medicare drug spending data and analyze to find interesting trends, anomalies, etc.

## Data sources
* CMS.gov (for Medicare drug spending data)
* FDA (for FDA drug codes, which are IDs assigned to each individual drug)
* Genome.jp (for ATC codes, which map drugs to their usages)
* Centerwatch.com (for mappings between drug names and their usages)

All data now housed either at data.world (mostly there) or in the project’s Git repository:
* https://github.com/data4democracy/drug-spending
* https://data.world/data4democracy/drug-spending
  * Several files annotated with URL(s) where data was originally sourced

## Issues

### Communication
* For a short while, both co-leads had to step away at roughly the same time; this made work on the project a bit less cohesive and resulted in some confusion
* Lack of specific questions: we knew Medicare drug spending was worthy of our attention, but we didn’t know where to start or what had already been explored
  * Couldn’t find any subject matter experts until later in the project’s life; by that time, activity had already died down considerably
  * Led to a lack of actionable tasks, even with available volunteers
  * Led to lack of interest/activity in the project’s Slack channel

### Technical
* Difficult to cross-reference drug names with other information (e.g., treatments, conditions)
  * Drug names and authorized usages differ by brand, locality, and method of use
  * Many different sources of truth
* (*Minor*) Multiple programming languages in use
  * Some volunteers knew one, some knew another
  * \# of available reviewers for any given PR depended on the language the submitter used
