From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 12:22:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110171218130.21071@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017111128.GF13963@ubuntu>
	<Pine.LNX.4.64.1110171004290.14928@hs20-bc2-1.build.redhat.com>
	<20111017140947.GA10136@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111017140947.GA10136@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 17 Oct 2011, Joe Thornber wrote:

> On Mon, Oct 17, 2011 at 10:05:26AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 17 Oct 2011, Joe Thornber wrote:
> > 
> > > On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> > > @@ -493,8 +500,10 @@ static void use_inline_bio(struct dm_buf
> > >  static void submit_io(struct dm_buffer *b, int rw, sector_t block,
> > >                       bio_end_io_t *end_io)
> > >  {
> > > -       if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
> > > -           b->data_mode != DATA_MODE_VMALLOC)
> > > +       if (rw == WRITE && b->c->write_callback)
> > > +               b->c->write_callback(b);
> > >         if (likely(b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE) &&
> > >             likely(b->data_mode != DATA_MODE_VMALLOC))
> > >                 use_inline_bio(b, rw, block, end_io);
> > >         else
> > >                 use_dmio(b, rw, block, end_io);
> > > @@ -550,8 +559,6 @@ static void __write_dirty_buffer(struct
> > >         clear_bit(B_DIRTY, &b->state);
> > >         wait_on_bit_lock(&b->state, B_WRITING,
> > >                          do_io_schedule, TASK_UNINTERRUPTIBLE);
> > > -       if (b->c->write_callback)
> > > -               b->c->write_callback(b);
> > >         submit_io(b, WRITE, b->block, write_endio);
> > >  }
> > > 
> > > 
> > > This doesn't seem an improvement.  Except ... it changes the behaviour
> > > of dm_bufio_release_move().  So was there a preexisting bug in
> > > dm_bufio_release_move() that you're trying to fix with this patch?
> > 
> > The actual reason was to do this callback in dm_bufio_release_move() too 
> > --- just for consistency. (the user of dm_bufio_release_move() doesn't use 
> > write_callback anyway).
> 
> thinp uses dm_bufio_release_move() and write_callback.  So yes, this
> is a bug fix.  I thought so and merged.

BTW. it still uses the old block number in "prepare_for_write" callback. 
Do you use this block number somewhere? Should we link the buffer to the 
new block before the call and the link it back?

Mikulas

> - Joe
> 
