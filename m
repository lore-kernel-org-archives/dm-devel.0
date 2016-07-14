From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: System freezes after OOM
Date: Thu, 14 Jul 2016 20:01:27 +0900
Message-ID: <201607142001.BJD07258.SMOHFOJVtLFOQF__38884.2561086223$1468499602$gmane$org@I-love.SAKURA.ne.jp>
References: <20160713133955.GK28723@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607131004340.31769@file01.intranet.prod.int.rdu2.redhat.com>
	<20160713145638.GM28723@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607131105080.31769@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.10.1607131644590.92037@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <b737d58a-24b3-13a9-bac5-ece7f556047c@redhat.com>
In-Reply-To: <alpine.DEB.2.10.1607131644590.92037@chino.kir.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rientjes@google.com, mpatocka@redhat.com
Cc: skozina@redhat.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, okozina@redhat.com, jmarchan@redhat.com
List-Id: dm-devel.ids

Michal Hocko wrote:
> OK, this is the part I have missed. I didn't realize that the swapout
> path, which is indeed PF_MEMALLOC, can get down to blk code which uses
> mempools. A quick code travers shows that at least
> 	make_request_fn = blk_queue_bio
> 	blk_queue_bio
> 	  get_request
> 	    __get_request
> 
> might do that. And in that case I agree that the above mentioned patch
> has unintentional side effects and should be re-evaluated. David, what
> do you think? An obvious fixup would be considering TIF_MEMDIE in
> mempool_alloc explicitly.

TIF_MEMDIE is racy. Since the OOM killer sets TIF_MEMDIE on only one thread,
there is no guarantee that TIF_MEMDIE is set to the thread which is looping
inside mempool_alloc(). And since __GFP_NORETRY is used (regardless of
f9054c70d28bc214), out_of_memory() is not called via __alloc_pages_may_oom().
This means that the thread which is looping inside mempool_alloc() can't
get TIF_MEMDIE unless TIF_MEMDIE is set by the OOM killer.

Maybe set __GFP_NOMEMALLOC by default at mempool_alloc() and remove it
at mempool_alloc() when fatal_signal_pending() is true? But that behavior
can OOM-kill somebody else when current was not OOM-killed. Sigh...

David Rientjes wrote:
> On Wed, 13 Jul 2016, Mikulas Patocka wrote:
> 
> > What are the real problems that f9054c70d28bc214b2857cf8db8269f4f45a5e23 
> > tries to fix?
> > 
> 
> It prevents the whole system from livelocking due to an oom killed process 
> stalling forever waiting for mempool_alloc() to return.  No other threads 
> may be oom killed while waiting for it to exit.

Is that concern still valid? We have the OOM reaper for CONFIG_MMU=y case.
