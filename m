From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Thu, 25 Jun 2020 14:40:17 +0200
Message-ID: <20200625124017.GL1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Thu 25-06-20 12:31:22, Matthew Wilcox wrote:
> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.

memalloc_nowait is a good idea! I suspect the primary usecase would be
vmalloc.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

[...]
> @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			unsigned nowait_flag = memalloc_nowait_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_nowait_restore(nowait_flag);

This looks confusing though. I am not familiar with alloc_buffer and
there is quite some tweaking around __GFP_NORETRY in alloc_buffer_data
which I do not follow but GFP_KERNEL just struck my eyes. So why cannot
we have 
		alloc_buffer(GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
-- 
Michal Hocko
SUSE Labs
