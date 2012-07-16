From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: questions about dm-thin and discard
Date: Mon, 16 Jul 2012 15:51:01 -0400
Message-ID: <20120716195100.GB7988@redhat.com>
References: <Pine.LNX.4.64.1207161302450.22760@file.rdu.redhat.com>
	<20120716180141.GA7988@redhat.com>
	<Pine.LNX.4.64.1207161426070.3859@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207161426070.3859@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 16 2012 at  2:32pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 16 Jul 2012, Mike Snitzer wrote:
> 
> > On Mon, Jul 16 2012 at  1:14pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi Joe
> > > 
> > > I would like to ask you about this code path: In process_discard, there is 
> > > a branch with a comment "This path is hit if people are ignoring 
> > > limits->discard_granularity." It trims the discard request so that it 
> > > doesn't span a block boundary and submits it.
> > > 
> > > The question is: what if the block is shared? In this case, we can't 
> > > submit discard to the block, because it would damage the other snapshot 
> > > that is sharing this block. Shouldn't there be shomething like this?
> > > if ((!lookup_result.shared) & pool->pf.discard_passdown) {
> > > 	remap_and_issue(tc, bio, lookup_result.block);
> > > } else {
> > > 	bio_endio(bio, 0) 
> > > } 
> > > ... or is it tested elsewhere and am I missing something?
> > 
> > in process_discard:
> > 
> >  m->pass_discard = (!lookup_result.shared) && pool->pf.disard_passdown;
> > 
> > then in process_prepared_discard:
> > 
> >  if (m->pass_discard)
> >         remap_and_issue(tc, m->bio, m->data_block);
> >  else
> >         bio_endio(m->bio, 0);
> 
> This is called in process_discard if io_overlaps_block returns true. But 
> if io_overlaps_block returns false, this check is not done. There is: 
> 
> cell_release_singleton(cell, bio);
> cell_release_singleton(cell2, bio); 
> remap_and_issue(tc, bio, lookup_result.block);
> 
> ... remap_and_issue calls remap (which just changes bio->bi_bdev and 
> bio->bi_sector) and issue (which calls generic_make_request) - so we issue 
> discard to a potentially shared block here.

That is a fair point, it does look like there should be a check for
sharing.  But I could be missing something implicit with the bio prison
code (though I don't think I am).

> > > Another question is about setting "ti->discards_supported = 1" in 
> > > pool_ctr. ti->discards_supported means that the target supports discards 
> > > even if the underlying disk doesn't. Since the pool device is passing 
> > > anyth I/O unchanged to the underlying disk, ti->discards_supported 
> > > shouldn't be set. Or is there any other reason why is it set?
> > 
> > The thin device's bios will be remapped to the pool device.
> > 
> > process_prepared_discard's remap_and_issue() will send the bio to the
> > pool device via generic_make_request().
> 
> If the underlying device doesn't support discards, there is no poin in 
> setting "ti->discards_supported = 1" on the pool device. You should set 
> "ti->discards_supported = 1" should be set on the thin device because thin 
> supports discards even if the underlying disk doesn't. But pool doesn't 
> support discards if the underlying disk doesn't, so it shouldn't be set.

The pool only sets "ti->discards_supported = 1" if (pf.discard_enabled
&& pf.discard_passdown).

The comment provides some insight:
  /*                                                                                    
   * Setting 'discards_supported' circumvents the normal                                                                                    
   * stacking of discard limits (this keeps the pool and                                                                                    
   * thin devices' discard limits consistent).                                                                                    
   */

All being said, there is currently a disconnect on the discard limits
that are imposed for thin/pool devices vs what the underlying
data device's discard limits are.  So "circumvents the normal stacking"
is treated as a feature here but it really is suspect in my view.  I
just haven't circled back to look at this area closer yet.

Mike
