module Ex1 exposing (..)

{- Docs: http://package.elm-lang.org/packages/elm-lang/core/latest
   From JS cheatsheet: http://elm-lang.org/docs/from-javascript

   1. Run the elm REPL in the current folder:
   elm-repl

   2. Then import this module:
   import Ex1

   -- Part 1
   -- Data Types

   3. Try to check what the `x` value is
   x

   4. What is the problem?
      We need fully qualified name:
   Ex1.x

   5. This is too much typing, let's import everything:
   import Ex1 exposing (..)

   You will find further instructions below as inline comments.
-}
-- Ad. 3.


x =
    3



{-
   6. Check values of:
    - c
    - f
    - s
    - ls
    - b
    - t
-}


c =
    'C'


f =
    2.718


s =
    "Elm"


ls =
    [ 1, 2, 3 ]


b =
    True


t =
    ( 3, "Apple" )



{-
   7. In REPL you can assign new value to the variable, but in the real, compiled Elm app - this is not possible!
   Immutability guarantees that everything in Elm, once bound, cannot be changed!

   8. You probably saw, that `t` is a tuple - it consists of 2 or more values of possibly different types.
   This comes handy, whenever function needs to return many values. We'll get into functions in a minute.
-}


t2 =
    ( False, "Finish homework", ( "why", "not" ) )



{-
   9. If you know how objects work in JavaScript, then Elm's records serve the same purpose - to represent the set of named properties of different types in one data structure.
      Here is the example of product record, type `p`:
   p

   10. You can define alias for record using `type alias` keywords (just take a look below).
-}


p =
    { id = 1
    , name = "Orange"
    }



-- 10.


type alias Product =
    { id : Int
    , name : String
    }



{-
   alias name of the record (in our case this is a `Product`) is also a - so called - data constructor.
   It means that its name is a function which, given arguments which stand for record's properties, returns the record (order does matter!)
-}


productFromConstructor =
    Product 7 "T-Shirt"



{-
   There is also a mechanism for getting values of properties of records using dot and name of the function, like this:
   .name anyProductCreated
-}


tShirtName =
    .name productFromConstructor



{-
    Function applications below will not work!
    Be careful: when the type of arguments is the same, it is easy to pass the in the wrong order!
    badProduct = Product "Name" 6

   The line below with colon is called `type annotation` - it annotates p2 as a Product
   This is a good practice to annotate all expressions in our program, even though Elm is smart enough to 'guess' types
   This is called `type inference` - the compiler will figure out types on its own
-}


p2 : Product
p2 =
    { id = 2
    , name = "Plum"
    }



{-
   11. FUNCTIONS
       The idea of a function is very simple - it takes input and returns output - always.

       Check out functions below (yes! verify that in REPL, please):

       boring
       boring 5
       boring c
-}
-- Type annotations for functions use arrows: ->
-- It means that what is on the left side of the arrow is an input (argument)
-- what is on the right hand side of the arrow is an output (result)


boring : a -> String
boring a =
    "boring"



{-
   12. If you need to pass nothing, to function, you can use so called `unit`: ()
       Unit is a type and a value itself.
       Experiment: what does happen when you apply an argument of different type to function which expects unit??

       getLuckyNumber
       getLuckyNumber ()
-}


getLuckyNumber : () -> Int
getLuckyNumber _ =
    7



{-
   13. All functions in elm get one argument and return one result (I swear this is true!):

       add
       add 1
       add 1 3

-}


add x y =
    x + y



{-
   14. As you saw earlier, you can partially apply function and it reutrns another function.

       increment = add 1
       increment
       increment 4

       n = 9
       increment n
       n -- do you remember about immutability??
-}


increment =
    add 1


n =
    9



{-
   15. let ... in ... expression
       It allows you to prepare some locally scoped variables to be used in some expression later (example below)
       Check what is the value of calculation?
       What is the value of x?
       Did let expression changed value of the x from the beginning of the file?
-}


calculation =
    let
        x =
            3 * 2

        y =
            -4 / 2
    in
        increment (x + y)



{-
   16. We can pass records as arguments.
       Remember, that Product is just an alias for the record with `id` and `name` properties!
       getName
       getName p
       getName p2
-}


getName r =
    r.name



{-
   17. We can specify properties we do care about, inline, as function arguments - it uses `pattern matching` mechanism
   getBetterName
   getBetterName p
   getBetterName p2
-}


getBetterName { name } =
    name



{-
   18. We can also uses properties names prefixed with `.` to get record's property value:
       .name
       .name p
       .name p2

       Elm creates it for free for us!
-}
{-
   19. Elm is smart enough to generalize types; that is why .name has type:
   <function> : { b | name : a } -> a
   It means that some record 'b' has a property 'name' of whatever type.
   `a` is a type variable and it means it can be any type (this is called parametric polimorphism)
   Try to cheat Elm:
   .name p
   .name named1

   .name


-}


type alias Named =
    { name : Char }


named1 =
    { name = 'C' }


named2 =
    { name = 'S' }



{-
   20. How to update a record? It is not possible to modify the record, but the new one with updated property(ies) can be obtained using special syntax:
   { p | name = "Mango" }

       Ensure that p is not modified at all!
       Try to obtain p2 with the name property set to your favourite fruit!

-}


mf =
    { p | id = 7, name = "Mango" }


myFavouriteFruit =
    { p2 | name = "Watermelon" }



{-
   21. Time for lists!
       If you want to store multiple elements together use list - they must be the same type!!
       Define your own list of characters B, S and F

-}


nums =
    [ 1, 2, 3 ]


names =
    [ "Bob", "Sam", "Frodo" ]


chars =
    [ 'B', 'S', 'F' ]



{-
   22. There is also another way to define function in Elm which is useful when working with functions from List module.
       Small inline functions are called `lambdas`:
       inc = \x -> x + 1

       Define you function 'mul' which multiplies arguments by 2
-}


inc =
    \x -> x + 1


mul =
    \x -> x * 2



{-
   23. Finally, in Elm, there is a rescue from null value, which is called Maybe (like in the song: call me maybe ;))
       There are two possibilities:
       - there is a value: Just "my value"
       - or there is no value: Nothing
-}


thereIs =
    Just "my value"


empty =
    Nothing



{-
   24. What if we want to write conditional code? Of course we can using different thechniques, let's start with 'if else' expression
-}


isAdult x =
    if x >= 18 then
        True
    else
        False



{-
   25. You can achieve similar effect using case expression:
-}


isAdult2 x =
    case x >= 18 of
        True ->
            "Adult"

        False ->
            "Child"



{-
   26.
       Write a function which accepts Maybe
       If there is a value, return string representation of that value (use `toString` built in function)
       If there is nothing, return string "Empty"
       Test it for values: (Just 3), (Just True), Nothing, (Just 99.9)
       Note: you can write this function below, and whenever you save the file - it will be instantly available in repl to be run.
       How cool is that?!
-}


maybe2str : Maybe a -> String
maybe2str x =
    case x of
        Just v ->
            toString v

        Nothing ->
            "Empty"



{-
   27. Higher order functions are functions which either accept another function as an input and/or return function as an output.
       Write function which accepts transformation function (for example increment) and Maybe.
       If there is `Just x`, apply transformation function to `x`
       If there is `Nothing`, return `0`
       Bonus - change the transformation function to inline lambda function
       Bonus 2 - instead of lambda use built-in operator - for example for addition or subtraction, etc.
-}


transformMeMaybe : (a -> Int) -> Maybe a -> Int
transformMeMaybe f x =
    case x of
        Just v ->
            f v

        Nothing ->
            0
