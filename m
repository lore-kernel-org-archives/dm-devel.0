From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] md: simplify free_params for kmalloc vs vmalloc
 fallback
Date: Thu, 28 Apr 2016 11:40:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1604281129360.14065@file01.intranet.prod.int.rdu2.redhat.com>
References: <1461849846-27209-20-git-send-email-mhocko@kernel.org> <1461855076-1682-1-git-send-email-mhocko@kernel.org> <alpine.LRH.2.02.1604281059290.14065@file01.intranet.prod.int.rdu2.redhat.com> <20160428152812.GM31489@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160428152812.GM31489@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 28 Apr 2016, Michal Hocko wrote:

> On Thu 28-04-16 11:04:05, Mikulas Patocka wrote:
> > Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Thanks!
> 
> > BTW. we could also use kvmalloc to complement kvfree, proposed here: 
> > https://www.redhat.com/archives/dm-devel/2015-July/msg00046.html
> 
> If there are sufficient users (I haven't checked other than quick git
> grep on KMALLOC_MAX_SIZE

the problem is that kmallocs with large sizes near KMALLOC_MAX_SIZE are 
unreliable, they'll randomly fail if memory is too fragmented.

> and there do not seem that many) who are
> sharing the same fallback strategy then why not. But I suspect that some
> would rather fallback earlier and even do not attempt larger than e.g.
> order-1 requests.
> -- 
> Michal Hocko
> SUSE Labs

There are many users that use one of these patterns:

	if (size <= some_threshold)
		p = kmalloc(size);
	else
		p = vmalloc(size);

or

	p = kmalloc(size);
	if (!p)
		p = vmalloc(size);


For example: alloc_fdmem, seq_buf_alloc, setxattr, getxattr, ipc_alloc, 
pidlist_allocate, get_pages_array, alloc_bucket_locks, 
frame_vector_create. If you grep the kernel for vmalloc, you'll find this 
pattern over and over again.

In alloc_large_system_hash, there is
	table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
- that is clearly wrong because __vmalloc doesn't respect GFP_ATOMIC

Mikulas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
