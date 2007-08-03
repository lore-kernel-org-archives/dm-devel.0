From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 03 Aug 2007 14:10:02 -0400
Message-ID: <46B36F7A.2090601@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B254E4.60700@cfl.rr.com>
	<20070803081133.GB939@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070803081133.GB939@percy.comedia.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Luca Berra wrote:
> I really have no clue, fortunately dmraid is usually used for boot
> disks, so it should be started before udev has a chance of messing with
> devices. btw, md already does this, and redhat's initrd does this as
> well.

I don't know about redhat, but Ubuntu uses udev in the initramfs. 
Currently the boot scripts wait for udevsettle, then run dmraid and 
pvscan to search out all detected devices, then tries to mount the root 
fs, but this setup is less than ideal.  Our goal is to move towards full 
udev plug and play, where devices are detected by the kernel, processed, 
and as soon as the one(s) needed for the root have been enumerated, 
mount the root fs and run-init.

> The real solution to this is so simple.
> Just ditch the partition detection code from the kernel, and move it to
> userspace where it belongs.
> For the time being use BLKPG_DEL_PARTITION, to undo what the kernel
> should not have done.

I agree with moving the partition detection code to user space, but 
trying to undo it after the fact doesn't help because udev is already 
processing the add events.  Also you do not need to remove the 
partitions so long as pvscan understands that it shouldn't be using them.

> i'd rather not see it coupled with udev :P
> maybe i am limited, but i really fail to see how an event driven model
> could be at all useful in this cases, and i am really convinced that the
> effort needed to make i work is too high compared to possible benefits.
> The biggest question being: How do you know you have scanned all
> possible PV for a given volume group, and you have to activate it.
> Anyway i still think my proposal is sensible and adapts to the current
> paradigm of lvm2.

Udev is supposed to be the new model for enumerating devices and 
performing plug and play actions on them, rather than "ls /dev/hd?".  To 
answer your specific question, lvm would know it has enumerated all the 
required pvs because the vg information tells it how many pvs are 
supposed to be there so it can check the udevdb to see if they have all 
been added yet.  If they have, activate the vg, otherwise do nothing 
until another pv is detected.

The event driven model is useful in that it allows faster boot times ( 
don't need to detect ALL devices before activating and mounting the root 
), and allows runtime plug and play.  Where does lvm store state 
information right now?  In conf files in /etc isn't it?  Why use its own 
database for that when it could just keep the information in udevdb?
Keeping the information in udevdb makes it easily available to things 
like hal in gnome, which in turn allows things like desktop popups when 
a mirror has a drive fail, which changes the state of the vg in udevdb, 
which pushes that update to any monitoring applications.  It also allows 
lvm to share information such as whether or not the device is "claimed" 
with other components, without those components having to be 
specifically aware of lvm and mess with its conf files.  Specifically, 
both dmraid and mdraid ( nor any other future components ) do not have 
to be taught how to edit lvm's conf files to tell it not to access the 
underlying physical disks but to use the virtual devices instead.
