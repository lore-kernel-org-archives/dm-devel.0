From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: disallow changing max_sectors_kb on a request
 stacking device
Date: Mon, 7 Nov 2016 16:27:34 -0500
Message-ID: <20161107212732.GA28478@redhat.com>
References: <20161028194549.14556-1-snitzer@redhat.com>
 <20161107164029.GA27464@redhat.com>
 <20161107192646.GA11572@redhat.com>
 <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Mon, Nov 07 2016 at  2:32pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/07/2016 12:26 PM, Mike Snitzer wrote:
> >Otherwise users can easily shoot themselves in the foot by creating the
> >situation where the top-level stacked device (e.g. DM multipath) has a
> >larger max_sectors_kb than the underlying device(s).  Which will
> >certainly lead to IO errors due to the "over max size limit" check in
> >blk_cloned_rq_check_limits().
> >
> >This is a crude, yet effective, solution that forces the use of system
> >software (e.g. udev rules or multipathd) to tweak max_sectors_kb of the
> >underlying devices _before_ a layer like DM multipath is layered ontop.
> 
> Maybe I'm missing something, but the code we have in place splits it
> into max sectors for software and hardware. Shouldn't the stacked
> devices have max_hw_sectors capped to what the lower levels support? If
> that was done, we would not have to worry about a user fiddling with
> max_sectors_kb, since it could only be smaller (or equal to) the max
> size of the lower level.

DM multipath just uses blk_stack_limits() to stack limits, which has:

        t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
        t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
        t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);

But I assume you realize that.. I'm just missing the relation you're
saying exists, or should exist, between max_hw_sectors and max_sectors
(other than the obvious: max_sectors cannot be greater than
max_hw_sectors) as they relate to stacking.

You're suggesting that when the DM multipath device's limits are stacked
up from the underlying devices: cap the mpath's max_hw_sectors to the
underlying devices' max_sectors?
