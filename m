From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 23 Mar 2012 12:22:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203231213320.17386@file.rdu.redhat.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
	<4F6C5A1F.1000103@redhat.com>
	<CALLzPKb+xrQQ-+sOTY0-MHbfVDkgvY2TYqmpP0Mqi7XwD4iEDg@mail.gmail.com>
	<CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Fri, 23 Mar 2012, Kasatkin, Dmitry wrote:

> When using dm-bufio and dm-io in general, how to ensure that all dirty

Regarding dm-io, you don't have to flush dirty buffers because dm-io does 
no caching. You only need to flush hardware disk cache with 
blkdev_issue_flush.

> At the moment, I have reboot notifier which does the following
> 
> 	dm_bufio_write_dirty_buffers(d->bufio);
> 	sync_blockdev(d->dev->bdev);
> 	blkdev_issue_flush(d->dev->bdev, GFP_KERNEL, NULL);
> 
> without first line on the next boot I got corrupted/not updated blocks.
> and I am not sure if I need last 2 lines...

You can drop sync_blockdev(d->dev->bdev) --- sync_blockdev flushes kernel 
buffer cache and dm-bufio doesn't use the kernel buffer cache (you only 
need sync_blockdev if you use kernel buffer cache on this device for 
something else). If you drop sync_blockdev, you can also drop 
blkdev_issue_flush, because dm_bufio_write_dirty_buffers already issues 
the flush request.

BTW. how are you going to deal with kernel crashes or power faults?

It is much better to use journaling, phase tree, crash counts or other 
method to maintain metadata integrity insted of reboot notifier --- these 
methods maintain integrity even in case of unexpected crash.

Mikulas
