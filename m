From: Mark Hills <mark@pogo.org.uk>
Subject: Re: Another cache target
Date: Sat, 22 Dec 2012 18:50:09 +0000 (GMT)
Message-ID: <alpine.LNX.2.01.1212221831500.1242@localhost>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121214021918.GA29561@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

On Thu, 13 Dec 2012, Mike Snitzer wrote:

> On Thu, Dec 13 2012 at  8:16pm -0500,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > On Thu, Dec 13, 2012 at 04:57:15PM -0500, Mike Snitzer wrote:
> > > On Thu, Dec 13 2012 at  3:19pm -0500,
> > > Joe Thornber <ejt@redhat.com> wrote:
> > > 
> > > > Here's a cache target that Heinz Mauelshagen, Mike Snitzer and I
> > > > have been working on.
> > > > 
> > > > It's also available in the thin-dev branch of my git tree:
> > > > 
> > > > git@github.com:jthornber/linux-2.6.git
[...]
> > Also, I found a bug when using the mru policy.  If I do this:
> 
> Pretty sure you'd be best served to focus on the code Joe posted.  Maybe
> best to clone my github tree and start with my 'dm-for-3.8' branch.  And
> then apply all the patches Joe posted.

I also tried the other policies before reading the comment above. I wanted 
to see data more agressively copied to the cache device to see what 
happened.

Specifically, I tested lru and had an interesting problem. One which 
suggests it is not specific to the policy, but possibly to trigger quickly 
with it.

When mounting an ext4 filesystem with lru:

  attempt to access beyond end of device
  sdc1: rw=0, want=625140480, limit=625140400

(though an fsck completed fine)

Possibly the outcome of lru trying to cache the final block of the 
filesystem? Where, I presume, mq would not try and do this unless this 
block became a hot-spot.

The table used was:

  0 625140400 cache /dev/sdb1 /dev/sdb2 /dev/sdc1 256 1 writethrough lru 0

I tried both with a cache prepared using mq, and a clean cache -- where 
sdb1 and sdb2 have the first 4k blanked.

The code is the current dm-devel-cache (b910ac06) from 
git://github.com/snitm/linux.git
 
> I'd stick to the "default" policy -- aka "mq".

I tested mq, and had no problems whatsoever with stability (except where I 
modified the backing device and forgot to clear the cache.) I didn't yet 
do any performance test yet.

I look forward to being able to use this for general workstation use, and 
as storage for a simple (but large) hash-table database for an 
application.

Great stuff, thanks!

-- 
Mark
