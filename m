From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Wed, 8 Apr 2009 16:06:29 +0200
Message-ID: <20090408140629.GC5178@kernel.dk>
References: <20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk>
	<Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

On Wed, Apr 08 2009, Mikulas Patocka wrote:
> > > So I'm wondering why Linux developers designed a barrier interface with 
> > > complex specification, complex implementation and the interface is useless 
> > > to provide any request ordering and it's no better than q->issue_flush_fn 
> > > method or whatever was there beffore. Obviously, the whole barrier thing 
> > > was designed by a person who never used it in a filesystem.
> > 
> > That's not quite true, it was done in conjunction with file system
> > people.
> > ...
> > Nobody was interested in barriers when they were done. Nobody.
> 
> That's a contradiction :-)

So we have sunk to this level now, snip and edit citing?

> 
> Some times ago I wrote a piece of code that uses barriers for performance 
> enhancement 
> (http://artax.karlin.mff.cuni.cz/~mikulas/spadfs/download/spadfs-0.9.10.tar.gz).
> 
> The used trick is basically to take a lock that prevents filesystem-wide 
> updates, submit remaining writes (don't wait), submit the barrier that 
> causes transition to new generation (don't wait) and release the lock. The 
> lock is held for minimum time, no IO is waited for inside the lock. This 
> trick can't be done without barriers, without barriers you'd have to wait 
> inside the lock.
> 
> And the requirement for this code is that barriers are supported for the 
> whole lifetime of the filesystem --- which is what the Linux kernel 
> doesn't support! If barrier support is lost, consistency is damaged. 
> 
> With barriers, the code does [submit A, submit barrier B, submit C].
> If you don't have barriers, you must modify this sequence to: [submit A, 
> wait for A endio, submit B, wait for B endio, submit C]
> 
> --- and now you are getting the point why failing barriers can't ever work 
> --- by the time request B completes, you find out that the device lost 
> barrier support and you realize that you should have inserted the waits in 
> the past --- but it's too late, there is no way to insert them 
> retroactively.
> 
> AFAIK this is the only piece of code that uses barriers to improve 
> performance. All the other filesystems use barriers just as a way to flush 
> cache and don't overlap barrier request with any other requests.
> 
> So there are two ways:
> 
> - either support only what all in-kernel filesystems do. Using barrier 
> reqiests to flush hw cache. You can remove support for barriers with data, 
> leave just zero-data barrier, you can remove ordering restrictions. 
> In-kernel filesystems never overlap barrier with another metadata request 
> (see above why such overlap can't work), so you can freely reorder 
> zero-data barriers and simplify the code ... because all the requests that 
> could be submitted in paralel with the barrier are either for different 
> partition or non-metadata requests to the same partition from prefetch, 
> direct io or so.
> 
> - or you can allow barriers to be used for purposes as I did. And then, 
> there must be clean indicator "this device supports barriers 
> *and*will*support*them*in*the*future*". Currently there is no such 
> indicator.

I'm about to leave, so I wont comment on the above. But the below is
basically what we pretend right now, and I think that is perfectly fine.
If you go and reconfigure your device and it suddenly doesn't support
barriers anymore, call the doctor and tell him that your foot hurts when
you slam it in the door. Don't do that, it's pretty simple. We already
agreed to kill the -EOPNOTSUPP and just pretend it always works, with a
notifier that we MAY not be safe. Not much point in harping the same
thing over and over again.

-- 
Jens Axboe
