From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 09:40:18 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811100933520.16965@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
	<20081110142715.GD16649@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081110142715.GD16649@agk.fab.redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 10 Nov 2008, Alasdair G Kergon wrote:

> On Mon, Nov 10, 2008 at 08:54:01AM -0500, Christoph Hellwig wrote:
> > On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > > For upstream Linux developers: you are holding a spinlock and calling 
> > > bdi*_congested functions that can take indefinite amount of time (there 
> > > are even users reporting having 50 disks in one logical volume or so). I 
> > > think it would be good to move these calls out of spinlocks.
> > Umm, they shouldn't block that long, as that completely defeats their
> > purpose.  
> 
> Indeed - the blocking was a bug for which there's a patch, but that doesn't
> deal with how the function should be operating in the first place.

To me it looks like the bug is more severe --- holding a reference to 
table can happen in other upcalls too and in many other dm places.

I'm considering if we could call the table destructor just at one place 
(that would wait until all references are gone), instead of calling the 
destructor at each dm_table_put point (there are many of these points and 
it's hard to check all of them for correctness).

> - If one device is found to be congested, why bother checking the remaining
> devices?

Yes, that could be improved. But it doesn't solve the O(n) problem.

> - If the device is suspended, the response should be that it is 
> congested, I'd have thought.

Yes, but these congestion upcalls are used only for optimization and the 
device is suspended for so small time, that it doesn't matter if we 
optimize io acces in small moment or not.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 
