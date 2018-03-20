From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Tue, 20 Mar 2018 10:35:12 -0700
Message-ID: <20180320173512.GA19669@bombadil.infradead.org>
References: <alpine.LRH.2.02.1803200954590.18995@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803200954590.18995@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: dm-devel.ids

On Tue, Mar 20, 2018 at 01:25:09PM -0400, Mikulas Patocka wrote:
> The reason why we need this is that we are going to merge code that does 
> block device deduplication (it was developed separatedly and sold as a 
> commercial product), and the code uses block sizes that are not a power of 
> two (block sizes 192K, 448K, 640K, 832K are used in the wild). The slab 
> allocator rounds up the allocation to the nearest power of two, but that 
> wastes a lot of memory. Performance of the solution depends on efficient 
> memory usage, so we should minimize wasted as much as possible.

The SLUB allocator also falls back to using the page (buddy) allocator
for allocations above 8kB, so this patch is going to have no effect on
slub.  You'd be better off using alloc_pages_exact() for this kind of
size, or managing your own pool of pages by using something like five
192k blocks in a 1MB allocation.
