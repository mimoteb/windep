# Load configuration from a separate file
. .\config.ps1

# Dismount the Windows image and discard changes
Dismount-WindowsImage -Path $mount -Discard
# This command dismounts the Windows image located at the specified path ($mount).
# The -Discard parameter ensures that any changes made to the mounted image are not saved.

# Check if the WIM file exists
if (Test-Path $wim) {
    # If the WIM file exists, it means the image was successfully captured.
    # In this case, we can remove the temporary mount directory.

    # Remove the temporary mount directory
    Remove-Item -Path $mount -Force
    # This command deletes the temporary mount directory ($mount) where the Windows image was mounted.
    # The -Force parameter ensures that the directory is deleted even if it contains files.
} else {
    # If the WIM file doesn't exist, there might have been an issue capturing the image,
    # so we don't attempt to remove the mount directory.
}
