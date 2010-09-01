From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] dm: implement REQ_FLUSH/FUA support for bio-based dm
Date: Wed, 1 Sep 2010 09:54:34 -0400
Message-ID: <20100901135433.GB25251@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-3-git-send-email-tj@kernel.org>
 <20100901134343.GA25260@redhat.com>
 <4C7E5A38.9050001@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C7E5A38.9050001@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 01 2010 at  9:50am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 09/01/2010 03:43 PM, Mike Snitzer wrote:
> > On Mon, Aug 30 2010 at  5:58am -0400,
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> This patch converts bio-based dm to support REQ_FLUSH/FUA instead of
> >> now deprecated REQ_HARDBARRIER.
> >>
> >> * -EOPNOTSUPP handling logic dropped.
> > 
> > Can you expand on _why_ -EOPNOTSUPP handling is no longer needed?  And
> > please at it to the final patch header.
> 
> It just doesn't happen anymore.  If the underlying device doesn't
> support FLUSH/FUA, the block layer simply make those parts noop.  IOW,
> it no longer distinguishes between writeback cache which doesn't
> support cache flush at all and writethrough cache.  Devices which have
> WB cache w/o flush very difficult to come by these days and there's
> nothing much we can do anyway, so it doesn't make sense to require
> everyone to implement -EOPNOTSUPP.
> 
> One scheduled feature is to implement falling back to REQ_FLUSH when
> the device advertises REQ_FUA but fails to process it, but one way or
> the other, the goal is encapsulating REQ_FLUSH/FUA support in block
> layer proper.  If FLUSH/FUA can be retried using a different strategy,
> it should be done inside request_queue proper instead of pushing retry
> logic to all its users.

OK, so maybe add this info to the patch header one of the primary
FLUSH+FUA conversion patches?

Thanks for the detailed explanation!

Mike
