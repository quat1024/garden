# Linux

I should have done this sooner. Windows 10 support ending is probably a good time as any.

I *thought* I liked computer-tinkering but kept bouncing off the nerd linux distros because they needed too much tinkering. So I went for Linux Mint as something more complete out-of-the-box.

## Shrinking the Windows partition

> n.b. I'm going with dualboot for now in case Linux doesn't work out or in case I need to use Windows-only software (the school semester is starting soon). This isn't an ideal setup because if I decide to fully use Linux, the linux partition will be located on the second half of the disk and I can't extend it backwards (...right?). Part of why I'm obsessively writing down everything is so that, in case I need to reinstall Linux, I will know what I did to the system.

I deleted a bunch of old files. I use scoop package manager, so `scoop cleanup *` removed old versions of programs. Also installed wiztree and looked around for any large files I forgot about, which prompted me to uninstall some games I haven't played in a while. In total my Windows install consumes about 310gb off the 1tb SSD this laptop has, and that includes some goodies like the hibernation file and (incidentally) the Mint installer iso.

Windows loves to put non-movable files at the end of its partitions so you can't shrink them. I had to disable and delete restore points (search "restore point" in start menu -> System Protection tab -> Configure -> Disable System Protection, and press Delete to remove the existing files) before Disk Management would allow shrinking the Windows partition. They can be turned back on after shrinking the partition, but tbh I've never used a restore point before.

In all, my system ssd had:

* 500mb unallocated space at the start (hm?)
* 500mb EFI System Partition
* 942.7gb allocated to Windows, showing as C
* A 9gb mystery partition
* A 1.06gb mystery partition
* 10mb unallocated space at the end

Some of the unallocated space *might* be slack to keep an SDD happy?

I went ahead and deleted the mystery partitions. Now that I think about it, might have been OEM factory troubleshooting stuff? Oh well. I've also heard that leaving some unallocated space on an SSD can make them happier but I've also heard that's an urban legend.

The new plan:

* leave the unallocated start space & the EFI system partition intact
* shrink Windows to 500gb
* allocate the rest to linux

You can't create linux filesystem partitions in Windows Disk Management, so I'm off to reboot into the Mint installer.