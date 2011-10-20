From: "Bernd Broermann" <bernd@broermann.com>
Subject: DM inconsistent after disk migration
Date: Thu, 20 Oct 2011 16:47:17 +0200
Message-ID: <780ff8d84fb70f7ddf8beb696ff02ddf.squirrel@webmail.xlab.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hallo

I can not remove an unused LUN , because devicemapper is inconsistent
under /sys/block.

Red Hat Enterprise Linux Server release 5.5 (Tikanga)
Linux xxxxxxx 2.6.18-194.el5 #1 SMP Tue Mar 16 21:52:39 EDT 2010 x86_64
x86_64 x86_64 GNU/Linux
device-mapper-multipath-0.4.7-34.el5


we have two hosts (MASTER,SLAVE) , which are connected to a shared storage
 (EMC SAN and SRDF)  with two equal sized disks.
One of the disk contains a Logical Volume in one Volume Group.

we wanted to migrate ("move") data from disk1 to disk2 , and remove disk1
afterwards.


MASTER                             SLAVE
disk1 (vg01/lvdata)   <-srdf->     disk3 (vg01/lvdata)
disk2 (empty)         <-srdf->     disk4 (empty)

On MASTER we "move" disk1 to disk2 with following commands.
Because of the SRDF mirror disk3 is copied simultaneous to disk4.



CODE "move" script
# mirror
pvcreate /dev/disk2
vgextend vg01  /dev/disk2
lvconvert -m1 --mirrorlog core /dev/vg01/lvdata  /dev/disk2
# split
lvconvert -m0 --mirrorlog core /dev/vg01/lvdata  /dev/disk1
vgreduce vg01  /dev/disk1
pvremove  /dev/disk1


The "move" process runs without error.
On MASTER disk1 can be removed without error.
On SLAVE  removing disk3 gives an error like

powermt  remove dev=disk3
Cannot remove device that is in use: disk3
( in real /dev/disk3 is /dev/emcpower$(belonging disk3 )


i analyzed the /sys filesystem on SLAVE and saw , that vg01-lvdata is
blocks by /dev/disk3.


find /sys -name '*disk3*' -ls
 29486    0 lrwxrwxrwx   1 root     root            0 Jul 27 09:10
/sys/block/dm-9/slaves/disk3 -> ../../../block/disk3
ls -l /dev/mapper/vg01-lvdata
brw-rw---- 1 root disk 253, 9 Jul 27 09:09 /dev/mapper/vg01-lvdata

My assumption is that SLAVE reconfigures the device-mapper not correct,
when doing the "move" operations on MASTER.

How can I reconfigure the device-mapper stuff on SLAVE to avoid an reboot ?


A bit complex, but i hope i could make the problem clear to you.

regards
bernd
