From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 14:27:15 +0000
Message-ID: <20081110142715.GD16649@agk.fab.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 10, 2008 at 08:54:01AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > For upstream Linux developers: you are holding a spinlock and calling 
> > bdi*_congested functions that can take indefinite amount of time (there 
> > are even users reporting having 50 disks in one logical volume or so). I 
> > think it would be good to move these calls out of spinlocks.
> Umm, they shouldn't block that long, as that completely defeats their
> purpose.  

Indeed - the blocking was a bug for which there's a patch, but that doesn't
deal with how the function should be operating in the first place.

- If one device is found to be congested, why bother checking the remaining
devices?

- If the device is suspended, the response should be that it is congested, I'd
have thought.

Alasdair
-- 
agk@redhat.com
