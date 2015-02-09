From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq crash with dm-multipath in for-3.20/core
Date: Mon, 9 Feb 2015 12:13:12 -0500
Message-ID: <20150209171311.GC1599@redhat.com>
References: <20150209163856.GA12781@posteo.de>
 <20150209164855.GB1599@redhat.com>
 <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 09 2015 at 12:07pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Mon, 9 Feb 2015, Mike Snitzer wrote:
> >On Mon, Feb 09 2015 at 11:38am -0500,
> >Dongsu Park <dongsu.park@profitbricks.com> wrote:
> >>So that commit 6d6285c45f5a should be either reverted, or moved to
> >>linux-dm tree, doesn't it?
> >>
> >>Cheers,
> >>Dongsu
> >>
> >>[1] https://www.redhat.com/archives/dm-devel/2015-January/msg00171.html
> >>[2] https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=102e38b1030e883efc022dfdc7b7e7a3de70d1c5
> >
> >Right, we're aware of this typo in 6d6285c45f5a.  Sorry about that, but
> >as you noted, once both the linux-block and linux-dm branches for 3.20
> >are merged all is back to working.
> >
> >So we're planning to just leave the block commit as broken and let the
> >dm commit you noted fix it up.  In the end 3.20-rc1 will have a working
> >dm-multipath.
> 
> Oh, we're not going rebase the series with the correction? I'm concerned
> someone biscecting a completely unrelated problem might step on this
> commit. Up to you guys. It's my fault, so I'll deal with the consequences.

Rebasing this late (3.20 merge already opened) is generally not done.
Unfortunately we'll just have to suck it up and deal with the fallout
during bisect -- would wager very few are bisecting with multipath as
the focus of their test.
