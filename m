From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Adding/removing multi-pathed disk partitions
Date: Tue, 25 Jan 2005 23:34:25 +0100
Message-ID: <1106692465.10990.98.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A708@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A708@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2005-01-25 at 16:07 -0500, goggin, edward wrote:
> Should one be using the multi-path device-mapper mapped device
> name or one of the SCSI target device names for the whole disk
> device when modifying a SCSI disk's partition table with fdisk(8)?
> 
> If the former, drivers/block/ioctl.c:blkdev_reread_part()
> currently returns EINVAL since the mapped device is not
> partitionable.  I can't imagine the recommendation is the
> latter, since there is no mechanism in place to synchronize
> the kernel's partition table handling amongst multiple target
> devices.
> 
May be that's not a problem, as we don't need the kernel partitioning
code. Though it's not nice to have the kernel not in sync with reality.

If kpartx reads the partition table directly from disk, ie bypassing the
cache, the correct layout will be mapped. Note it recquires a manual
execution, as no hotplug event is generated upon fdisk's sync. This also
applies to "blockdev --rereadpt" anyway.

This trick should have it working leaving all involved code mostly
untouched. 

Now that's not necessarily satisfying. The weak spots of the situation
are :
1) impose an manual kpartx run to admins
2) the kernel display bogus partitioning info
3) the admin has to know he must run fdisk on a path and not on the
multipath

What can we do to improve that ?

3) would be solved by using "sfdisk --no-reread" on the multipath map
instead of fdisk. It would need to be a FAQ item (near the top).
1) could be addressed the same way BLKREREADPART has made its way into
fdisk and the like : we could push a kpartx awareness into them.
2) flames to me for suggesting we could get away altogether with the
kernel partitioning code ?

All insights are more than welcome.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
