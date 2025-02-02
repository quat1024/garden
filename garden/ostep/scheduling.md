*Part of the [OSTEP notes](./index)*

# Process scheduling

Which processes run when?

If you have several processes all running concurrently, it makes sense to divide time equally between them. If you have several processes waiting on a network request, it makes sense to run *different* processes while those ones wait. Some processes (like moving the mouse pointer) are more important than others (like updating the on-screen digital clock)

## Process states

OSs have lots of process states, but it's possible to divide them into three categories:

* *Running*. The process is currently the one using the CPU.
* *Ready*. The process is not using the CPU, but if the scheduler decided to give it a turn, it's ready to go.
* *Blocked*. The process is not using the CPU, and additionally, there's no reason for the process to run because it's waiting on another part of the system.
  * For example, a program asks for the first character of a file. There's no reason to schedule the process until we get that first character, because we can't even allow that function to return without giving it a character to return with.

## Scheduling policies

Some of these ideas were taken from operations management :)

To measure scheduling policies you'd better have a metric to measure them by.

* "Turnaround time" is the difference in time between when the task arrived and when the task completed.
* "Fairness" is a (more complicated) metric that measures how equally time is divded among processes.
  * Optimizing turnaround time will pessimize fairness, and vice versa. "If you are willing to be unfair, you can run shorter jobs to completion."
* "Response time" is the difference in time between a task's first-run and when the task was scheduled. (How long it takes the computer to start working on this process.)

However, it's not always clear how to minimize these metrics for a set of processes (is it okay to give 10 tasks a short turnaround if it makes 1 task have a long turnaround). One way to combine the metric is to average the turnaround time for all processes.

### FIFO

First in first out. The first task submitted is worked until completion, then the next, then the next. It's simple!

Problem: imagine the first task takes 1 minute and the later tasks take 10 seconds. It would be better to complete the small tasks before working on the large task. This is the "convoy effect" (like when you're on the highway stuck behind a convoy of semi trucks)

### Shortest job first ("SJF")

Sort the jobs by duration and do the shorter ones first.

Problem: How do you know how long a job will take before you start on it? (You just have to estimate.)

Problem: What if you're already working on a job when new, shorter jobs come in? ([Preemption](./timeslicing))

### Shortest time to completion first ("STCF")

* If you've already worked on a task for 10 seconds, subtract 10 seconds from the duration when computing which one is the shortest
* For this to make sense, you need preemption. If you don't have preemption you'd have to finish the task anyway, so the time-to-completion doesn't matter.

### Round robin

This is true [time slicing](./timeslicing). Work on the job for only a small amount of time, context-switch away to other tasks. You switch between them every "scheduling quantum".

* Minimizes the response time, since if a new task arrives you can just toss it in the round-robin cycle.
* *Maximizes* the average turnaround time, since if you have three tasks they will all be completed at around the same time.
  * All "fair" schedulers will maximize turnaround time

Requires far more context switches than other methods. Either context switches should be cheap, or you can increase the duration of each time-slice

### Taking blocking into account

Consider the process states again. If some are *blocked* on a disk/IO/network resource then there is no need to schedule that process. In a round-robin setting, you can take the process out of the round-robin loop while it is blocked.

## Scheduling practicalities

The previous scheduling systems use some sense of "task duration", but we don't actually know how long a process will take when it's submitted. 

We can use a *multi level feedback queue*. ("MLFQ")

* A task is given a priority number. Tasks with higher priorities always run instead of tasks with lower priorities (if two tasks have the same priority they are interleaved together with round-robin)
* Tasks are allowed to willingly *yield* back to the CPU and use less time than they are alloted

Note that "priority number" doesn't have anything to do with niceness levels or the Windows concept of task priority

### Priority adjustment

A simple scheme:

* All new tasks are given the highest prioirity level.
* Tasks are bumped down when they are preempted.
* Tasks are not bumped down when they yield control before being preempted,  and/or enter a blocked state (waiting for something)

Imagine this in relation with the "shortest job first" theoretical strategy. There's no way to tell whether a job will be long or short. So just assume every task is short, and if it runs so long it needs to be preempted a few times, it must be a long task instead (and other short tasks will get higher priorities)

Problems:

* If a truckload of small tasks is dumped onto the system, tasks with lower priorities will *never* get to run.
* Doesn't account for changing behavior. Imagine a graphical program which takes user inputs and also does long-running computations. While the program is taking user input, it's constantly checking the message pump, usually realizing there are no new input events, and quickly yielding back to the CPU. When the program is doing an intensive computation it gets knocked down in priority. But when the process is done, it still has a low priority.

### Better ideas

* Instead of "yielding control to the CPU before the timeslice is up" essentially being a free pass to avoid getting prioirty bumped down, count the total amount of time each process uses.

This fixes the ability to game the system by yielding right before you were about to be preempted

* Occasionally dump all the processes back into the highest priority bucket

They'll settle down to their rightful places again. This improves fairness and accounts for changing behavior.

* Reserve some of the highest priority levels for OS work

Just in case.

* Allow the user to advise the scheduling system

Increase the prioirity of tasks the user deems important

## Fair share scheduling

You can do this lottery-style (each process gets a probability to run on a given timeslice, with more important tasks given higher probabilities) or round-robin style (where you interleave between all tasks in the system, with more important tasks given wider slices).

Actually pretty easy to do lottery with a linked-list of tasks & the total number of tickets in the system. Pick a random number `i` between 0 and the total number of tickets, walk the linked list, and subtract each task's ticket count from `i`. When it goes negative that task is the winner. This is an algorithm for "weighted random choice" basically

Round-robin scheduling is the same idea but deterministic pretty much!

Linux's "niceness" concept is a user-set bonus (or penalty) to the priority level of a process. Allows users to let their favorite processes run more often while still preventing them from starving out other processes.

Linux uses something deemed the "completely fair scheduler" which takes into account the cost of a context switch & always tries to pick the task which has run for the least amount of "virtual time". Virtual time is accrued at different rates depending on the nice level of each process.