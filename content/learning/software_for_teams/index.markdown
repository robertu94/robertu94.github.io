---
title:    "Learning to Learn: Software Teams"
date:     2023-02-09
tags: 
- Learning to Learn
- Software Engineering
- Teams
---

Outside of school very seldom in software development will you completely work alone on a project.
Leading and being an effective member of a software team will be critical to your success in this field.
However each team and project is different.
Some projects have a high iteration cost because testing could cause people to die (e.g. bugs in rocket guidance systems in manned space flight), testing could be lengthy (e.g. if you need to manufacture a physical thing), or expensive resources are consumed (e.g. issues that only manifest when using 1000 nodes) and have to be more planning focused.
Other line of business or research applications can afford to be more iterative.
Knowing which situation you are in is key to crafting your process to be more effective.
Regardless, there are some timeless principles of teams which are important to consider when working in or leading a team.
In this post, I will highlight what research says makes effective teams and highlight how one popular approach implements these principles.

# The Principles

Industrial organizational psychology is the disciple that studies how individuals work in teams.  While there are many specific debates within this discipline on specific approaches that work the best, Dr. Fred Switzer argues that there are roughly 3 attributes that are indicative of high performing teams:

1. Backup behavior triggered by mutual performance monitoring and enabled by trust.
3. Coordinated effort enabled by closed loop communication.
2. Adaptability between team members

There is a lot here:

Backup behavior is a term that describes where team member(s) proactively assist other members of the team that are facing challenges in their part of the task.
For example, if I am struggling, my team will notice and help me to face the task ahead and I do the same for them.
This is triggered by mutual performance monitoring which means that I am aware of how other members of my team are preforming, and I of them.
This is not suppose to be some sort of Orwellian surveillance state, but an openness and honestest around progress on towards the teams shared goals which is only possible when team members trust one another.

Coordinated effort means that teams both have a shared vision of the work to be done and are working cooperatively to achieve that vision.
The shared vision describes clearly where the team is hoping to go, and the rough goals and plans that will take them there.
Working coordinately means that team members each do their tasks, that each task is done once, and that proper synchronization occurs between team members when necessary to complete tasks.
This is made possible by "closed loop" communication which means that each party acknowledges receipt and the their understanding of the message.
You might have seen this in air plane where pilots say "I have control", and the co-pilot responds "you have control" indicating that he or she is now the person responsible for flying the plane.
A similar concept exists in the TCP/IP protocol where packets are acknowledged by `SYN`, `ACK`, and `SYN+ACK` flags to ensure that the message was received.

Adaptability between team members means that various members of the team know and can assist each other with tasks.
I often think of the "bus factor" of a project.
It's a tad morbid, but "how many people would need to be hit by a bus simultaneously for the project to die or be significantly delayed?"
I suspect that many people have been on projects where a specific task or group of tasks could only be completed by a single team member, and they became a bottleneck for the progress of the team.
Such a project likely has bus factor of 1.
Ideally each member of the team can fill all roles required which requires careful attention to cross training and knowledge sharing.

In leading or working in a software project, you have a responsibility to help strengthen these aspects of your team.
How you will implement these principles will very.
Every team is different.
Every project is different.
The goal is to adapt these principles to each team.

# Implementation

In software development on popular methodology is Scrum which a form of iterative or agile software development practice.
In a podcast that I thought described it well entitled [Product Development Structures as Systems](https://changelog.fm/507):

> So Scrum - I see it as kind of like a management training wheels, because it gives you good practices out of the box. You know, just follow the good practices, and it works. But if you understand the principles of why it works, you can make Kanban work in the same way. As long as you don’t create a longer queue, and you’re always revising what you’re going to put into the queue, maybe you can have even faster feedback  -- Lucas Fernandes Da Costa

My goal here is to illustrate how the principles above can be implemented in Scrum as kind of an "easy default" for teams to start with and evolve to their specific needs.

In the scrum process, you have a few key "roles" and a few key "rituals".
The key roles are:

+ the "scrum master" who leads the team and helps ensure that the process is followed
+ the "product owner" who represents the interests of the stakeholders/clients/users
+ and the cross-functional team members

Amazon famously tries to make these "pizza box" sized teams -- no bigger than can share a box of pizza without getting hungry.
The idea is to give each team as much autonomy as possible by giving them authority to make decisions and all the pessary skills to accomplish the project within the team so that it doesn't get stuck waiting on things from other teams which allows it to move quickly.

The key rituals are designed to be lightweight processes that enable the team to accomplish tasks and improve their performance over time.

+ "sprint planning" -- the team and the product owner negotiate on what work will be preformed over the next development cycle (sprint).
+ "sprint" -- the team works together to accomplish the work usually in a short time boxed window of 1-4 weeks.
+ "sprint retrospectives" -- the team celebrates what was accomplished over the last sprint and discusses what went well and what did not.
+ "standups" -- the team meets for less than 15 minutes each day to share what they accomplished, what they plan to do next, and what is blocking them.
+ "ad-hoc meetings" -- Anything that can't be resolved in the standup or sprint planning or retrospective is done separately with only the team members responsible for a specific task.

During Sprint planning the team reviews their backlog of tasks -- the list of all of the tasks that they would like to attempt at sometime in near future.
They decide if tasks need to be broken up into smaller tasks to be more reasonably sized for each person to do or to merge tasks that may be too small.
They decide what to include in the sprint often using some sort of a "points" system based on triangular numbers (e.g. 1 trivial, 3 a few hours, 6 a day, 10 several days, 15 several weeks).
The team members each individually estimate their perceived effort for a task and then share them together.
Large differences in the score of a task could prompt discussion on the approach or the idea person to perform a task.
Large scores may also prompt a task to be broken up into smaller tasks.
The product owner and team then collaborate on what tasks to attempt based on the perceived effort within an allotted budget of points.
Over time and based on team member availability the budget is adjusted for each sprint to better reflect what is feasible.
Ideally, once this list is agreed upon it is not modified until the end of the sprint which is ideally short enough that this is not challenging restriction.
In practice however, if a team member has many "on-demand" tasks which are urgent and important, their availability is reduced to make time for them.

During the sprint itself, the team works hard and focuses on the tasks at hand.
They meet daily for a standup to quickly share progress and determine what meeting need to happen that day.
I've frequently seen this done it "kanban" board which shows the progress of the tasks and the team as things progress.
They often will work through the scrum master to clarify the tasks with the product owner as needed.
I've often seem people do this part wrong by having stand ups which take hours which generally wastes a lot of peoples time.
If longer discussions are need they should be handled separately with only the people who need to handle them.

At the end of the sprint, the retrospective both celebrates what was accomplished and tries to identify where improvements can be made.
The team creates and adds new items to the backlog that they discovered thought out the sprint.

Now how does scrum act as training wheels? Scrum supports the principles of effective teams by:

1. Backup behavior triggered by mutual performance monitoring and enabled by trust. -- Scrum accomplishes this with the daily standup and "no-blame" post-postmortems during the retrospective
3. Coordinated effort enabled by closed loop communication. --  Scrum closes the loop with the sprint retrospective and synchronizes with the daily stand-up.
2. Adaptability between team members -- Scrum accomplishes this through it's sprint planning and retrospective mechanisms

Are these the only ways to accomplish these goals? no.  But they are relatively straight forward and give you a solid foundation for more developed practices later.

+ What are your current team practices?  How do they enable backup behavior, coordinated effort, and adaptability?
{.activity}

# Task specific resources

Now that you have some general knowledge on work planning, there are a few topics specific to software engineering:

+ Google produced a [book on software engineering](https://abseil.io/resources/swe-book/html/toc.html)
Chapters 13-20 focus on engineering process useful for filling our your knowledge on specific topics on testing, documentation, and code review.
It also covers some long term technical leadership culture things (i.e. blame free postmortems), and how to be a good team member.
However, it focuses much less on the work planning of software development life cycle stuff.
+ A related book also by Google is on [Site Reliability Engineering](https://static.googleusercontent.com/media/sre.google/en//static/pdf/building_secure_and_reliable_systems.pdf) which is the team in Google that develops and maintains their critical infrastructure. 
Specifically Parts 2 and 3 on design and implementation are also valuable for understanding current practices they use to make their systems reliable.
+ "The Phoenix Project" by Gene Kim et al -- is software engineering folk tale that shows how teams can work together on software projects and common challenges a light hearted quick read.
+ "The Unicorn Project" by Gene Kim -- the follow up to the Phoenix project from the software engineering organization's perspective.


I hope this helps!

# Changelog

+ 2023-02-09 created
