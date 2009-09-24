From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2 of 2] DM Snapshot: dont insert before
	existing chunk
Date: Thu, 24 Sep 2009 10:21:40 -0400
Message-ID: <20090924142140.GA15619@redhat.com>
References: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
	<20090924124841.GI3866@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0909241007440.18846@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909241014500.18846@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909241014500.18846@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2009 at 10:15am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 24 Sep 2009, Mikulas Patocka wrote:
> 
> > On Thu, 24 Sep 2009, Alasdair G Kergon wrote:
> > 
> > > On Wed, Sep 23, 2009 at 10:25:08AM -0500, Jon Brassow wrote:
> > > > Don't insert into hash before an existing chunk.
> > > > Most inserts are after an existing extent anyway so this code is used
> > > > very rarely.
> > >  
> > > Again, I'm not particularly keen on taking this one.  Some systems are very
> > > short of memory and everything we can save matters and we have no statistics
> > > about how "rare" this actually is.
> > > 
> > > Is it really that difficult to split into two when removing?
> > 
> > It is code bloat --- it would increase coding/reviewing/testing time (the 
> > splitting would have to be simulated because it happens rarely).
> > 
> > Also, it could lead to the situation that memory consumption starts 
> > growing when merging.
> > 
> > Mikulas
> 
> These backmerges happen if someone writes to the logical volume backwards. 
> Do you know any common usage scenario that does it?

I was able to reliably reproduce backmerges simply by taking a snapshot
of a 32G LV and then formatting that origin with ext3.  This resulted in
a ~9% copy-out to the snapshot.

AFAIK mkfs.ext3 does write backwards for updating block groups.  In
practice it clearly does because without disabling the insertion before
other chunks I would reliably BUG in clear_exception (as I shared
earlier today on dm-devel).

Mike
