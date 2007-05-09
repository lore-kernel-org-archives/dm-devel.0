From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Wed, 9 May 2007 16:54:11 +0100
Message-ID: <20070509155411.GD18152@agk.fab.redhat.com>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
	<20070509064923.GO4163@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070509064923.GO4163@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, Heinz Mauelshagen <hjm@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 09, 2007 at 08:49:23AM +0200, Jens Axboe wrote:
> Besides, manual prefetching is very rarely a win. I dabbled with some
> benchmarks a few weeks back (with the doubly linked lists), and in most
> cases it was actually a loss. So I'd vote for just removing the
> prefetch() above.

OK.
 
Alasdair
-- 
agk@redhat.com
