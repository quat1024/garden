# The wrong abstraction

## Scheduling application

In dealing with [my injury](/broken-bone) I have had the pleasure of using a web application for scheduling one-off paratransit. At the bottom of the login page, it says "Assistive technology users may have trouble using this application; please call 1-xxx-xxx-xxxx for assistance".

The transit scheduling program is a simple web form where you enter times, dates, and addresses to get picked up and dropped off. How do you write an application like that that doesn't function with screen readers? Moreover how do you write an *accessibility* program without testing its accessibility properties?

There have been HTML forms since *the beginning of time.*

## Outlook reloads the page as a failsafe

I have also had the pleasure of interacting with Microsoft Outlook's web interface. Outlook, when rendering an inline attachment that I did not need to view and I did not want it to render a preview of, apparently throws some kind of exception. Outlook's error handler is, apparently, refreshing the entire page.

The solution was writing

```js
window.onbeforeunload = () => "no"
```

in the JS console. This made the brower open its "are you sure you want to navigate away" dialog when Outlook attempted to reload the page. I dismissed the dialog.

The rest of the application functioned perfectly fine. I even disabled µBlock for you guys, like your troubleshooting page said, and that didn't fix it. Only hacking at shit in the console worked.

I mean, not like it was an *important* email or anything. Not like if I was less technically inclined, Outlook auto-refreshing ten seconds after opening a critical email would have prevented me from talking with disability services to schedule a trip to class. No, no. 

## If you'll excuse a small rant

Dear frontend developers. I hear endless talk about how sluggish frontend frameworks are good tradeoffs: Let's accept the costs because the benefits of "faster iteration" are worth it. No, no, it's fine because web applications are so much easier to write than they used to be.

The fruits of these wondrous developments in the frontend world is clear: Programs that do not work, and programs that are nearly unusably slow when they do work.

Go fuck yourself.

## The wrong abstraction

I firmly, blithely, naively believe that software complexity exists because we're not looking through the right lens. If piling heaps of Javascript garbage onto people's computers is the only way we've found to manage the complexity of web applications, then I believe we are looking in the wrong place. We are using the wrong abstraction.