## Compatibility shims for callback signatures.
##
## Some downstream code wants to use correctly-typed callback imports even when
## older generated bindings used looser types (e.g. `void*` contexts or
## non-const strings).  This module provides small helpers while keeping the
## main `duktape_sys` API surface unchanged.

import ./duktape_sys

type
  cstringConst* {.importc: "const char *", nodecl.} = cstring

  ## Duktape's `duk_context` is a typedef to `struct duk_hthread`.
  DukHThread* {.importc: "struct duk_hthread", header: "duktape.h",
               incompleteStruct.} = object
  DukContextPtr* = ptr DukHThread

  DukAllocFunction* = proc(udata: pointer; size: duk_size_t): pointer {.cdecl.}
  DukReallocFunction* = proc(udata: pointer; mem: pointer; size: duk_size_t): pointer {.cdecl.}
  DukFreeFunction* = proc(udata: pointer; mem: pointer) {.cdecl.}
  DukFatalFunction* = proc(udata: pointer; msg: cstringConst) {.cdecl.}
  DukCFunction* = proc(ctx: DukContextPtr): duk_ret_t {.cdecl.}

proc duk_create_heap_compat*(
  allocFunc: DukAllocFunction,
  reallocFunc: DukReallocFunction,
  freeFunc: DukFreeFunction,
  heapUdata: pointer,
  fatalHandler: DukFatalFunction
): DukContextPtr {.importc: "duk_create_heap", header: "duktape.h".}

proc duk_push_c_function_compat*(ctx: DukContextPtr; fn: DukCFunction; nargs: cint): cint {.
  importc: "duk_push_c_function", header: "duktape.h".}

template asCompatCtx*(ctx: DTContext): DukContextPtr =
  cast[DukContextPtr](ctx)

template asDTContext*(ctx: DukContextPtr): DTContext =
  cast[DTContext](ctx)
