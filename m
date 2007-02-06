From: "Toni L. Harbaugh-Blackford [Contr]" <harbaugh@ncifcrf.gov>
Subject: no /sys/block/sd%/device/bus file in 2.6.20-rc7 causing
 multipath to fail?
Date: Tue, 6 Feb 2007 12:50:55 -0500
Message-ID: <Pine.SGI.4.58.0702061224400.4388493@ncisgi.ncifcrf.gov>
Reply-To: harbaugh@ncifcrf.gov,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi-

I have been using multipath-tools successfully OpenSuse with kernel 2.6.18.

I upgraded to 2.6.20-rc7 today, and multipath will not work.  When I do
a 'multipath -v3' I get:

   dm-0: blacklisted
   dm-1: blacklisted
   dm-2: blacklisted
   dm-3: blacklisted
   dm-4: blacklisted
   dm-5: blacklisted
   dm-6: blacklisted
   loop0: blacklisted
   loop1: blacklisted
   loop2: blacklisted
   loop3: blacklisted
   loop4: blacklisted
   loop5: blacklisted
   loop6: blacklisted
   loop7: blacklisted
   md0: blacklisted
   sdaa: not found in pathvec
   sdaa: mask = 0x1f
   sdab: not found in pathvec
   sdab: mask = 0x1f
   sdac: not found in pathvec
   sdac: mask = 0x1f
   sdad: not found in pathvec
   sdad: mask = 0x1f
   sdae: not found in pathvec
   sdae: mask = 0x1f
   sdaf: not found in pathvec
   sdaf: mask = 0x1f
   sdag: not found in pathvec
   sdag: mask = 0x1f
   sdah: not found in pathvec
   sdah: mask = 0x1f
   sdai: not found in pathvec
   sdai: mask = 0x1f
   .
   .
   .

comparing the /sys directories for the same volume on two different systems,
one with kernel 2.6.18 and this one with 2.6.20-rc7, shows a difference between
the /sys/block/sd%/device directories.  In particular, the 'bus' file is missing
under 2.6.20-rc7:

   node05:/sys/block/sde/device # ls -la
   total 0
   drwxr-xr-x 2 root root    0 Feb  6 16:51 .
   drwxr-xr-x 8 root root    0 Feb  6 15:32 ..
   lrwxrwxrwx 1 root root    0 Feb  6 15:33 block:sde -> ../../../../../../../../block/sde
   --w------- 1 root root 4096 Feb  6 16:51 delete
   -r--r--r-- 1 root root 4096 Feb  6 16:51 device_blocked
   lrwxrwxrwx 1 root root    0 Feb  6 15:32 driver -> ../../../../../../../../bus/scsi/drivers/sd
   lrwxrwxrwx 1 root root    0 Feb  6 16:51 generic -> ../../../../../../../../class/scsi_generic/sg4
   -r--r--r-- 1 root root 4096 Feb  6 16:51 iocounterbits
   -r--r--r-- 1 root root 4096 Feb  6 16:51 iodone_cnt
   -r--r--r-- 1 root root 4096 Feb  6 15:32 ioerr_cnt
   -r--r--r-- 1 root root 4096 Feb  6 16:51 iorequest_cnt
   -r--r--r-- 1 root root 4096 Feb  6 15:32 model
   -rw-r--r-- 1 root root 4096 Feb  6 16:51 queue_depth
   -rw-r--r-- 1 root root 4096 Feb  6 16:51 queue_type
   --w------- 1 root root 4096 Feb  6 16:51 rescan
   -r--r--r-- 1 root root 4096 Feb  6 15:32 rev
   -r--r--r-- 1 root root 4096 Feb  6 16:51 scsi_level
   -rw-r--r-- 1 root root 4096 Feb  6 16:51 state
   lrwxrwxrwx 1 root root    0 Feb  6 15:32 subsystem -> ../../../../../../../../bus/scsi
   -rw-r--r-- 1 root root    0 Feb  6 15:32 timeout
   -r--r--r-- 1 root root 4096 Feb  6 15:32 type
   --w------- 1 root root 4096 Feb  6 15:32 uevent
   -r--r--r-- 1 root root 4096 Feb  6 15:32 vendor

On the 2.6.18 system, the 'bus' file *is* present:

   cl1n002:/sys/block/sdac/device # ls -la
   total 0
   drwxr-xr-x 3 root root    0 Feb  6 11:47 .
   drwxr-xr-x 9 root root    0 Jan 17 06:59 ..
   lrwxrwxrwx 1 root root    0 Feb  6 11:39 block:sdac -> ../../../../../../../../../block/sdac
   lrwxrwxrwx 1 root root    0 Feb  6 10:42 bus -> ../../../../../../../../../bus/scsi
   --w------- 1 root root 4096 Feb  6 11:47 delete
   -r--r--r-- 1 root root 4096 Feb  6 11:47 device_blocked
   lrwxrwxrwx 1 root root    0 Feb  6 10:42 driver -> ../../../../../../../../../bus/scsi/drivers/sd
   lrwxrwxrwx 1 root root    0 Feb  6 11:47 generic -> ../../../../../../../../../class/scsi_generic/sg35
   -r--r--r-- 1 root root 4096 Feb  6 11:47 iocounterbits
   -r--r--r-- 1 root root 4096 Feb  6 11:47 iodone_cnt
   -r--r--r-- 1 root root 4096 Feb  6 11:47 ioerr_cnt
   -r--r--r-- 1 root root 4096 Feb  6 11:47 iorequest_cnt
   -r--r--r-- 1 root root 4096 Feb  6 10:42 model
   drwxr-xr-x 2 root root    0 Jan 17 06:59 power
   -rw-r--r-- 1 root root 4096 Feb  6 11:47 queue_depth
   -r--r--r-- 1 root root 4096 Feb  6 11:47 queue_type
   --w------- 1 root root 4096 Feb  6 11:47 rescan
   -r--r--r-- 1 root root 4096 Feb  6 10:42 rev
   lrwxrwxrwx 1 root root    0 Feb  6 11:47 scsi_device:6:0:4:35 -> ../../../../../../../../../class/scsi_device/6:0:4:35
   lrwxrwxrwx 1 root root    0 Feb  6 11:47 scsi_generic:sg35 -> ../../../../../../../../../class/scsi_generic/sg35
   -r--r--r-- 1 root root 4096 Feb  6 11:47 scsi_level
   -rw-r--r-- 1 root root 4096 Feb  6 11:47 state
   -rw-r--r-- 1 root root 4096 Jan 17 06:59 timeout
   -r--r--r-- 1 root root 4096 Feb  6 11:39 type
   --w------- 1 root root 4096 Feb  6 11:47 uevent
   -r--r--r-- 1 root root 4096 Feb  6 10:42 vendor


The 'sysfs_get_bus' function in discovery.c seems to play a large roll in the
discovery of devices, and it appears from the code this funtion will not work
without the 'bus' file.

Is it possible that the changes to /sys are preventing multipath from working?

Thanks,
Toni

-------------------------------------------------------------------
Toni Harbaugh-Blackford                   harbaugh@abcc.ncifcrf.gov
System Administrator
Advanced Biomedical Computing Center (ABCC)
National Cancer Institute
Contractor - SAIC/Frederick
