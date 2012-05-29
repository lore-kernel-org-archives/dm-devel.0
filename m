From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v3 05/16] block: Kill bi_destructor
Date: Mon, 28 May 2012 22:10:42 -0400
Message-ID: <20120529021042.GA6472@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-6-git-send-email-koverstreet@google.com>
 <20120528013608.GE9891@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120528013608.GE9891@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Mon, May 28, 2012 at 10:36:08AM +0900, Tejun Heo wrote:
> On Fri, May 25, 2012 at 01:25:28PM -0700, Kent Overstreet wrote:
> > Now that we've got generic code for freeing bios allocated from bio
> > pools, this isn't needed anymore.
> > 
> > This also changes the semantics of bio_free() a bit - it now also frees
> > bios allocated by bio_kmalloc(). It's also no longer exported, as
> > without bi_destructor there should be no need for it to be called
> > anywhere else.
> 
> I like this patch but I'd *really* like to see the patch description
> giving some background and explains *why* this is a good change.

Heh. Well, in my view deleting stuff is good by default, and if you can
delete things without user visible effects and without making the code
more complicated... 

So I guess given the simplicity of this particular patch in the series
I'm not sure what there is to justify here. Any suggestions on what
would make sense to put in...?

> 
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index 6b7daf3..b6ddbf1 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -74,11 +74,8 @@ struct bio {
> >  	struct bio_integrity_payload *bi_integrity;  /* data integrity */
> >  #endif
> >  
> > -	/* If bi_pool is non NULL, bi_destructor is not called */
> >  	struct bio_set		*bi_pool;
> 
> Maybe explain that %NULL bi_pool indicates kmalloc backed allocation?

Yeah, I'll update that comment.
