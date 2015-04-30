From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH stable] block: discard bdi_unregister() in favour of
 bdi_destroy()
Date: Thu, 30 Apr 2015 10:35:03 +0200
Message-ID: <20150430083503.GU5029@twins.programming.kicks-ass.net>
References: <20150414171537.GH25394@azat>
 <20150423160551.45345f96@notabene.brown>
 <20150427141222.5dac22f1@notabene.brown>
 <CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
 <20150429072530.39d38b00@notabene.brown>
 <20150429133512.GA4436@lst.de>
 <20150429160258.GK17717@twins.programming.kicks-ass.net>
 <20150430103233.75227693@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150430103233.75227693@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 30, 2015 at 10:32:33AM +1000, NeilBrown wrote:
> 
> bdi_unregister() now contains very little functionality.
> 
> It contains a "WARN_ON" if bdi->dev is NULL.  This warning is of no
> real consequence as bdi->dev isn't needed by anything else in the function,
> and it triggers if
>    blk_cleanup_queue() -> bdi_destroy()
> is called before bdi_unregister, which a subsequent patch will make happen.
> So this isn't wanted.
> 
> It also calls bdi_set_min_ratio().  This needs to be called after
> writes through the bdi have all been flushed, and before the bdi is destroyed.
> Calling it early is better than calling it late as it frees up a global
> resource.
> 
> Calling it immediately after bdi_wb_shutdown() in bdi_destroy()
> perfectly fits these requirements.
> 
> So bdi_unregister can be discarded with the important content moved to
> bdi_destroy, as can the
>   writeback_bdi_unregister
> event which is already not used.
> 
> This is tagged for 'stable' as it is a pre-requisite for a subsequent
> patch which moves calls to blk_cleanup_queue() before calls to
> del_gendisk().  The commit identified as 'Fixes' removed a lot of
> other functionality from bdi_unregister(), and made a change which
> necessitated moving the blk_cleanup_queue() calls.
> 
> Reported-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org (v4.0)
> Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37

Fixes: c4db59d31e39 ("fs: don't reassign dirty inodes to default_backing_dev_info")

> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
