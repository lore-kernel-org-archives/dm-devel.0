From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 1/2] mempool: do not consume memory reserves from
 the reclaim path
Date: Mon, 18 Jul 2016 19:00:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1607181858020.16586@chino.kir.corp.google.com>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org> <1468831285-27242-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1468831285-27242-1-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Mel Gorman <mgorman@suse.de>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Michal Hocko <mhocko@suse.com>
List-Id: dm-devel.ids

On Mon, 18 Jul 2016, Michal Hocko wrote:

> David Rientjes was objecting that such an approach wouldn't help if the
> oom victim was blocked on a lock held by process doing mempool_alloc. This
> is very similar to other oom deadlock situations and we have oom_reaper
> to deal with them so it is reasonable to rely on the same mechanism
> rather inventing a different one which has negative side effects.
> 

Right, this causes oom livelock as described in the aforementioned thread: 
the oom victim is waiting on a mutex that is held by a thread doing 
mempool_alloc().  The oom reaper is not guaranteed to free any memory, so 
nothing on the system can allocate memory from the page allocator.

I think the better solution here is to allow mempool_alloc() users to set 
__GFP_NOMEMALLOC if they are in a context which allows them to deplete 
memory reserves.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
