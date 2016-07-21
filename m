From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 1/2] mempool: do not consume memory reserves from the
 reclaim path
Date: Thu, 21 Jul 2016 08:13:00 -0400
Message-ID: <20160721121300.GA21806@cmpxchg.org>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org>
 <1468831285-27242-1-git-send-email-mhocko@kernel.org>
 <20160719135426.GA31229@cmpxchg.org>
 <alpine.DEB.2.10.1607191315400.58064@chino.kir.corp.google.com>
 <20160720081541.GF11249@dhcp22.suse.cz>
 <alpine.DEB.2.10.1607201353230.22427@chino.kir.corp.google.com>
 <20160721085202.GC26379@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160721085202.GC26379@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Mel Gorman <mgorman@suse.de>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 21, 2016 at 10:52:03AM +0200, Michal Hocko wrote:
> Look, there are
> $ git grep mempool_alloc | wc -l
> 304
> 
> many users of this API and we do not want to flip the default behavior
> which is there for more than 10 years. So far you have been arguing
> about potential deadlocks and haven't shown any particular path which
> would have a direct or indirect dependency between mempool and normal
> allocator and it wouldn't be a bug. As the matter of fact the change
> we are discussing here causes a regression. If you want to change the
> semantic of mempool allocator then you are absolutely free to do so. In
> a separate patch which would be discussed with IO people and other
> users, though. But we _absolutely_ want to fix the regression first
> and have a simple fix for 4.6 and 4.7 backports. At this moment there
> are revert and patch 1 on the table.  The later one should make your
> backtrace happy and should be only as a temporal fix until we find out
> what is actually misbehaving on your systems. If you are not interested
> to pursue that way I will simply go with the revert.

+1

It's very unlikely that decade-old mempool semantics are suddenly a
fundamental livelock problem, when all the evidence we have is one
hang and vague speculation. Given that the patch causes regressions,
and that the bug is most likely elsewhere anyway, a full revert rather
than merely-less-invasive mempool changes makes the most sense to me.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
