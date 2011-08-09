From: Tejun Heo <tj@kernel.org>
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Date: Tue, 9 Aug 2011 19:55:09 +0200
Message-ID: <20110809175509.GF23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
 <20110809175237.GA978@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110809175237.GA978@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 09, 2011 at 01:52:37PM -0400, Vivek Goyal wrote:
> > +	/*
> > +	 * All FLUSH/FUA requests are expected to have gone through the
> > +	 * flush machinary.  If a request's cmd_flags doesn't match the
> > +	 * flush_flags of the underlying request_queue it is a bug.
> > +	 */
> > +	BUG_ON((rq->cmd_flags & REQ_FLUSH) && !(q->flush_flags & REQ_FLUSH));
> > +	BUG_ON((rq->cmd_flags & REQ_FUA) && !(q->flush_flags & REQ_FUA));
> > +
> 
> Actually this makes sense and is simple. :-) Is BUG_ON() too harsh, how
> about WARN_ONCE() variants? To me system continues to work so warning 
> is probably good enough.

I don't really think this is the right thing to do.  It makes the
cloning a special case.  It looks easy now but puts it in its own
special box which usually ends up ugly in the long run.  Let's get the
thing fixed and let it play like others do.  There's nothing
fundamentally broken with the usual mechanism.

Thanks.

-- 
tejun
