From: Christoph Hellwig <hch@lst.de>
Subject: Re: a fix and two cleanups around blk_stack_limits
Date: Mon, 20 Jul 2020 19:35:30 +0200
Message-ID: <20200720173530.GA21442@lst.de>
References: <20200720061251.652457-1-hch@lst.de> <dfe56cf2-db3d-3461-9834-be314f4080ef@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfe56cf2-db3d-3461-9834-be314f4080ef@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 20, 2020 at 10:56:23AM -0600, Jens Axboe wrote:
> On 7/20/20 12:12 AM, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series ensures that the zoned device limitations are properly
> > inherited in blk_stack_limits, and then cleanups up two rather
> > pointless wrappers around it.
> 
> We should probably make this against for-5.9/drivers instead, to avoid
> an unnecessary conflict when merging.

Then we'd also need a merge as my next series depends on this, and it
clearly is core material.  Not sure which one is more important.
