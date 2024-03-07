Start-Process reg -ArgumentList "import ./machine.reg" -Wait
Start-Process regedit -ArgumentList '/s', join-path $BaseDir '\online\machine.reg'
regedit /s (join-path $BaseDir '\online\machine.reg')
#Start-Process reg -ArgumentList "import ./user.reg" -Wait