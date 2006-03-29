From: Sharif Nassar <lists-dmdevel@mrwacky.com>
Subject: resizing multipathed luns attached to EMC cx500
Date: Tue, 28 Mar 2006 17:36:58 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0603281705170.6511@mrwacky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


Hi,

I'm running latest greatest RHEL 4 kernel, device-mapper tools, etc on a 
Sun V40z, using dual Qlogic 2340 HBA attached to Brocade SAN (EMC badged 
3850), tied to our EMC CX500.

I'm trying to determine if it's possible to resize a multipathed LUN while 
there are active LVM2 volume groups.

Lots of searching, and list archive trawling has told me that I should be 
able to just invoke multipath from the command line, and it will see the 
new size, and I run merrily along with pvresize and lvresize..

After expanding the lun in navisphere, however, i can't see the new size 
of the block device without deactivating all VG on the multipathed 
device-mapped device.

Here is the test LUN, that the OS sees as 8GB, even though it's been grown 
on EMC to 19GB:

# multipath -l mpath3
mpath3 (3600601608a9112009cd9fafafebdda11)
[size=8 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:1:2 sdf 8:80  [active][ready]
  \_ 2:0:1:2 sdj 8:144 [active][ready]
\_ round-robin 0 [enabled]
  \_ 1:0:0:2 sdd 8:48  [active][ready]
  \_ 2:0:0:2 sdh 8:112 [active][ready]

  vgchange -an test3
   0 logical volume(s) in volume group "test3" now active
[root@halfoat.ds ~]# multipath -l mpath3
mpath3 (3600601608a9112009cd9fafafebdda11)
[size=8 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:1:2 sdf 8:80  [active][ready]
  \_ 2:0:1:2 sdj 8:144 [active][ready]
\_ round-robin 0 [enabled]
  \_ 1:0:0:2 sdd 8:48  [active][ready]
  \_ 2:0:0:2 sdh 8:112 [active][ready]

Next, turn off the VG, and flush multipath table
# vgchange -an test3
   0 logical volume(s) in volume group "test3" now active
# multipath -f mpath3

# for i in f j d h ; do blockdev --getsize /dev/sd$i ; done
39845888
39845888
39845888
39845888

BANG, it's got the new size:
# multipath
create: mpath3 (3600601608a9112009cd9fafafebdda11)
[size=19 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [prio=2]
  \_ 1:0:1:2 sdf 8:80  [ready]
  \_ 2:0:1:2 sdj 8:144 [ready]
\_ round-robin 0
  \_ 1:0:0:2 sdd 8:48  [ready]
  \_ 2:0:0:2 sdh 8:112 [ready]

Next, I grow the LUN again on EMC, and try to skip some steps..

# for i in f j d h ; do blockdev --rereadpt /dev/sd$i ; done
# multipath
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: device 8:80 too small for target
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper ioctl cmd 9 failed: Invalid argument


So, yeah, is there a way to get dm to see the new size of the block device 
without:  un mounting all fs, and vgchange all volgroups on the device ?

thanks

-sharif
