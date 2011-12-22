From: Alasdair G Kergon <agk@redhat.com>
Subject: FW: CVE-2011-4127 kernel: possible privilege escalation
	via SG_IO	ioctl
Date: Thu, 22 Dec 2011 17:25:48 +0000
Message-ID: <20111222172548.GA31021@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-lvm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

----- Forwarded message from Petr Matousek <pmatouse@redhat.com> -----

Date: Thu, 22 Dec 2011 18:06:47 +0100
From: Petr Matousek <pmatouse@redhat.com>

Paolo Bonzini of Red Hat found out that the host Linux system allows
executing the SG_IO ioctl on a partition or even on an LVM volume, and
will pass the command to the underlying block device. This could be
further exploited in the in the context of virtualization, because
virtio disks support a limited form of SCSI passthrough via the SG_IO
ioctl. If virtio disk is hosted on a partition or LVM volume with
format=raw, tools such as sg_dd can be used to read and write other data
on the same disk --- even data that belongs to the host or to other
guests.

References:
https://lkml.org/lkml/2004/8/12/218
https://lkml.org/lkml/2004/8/12/260
https://bugzilla.redhat.com/show_bug.cgi?id=752375

Thanks,
-- 
Petr Matousek / Red Hat Security Response Team

----- End forwarded message -----


For a storage stack to be vulnerable, every layer must forward the SG_IO ioctls
to the layer below it.

Three device-mapper target types are known to do this: linear, multipath and
flakey.

If the I/O has to pass through striped, crypt, mirror or snapshot*
device-mapper target types or an md software raid layer on its route to disk,
any SG_IO will get blocked by those layers and so we believe such
configurations are not vulnerable.

Immediate mitigation (without patching your kernel/rebooting) is available with
a systemtap script mentioned in the bug if you have systemtap installed, or
alternatively by creating a patched version of LVM with:

  http://www.redhat.com/archives/lvm-devel/2011-November/msg00171.html
  http://sourceware.org/git/?p=lvm2.git;a=commitdiff;h=bb69784719932515baea4757dc9d61e81b825285;hp=8ec116a6b874f3575bc346e4cbd69ac5f0522160

and then setting 'use_linear_target = 0' in the 'activation' section of
lvm.conf and running lvchange --refresh on the relevant logical volumes to
convert them in-situ from the vulnerable 'linear' target type to the
not-vulnerable 'striped' target type.  (A linear target works the same as a
striped target with just 1 stripe.)  When you run 'dmsetup table' you should
then see 'striped' in the output where previously there was 'linear'.

A kernel patch that fixes device-mapper/LVM devices is here:
  http://people.redhat.com/agk/patches/linux/editing/dm-block-sg_io-ioctls.patch
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-block-sg_io-ioctls.patch

Alasdair
