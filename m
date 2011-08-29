From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: new dm-bufio
Date: Mon, 29 Aug 2011 14:53:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110823185423.GA10936@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 23 Aug 2011, Christoph Hellwig wrote:

> FYI, the "shrinker" interface in include/linux/shrinker.h is how the
> VM tells subsystems to shrink their memory usage.  It is used for
> various slab caches, and the XFS buffercache in
> fs/xfs/linux-2.6/xfs_buf.c

BTW. shrinker functions from xfs_qm.c - xfs_qm_shake and 
xfs_qm_shake_freelist - look completely bogus. They don't read 
sc->nr_to_scan to determine how many values they should scan (and compare 
it with zero to test if they should scan at all) and they return the 
number of entries freed - the interface specifies that they should return 
the number of entries remaining the in cache.

Mikulas
