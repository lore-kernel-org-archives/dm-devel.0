From: Ray Van Dolson <rayvd@bludgeon.org>
Subject: loopX too small for target
Date: Tue, 7 Jun 2011 22:13:41 -0700
Message-ID: <20110608051340.GA16351@bludgeon.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've imaged the hard disk off of a CentOS 5 machine via dd which
resulted in a 112GB file "gawaine.img":

  # file gawaine.img 
  gawaine.img: x86 boot sector; GRand Unified Bootloader, stage1 version 0x3, boot drive 0x80, 1st sector stage2 0x8841; partition 1: ID=0x83, active, starthead 1, startsector 63, 208782 sectors; partition 2: ID=0x8e, starthead 0, startsector 208845, 234227700 sectors, code offset 0x48
  [root@brick VM]# sfdisk -l gawaine.img 
  Disk gawaine.img: cannot get geometry

  Disk gawaine.img: 14589 cylinders, 255 heads, 63 sectors/track
  Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

     Device Boot Start     End   #cyls    #blocks   Id  System
  gawaine.img1   *      0+     12      13-    104391   83  Linux
  gawaine.img2         13   14592   14580  117113850   8e  Linux LVM
  gawaine.img3          0       -       0          0    0  Empty
  gawaine.img4          0       -       0          0    0  Empty

  I'm trying to access this image via kpartx, but running into the
  following:

  [root@brick VM]# losetup -a
  [root@brick VM]# kpartx -av gawaine.img 
  add map loop0p1 (253:5): 0 208782 linear /dev/loop0 63
  device-mapper: resume ioctl failed: Invalid argument
  create/reload failed on loop0p2
  add map loop0p2 (0:0): 0 234227700 linear /dev/loop0 208845
  [root@brick VM]# dmesg
  device-mapper: table: 253:6: loop0 too small for target: start=208845, len=234227700, dev_size=234375000

Hmm...

  [root@brick VM]# losetup -a
  /dev/loop0: [fd03]:2386057117 (gawaine.img)
  [root@brick VM]# ls -l /dev/mapper/loop0p1 
  lrwxrwxrwx 1 root root 7 Jun  7 22:18 /dev/mapper/loop0p1 -> ../dm-5

So only the non-LVM partitioned (much smaller) got mapped.  Are there
size limitations to what a loopback device can handle?

  [root@brick VM]# rpm -q kpartx util-linux-ng
  kpartx-0.4.9-31.el6.x86_64
  util-linux-ng-2.17.2-6.el6.x86_64

Thanks,
Ray
