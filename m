From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Date: Tue, 9 Aug 2011 15:05:09 -0400
Message-ID: <20110809190509.GA31927@redhat.com>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
 <20110809175237.GA978@redhat.com>
 <20110809185531.GC13293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110809185531.GC13293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 09, 2011 at 02:55:31PM -0400, Mike Snitzer wrote:

[..]
> > > +	/*
> > > +	 * All FLUSH/FUA requests are expected to have gone through the
> > > +	 * flush machinary.  If a request's cmd_flags doesn't match the
> > > +	 * flush_flags of the underlying request_queue it is a bug.
> > > +	 */
> > > +	BUG_ON((rq->cmd_flags & REQ_FLUSH) && !(q->flush_flags & REQ_FLUSH));
> > > +	BUG_ON((rq->cmd_flags & REQ_FUA) && !(q->flush_flags & REQ_FUA));
> > > +
> > 
> > Actually this makes sense and is simple. :-) Is BUG_ON() too harsh, how
> > about WARN_ONCE() variants? To me system continues to work so warning 
> > is probably good enough.
> 
> Sure, WARN_ONCE() is fine by me.
> 
> Seems Tejun wants a more involved fix though.

Fixing it properly doesn't hurt. Makes it more future proof. In fact I am
thinking what happens to blk_execute_rq() variants where one can prepare a
request and send it down. What if caller sets FLUSH/FUA flags there.

Thanks
Vivek
