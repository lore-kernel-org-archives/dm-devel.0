From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next dm-thinp regression due to "bio: skip
 atomic inc/dec of ->bi_remaining for non-chains"
Date: Thu, 14 May 2015 11:05:55 -0400
Message-ID: <20150514150554.GA21561@redhat.com>
References: <20150513192827.GA15831@redhat.com>
	<20150514024953.GA17947@redhat.com>
	<20150514032953.GB17947@redhat.com>
	<20150514075829.GA13656@quack.suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150514075829.GA13656@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, Robert Elliott <elliott@hp.com>, dm-devel@redhat.com, hch@lst.de, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On Thu, May 14 2015 at  3:58am -0400,
Jan Kara <jack@suse.cz> wrote:

> On Wed 13-05-15 23:29:53, Mike Snitzer wrote:
> > On Wed, May 13 2015 at 10:49pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> >  
> > > As you know commit c4cf5261 avoids the atomic operations during endio
> > > unless BIO_CHAIN is set.  It only gets set if bio_inc_remaining() is
> > > used.  But bio_inc_remaining() is only used _after_ the initial endio --
> > > we needed BIO_CHAIN set earlier for these cases.  Seems we need a new
> > > function to register the intent to cascade endios (to allow for proper
> > > accounting)?
> > > 
> > > We could then switch callers to something like:
> > > 
> > >   bio_set_chain(bio); // establishes BIO_CHAIN iff __bio_remaining is 1?
> > >   old = io->bi_end_io;
> > >   bio->bi_end_io = new;
> > > 
> > >  in new():
> > >   bio->bi_end_io = old;
> > >   bio_inc_remaining(bio)
> > > 
> > > Anyway, not sure about the proper fix -- I do know this commit is a
> > > definite regression (but it does nicely avoid the costly atomics ;)
> > 
> > Just adding this to dm-thin.c:save_and_set_endio() fixed it:
> >  bio->bi_flags |= (1 << BIO_CHAIN);
> > 
> > (setting a bit doesn't need a bio_set_chain fn like I suggested above).
> > 
> > But, all relevant callers would need this treatment (I'd imagine
> > bio_endio_nodec callers need help too? -- either that or __bi_remaining
> > is completely irrelevant for all old users except for bio_chain()).
>   From my mostly outsider view of block layer and dm, it seems that
> dm-thinp isn't really interested in bi_remaining value. It just needs
> bio_endio() to call the original completion function and to achieve that
> dm-thinp increments bi_remaining.

None of the existing users (including bio_endio_nodec) _really_ care
about the specifics of bi_remaining.  But they have to care because that
is how the implementation is.  It is unfortunate bi_remaining (or more
specifically the need to increment or not) was ever exposed to begin
with.

All these callers only ever care about their endio getting called.
 
> What we could do is the following:
> 1) bio_remaining_done() would clear BIO_CHAIN flag when __bi_remaining()
>    drops to 0. That way bio_endio() will end up calling ->bi_end_io() always
>    as soon as __bi_remaining drops to 0 or if bio was never chained. This
>    wouldn't be needed if nobody can chain on bios previously modified by
>    e.g. dm-thinp but AFAIU we cannot assume that.

Not completely following what you're proposing or how it helps fix this
regression considering 1) something will have needed to set BIO_CHAIN to
begin with (you're missing where that'd happen). 2) the entire intent
behind commit c4cf5261 is to optimize away the atomic operations.

So, given that is the intent.. do we just rip out all the callers' code
that tries to adjust __bi_remaining?

Then the only case that opts in to the BIO_CHAIN atomic operation
accounting is bio_chain().

> 2) remove bio_inc_remaining() from dm-thinp, dm-snap, dm-raid1,
>    dm-cache-target as they all look like situations where we only want newly
>    set bi_end_io function to be called by bio_endio().

Yes that is correct.

> 3) as a bonus bi_remaining handling is now fully inside block/bio.c and
>    bio_inc_remaining() can be static there.

Almost, we still have bio_endio_nodec() to deal with.  Which is the same
pattern as we've been discussing.  It just happens to be microoptimized
via api to:
1) reestablish the final endio
2) immediately call that final endio (rather than arm the bio to have
   endio called at a later time).

So I _think_ bio_endio_nodec() would go away completely.

The devil is in the details.  I'll have a go at implementing this and
see what falls out.

Thanks,
Mike
