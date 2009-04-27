From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:09:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427220644.GG23302@agk.fab.redhat.com>
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

> On Mon, Apr 27, 2009 at 10:48:37PM +0100, Alasdair G Kergon wrote:
> > On Mon, Apr 20, 2009 at 04:01:11AM -0400, Mikulas Patocka wrote:
> > > Flush supoprt for dm-delay target.
> > > @@ -281,6 +282,8 @@ static int delay_map(struct dm_target *t
> > >  		bio->bi_sector = dc->start_write +
> > >  				 (bio->bi_sector - ti->begin);
> 
> In fact, does bi_sector have a meaningful value within
> the context of a specific target any more when processing
> a barrier flush, or is it a bug if a target attempts to access it?
> (For example, it could be set to ti->begin or 0.)
> 
> I think the situation deserves defining in a comment.
> 
> (Maybe we will remove "- ti->begin" from all the mapping functions one day.
> Not mixed in with this patch set though.)

The code is correct as it is.

For example, if you have first 10 sectors mapped on linear target and next 
sectors mapped on delay target, you must subtract 10 from the value 
(-ti->begin) and add the start offset dc->start_write.

If you map the whole device as one target, this is meaningless. But if you 
map more targets into one table, this arithmetics is required.

The difference is the zero-barrier flush request --- it should have 
bi_sector always 0.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 
