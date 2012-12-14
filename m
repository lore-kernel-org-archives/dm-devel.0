From: thornber@redhat.com
Subject: Re: Another cache target
Date: Fri, 14 Dec 2012 10:24:43 +0000
Message-ID: <20121214102443.GB3022@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
	<20121214023425.GG9453@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121214023425.GG9453@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 06:34:25PM -0800, Darrick J. Wong wrote:
> Actually, I decided to try out "mru" and see what it would do (or not do).  My
> current theory is that mq doesn't seem to like putting blocks in the cache
> until after you write 'em(?)  There's no way to spit out the cache stats while
> it's running, so it's difficult to make observations.
> 
> The "exerciser" is called maxiops, from:
> http://djwong.org/programs/bogodisk/bogoseek-0.6.2.tar.gz
> 
> untar, make, ./maxiops /dev/somethingorother -b 4096
> 
> The third column of output is a rough estimate of iops.  maxiops is really just
> an aio port of bogoseek -n, which is in the same package.  If you want to do a
> destructive write test with them, pass -w.


The mq policy is very conservative, designed to slowly move frequently
accessed blocks into the cache.  I'm going to provide another policy
that's simpler, but much more aggressive about caching writes and
constantly cleaning blocks in the background.

There are a couple of reasons why mq may have decided not to cache
your blocks:

i) They just aren't being hit very frequently.

ii) It's decided that you're doing a big linear read/write, and so is
not updating it's hit stats.  Vivek Goyal put this code in for us and
it's been a big win in the testing I've done.  The rationale being
that spindles are often very good at doing v. large contiguous io.

The threshold for deciding what is linear/random io is configurable.

You may also want to experiment with discarding all data at the start
of your test (eg, as mkfs does).  In this case mq is aware that
promoting a block to the cache is very cheap because no copying is
needed, and as such will promote much sooner.

I'll add some tests to my test suite that use your maxiops program and
see if I can work out what's going on.

- Joe
