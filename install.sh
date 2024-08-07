#!/usr/bin/env bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install go using xbps-install
install_go_xbps() {
    if command_exists xbps-install; then
        echo "Installing go using xbps-install..."
        sudo xbps-install -S go
        echo "go installed successfully."
    else
        echo "xbps-install is not available. Please install go manually."
        exit 1
    fi
}

# Function to install gum using go
install_gum_go() {
    if command_exists go; then
        echo "Installing gum using go..."
        go install github.com/charmbracelet/gum@latest
        echo "gum installed successfully."
    else
        echo "Hmm. Go is not installed."
        while true; do
            echo "Would you like to install go using xbps-install? (y/n)"
            read -r install_go

            if [ "$install_go" = "y" ]; then
                install_go_xbps
                # Try to install gum again after installing go
                if command_exists go; then
                    echo "Installing gum using go..."
                    go install github.com/charmbracelet/gum@latest
                    echo "gum installed successfully."
                    break
                else
                    echo "Failed to install go. Please install go manually and try again."
                    exit 1
                fi
            elif [ "$install_go" = "n" ]; then
                return 1
            else
                echo "Invalid choice. Please enter 'y' or 'n'."
            fi
        done
    fi
}

# Function to install gum using xbps-install
install_gum_xbps() {
    if command_exists xbps-install; then
        echo "Installing gum using xbps-install..."
        sudo xbps-install -S gum
        echo "gum installed successfully."
    else
        echo "xbps-install is not available. Please install gum manually."
        exit 1
    fi
}

# Function to install gum
install_gum() {
    while true; do
        echo "Choose how to install gum:"
        echo ""
        echo "1) Install using go"
        echo "2) Install using xbps-install"
        read -r choice

        case $choice in
            1)
                if install_gum_go; then
                    break
                fi
                ;;
            2)
                install_gum_xbps
                break
                ;;
            *)
                echo "Invalid choice. Please enter '1' or '2'."
                ;;
        esac
    done
}

# Function to add a directory to PATH in ~/.bashrc
add_to_path() {
    local dir=$1
    local file="$HOME/.bashrc"

    if ! grep -q "$dir" "$file"; then
        echo "Adding $dir to PATH in $file"
        echo "export PATH=\"$dir:\$PATH\"" >> "$file"
    fi
}

# Function to prompt the user to update ~/.bashrc
update_bashrc() {
    while true; do
        echo "Do you want to update your ~/.bashrc file to include the new paths in PATH? (y/n)"
        read -r update_bashrc

        case $update_bashrc in
            y)
                if [ "$install_location" = "$HOME/.local/bin" ]; then
                    add_to_path "$HOME/.local/bin"
                fi

                if command_exists go; then
                    local go_bin=$(go env GOPATH)/bin
                    add_to_path "$go_bin"
                fi

                echo "The ~/.bashrc file has been updated. Please restart your terminal or run 'source ~/.bashrc' for changes to take effect."
                break
                ;;
            n)
                echo "No changes were made to ~/.bashrc."
                break
                ;;
            *)
                echo "Invalid choice. Please enter 'y' or 'n'."
                ;;
        esac
    done
}

# Saves screen so we can return to the previous screen later.
savescreen() {
  printf '\e[?1049h'
}

# Restores previous screen
restorescreen() {
  printf '\e[?1049l'
}

savescreen

cat xbpsman.txt
printf '\e[8;30r'
printf '\e[9H'

printf "Hi there! xbpsman is a script I wrote to make it a little easier for you to manage
packages on Void Linux. While I certainly think one should learn how to use xbps-install,
xbps-remove, xbps-query, and other xbps tools on Void Linux, I understand some people 
might have issues with that. In the meantime while they learn, I feel this is a great
alternative. ~ Michael Williams/Fearless Geek Media."

printf "Charm gum is a required package. So first, let's check to see if you have that
installed on your system."

sleep 3

# Check if gum is installed
if ! command_exists gum; then
    echo "Well, gum isn't installed. Let's do that quickly!"
    install_gum
fi

# Prompt the user for installation location
while true; do
    echo ""
    echo "Where would you like to install xbpsman?"
    echo ""
    echo "1) /usr/local/bin"
    echo "2) ~/.local/bin"
    read -r location_choice

    case $location_choice in
        1)
            install_location="/usr/local/bin"
            break
            ;;
        2)
            install_location="$HOME/.local/bin"
            break
            ;;
        *)
            echo "Invalid choice. Please enter '1' or '2'."
            ;;
    esac
done

# Create the installation directory if it does not exist
mkdir -p "$install_location"

# Path to the xbpsman script
xbpsman_script_path="$(dirname "$(realpath "$0")")/xbpsman"

# Copy the xbpsman script to the chosen location
if [ "$install_location" = "/usr/local/bin" ]; then
    echo "Installing xbpsman to $install_location..."
    sudo cp "$xbpsman_script_path" "$install_location/xbpsman"
    sudo chmod +x "$install_location/xbpsman"
else
    echo "Installing xbpsman to $install_location..."
    cp "$xbpsman_script_path" "$install_location/xbpsman"
    chmod +x "$install_location/xbpsman"
fi

echo "xbpsman installed successfully to $install_location."

# Update ~/.bashrc if necessary
if [ "$install_location" = "$HOME/.local/bin" ] || command_exists go; then
    update_bashrc
fi

echo "Press any key to continue."
read -n1
printf '\e[;r'
restorescreen
