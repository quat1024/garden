# Styling forms
```{=html}
<style>body:has(#labelbg:checked){--labelbg:rgba(100,0,0,0.1)}label{background-color:var(--labelbg, transparent)}</style>
<form>
<input type=checkbox id=labelbg checked=true>
<label for=labelbg>Show <code>&lt;label&gt;</code> clickboxes</label>
</form>
```

There's a lot of resources floating around about styling form *controls* -- I like [Adrian Roselli's 'underengineered' posts](https://adrianroselli.com/2023/05/under-engineered-patterns-for-wcbuf.html) -- but I wanted to write down how to actually *lay out* the form.

Most form controls are inline elements, so the "default" is to create single-line forms. Sometimes this is fine, such as the checkbox above. Other times it is less fine:

```
<label for=name>Name</label><input type=text id=name>
<label for=email>Email</label><input type=text id=email>
<label for=password>Password</label><input type=password id=password>
<button>Sign up</button>
```

> ```{=html}
> <label for=name1>User name</label><input type=text id=name1>
> <label for=email1>Email</label><input type=text id=email1>
> <label for=password1>Password</label><input type=password id=password1>
> <button>Sign up</button>
> ```

You can slap each group of fields in a block-level container, but now you have an ugly ragged form, and the controls butt up against the label.

```
<p><label for=name>User name</label><input type=text id=name></p>
<p><label for=email>Email</label><input type=text id=email></p>
<p><label for=password>Password</label><input type=password id=password></p>
<p><button>Sign up</button></p>
```

> ```{=html}
> <p><label for=name2>User name</label><input type=text id=name2></p>
> <p><label for=email2>Email</label><input type=text id=email2></p>
> <p><label for=password2>Password</label><input type=password id=password2></p>
> <p><button>Sign up</button></p>
> ```

## Labels above controls

You can solve both problems by simply forcing linebreaks with `label { display: block; }`. Of course this changes the layout of the form.

```
label {
  display: block;
}

<div>
<p><label for=name>User name</label><input type=text id=name></p>
<p><label for=email>Email</label><input type=text id=email></p>
<p><label for=password>Password</label><input type=password id=password></p>
<p><button>Sign up</button></p>
</div>
```

> ```{=html}
> <style>#b label{display:block}</style>
> <div id=b>
> <p><label for=name4>User name</label><input type=text id=name4></p>
> <p><label for=email4>Email</label><input type=text id=email4></p>
> <p><label for=password4>Password</label><input type=password id=password4></p>
> <p><button>Sign up</button></p>
> </div>
> ```

The block-level element stretches to the width of the container, which gives it a strange clickbox. There are ways around this, like assigning `display: block` to a wrapper element and letting that grow instead of to the label itself. Maybe a single-column grid or flexbox. TODO.

## Labels beside controls

You can do it with a table, but... let's not.

> ```{=html}
> <style>
> table#a td:first-child {
>   text-align:right;
> }
> </style>
> 
> <table id=a>
> <tr><td><label for=name3>User name</label></td><td><input type=text id=name3></td></tr>
> <tr><td><label for=email3>Email</label></td><td><input type=text id=email3></td></tr>
> <tr><td><label for=password3>Password</label></td><td><input type=password id=password3></td><tr>
> <tr><td></td><td><button>Sign up</button></td></tr>
> </table>
> ```

You can also do it with a grid. Here, `grid-template-columns: max-content max-content` creates two columns with the width of the widest element inside each column, much like a `<table>` would. Unlike a table, you get much better accessibilty characteristics out of the box, tidier HTML, and can easily make it single-column (or even `display: block`ing everything) on a smaller screen.

I'm using a spacer div to kick the `<button>` into the second column. For a non-toy example it would be better to use an explicit `grid-column`.

Using `justify-self` on the `<button>` prevents the grid from stretching it to the width of its column. `text-align` is used on the `<label>`s, instead of `justify-self`, because this time I want the grid to stretch their clickbox.

```
form {
  display: grid;
  grid-template-columns: max-content max-content;
  gap: 5px 15px;
}

button {
  justify-self: start;
}

label {
  text-align: right;
}

<form>
  <label for=name>User name</label>
  <input type=text id=name>
  <label for=email>Email</label>
  <input type=text id=email>
  <label for=password>Password</label>
  <input type=password id=password>
  <div></div>
  <button>Sign up</button>
</form>
```

> ```{=html}
> <style>
> form#d {
>   display: grid;
>   grid-template-columns: max-content max-content;
>   gap: 15px 5px;
> } form#d label { text-align: right}
> form#d button{justify-self: start}
> </style>
> 
> <form id=d action="javascript:void(0);">
>   <label for=name6>User name</label><input type=text id=name6 autocomplete=off>
>   <label for=email6>Email</label><input type=text id=email6 autocomplete=off>
>   <label for=password6>Password</label><input type=password id=password6 autocomplete=off>
>   <div></div><button>Sign up</button>
> </form>
> ```

How about this: Only set `row-gap` in the grid, and instead create the gap with the `padding-right` of the `<label>`s. This closes up the clickbox.

> ```{=html}
> <style>
> form#e {
>   display: grid;
>   grid-template-columns: max-content max-content;
>   row-gap: 15px;
> } form#e label { text-align: right; padding-right:5px}
> form#e button{justify-self: start}
> </style>
> 
> <form id=e action="javascript:void(0);">
>   <label for=name7>User name</label><input type=text id=name7 autocomplete=off>
>   <label for=email7>Email</label><input type=text id=email7 autocomplete=off>
>   <label for=password7>Password</label><input type=password id=password7 autocomplete=off>
>   <div></div><button>Sign up</button>
> </form>
> ```

As always when using CSS grid, make sure to test for overflow. Grid is very rigid. Consider `minmax()`, `fit-content()`.

> ```{=html}
> <style>
> form#f {
>   display: grid;
>   grid-template-columns: max-content max-content;
>   gap: 15px 5px;
>   max-width: 300px;
>   margin: 0 auto;
>   border: 2px solid red;
>   overflow: hidden;
> } form#f label { text-align: right}
> form#f button{justify-self: start}
> </style>
> 
> <form id=f action="javascript:void(0);">
>   <label for=name8>User name</label><input type=text id=name8 autocomplete=off>
>   <label for=email8>Email</label><input type=text id=email8 autocomplete=off>
>   <label for=password8>My complicated form control</label><input type=password id=password8 autocomplete=off>
>   <div></div><button>Sign up</button>
> </form>
> ```