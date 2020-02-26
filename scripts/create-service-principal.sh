#!/bin/bash

az ad sp create-for-rbac \
    --skip-assignment \
    -o json