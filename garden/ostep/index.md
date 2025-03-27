# "Operating Systems: Three Easy Pieces" notes

Honestly I'm not in the mood for studying, but if I can pass it off as "filling out my ✨ *digital garden* ✨" then maybe I'll want to do it!

I'm [reading OSTEP](https://pages.cs.wisc.edu/~remzi/OSTEP/) for an operating systems class ("Systems 2" here at OSU). This is an open access book and apparently it's pretty famous if you can get past the jokes.

(These notes aren't chapter-by-chapter.)

* A main theme of the book is ["virtualization"](./virtualization); the operating system pretending limited physical resources are more plentiful, or fooling programs into believing they have exclusive access over something they don't.
* Virtualization is accomplished with [timeslicing](./timeslicing), [virtual memory](./virtualmemory), and other techniques.
* A [process](./processes) is some task that can have a turn on the CPU.
* The [scheduler](./scheduling) decides which processes get to run when.

Currently left off on chapter 9. I'm [behind the rest of the class](/broken-bone); going to catch up more later.

## Unsorted stuff

Because if i spend time organizing notes instead of taking notes I'll never get anything done. Also I have a headache and homework is due soon.

* On [memory](./memory)

## cond variables

What if i go off and take notes during class on my compoiter instead of my paper notebook

* Cond variables. You can `wait` or `signal/broadcast`.
* If you call `wait` you get added to a list of threads waiting on this variable.
* If you call `signal`, one thread (arbitrarily) from the list is woken up.
* If you call `broadcast` all waiting threads are woken up.

signal and broadcast are ways to tell a thread that some condition *might* be true. Not that it's definitely true.

Also order is really important. If the intention is something like this:

- thread A forks off thread B
- thread A calls `wait`
- thread B finishes and calls `signal` to tell A that it's done

this might happen instead:

- thread A forks off thread B
- thread A gets descheduled, or thread B finishes really fast, and calls `signal` first
- thread A calls `wait` and gets stuck

To fix this, there's two things that work in tandem.

- The condvar isn't the only signal that thread B is done. Thread B might set an "i'm done" variable that thread A can see.
- Mutexes and condvars go hand in hand. `pthread_cond_wait` takes a mutex as argument, and will release the mutex *after* waiting on the condvar.

Thread A:

```
//...fork off thread b...

pthread_mutex_lock(&mutex);
while (!done)
  pthread_cond_wait(&condvar, &mutex); //releases the mutex while waiting
pthread_mutex_unlock(&mutex);
```

Thread B:

```
//...do work...

pthread_mutex_lock(&mutex);
done = true;
pthread_cond_broadcast(&condvar);
pthread_mutex_unlock(&mutex);
```

So now you have something like this

- thread A forks off thread B
- thread A takes the mutex, sees `!done`, registers itself with the condvar and releases the mutex
- thread B runs and finishes, takes the mutex, sets `done`, calls `signal`, and releases the mutex
- thread A takes the mutex, sees `done`, releases the mutex and continues

or if thread B is scheduled quickly:

- thread A forks off thread B
- thread B runs and finishes, takes the mutex, sets `done`, calls `signal` (uselessly) and releases the mutex
- thread A takes the mutex, sees `done`, releases the mutex and continues

*why `while` instead of `if`?* Spurious wakeups. What if `done` can be set back to false by a third thread (or, more realistically, the condition is more complex than a simple `done` boolean)? When you have the mutex you need to check that the condition is still true. I think this is another example of the "condvar shouldn't be the *only* wakeup trigger" principle

Basically where's the "condition" in "condition variable"? It's in the `while` loop that you should always use when waiting on condition variables.

## semaphores

Kind of a lower-level primitive than both locks and condvars. (You can use semaphores to implement both). Apparently this was Dijkastra's idea. (Insert a weird slide glazing Dijkastra.) (Advice: Either use semaphores or use locks+CVs, combining both will lead to a mess.)

It's a counter with some number of "tickets". `wait` takes a ticket, blocking if it took the last ticket, and `post` returns a ticket. Both `wait` and `post` are atomic (two threads cannot take the same ticket).

Sometimes `wait`/`post` are called `down`/`up` -- `down` makes the counter go down and `up` makes it go up. And the "tickets" are just an analogy; you don't need to specifically return the ticket that you received, and you can return tickets before obtaining them.

In practice there's a wait queue kinda like condvars.

### Using it like a mutex

A semaphore starting with one ticket. Then `wait` takes the single ticket (locking) and `post` returns the ticket (unlocking).

### Using it like a condvar

A semaphore starting with zero tickets. Then `wait` makes that thread wait for a ticket to be available (waiting) and `post` allows that thread to run (signalling).

### binary/counting semaphores

Most of the semaphore utility happens when there's a max of one ticket, called a "binary semaphore". If the semaphore can have more than one ticket:

* you can implement like... double-mutexes, allowing a maximum number of threads to enter a critical section
* you can broadcast your condvars (with like, `post(99999)`)