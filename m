From: "goggin, edward" <egoggin@emc.com>
Subject: Adding/removing multi-pathed disk partitions
Date: Tue, 25 Jan 2005 16:07:03 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A708@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Should one be using the multi-path device-mapper mapped device
name or one of the SCSI target device names for the whole disk
device when modifying a SCSI disk's partition table with fdisk(8)?

If the former, drivers/block/ioctl.c:blkdev_reread_part()
currently returns EINVAL since the mapped device is not
partitionable.  I can't imagine the recommendation is the
latter, since there is no mechanism in place to synchronize
the kernel's partition table handling amongst multiple target
devices.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
