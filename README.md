Installs nexmon on Raspberry Pi 3 Model B

to run installer:   
`bash pimon.sh`

to run nexutil:  
`sudo su`
`nexutil`

to run after reboot:  
get to nexmon/patches/bcm43438/7_45_41_26/nexmon  
`sudo su`
`rmmod brcmfmac` # removes regular broadcom driver module  
`insmod brcmfmac/brcmfmac.ko` # installs new driver module  
`nexutil -m2` # places WiFi into monitor mode  

to revert back to managed mode and use regular wifi:  
get to the same folder as above  
`rmmod brcmfmac/brcmfmac.ko`  
`modprobe brcmfmac`  
`exit` # exits su  

