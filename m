From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] md: simplify free_params for kmalloc vs vmalloc fallback
Date: Thu, 28 Apr 2016 17:28:12 +0200
Message-ID: <20160428152812.GM31489@dhcp22.suse.cz>
References: <1461849846-27209-20-git-send-email-mhocko@kernel.org>
 <1461855076-1682-1-git-send-email-mhocko@kernel.org>
 <alpine.LRH.2.02.1604281059290.14065@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1604281059290.14065@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu 28-04-16 11:04:05, Mikulas Patocka wrote:
> Acked-by: Mikulas Patocka <mpatocka@redhat.com>

Thanks!

> BTW. we could also use kvmalloc to complement kvfree, proposed here: 
> https://www.redhat.com/archives/dm-devel/2015-July/msg00046.html

If there are sufficient users (I haven't checked other than quick git
grep on KMALLOC_MAX_SIZE and there do not seem that many) who are
sharing the same fallback strategy then why not. But I suspect that some
would rather fallback earlier and even do not attempt larger than e.g.
order-1 requests.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
