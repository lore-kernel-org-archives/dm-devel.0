From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Date: Thu, 17 Feb 2011 12:03:48 -0500
Message-ID: <x494o82wq2z.fsf@segfault.boston.devel.redhat.com>
References: <20110217165057.5c50e566@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217165057.5c50e566@notabene.brown> (NeilBrown's message of
	"Thu, 17 Feb 2011 16:50:57 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

NeilBrown <neilb@suse.de> writes:

> Hi Andrew (and others)
>  I wonder if you would review the following for me and comment.
>
> Thanks,
> NeilBrown
>
>
>
> From e7f75c2a757108cdd83ce8c808a16bf27686c95f Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 17 Feb 2011 16:37:30 +1100
> Subject: [PATCH] Fix over-zealous flush_disk when changing device size.
>
> There are two cases when we call flush_disk.
> In one, the device has disappeared (check_disk_change) so any
> data will hold becomes irrelevant.
> In the oter, the device has changed size (check_disk_size_change)
> so data we hold may be irrelevant.
>
> In both cases it makes sense to discard any 'clean' buffers,
> so they will be read back from the device if needed.
>
> In the former case it makes sense to discard 'dirty' buffers
> as there will never be anywhere safe to write the data.  In the
> second case it *does*not* make sense to discard dirty buffers
> as that will lead to file system corruption when you simply enlarge
> the containing devices.
>
> flush_disk calls __invalidate_devices.
> __invalidate_device calls both invalidate_inodes and invalidate_bdev.
>
> invalidate_inodes *does* discard I_DIRTY inodes and this does lead
> to fs corruption.
>
> invalidate_bev *does*not* discard dirty pages, but I don't really care
> about that at present.
>
> So this patch adds a flag to __invalidate_device (calling it
> __invalidate_device2) to indicate whether dirty buffers should be
> killed, and this is passed to invalidate_inodes which can choose to
> skip dirty inodes.
>
> flusk_disk then passes true from check_disk_change and false from
> check_disk_size_change.
>
> dm avoids tripping over this problem by calling i_size_write directly
> rathher than using check_disk_size_change.
>
> md does use check_disk_size_change and so is affected.
>
> This regression was introduced by commit 608aeef17a
> which causes check_disk_size_change to call
> flush_disk.

This makes sense to me.  Nice write-up, Neil.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
