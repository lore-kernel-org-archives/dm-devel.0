From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Sun, 29 Aug 2010 11:39:43 -0700
Message-ID: <20100829183943.GA22562@us.ibm.com>
References: <20100827182634.GB31618@us.ibm.com>
	<C89D80D7.10732%brian.p.stamper@nasa.gov>
	<20100828174751.GA31397@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>
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

> [root@testfs boot]# mkdir foo
> [root@testfs boot]# cd foo
> [root@testfs foo]# zcat ../initramfs-with-multipath.img | cpio -icd
> 26392 blocks
> [root@testfs foo]# ls
> bin                emergency  initqueue-finished  mount        proc     tmp
> cmdline            etc        initqueue-settled   pre-pivot    sbin     usr
> dev                init       lib                 pre-trigger  sys      var
> dracut-005-3.fc13  initqueue  lib64               pre-udev     sysroot
> [root@testfs foo]# find . -print | grep -i multi
> ./lib/modules/2.6.33.8-149.fc13.x86_64/kernel/drivers/md/dm-multipath.ko

The dm-multipath.ko kernel module is present. It needs multipath command
calling from an initrd script (/init ???)

> /dev/sdq: UUID="2VqqWi-cWZo-Tu5T-cC40-z4CW-ZOti-aWhi5F" TYPE="LVM2_member"
> /dev/sdr: UUID="JV8nOF-NxdU-WAZP-ZY9h-iXo8-HJWs-CjSjTj" TYPE="LVM2_member"
> /dev/sds: UUID="Crn275-rSvZ-6Bl1-LplP-c0iG-PvtZ-OVofd8" TYPE="LVM2_member"
> /dev/sdc: UUID="2VqqWi-cWZo-Tu5T-cC40-z4CW-ZOti-aWhi5F" TYPE="LVM2_member"
> /dev/sdd: UUID="JV8nOF-NxdU-WAZP-ZY9h-iXo8-HJWs-CjSjTj" TYPE="LVM2_member"
> /dev/sde: UUID="Crn275-rSvZ-6Bl1-LplP-c0iG-PvtZ-OVofd8" TYPE="LVM2_member"

The above drives are added to LVM without any partitions. Everything
else has partitions, so you need to run "kpartx" on each multipath
device to create mappings for partitions. Did you enable multipathd
service (I thought it should call kpartx or maybe a udev rule)?

I saw device mapper reload ioctl failures when you enabled the VGs. The
LVM scan seems to use single paths rather than multipath devices (from
duplicate PV messages).

So run "kpartx -a /dev/mapper/<yourmultipathdevice>" on each multipath
device and then run LVM scan.

If LVM still uses paths and complains about duplicate PVs, then you may
need create a right filter in /etc/lvm/lvm.conf to use intended devices.
I hope this is not necessary.

Thanks, Malahal.
