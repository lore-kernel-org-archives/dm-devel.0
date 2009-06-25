From: Frans Pop <elendil@planet.nl>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 18:40:06 +0200
Message-ID: <200906251840.07617.elendil@planet.nl>
References: <200906250904.57149.elendil@planet.nl> <20090625154120.GA22616@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756427AbZFYQkU@vger.kernel.org>
In-Reply-To: <20090625154120.GA22616@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thursday 25 June 2009, Mike Snitzer wrote:
> On Thu, Jun 25 2009 at  3:04am -0400,
> Frans Pop <elendil@planet.nl> wrote: 
> > During boot of 2.6.31-rc1 on an arm EABI system I got the following
> > errors:
> > device-mapper: table: 254:0: target device sda6 is misaligned
> > device-mapper: table: 254:0: target device sda6 is misaligned
> > device-mapper: table: 254:1: target device sda6 is misaligned
> > device-mapper: table: 254:1: target device sda6 is misaligned
> >
> > The boot did complete successfully. A boot with 2.6.30 just
> > previously was clean, and when I reboot back into 2.6.30 the messages
> > are gone again.
> >
> > The system has a single volume group with two logical volumes.
>
> Even though the messages don't contain "warning", and probably should,
> they are printed via DMWARN().

When I first saw the messages I almost got a heart attack, especially 
because I also got an fsck for the file systems on them. Luckily it 
turned out later that the reason for that was that I'd accidentally 
removed the rtc driver from my config, so the fsck was triggered by the 
system clock not being set :-/

> These warnings are a function of device-mapper now being
> topology-aware.  This means that your LVs are likely misaligned
> relative to the underlying hardware.  Given that you're using
> partitions I'd wager they are the source of the misalignment.  But
> there could be a bug lurking somewhere.

OK. If it does turn out to be benign, then I'd suggest marking the 
messages "info: " instead of "warning: ". With "warning" admins would 
still be given the idea that something might be desperately wrong and 
action should be taken NOW.
Personally, I'd even prefer just not to know, unless it for example has a 
major effect on performance _and_ is easily fixable using lvm2.

Wouldn't it be much more logical if the userspace tools warn about 
alignment problems when volumes are _created_?

The volumes were all created using Debian Installer's partitioning 
component, which uses libparted and lvm2.

> Please provide the output from the following commands:
>
> pvs -o +pe_start

  PV         VG   Fmt  Attr PSize   PFree  1st PE
  /dev/sda6  qnap lvm2 a-   124.50G 44.50G 192.00K

> cat /sys/block/sda/sda6/alignment_offset
> cat /sys/block/sda/queue/physical_block_size
> cat /sys/block/sda/queue/logical_block_size

I'm afraid those files don't exist on my systems (none of them: arm, s390 
and x86_64 notebook). Some kernel config option I'm missing maybe?

Here's the partition layout:
# fdisk -u -l /dev/sda

Disk /dev/sda: 164.7 GB, 164696555520 bytes
255 heads, 63 sectors/track, 20023 cylinders, total 321672960 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0x00054f49

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63    19535039     9767488+  83  Linux
/dev/sda2        19535040    39070079     9767520   83  Linux
/dev/sda3        39070080    58605119     9767520   83  Linux
/dev/sda4        58605120   321669494   131532187+   5  Extended
/dev/sda5        58605183    60565049      979933+  82  Linux swap
/dev/sda6        60565113   321669494   130552191   8e  Linux LVM

> If you could also provide the same info for all other PVs that are in
> the VG that would be appreciated.

There's only the one PV.

On Thursday 25 June 2009, Mike Snitzer wrote:
> In addition to the other commands I asked for in my previous mail;
> please provide the output from the following commands on both your real
> and emulated configs:

# dmsetup ls
qnap-home       (254, 0)
qnap-music      (254, 1)

# dmsetup table
qnap-home: 0 83886080 linear 8:6 384
qnap-music: 0 83886080 linear 8:6 83886464

The above is all for the arm system.

Thanks,
FJP
