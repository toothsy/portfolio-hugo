+++
date = '2025-03-29T17:17:21+05:30'
draft = false
title = 'Golang Defer'
pin = true
tags = ["golang","closure","defer"]
+++

# Defer And Closure in Go-lang

![Defer and Closure](https://miro.medium.com/0*bzYROhQxguUiBqgn)

Hello, fellow internet user, before we begin, this article assumes you have the following pre-requisites:

- You know about functions in Go
- Have an understanding of the local and global scope
- Have your VS Code setup for Go-lang, because it'll be a delightful experience with autocomplete, linting, and auto-imports
With that out of the way, onto the main issue at hand, young padawan.
<!--more-->
## Just what is defer all about?

Just so we're on the same page, you **always** use the `defer` keyword on a function call. Now, what `defer` means is that the execution of the deferred function is delayed till the end of the surrounding function.

![Defer Example](https://miro.medium.com/0*-FL_wSmKZokdvXVK)

- In the code above, the deferred function is `fmt.Println("Two")`, so this function will execute once the surrounding function is done executing. In our case, it was simply to print `fmt.Println("Three")`. Once that is over, the deferred function is executed.
- One thing to note is that if you have multiple `defer` keywords in a single function, they will be executed in **First In Last Out (FILO)** order, in simple words, the reverse order in which they were deferred.
- Let's go a little crazy for a second and add `defer` keyword to everything you see. Try predicting the output.

![Multiple Defer Example](https://miro.medium.com/0*zk2MHqy6N9zf9ZvS)

- In the code above, since everything is deferred, nothing is executed till the control reaches line 8. As `fmt.Println("Four")` is the last function to be deferred, it is executed first. In other words, it doesn't make much difference if you want to defer a function just before the surrounding function ends.
- Since `fmt.Println("One")` was first to be deferred, it was executed last.
- **Things to note:** The **deferred function belongs to the surrounding function** and **not the block scope**. So, if you deferred a function in an `if` block or a `for` loop, the deferred function will always execute after the surrounding function ends, not before the loop or if statement.

## Okay, but what if I wanted to return something from a deferred function?

- Well, you can't do it. Your function needs to be the kind that returns nothing, or you can have a return and choose to defer it, but you'll have to ignore the return value.
- However, Go has this feature called [named return](https://go.dev/tour/basics/7), which makes things a little interesting.

![Named Return Example](https://miro.medium.com/0*33WkfCzsP6fs38qK)

- In the line above, when the function is created, `returnVal` is 0. We're deferring the anonymous function, so we jump to line 15. There, `returnVal` becomes -1. Finally, our function is fired, and we overwrite `returnVal` as 1000 and return that value.

## Okay, now for closures

- Closures are function values that reference variables residing outside of the function in question.
- This piece of code is shamelessly stolen from the Go [docs](https://go.dev/tour/moretypes/25) because it is actually that effective to understand.

![Closure Example](https://miro.medium.com/0*cmU6WpPNwkt7jWBA)

- **Things to note:** Despite having `sum` defined outside the scope of the anonymous return function, the `sum` variable is tied along with it, with a different copy every time `adder()` is called.
- Here, since each instance of the anonymous function (which happens to be `pos(i int)` and `neg(i int)`) can be called with a different parameter, they both have their own `sum` variable under the hood, allowing them to have different outputs as shown.

## Let's mix things up

- It gets more interesting when you defer an anonymous function in a loop. As the function loses its meaning outside the scope of the loop, the compiler has to keep track of the deferred function calls in different ways. Have a look below.

![Defer in Loop Example](https://miro.medium.com/0*sStVU_ZKRd9CYZtV)

- Here, VS Code shows that the **variable** `index` will be captured. That is to say, the address space `index` is referring to will be tied to the function. That is why in the output, we see that `captured index is 4` is printed 4 times—this is due to the closure concept.
- But in the other loop (line 17), we store the **value** that `index` holds along with the function, as dictated by the [Go Spec](https://go.dev/ref/spec#Defer_statements):

> *Each time a "defer" statement executes, the function value and parameters to the call are evaluated as usual and saved anew, but the actual function is not invoked.*

Hope you learned something from this article! If there are any incorrect assumptions made on my behalf, please do tell 😊. Nothing would delight me more than dispelling my inaccurate understandings.

Meanwhile, here are some resources that helped me write this article:

- [Another cool article on defer](https://blog.learngoprogramming.com/gotchas-of-defer-in-go-1-8d070894cb01)
- [This Y Combinator discussion was quite insightful](https://news.ycombinator.com/item?id=14668955)
- I may or may not have taken things from this [Stack Overflow question](https://stackoverflow.com/questions/16010694/how-golangs-defer-capture-closures-parameter)

Thanks for reading and hope you have a great day 😁
