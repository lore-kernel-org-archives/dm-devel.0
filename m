From: David Rientjes <rientjes@google.com>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 17:01:37 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1607131659190.92037__22824.3912374184$1468499604$gmane$org@chino.kir.corp.google.com>
References: <57837CEE.1010609@redhat.com>
	<f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
	<9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
	<alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
	<20160712064905.GA14586@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
	<2d5e1f84-e886-7b98-cb11-170d7104fd13@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <e7b9aef7-41e2-92b1-8fe2-8109b6be7dbf@redhat.com>
In-Reply-To: <2d5e1f84-e886-7b98-cb11-170d7104fd13@I-love.SAKURA.ne.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Stanislav Kozina <skozina@redhat.com>
List-Id: dm-devel.ids

On Wed, 13 Jul 2016, Tetsuo Handa wrote:

> I wonder whether commit f9054c70d28bc214 ("mm, mempool: only set
> __GFP_NOMEMALLOC if there are free elements") is doing correct thing.
> It says
> 
>     If an oom killed thread calls mempool_alloc(), it is possible that it'll
>     loop forever if there are no elements on the freelist since
>     __GFP_NOMEMALLOC prevents it from accessing needed memory reserves in
>     oom conditions.
> 
> but we can allow mempool_alloc(__GFP_NOMEMALLOC) requests to access
> memory reserves via below change, can't we? The purpose of allowing
> ALLOC_NO_WATERMARKS via TIF_MEMDIE is to make sure current allocation
> request does not to loop forever inside the page allocator, isn't it?

This would defeat the purpose of __GFP_NOMEMALLOC for oom killed threads, 
so you'd need to demonstrate that isn't a problem for the current users 
and then change the semantics of the gfp flag.

> Why we need to allow mempool_alloc(__GFP_NOMEMALLOC) requests to use
> ALLOC_NO_WATERMARKS when TIF_MEMDIE is not set?
> 

mempool_alloc(__GFP_NOMEMALLOC) is forbidden.
