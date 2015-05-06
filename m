From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [dm-devel] [PATCH stable] block: discard bdi_unregister() in
 favour of bdi_destroy()
Date: Wed, 6 May 2015 09:11:19 -0700
Message-ID: <CAA9_cmcNfpNAuJbVVbNN-cacVg4Dn-=VroUQ0T-PZz-j69S+iQ@mail.gmail.com>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150427141222.5dac22f1@notabene.brown>
	<CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
	<20150429072530.39d38b00@notabene.brown>
	<20150429133512.GA4436@lst.de>
	<20150429160258.GK17717@twins.programming.kicks-ass.net>
	<20150430103233.75227693@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430103233.75227693@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Azat Khuzhin <a3at.mail@gmail.com>, Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, nicholas.w.moulin@linux.intel.com
List-Id: dm-devel.ids

On Wed, Apr 29, 2015 at 5:32 PM, NeilBrown <neilb@suse.de> wrote:
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
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> ---
>
> Hi again Jens,
>  would you be able to queue this patch *before* the other one:
>    block: destroy bdi before blockdev is unregistered.
>
>  If it has to come after I'll need to re-write the text a bit.
>  If you could give me the commit hash to reference I'll do that.

Seems it is after:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=6cd18e71

Also, we gave both patches a try internally after seeing the duplicate
sysfs warning.  You can add:

Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>

...on the re-send.

Thanks Neil!
