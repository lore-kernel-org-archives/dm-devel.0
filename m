From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm-thin: fix discard support
Date: Tue, 17 Jul 2012 10:49:21 -0400
Message-ID: <20120717144920.GB15180@redhat.com>
References: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434550.3859@file.rdu.redhat.com>
	<20120717132605.GA11031@redhat.com>
	<20120717135841.GA15180@redhat.com>
	<Pine.LNX.4.64.1207171012190.12449@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207171012190.12449@file.rdu.redhat.com>
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
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 17 2012 at 10:18am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 17 Jul 2012, Mike Snitzer wrote:
> 
> > On Tue, Jul 17 2012 at  9:26am -0400,
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Mon, Jul 16, 2012 at 02:35:18PM -0400, Mikulas Patocka wrote:
> > > > dm-thin: fix discard support
> > > > 
> > > > There is a bug in dm_thin regarding processing discards.
> > > > When dm-thin receives a discard request with size equal to block size
> > > > that is not aligned on block size boundary, io_overlaps_block returns
> > > > true, process_discard treats this discard as a full block discard,
> > >   ^^^^
> > > > deletes the full block - the result is that some data that shouldn't be
> > > > discarded are discarded.
> > > 
> > > Looking at io_overlaps_block(), it looks like it will return false (and
> > > not true) for bios which are not aligned to block size boundary.
> > > 
> > > static int io_overlaps_block(struct pool *pool, struct bio *bio)
> > > {
> > >         return !(bio->bi_sector & pool->offset_mask) &&
> > >                 (bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT));
> > > 
> > > }
> > > 
> > > Hence for block which crosses block size boundary, we should be sending
> > > discard down for partial block as per the current code and no harm should
> > > be done?
> > 
> > Right, not sure why Mikulas read that as it'd return true.
> 
> The patch refers to the patchset that will be sent out for the next 
> kernel: http://people.redhat.com/agk/patches/linux/editing/series.html
> 
> In the current 3.5-rc code unaligned discard is partially ignored. In the 
> patchset it causes wrong data to be discarded.

Alasdair should reorder the patches then.  Your thinp discard changes
should come before the patch with the io_overlaps_block optimization
(that optimization causes it to return true for this case).

> > > > This patch sets the variable "ti->split_discard_requests", so that
> > > > device mapper core splits discard requests on a block boundary.
> > > > 
> > > > Consequently, a discard request that spans multiple blocks is never sent
> > > > to dm-thin. The patch also removes some code in process_discard that
> > > > deals with discards that span multiple blocks.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > 
> > > > ---
> > > >  drivers/md/dm-thin.c |   18 +++++++-----------
> > > >  1 file changed, 7 insertions(+), 11 deletions(-)
> > > > 
> > > > Index: linux-3.5-rc6-fast/drivers/md/dm-thin.c
> > > > ===================================================================
> > > > --- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 18:46:18.000000000 +0200
> > > > +++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-16 20:07:19.000000000 +0200
> > > > @@ -1246,17 +1246,10 @@ static void process_discard(struct thin_
> > > >  			}
> > > >  		} else {
> > > >  			/*
> > > > -			 * This path is hit if people are ignoring
> > > > -			 * limits->discard_granularity.  It ignores any
> > > > -			 * part of the discard that is in a subsequent
> > > > -			 * block.
> > > > +			 * The dm makes sure that the discard doesn't span
> > > > +			 * a block boundary. So we submit the discard
> > > > +			 * to the appropriate block.
> > > >  			 */
> > > > -			sector_t offset = pool->sectors_per_block_shift >= 0 ?
> > > > -			      bio->bi_sector & (pool->sectors_per_block - 1) :
> > > > -			      bio->bi_sector - block * pool->sectors_per_block;
> > > > -			unsigned remaining = (pool->sectors_per_block - offset) << SECTOR_SHIFT;
> > > > -			bio->bi_size = min(bio->bi_size, remaining);
> > > > -
> > > 
> > > So previous code will also send down partial block discard and this code
> > > will also send down partial discard. So nothing has changed from
> > > functionality point of view?
> > 
> > The change is the bit that you trimmed:
> > 
> > ti->split_discard_requests = 1;
> > 
> > That will restrict the size of the discard to be on a blocksize
> > boundary.
> > 
> > But I'm really not sure we want to impose such small discards -- though
> 
> Because the code can't handle large discards --- it trims them to a block 
> boundary and sends the trimmed request to the first chunk.

Yeap, fair enough.

> > the current thinp code does have a problem with discards that are too
> > large (I need to dig up specifics that Joe conveyed to me a few weeks
> > back; I was asking: "why cannot the thinp device have discard limits
> > that match the underlying data device's discard limits?").
> > 
> > <snitm> why not just rely on the max of the underlying device?
> > <ejt> we have to quiesce the blocks we'e about to discard
> > <snitm> e.g. remove the explicit override for max_bytes in set_discard_limits?
> > <ejt> no, it's not simple at all.
> > <ejt> have to be very careful we can service the discard in bounded memory
> > <snitm> so you don't think thinp can handle processing what the hardware can?
> > <ejt> not yet; I'd need to change the bio_prison to be able to lock
> > ranges of blocks, not just single ones.  And add a btree_trim method to
> > prune a btree.
> 
> When Joe implements this, ti->split_discard_requests could be cleared.

Sure, I'm fine with this.
