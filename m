From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2 of 2] DM Snapshot: dont insert before
	existing chunk
Date: Thu, 24 Sep 2009 23:40:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909242329280.28511@hs20-bc2-1.build.redhat.com>
References: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
	<20090924124841.GI3866@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0909241007440.18846@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909241014500.18846@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids



On Thu, 24 Sep 2009, Mikulas Patocka wrote:

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
> 
> Mikulas

I was wrong about this.

If someone writes backwards, (from chunk 100 to 97), it will be allocated 
100->2, 99->3, 98->4, 97->5 and no back-merge will happen.

The backmerge will happen if the disk driver finishes the writes 
backwards: if someone writes to chunks 100-103, they get reallocated to 
2-5 and copying starts. If the disk driver finishes the copies backwards 
(it first finishes 103->5, then 102->4, then 101->3 and finally 100->2), 
the exceptions will be added in this order to the table and they'll be 
back-merged.

I think that disk shuffling writes is unlikely.

There was already a fix to make kcopyd not reorder writes 
(b673c3a8192e28f13e2050a4b82c1986be92cc15, 2.6.28).

On the other hand, merging could be implemented even without splitting 
(because the merge comes either from the beginning or from the end of the 
range), so we can go with backmerges.

Mikulas
