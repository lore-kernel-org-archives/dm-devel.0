From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq IO merging
 via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 11:58:32 -0500
Message-ID: <20180117165832.GA5573@redhat.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
 <45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at 11:50am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/17/18 9:25 AM, Mike Snitzer wrote:
> > Hi Jens,
> > 
> > Think this finally takes care of it! ;)
> > 
> > Thanks,
> > Mike
> > 
> > Mike Snitzer (2):
> >   blk-mq: factor out a few helpers from __blk_mq_try_issue_directly
> >   blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request
> > 
> > Ming Lei (1):
> >   blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback
> 
> Applied - added actual commit message to patch 3.

Great, thanks.
