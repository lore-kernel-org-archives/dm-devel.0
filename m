From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 3 Aug 2007 10:11:34 +0200
Message-ID: <20070803081133.GB939@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B254E4.60700@cfl.rr.com>
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

On Thu, Aug 02, 2007 at 06:04:20PM -0400, Phillip Susi wrote:
>Luca Berra wrote:
>>Two things come to mind
>>1) dmraid should use ioctl BLKPG_DEL_PARTITION, to clean up any eventual
>>partition table on component devices
>
>How will this play out in terms of udev plug events?  Can it be relied 
>on that udev will process the disk first, before the partitions?  If the 
>partitions are deleted during the processing of the disk, does udev 
>still try to process their add events?  Will it then process the delete 
>events?  If so then this is problematic.
I really have no clue, fortunately dmraid is usually used for boot
disks, so it should be started before udev has a chance of messing with
devices. btw, md already does this, and redhat's initrd does this as
well.
The real solution to this is so simple.
Just ditch the partition detection code from the kernel, and move it to
userspace where it belongs.
For the time being use BLKPG_DEL_PARTITION, to undo what the kernel
should not have done.

>>2) lvm tool filter could be modified to check if a device has been
>>already claimed by device-mapper.
>>
>>something along the lines of:
>>ioctl DM_LIST_DEVICES
>>while (...)
>>  ioctl DM_TABLE_DEPS
>>
>>the above would probably require a cache.
>
>I'd rather not see it that tightly coupled to dm.  I was thinking 
>perhaps of something involving udev attributes so that udev would know 
>not to run pvscan on that device.  Though it looks like pvscan also 
>needs reworked so it plays nice with udev, being called to scan a given 
>device as detected rather than looking for all well known physical 
>device names in /dev.
i'd rather not see it coupled with udev :P
maybe i am limited, but i really fail to see how an event driven model
could be at all useful in this cases, and i am really convinced that the
effort needed to make i work is too high compared to possible benefits.
The biggest question being: How do you know you have scanned all
possible PV for a given volume group, and you have to activate it.
Anyway i still think my proposal is sensible and adapts to the current
paradigm of lvm2.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
