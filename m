From: Joel Becker <Joel.Becker@oracle.com>
Subject: Bug? Determining the holders of partitions shadowed by
	dm-multipath.
Date: Mon, 9 Feb 2009 16:49:51 -0800
Message-ID: <20090210004951.GA4341@mail.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Sunil Mushran <sunil.mushran@oracle.com>
List-Id: dm-devel.ids

Folks,
	I think this is a bug.
I	I have a device with two paths, sda and sdb.  The device is
partitioned into two partitions (sda1, sdb1) and (sda2, sdb2).  The
multipath software will create me the devices mpath1, mpath1p1, and
mpath1p2.  So far so good.
	Now, I need to detect disks used by my software.  There is a
signature on disks used by my software, so the basic algorithm is "for
each disk, check for the signature".  But, as you know, multipath makes
this fun.  You don't want to detect sda1 or sdb1, you want to detect
mpath1.  This is true no matter how the devices are arranged (LVM
devices, kpartx of loopbacks, whatever it is).  I'll use the term
"toplevel device" to describe a device that is not being used as part
of some other device.
	So, how to determine toplevel devices?  Well,
/sys/block/.../holders works for that, so I tried it.  Sure enough,
/sys/block/sda/holders and /sys/block/sdb/holders point to mpath1.  So
my software can reliably ignore sda and sdb.  But when I look at
/sys/block/sda1/holders, it is empty.
	The disk encompassing sda1 is held by another device.  By
extension, sda1 is held.  So I think it is a bug that
/sys/block/sda1/holders is empty.
	Bug or not, what is the recommended way to determine that
/dev/sda1 should not be used, because you should be using
/dev/mpath/mpath1p1 (or whatever udev name it appears as)?

Joel

-- 

Life's Little Instruction Book #510

	"Count your blessings."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
