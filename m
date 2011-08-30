From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters]  new dm-bufio
Date: Tue, 30 Aug 2011 11:49:06 +1000
Message-ID: <20110830014906.GJ3162@dastard>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
	<Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 29, 2011 at 02:53:51PM -0400, Mikulas Patocka wrote:
> On Tue, 23 Aug 2011, Christoph Hellwig wrote:
> 
> > FYI, the "shrinker" interface in include/linux/shrinker.h is how the
> > VM tells subsystems to shrink their memory usage.  It is used for
> > various slab caches, and the XFS buffercache in
> > fs/xfs/linux-2.6/xfs_buf.c
> 
> BTW. shrinker functions from xfs_qm.c - xfs_qm_shake and 
> xfs_qm_shake_freelist - look completely bogus. They don't read 
> sc->nr_to_scan to determine how many values they should scan (and compare 
> it with zero to test if they should scan at all) and they return the 
> number of entries freed - the interface specifies that they should return 
> the number of entries remaining the in cache.

It's a relic from the days of Irix that we've kept around and never
really touched because it's never shown up as a problem. Such code
is cleaned up as we go along or as problems arise.

As it is, this patchset:

http://thread.gmane.org/gmane.linux.kernel.mm/67326

that I'm currently working on changes the shrinker API to be much
more sane - the shrinker now has a separate "count objects"
operation and the "scan objects" operation now returns the number of
items freed rather than the number of items left in the cache.

As the API is being changed, the xfs_qm shrinker is also fixed to
return the right values according to the new API. It still doesn't
pay attention to nr_to_scan, but that's not a big deal and will get
addressed in future when other upcoming changes are made to the
code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
