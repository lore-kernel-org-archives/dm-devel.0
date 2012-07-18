From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/3] dm-thin: fix discard_granularity
Date: Wed, 18 Jul 2012 15:10:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207181453070.8618@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434550.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161435230.3859@file.rdu.redhat.com>
	<20120717153140.GA18345@redhat.com>
	<Pine.LNX.4.64.1207171519120.26839@file.rdu.redhat.com>
	<20120717215200.GA20338@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120717215200.GA20338@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo.bonzini@lu.unisi.ch, dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Tue, 17 Jul 2012, Vivek Goyal wrote:

> On Tue, Jul 17, 2012 at 03:35:04PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 17 Jul 2012, Mike Snitzer wrote:
> > 
> > > On Mon, Jul 16 2012 at  2:35pm -0400,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > > dm-thin: fix discard_granularity
> > > > 
> > > > The kernel expects that limits->discard_granularity is a power of two.
> > > > Set this limit only if we use a power of two block size.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > 
> > > > ---
> > > >  drivers/md/dm-thin.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-3.5-rc6-fast/drivers/md/dm-thin.c
> > > > ===================================================================
> > > > --- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 20:07:49.000000000 +0200
> > > > +++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-16 20:08:01.000000000 +0200
> > > > @@ -2502,7 +2502,8 @@ static void set_discard_limits(struct po
> > > >  	 * bios cover a block partially.  A discard that spans a block boundary
> > > >  	 * is not sent to this target.
> > > >  	 */
> > > > -	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
> > > > +	if (pool->sectors_per_block_shift >= 0)
> > > > +		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
> > > >  	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
> > > >  }
> > > 
> > > Given the block layer's assumption that discard_granularity is always a
> > > power of 2: thinp should disable discard if the thinp blocksize is a non
> > > power of 2.  So this patch isn't correct (discard support should be
> > > disabled in pool_ctr based on the specified blocksize).
> > 
> > discard_granularity is just a hint (and IMHO quite useless hint).
> > 
> > The documentation says that it indicates a size of internal allocation 
> > unit that may be larger than the block size. The code doesn't use it this 
> > way - it is used in FITRIM ioctl where it specifies the minimum request 
> > size to be sent. It is also used in blkdev_issue_discard where it is used 
> > to round down the number of sectors to discard on discard_granularity 
> > boundary - this is wrong, it aligns request size on discard_granularity 
> > boundary, but it doesn't align request start on this boundary.
> 
> I am not sure I understand completely what you are trying to say.

I mean that it is used inconsistently - sometimes it is used as s minimum 
request to be sent (requests smaller than discard_granularity are not 
sent). And sometimes length is rounded down to discard_granularity 
boundary.

> But
> after paolo's patch, blkdev_issue_discard() will take into account
> max_discard_sectors to limit max discard request size and use
> discard_granularity and discard_alignment to determine aligned request start.

The question is - how are we supposed to propagate these parameters 
through linearly appended devices, raid0, raid1 or other mappings?

For example, if you have a logical volume that consists of two linearly 
appended disks, disk1 with discard_granularity1,discard_alignment1 and 
disk2 with discard_granularity2,discard_alignment2 - tell me, how do you 
calculate discard_granularity and discard_alignment for the combined 
logical device from these four numbers? How do you calculate it if those 
two disks are in raid0 or raid1?

It seems to me that would be much better to state that discard request 
size is unlimited and break one long discard to several smaller discard 
requests at the physical disk driver - then, the problem with combining 
the limits would go away.

> First request in the range will go as it is and can be unaligned but if
> discard range is big, then rest of the request start will be aligned.
> 
> Because there might be an unligned requests at the start of range drivers
> will still have to handle unaligned requests, i think.
> 
> Thanks
> Vivek

Mikulas
