From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Adding/removing multi-pathed disk partitions
Date: Thu, 17 Feb 2005 23:38:40 +0100
Message-ID: <42151CF0.90709@free.fr>
References: <C2EEB4E538D3DC48BF57F391F422779321A708@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

goggin, edward wrote:

>Should one be using the multi-path device-mapper mapped device
>name or one of the SCSI target device names for the whole disk
>device when modifying a SCSI disk's partition table with fdisk(8)?
>
>If the former, drivers/block/ioctl.c:blkdev_reread_part()
>currently returns EINVAL since the mapped device is not
>partitionable.  I can't imagine the recommendation is the
>latter, since there is no mechanism in place to synchronize
>the kernel's partition table handling amongst multiple target
>devices.
>
>--
>
As discussed earlier, one face of this problem is that kpartx does 
buffered reads to grab the on-disk partition table, leading to 
situations where kpartx ->fdisk -> kpartx sequence does not garanty 
partitons-to-maps layout will reflect reality.

To address this particular problem, do you think adding O_DIRECT to the 
open() call in kpartx.c would be enough ?

Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
