#!/usr/bin/env bash

while(1 -eq 1 )
	{Get-Process -Name chrome | Select-Object -ExpandProperty ID | ForEach-Object {Get-NetTCPConnection -OwningProcess $_} -ErrorAction SilentlyContinue }
done
