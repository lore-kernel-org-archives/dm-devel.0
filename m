From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:06:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271904320.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427214837.GF23302@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 27 Apr 2009, Alasdair G Kergon wrote:

> On Mon, Apr 20, 2009 at 04:01:11AM -0400, Mikulas Patocka wrote:
> > Flush supoprt for dm-delay target.
>  
> > @@ -281,6 +282,8 @@ static int delay_map(struct dm_target *t
> >  		bio->bi_bdev = dc->dev_write->bdev;
> >  		bio->bi_sector = dc->start_write +
> >  				 (bio->bi_sector - ti->begin);
> > +		if (!bio_sectors(bio))
> > +			bio->bi_sector = 0;
> 
> Why set bio->bi_sector twice on that path?
> Should we instead guarantee it's 0 before calling?

For non-barrier requests, it needs to be translated according to the 
table.

For zero-barrier request, it should be 0. (well, non-zero values may work, 
but I'm setting it zero, all other kernel code sets it to zero too).

> >  
> >  		return delay_bio(dc, dc->write_delay, bio);
> >  	}
> 
> Is flushing different - do we really want to delay it?
> (I'd have thought not.  But if so, should it be a separate option?)

Depending how you want it. I'd see it as a write and delay it as a write. 
If dm-delay is to be used for example for debugging, it should have a 
capability to delay all requests, including flushes.

> Alasdair
> -- 
> agk@redhat.com

Mikulas
