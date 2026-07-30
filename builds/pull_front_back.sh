#!/bin/sh
# Requirements: git
# Maintainer: Fran
echo "============= Pull Taiga Front ============="
git -C ../../taiga-front pull
echo "============= Pull Taiga Back =============="
git -C ../../taiga-back pull
