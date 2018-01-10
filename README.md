## drug-spending

**Slack:** [#drug-spending](https://datafordemocracy.slack.com/messages/drug-spending/)

[**Project Leads:**](https://github.com/Data4Democracy/read-this-first/blob/master/lead-role-description.md) 
* Current: @darya.akimova, @chaya.stern
* Former: @mattgawarecki, @jenniferthompson

**Maintainers (people with commit access)**: @dhuppenkothen, @skirmer

**Project Description:** At its heart, this project seeks to gain a deeper understanding of where and how Medicare tax dollars are being spent. Healthcare is an increasingly important issue for many Americans; the Centers for Medicare and Medicaid Services estimate *over 41 million Americans* were enrolled in Medicare prescription drug coverage programs as of October 2016.

Because healthcare spending is a very real concern, we want to make it real -- not just for people who like reading graphs and looking at statistics, but for everybody. We're harnessing the power of data and modern computing to find answers to the questions people keep asking, and to make those answers easily understandable for anyone who wants to know more; questions like:

* Which conditions are we spending the most to treat?
* How much are people paying out of their own pockets for prescription drugs?
* What could Medicare and the American people do to save money, while also ensuring the same quality of care?

In conducting this research, we hope to gain new insights and create a positive impact for healthcare consumers and providers across the United States. For more details, head to our [objectives](docs/objectives.md).

## Getting started

If you haven't already, [read this first](https://github.com/Data4Democracy/read-this-first). Then:

### Things you should know about
* **"First-timers" are welcome!** Whether you're trying to learn data science, hone your coding skills, or get started collaborating over the web, we're happy to help. *(Sidenote: with respect to Git and GitHub specifically, our [github-playground](https://github.com/Data4Democracy/github-playground) repo and the [#github-help](https://datafordemocracy.slack.com/messages/github-help/) Slack channel are good places to start.)*
* **We've got (GitHub) Issues.** Ready to dive in and do some good? Check out our [weekly update](https://docs.google.com/document/d/1azJZBPo9438ZOc73Gq2_AWbciKXgwBXiJk5gUAwGA0c) and our [issues board](https://github.com/Data4Democracy/drug-spending/issues). Issues are how we officially keep track of the work we're doing, what we've done, and what we'd like to do next. If you'd like to work on something, comment on the issue and/or ping a lead on Slack so we can make assignments.

    You can identify different issue types by their tags. If you're new to either Github or data science, pay special attention to:
    * `first-pr`: smaller issues to cut your teeth on as a first-time contributor
    * `beginner-friendly`: issues suitable for those with less experience or in need of mentorship
* **We believe good code is reviewed code.** All commits to this repository are approved by project maintainers and/or leads (listed above). The goal here is *not* to criticize or judge your abilities! Rather, sharing insights and achievements this way ensures that we all continue to learn and grow. Code reviews help us continually refine the project's scope and direction, as well as encourage the discussion we need for it to thrive.
* **This README belongs to everyone.** If we've missed some crucial information or left anything unclear, edit this document and submit a pull request. We welcome the feedback! Up-to-date documentation is critical to what we do, and changes like this are a great way to make your first contribution to the project.

### Currently utilized skills
Take a look at this list to get an idea of the tools and knowledge we're leveraging. If you're good with any of these, or if you'd like to get better at them, this might be a good project to get involved with!

* **Python 3** (scripting, analysis, Jupyter notebooks, visualization)
* **R** (analysis, R Markdown notebooks, visualization)
* **JavaScript** (visualization)
* **Data extraction/ETL**
* **Data cleaning**
* **Data analysis**

## FAQ and other useful info

### Downloading this repository
To download the code and data inside this repository, you'll need [Git](https://git-scm.com/). Once you've got the necessary tools, open a command prompt and run `git clone https://github.com/data4democracy/drug-spending.git` to start downloading your own working copy. Once the command finishes, you should see a new `drug-spending` directory in the current directory's file listing. That's where you'll find it!

### Project structure (or, "how do I find `thing`?")
* **Data**: all our datasets are housed in our [repo on data.world](https://data.world/data4democracy/drug-spending), which both keeps our Github repo streamlined and allows us to take advantage of data.world features like querying and discussion. If you're using R or Python, data.world has query clients for both. ([R client](https://github.com/datadotworld/data.world-r); [Python client](https://github.com/datadotworld/data.world-py))
* **Documentation**:
    * See our [`docs`](docs) directory for general documentation, including more detailed [objectives](docs/objectives.md) and (coming soon) a glossary of terms. We'll add other docs there as we go.
    * Our [`datadictionaries`](datadictionaries) directory contains an [overview](datadictionaries/README.md) of our current available datasets, as well as detailed data dictionaries for each and [tips](datadictionaries/README.md) on how to most effectively contribute more data.
* **Source code and notebooks**: We currently have one directory each for Python and R code, with subdirectories for analyses/visualizations; notebooks; apps (eg, Flask/Shiny); and data collection/cleaning scripts.

### Core data sets
https://data.world/data4democracy/drug-spending

### Performing data analysis
There are many ways to analyze the data in this repository, but "notebook" formats like [Jupyter](http://jupyter.org/install.html) and [R Markdown](http://rmarkdown.rstudio.com/r_notebooks.html) are the most common. The setup process for these tools is in-depth enough to be outside the scope of this README, so please refer to documentation at the aforementioned links if necessary. If something isn't working quite right for you, that's okay! Continue reading to see how you can reach out for assistance.

### Talking to people/asking for help
If you have questions or you'd like to discuss something on your mind, reach out to us in the [#drug-spending](https://datafordemocracy.slack.com/messages/drug-spending/) channel on Slack. Project leads and maintainers are available for troubleshooting, brainstorming, mentorship, and just about anything else you might need.

### System requirements (suggested)
* **Git** (check out the [github-playground](https://github.com/data4democracy/github-playground) repository if you need a good place to get accustomed)
* **An analytical language of your choice** (Python, R, Julia, etc.)
* **Python 3** (for Jupyter/`.ipynb` notebook files)
* **RStudio** (for R Markdown/`.Rmd` notebook files)
