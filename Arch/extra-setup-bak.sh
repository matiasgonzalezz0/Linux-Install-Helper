#!/bin/bash

# Does extra setup to some of the packages installed before
# In this case, because of the $ZSH_CUSTOM variable, the script must be executed like this:
# . ./extra_setup.sh (Notice the extra dot)


# Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "Done!"
