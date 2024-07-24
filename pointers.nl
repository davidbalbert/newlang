// pointers
var x *int          // A pointer. Panics on nil dereference. Can be passed to C. Is it auto-coerced
                    // into an (unsafe *int)? Do C function arguments take *int instead of (unsafe *int).
                    // What about return values from C functions? If all a pointer provides is panic on
                    // nil dereference, then is there a need for (unsafe *int). For the sketch of `free`
                    // below, are we creating an (unsafe *int) or are we doing an unsafe cast?
var x (unsafe *int) // a C pointer (are parens required?). See notes above for whether this is actually
                    // required.
var x #*int         // A refcounted pointer? Alts: #int, (ref *int), (counted *int), (strong *int).
var x (weak *int)   // A weak pointer. Can only be derived from a refcounted pointer.
var x !*int         // An owned pointer. Move only. Alt: (nocopy *int), (owned *int), &int, &*int.

// What about mutable vs immutable references a la Rust? That would imply single writer multi reader.
// Is that what we want?


// optionals
var x ?int  // An optional int. nilable. Not representable in C. Could we have autogenerated C structs
            // to represent this? optint? What's the ABI here?
var x ?*int // An optional pointer to an int. nilable. Can be passed to C.

// int is non-optional. It's guaranteed to be non-nil. What's the equivalent for pointers? It can't just
// be *int, because those can also be nil. Perhaps this means we shouldn't have ?*int. We could either
// allow some sort of pattern matching on *int, or we could have a separate type for non-nil pointers.
// This is another annoying asymetry in the current sketch.

// x is move only, so we need to call free to clean it up. Free consumes the pointer
// and then does an unsafe cast to get rid of its "owned-ness". This is the consume
// operation.
//
// What is p? Is it an unsafe pointer? Or are we performing an unsafe operation on a pointer.
//
// I feel like it might be the latter. If C functions can take and return normal (non-unsafe) pointers,
// which are just nil-checked in Newlang land, then as far as I can tell there's no need for (unsafe *int).
// Just an unsafe cast that consumes the pointer.
func free(x : !*int) {
    p = (unsafe *void) x;
    // add p to freelist
}

// conversions

*int -> !*int // consumes the original pointer. Alt: maybe you can't do this conversion at all.
*int -> #*int // consumes the original pointer.

// unsafe conversions
!*int -> *int
(weak *int) -> *int // Do we actually need weak pointers? The refcounting machinery could just nil out normal
                    // pointers, and using normal pointers would be how you break a reference cycle. If we do
                    // need weak pointers, then this should definitely be unsafe.

#*int -> *int       // Re: the above. Could this just be the safe way to create a weak reference? That would
                    // have some gross asymetry. *int -> #*int consumes the original, but #*int -> *int leaves
                    // the original in place.


// noncopy operators

// move, take, consume, drop, eat!?
// moving, taking, consuming, dropping, eating!?

// borrow - is there a pointer type that would work for this
// inout -- ditto

// Lifetimes:
// Rust says the lifetime of foo<'a> can't outlive the lifetime of 'a.
// What if instead foo<'a> extends the lifetime of 'a? E.g. 'a can't be
// dropped until foo<'a> is dropped. Are these the same thing?
