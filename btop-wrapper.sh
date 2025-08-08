#!/bin/bash

# Clear screen and show instructions
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " btop - Go Services Monitor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Filter commands:"
echo "   'f' + 'go-'         → All Go services"
echo "   'f' + 'go-billing'  → Billing API only"
echo "   'Esc'               → Clear filter"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Starting btop in 2 seconds..."
sleep 2

# Launch btop
exec btop