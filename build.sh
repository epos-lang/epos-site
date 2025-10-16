#!/usr/bin/env bash
nix build
./result/bin/build
git add docs
