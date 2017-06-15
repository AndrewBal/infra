#!/bin/bash

deis limits:set web=300M/600M -a bedrock-prod
deis limits:set web=250m/1000m --cpu -a bedrock-prod
deis autoscale:set web --min=5 --max=20 --cpu-percent=80 -a bedrock-prod

deis limits:set web=300M/600M -a bedrock-stage
deis limits:set web=250m/1000m --cpu -a bedrock-stage
deis autoscale:set web --min=5 --max=20 --cpu-percent=80 -a bedrock-stage

deis limits:set web=120M/300M -a bedrock-dev
deis limits:set web=250m/500m --cpu  -a bedrock-dev
deis autoscale:set web --min=3 --max=5 --cpu-percent=80 -a bedrock-dev
