# Package
version       = "0.1.0"
author        = "Manguluka Kakia"
packageName   = "duktape"
description   = "wrapper for the Duktape embeddable Javascript engine"
license       = "MIT"

# Dependencies

requires "nimgen >= 0.1.4"

skipDirs = @["tests","src"]
installDirs = @["duktape"]

var cmd = ""

task setup, "Download and generate":
    #exec cmd & "/bin/cp -r duktape/duktape-2.3.0/src/* duktape/src && nimgen nim_duktape.cfg"
    exec cmd & "nimgen duktape.cfg"

before install:
    setupTask()

task test, "Test duktape":
    exec "nim c -r tests/basic_eval.nim"
    exec "nim c -r tests/bind_proc.nim"
