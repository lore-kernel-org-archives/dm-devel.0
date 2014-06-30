From: Paul Mackerras <paulus@samba.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
Date: Mon, 30 Jun 2014 21:02:02 +1000
Message-ID: <20140630110202.GB17747@iris.ozlabs.ibm.com>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com>
 <53B1416D.8020305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53B1416D.8020305@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Vladimir Davydov <vdavydov@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On Mon, Jun 30, 2014 at 12:52:29PM +0200, Hannes Reinecke wrote:
> On 06/30/2014 12:30 PM, Paul Mackerras wrote:
> >I have a machine on which 3.15 usually fails to boot, and 3.14 boots
> >every time.  The machine is a POWER8 2-socket server with 20 cores
> >(thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
> >hardware-RAID-capable adapter which appears as two IPR controllers
> >which are both connected to each disk.  I am booting from a disk that
> >has Fedora 20 installed on it.
> >
> >After over two weeks of bisections, I can finally point to the commits
> >that cause the problems.  The culprits are:
> >
> >3e9f1be1 dm mpath: remove process_queued_ios()
> >e8099177 dm mpath: push back requests instead of queueing
> >bcccff93 kobject: don't block for each kobject_uevent
> >
> >The interesting thing is that neither e8099177 nor bcccff93 cause
> >failures on their own, but with both commits in there are failures
> >where the system will fail to find /home on some occasions.
> >
> >With 3e9f1be1 included, the system appears to be prone to a deadlock
> >condition which typically causes the boot process to hang with this
> >message showing:
> >
> >A start job is running for Monitoring of LVM2 mirror...rogress polling
> >
> >(with a [***     ] thing before it where the asterisks move back and
> >forth).
> >
> >If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
> >4cdd2ad7 ("dm mpath: fix lock order inconsistency in
> >multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
> >kernel that will boot every time.  The first two are later commits
> >that fix some problems with 3e9f1be1 (though not the problems I am
> >seeing).
> >
> >Can anyone see any reason why e8099177 and bcccff93 would interfere
> >with each other?
> >
> It might be running afoul with the 'cookie' mechanism.
> Device-mapper is using inserting a 'cookie' with the ioctl, and listens to
> any event containing the cookie to ensure udev has finished processing that
> device and hence the device node is accessible. Added to this is the problem
> that we don't have any good means of detecting any changes to device-mapper
> devices.
> 
> EG look at this sequence of events:
> 
> add dm-1
> remove dm-1
> add dm-1
> 
> Originally udev would pick up the event, read the details from sysfs, and
> return control to the kernel.
> With bcccff93 udev will _not_have a chance to read the details
> from sysfs for 'dm-1', as anything read from sysfs relating to 'dm-1' might
> infact refer to the _second_ 'add' event, which might be a totally different
> device.
> As far as I know udev doesn't have any mechanism to drop events,
> so it'll always process all events. Assuming that the sysfs attributes it
> reads _do_ relate to that event. If they don't things become interesting ...
> 
> (Actually, this issue was always present, especially with multipathing.
> multipath occasionally can become sluggish when processing events, so the
> same might happen with it. We've tried to work around this, but never found
> a fool-proof way of doing so).
> 
> Adding Kay as he might have some more insight here.
> 
> Another thing:
> Do you run LVM on top of multipathing?
> If so, could you setup your system with _not_ using LVM and disabling the
> LVM service?

No, I'm not using LVM, and in fact I deleted all the physical volumes
that were on any of the disks (they were installations of other
distros), so there are no physical or logical volumes anywhere on any
disk.  I haven't tried disabling the LVM service completely, though.
What would it mean if disabling the LVM service made a difference?

> Reasoning here is that multipath should not be that susceptible to changes
> here than LVM2 is (don't nail me on this, I not _that_ into LVM2 details).
> 
> And as the system is stuck while waiting for LVM it might indeed be an
> side-effect when running LVM on top of multipathing.

Yes, I thought so too early on, and that's why I deleted all LVM
physical and logical volumes, but that didn't help.

Paul.
