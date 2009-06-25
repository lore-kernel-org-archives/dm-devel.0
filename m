From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 13:20:42 -0400
Message-ID: <20090625172041.GA22891@redhat.com>
References: <200906250904.57149.elendil@planet.nl>
	<20090625154120.GA22616@redhat.com>
	<200906251840.07617.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200906251840.07617.elendil@planet.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thu, Jun 25 2009 at 12:40pm -0400,
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 25 June 2009, Mike Snitzer wrote:
> > On Thu, Jun 25 2009 at  3:04am -0400,
> > Frans Pop <elendil@planet.nl> wrote: 
> > > During boot of 2.6.31-rc1 on an arm EABI system I got the following
> > > errors:
> > > device-mapper: table: 254:0: target device sda6 is misaligned
> > > device-mapper: table: 254:0: target device sda6 is misaligned
> > > device-mapper: table: 254:1: target device sda6 is misaligned
> > > device-mapper: table: 254:1: target device sda6 is misaligned
> > >
> > > The boot did complete successfully. A boot with 2.6.30 just
> > > previously was clean, and when I reboot back into 2.6.30 the messages
> > > are gone again.
> > >
> > > The system has a single volume group with two logical volumes.
> >
> > Even though the messages don't contain "warning", and probably should,
> > they are printed via DMWARN().
> 
> When I first saw the messages I almost got a heart attack, especially 
> because I also got an fsck for the file systems on them. Luckily it 
> turned out later that the reason for that was that I'd accidentally 
> removed the rtc driver from my config, so the fsck was triggered by the 
> system clock not being set :-/
> 
> > These warnings are a function of device-mapper now being
> > topology-aware.  This means that your LVs are likely misaligned
> > relative to the underlying hardware.  Given that you're using
> > partitions I'd wager they are the source of the misalignment.  But
> > there could be a bug lurking somewhere.
> 
> OK. If it does turn out to be benign, then I'd suggest marking the 
> messages "info: " instead of "warning: ". With "warning" admins would 
> still be given the idea that something might be desperately wrong and 
> action should be taken NOW.
> Personally, I'd even prefer just not to know, unless it for example has a 
> major effect on performance _and_ is easily fixable using lvm2.
> 
> Wouldn't it be much more logical if the userspace tools warn about 
> alignment problems when volumes are _created_?
>
> The volumes were all created using Debian Installer's partitioning 
> component, which uses libparted and lvm2.

The device-mapper layer doesn't distinguish between the first creation
and every activation there after.  The blk_stack_limits() method is
called by DM when an LV's table is pushed down to the kernel.  As such,
you'll always see the warnings.  Think of it as motivation to fix
libparted and all the other storage tools (LVM2 included) to create
properly aligned devices :)
 

> > Please provide the output from the following commands:
> >
> > pvs -o +pe_start
> 
>   PV         VG   Fmt  Attr PSize   PFree  1st PE
>   /dev/sda6  qnap lvm2 a-   124.50G 44.50G 192.00K
> 
> > cat /sys/block/sda/sda6/alignment_offset
> > cat /sys/block/sda/queue/physical_block_size
> > cat /sys/block/sda/queue/logical_block_size
> 
> I'm afraid those files don't exist on my systems (none of them: arm, s390 
> and x86_64 notebook). Some kernel config option I'm missing maybe?

OK, that is not possible; if you're seeing messages like the following:
device-mapper: table: 254:0: target device sda6 is misaligned

You should definitely have the topology attributes in the associated
device's sysfs tree.  What does the following show on your 2.6.31-rc1
system that produced the above "target device sda6 is misaligned":

find /sys/block/sda/queue -type f

If you don't see attributes like the following you're collecting
information from the wrong machine:

/sys/block/sda/queue/logical_block_size
/sys/block/sda/queue/physical_block_size
/sys/block/sda/queue/minimum_io_size
/sys/block/sda/queue/optimal_io_size
