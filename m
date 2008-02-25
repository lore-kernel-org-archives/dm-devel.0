From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: device mapper not reporting no-barrier-support?
Date: Mon, 25 Feb 2008 15:20:50 -0800
Message-ID: <20080225152050.94788622.akpm@linux-foundation.org>
References: <20080225132615.GA21990@1und1.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080225132615.GA21990@1und1.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anders Henke <anders.henke@1und1.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 25 Feb 2008 14:26:15 +0100 Anders Henke <anders.henke@1und1.de> wrote:

> Hi,
> 
> I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
> 2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).
> 
> -LVM2/device mapper doesn't support write barriers
> -DRBD uses blkdev_issue_flush() to flush its metadata to disk.
>  On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
>  it really does receive an EIO. Promptly, DRBD gives the
>  error message "drbd0: local disk flush failed with status -5".
> 
> The physical disk (in LVM speak) is a RAID1 on a 3ware 9650SE-2LP
> controller; the driver 3w-9xxx supports barriers and after moving my D
> RBD device from the LV to a single partition on the same RAID1, the 
> error messages from DRBD vanished.
> 
> I've posted a lengty summary of my findings to
> 
> http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html
> 
> ... where Lars Ellenberg from DRBD basically responded in
> 
> http://lists.linbit.com/pipermail/drbd-user/2008-February/008666.html
> 
> ... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
> BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
> 2.6.24.2 aparently does return EIO for blkdev_issue_flush.
> 
> So simply the question: how should a top-layer driver check wether a lower
> device does support barriers? md-raid does check this way differently than
> e.g. XFS does, while DRBD also adds a third way to check this.
> Or is this "merely" a bug in drivers/md/dm.c?
> 

(cc dm-devel)

I'd say it's a DM bug.  Probably a hard-to-fix one though.
