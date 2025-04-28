#!/bin/sh
git submodule foreach "git pull origin stable || git pull origin main || git pull origin master"
