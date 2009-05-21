From: Tim Connors <tconnors@rather.puzzling.org>
Subject: raid failure and LVM volume group availability
Date: Thu, 21 May 2009 13:07:09 +1000 (EST)
Message-ID: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I had a raid device (with LVM ontop of it) that failed through the disks
being disconnected in a long power failure that outlasted the UPS (the
computer, being a laptop, had its own builtin UPS).

While I could just reboot the computer, I don't particularly want to
reboot it just yet.  Unfortunately, failing a raid device like that means
that the volume group half disappears in a stream of I/O errors, but you
can't stop the raid device because it still has something accessing it
(LVM), but you can't make LVM stop accessing it by making the volume group
unavailable because it is suffering from I/O errors:

> mdadm -S /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?

> vgchange -an
  /dev/md0: read failed after 0 of 4096 at 0: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
  Can't deactivate volume group "500_lacie" with 2 open logical volume(s)
  Can't deactivate volume group "laptop_250gb" with 3 open logical volume(s)

> vgchange -an rotating_backup
  /dev/md0: read failed after 0 of 4096 at 0: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
  /dev/md0: read failed after 0 of 4096 at 1000204664832: Input/output error
  /dev/md0: read failed after 0 of 4096 at 1000204722176: Input/output error
  /dev/md0: read failed after 0 of 4096 at 0: Input/output error
  /dev/md0: read failed after 0 of 4096 at 4096: Input/output error
  /dev/md0: read failed after 0 of 4096 at 0: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 644245028864: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 644245086208: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 4096: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
  Volume group "rotating_backup" not found

The lvm device file still exists,

> ls -lA /dev/rotating_backup /dev/mapper/rotating_backup-rotating_backup
brw-rw---- 1 root disk 254, 5 May 10 09:22 /dev/mapper/rotating_backup-rotating_backup

/dev/rotating_backup:
total 0
lrwxrwxrwx 1 root root 43 May 10 09:22 rotating_backup -> /dev/mapper/rotating_backup-rotating_backup

however lvdisplay, vgdisplay and pvdisplay can't access it:
> vgdisplay
  /dev/md0: read failed after 0 of 4096 at 0: Input/output error
  /dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
  --- Volume group ---
  VG Name               500_lacie
...

but the raid device files don't exist (the drive I plugged back in later
was given a new device name, /dev/sda1) and obviously raid is not very
happy anymore:

> cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc1[0] sdb1[2](F)
      976762432 blocks [2/1] [U_]
      bitmap: 147/233 pages [588KB], 2048KB chunk
> ls -lA /dev/sdc1 /dev/sdb1 /dev/md0
ls: cannot access /dev/sdc1: No such file or directory
ls: cannot access /dev/sdb1: No such file or directory
brw-rw---- 1 root disk 9, 0 May 10 09:22 /dev/md0


Does anyone know a way out of this, sans rebooting?
I don't suspect I could just add /dev/sda1 back into the array because I'm
sure LVM would still complain about IO errors even if raid would let me (I
suspect raid itself will also fail to add the disk back because it is
still trying to be active but has no live disks so would be completely
inconsistent).

Is it possible to force both lvm and md to give up on the device so I can
readd them without rebooting (since they're not going to be anymore
corrupt yet than you'd expect from an unclean shutdown, because there's
been no IO to them yet, so I should just be able to readd them, mount and
resync)?

-- 
TimC
"This company performed an illegal operation but they will not be shut
down."     -- Scott Harshbarger from consumer lobby group on Microsoft
