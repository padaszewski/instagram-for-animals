#!/bin/sh
docker build -t nicbet/phoenix:1.5.1 .
./mix ecto.create
./mix ecto.migrate