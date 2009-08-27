From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] expose dm-stripe target's topology I/O
	hints
Date: Thu, 27 Aug 2009 10:24:51 -0400
Message-ID: <20090827142451.GC29894@redhat.com>
References: <1250864238-4093-1-git-send-email-snitzer@redhat.com>
	<20090827131220.GN643@agk-dp.fab.redhat.com>
	<20090827141939.GB29894@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090827141939.GB29894@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thu, Aug 27 2009 at 10:19am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Aug 27 2009 at  9:12am -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Fri, Aug 21, 2009 at 10:17:18AM -0400, Mike Snitzer wrote:
> > > Add .io_hints to 'struct target_type' to allow the I/O hints portion of
> > > the 'struct queue_limits' to be set by each target.  Expose dm-stripe
> > > target's topology I/O hints.
> >  
> > Do you still think this should go into 2.6.31?
> 
> Yes, it is important.  Otherwise DM won't expose the proper I/O hints in
> /sys for a striped device.  This is bad because then higher-level tools
> won't be able to rely on that information to properly align ther data
> (e.g. mkfs.extX -E).
> 
> > If so, please supply a revised patch header that explains the benefits
> > of having the patch (and reference the new stuff in 2.6.31 that it
> > uses).
> > 
> > > +	limits->io_opt = chunk_size * sc->stripes;
> > 
> > blk_queue_io_opt() ?

Did you mean why not use blk_limits_io_opt()?
 
> Martin didn't expose such an interface because all existing code (both
> DM and MD) does not require anything beyond a simple assignment.  I
> worked with Martin to establish the blk_queue_io_min() precisely because
> DM needed to avoid duplicating the block layer's logic.  I think Martin
> stopped short of adding a symmetric wrapper for setting io_opt because
> he felt it was unnecessary.  But I could be mis-remembering.

To clarify further; I meant to say blk_limits_io_min() in my above
paragraph.  We don't have access to the queue (because target's don't
have a queue); we're working with 'struct queue_limits *limits'

Mike
