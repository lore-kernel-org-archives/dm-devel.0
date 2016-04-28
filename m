From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] md: simplify free_params for kmalloc vs vmalloc fallback
Date: Thu, 28 Apr 2016 18:59:34 +0200
Message-ID: <20160428165934.GQ31489@dhcp22.suse.cz>
References: <1461849846-27209-20-git-send-email-mhocko@kernel.org>
 <1461855076-1682-1-git-send-email-mhocko@kernel.org>
 <alpine.LRH.2.02.1604281059290.14065@file01.intranet.prod.int.rdu2.redhat.com>
 <20160428152812.GM31489@dhcp22.suse.cz>
 <alpine.LRH.2.02.1604281129360.14065@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1604281129360.14065@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu 28-04-16 11:40:59, Mikulas Patocka wrote:
[...]
> There are many users that use one of these patterns:
> 
> 	if (size <= some_threshold)
> 		p = kmalloc(size);
> 	else
> 		p = vmalloc(size);
> 
> or
> 
> 	p = kmalloc(size);
> 	if (!p)
> 		p = vmalloc(size);
> 
> 
> For example: alloc_fdmem, seq_buf_alloc, setxattr, getxattr, ipc_alloc, 
> pidlist_allocate, get_pages_array, alloc_bucket_locks, 
> frame_vector_create. If you grep the kernel for vmalloc, you'll find this 
> pattern over and over again.

It is certainly good to address a common pattern by a helper if it makes
to code easier to follo IMHO.

> 
> In alloc_large_system_hash, there is
> 	table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
> - that is clearly wrong because __vmalloc doesn't respect GFP_ATOMIC

I have seen this code some time already. I guess it was Al complaining
about it but then I just forgot about it. I have no idea why GFP_ATOMIC
was used there. This predates git times but it should be
https://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.10/2.6.10-mm1/broken-out/alloc_large_system_hash-numa-interleaving.patch
The changelog is quite verbose but no mention about this ugliness.

So I do agree that the above should be fixed and a common helper might
be interesting but I am afraid we are getting off topic here.

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
