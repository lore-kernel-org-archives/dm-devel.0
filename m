From: Dave Chinner <david@fromorbit.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Thu, 9 Apr 2009 09:44:08 +1000
Message-ID: <20090408234408.GA16929@discord.disaster>
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
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Wed, Apr 08, 2009 at 09:37:56AM -0400, Mikulas Patocka wrote:
> The used trick is basically to take a lock that prevents filesystem-wide 
> updates, submit remaining writes (don't wait), submit the barrier that 
> causes transition to new generation (don't wait) and release the lock. The 
> lock is held for minimum time, no IO is waited for inside the lock. This 
> trick can't be done without barriers, without barriers you'd have to wait 
> inside the lock.

Woo! You just described the technique XFS uses to guarantee
ordering of metadata and log IO (i.e. asynchronous barriers). ;)

> AFAIK this is the only piece of code that uses barriers to improve 
> performance. All the other filesystems use barriers just as a way to flush 
> cache and don't overlap barrier request with any other requests.

The problem is, disks often slow down when you issue barriers. It
doesn't matter what purpose you are using barriers for, they change
the order in which the disk would retire the I/O and hence that
changes performance. Issue enough barriers and performance will
drop noticably.

In the case of XFS, we need to guarantee ordering of every single
log write w.r.t. metadata writeback. Hence barriers are issued
relatively frequently (several a second) and so disks operate at
spindle speed rather than cache speed.  It is the frequency of
barrier IO that slows XFS down, not the way they are implemented.
Your technique will show exactly the same behaviour if you issue
barriers frequently enough.

Cheers,

Dave.
-- 
Dave Chinner
dgc@evostor.com
