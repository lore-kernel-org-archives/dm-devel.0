From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 09:19:21 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081110135401.GA11606@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 10 Nov 2008, Christoph Hellwig wrote:

> On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > For upstream Linux developers: you are holding a spinlock and calling 
> > bdi*_congested functions that can take indefinite amount of time (there 
> > are even users reporting having 50 disks in one logical volume or so). I 
> > think it would be good to move these calls out of spinlocks.
> 
> Umm, they shouldn't block that long, as that completely defeats their
> purpose.  These functions are mostly used to avoid throwing more I/O at
> a congested device if pdflush could do more useful things instead.  But
> if it blocks in those functions anyway we wouldn't have to bother using
> them.  Do you have more details about the uses cases when this happens
> and where the routines spend so much time?

For device mapper, congested_fn asks every device in the tree and make OR 
of their bits --- so if the user has 50 devices, it asks them all.

For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
same --- asking every device.

If you have a better idea how to implement congested_fn, say it.

Mikulas
