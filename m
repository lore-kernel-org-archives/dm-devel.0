From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] dm-mpath: convert to request-based
Date: Fri, 28 Aug 2009 09:36:38 -0400
Message-ID: <20090828133638.GA8377@redhat.com>
References: <4A24CD74.80708@ct.jp.nec.com> <4A24CEBD.8010807@ct.jp.nec.com>
	<20090827175419.GQ643@agk-dp.fab.redhat.com>
	<4A97646D.1000201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A97646D.1000201@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 28 2009 at  1:00am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Alasdair,
> 
> On 08/28/2009 02:54 AM +0900, Alasdair G Kergon wrote:
> > On Tue, Jun 02, 2009 at 04:03:25PM +0900, Kiyoshi Ueda wrote:
> >> This patch converts dm-multipath target to request-based from bio-based.
> >  
> > How much effort would it be to retain the old mpath implementation
> > in parallel?
> > 
> > I'm rather concerned that we're losing some useful functionality in
> > 2.6.31 with this patch - stacking over bio-based devices (test beds use
> > this and it's helpful for debugging), barrier support - and supporting
> > both would make it easier for people to compare the two implementations
> > and stick to the old one if in their particular circumstances it worked
> > better.
> > 
> > Perhaps, dm-mpath could just register two targets (like snapshot does),
> > one bio-based, and one rq-based, sharing most of the functions with
> > wrappers to indicate which is which where necessary?
> 
> Such wrappers need to be made very well to share codes as much as
> possible.  Otherwise, we won't be able to maintain the non-default
> (bio-based?) code, then people won't be able to use it even for
> testing/debugging.
> Also we need to consider the user interface so that user-space tools
> won't be confused.
> 
> I'll look into this when I finish the barrier implementation of
> request-based dm. (hopefully 2.6.32 timeframe, maybe 2.6.33)
> 
> By the way, only for testing/debugging purposes, making request-based
> error/linear targets (e.g. named like error_rq/linear_rq) may be an
> alternative.

As a stop-gap I'd imagine Linux's 'scsi_debug' could be used for testing
and debugging purposes.

Mike
