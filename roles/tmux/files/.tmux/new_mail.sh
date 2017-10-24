#!/bin/bash

count=$(ls ~/.mail/meviccuadme/INBOX/new | wc -l)

if [[ -n "$count"  && "$count" -gt 0 ]]; then
    echo "${count}✉"
fi
