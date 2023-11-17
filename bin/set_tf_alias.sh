#!/bin/bash

# Set the alias
ALIAS_NAME="tf"
ALIAS_COMMAND="terraform"

# Check if alias already exists
if grep -q "alias $ALIAS_NAME=" ~/.bash_profile; then
    echo "Alias '$ALIAS_NAME' already exists in ~/.bash_profile."
else
    # Append alias definition to .bash_profile
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> ~/.bash_profile
    echo "Alias added to ~/.bash_profile."
    # Apply changes to the current session
    source ~/.bash_profile
fi