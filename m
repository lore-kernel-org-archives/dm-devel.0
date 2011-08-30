From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters]  new dm-bufio
Date: Tue, 30 Aug 2011 01:27:55 -0400
Message-ID: <20110830052755.GA30730@infradead.org>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
	<Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
	<20110830014906.GJ3162@dastard>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110830014906.GJ3162@dastard>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 30, 2011 at 11:49:06AM +1000, Dave Chinner wrote:
> 
> It's a relic from the days of Irix that we've kept around and never
> really touched because it's never shown up as a problem. Such code
> is cleaned up as we go along or as problems arise.
> 
> As it is, this patchset:
> 
> http://thread.gmane.org/gmane.linux.kernel.mm/67326
> 
> that I'm currently working on changes the shrinker API to be much
> more sane - the shrinker now has a separate "count objects"
> operation and the "scan objects" operation now returns the number of
> items freed rather than the number of items left in the cache.

I think if you find bugs like that they should be in patches separate
from the main conversion.  Especially given that the 3.2 merge window
is getting closer a first batch of patches with these fixes and some
of the preparatory icache/dcache changes that can go into linux-next
ASAP would be nice.
