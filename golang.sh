#!/usr/bin/env bash

# Golang related tools
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing newest version of go using homebrew..."
    brew install go
fi

GO=go
echo Installing golang tools...
function go_get_install {
    $GO get $1
    $GO install $1
}
go_get_install "github.com/nsf/gocode"
go_get_install "golang.org/x/tools/cmd/goimports"
go_get_install "github.com/rogpeppe/godef"
go_get_install "golang.org/x/tools/cmd/oracle"
go_get_install "golang.org/x/tools/cmd/gorename"
go_get_install "golang.org/x/tools/cmd/gomvpkg"
go_get_install "golang.org/x/tools/cmd/cover"
go_get_install "github.com/golang/lint/golint"
go_get_install "github.com/kisielk/errcheck"
go_get_install "github.com/jstemmer/gotags"
go_get_install "github.com/tools/godep"
