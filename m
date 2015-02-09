From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq crash with dm-multipath in for-3.20/core
Date: Mon, 9 Feb 2015 11:48:56 -0500
Message-ID: <20150209164855.GB1599@redhat.com>
References: <20150209163856.GA12781@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150209163856.GA12781@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 09 2015 at 11:38am -0500,
Dongsu Park <dongsu.park@profitbricks.com> wrote:

> Hi Jens,
> 
> during testing with the linux-block for-3.20/core branch, I hit a BUG
> like below. It's reproducible by running xfstests/xfs/279.
> 
> Bisecting showed that the first bad commit is 6d6285c45f5a ("block:
> require blk_rq_prep_clone() be given an initialized clone request").
> With reverting this commit, the crash disappears.
> The linux-dm's branch dm-for-3.20 works fine without crash too.
> 
> As pointed out already by Keith Busch in a thread, [1] that commit should
> not be there in the first place. Commit 102e38b1030e ("dm: split
> request structure out from dm_rq_target_io structure") from linux-dm tree
> [2] is going to move the blk_rq_init() call again to __clone_rq().
> 
> So that commit 6d6285c45f5a should be either reverted, or moved to
> linux-dm tree, doesn't it?
> 
> Cheers,
> Dongsu
> 
> [1] https://www.redhat.com/archives/dm-devel/2015-January/msg00171.html
> [2] https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=102e38b1030e883efc022dfdc7b7e7a3de70d1c5

Right, we're aware of this typo in 6d6285c45f5a.  Sorry about that, but
as you noted, once both the linux-block and linux-dm branches for 3.20
are merged all is back to working.

So we're planning to just leave the block commit as broken and let the
dm commit you noted fix it up.  In the end 3.20-rc1 will have a working
dm-multipath.

Mike
