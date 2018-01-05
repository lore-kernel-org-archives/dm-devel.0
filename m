From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snapshot: use mutex instead of rw-semaphore
Date: Fri, 5 Jan 2018 17:52:20 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1801051751110.24998@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711231615160.2217@file01.intranet.prod.int.rdu2.redhat.com>
	<20180105202409.GA21622@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180105202409.GA21622@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 5 Jan 2018, Mike Snitzer wrote:

> On Thu, Nov 23 2017 at  4:15pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The rw-semaphore is acquired for read only on two places, none of them is
> > performance-critical. So, we can replace it with a mutex.
> 
> Can you expand on why you'd like to avoid using a rw_semaphore?  mutex
> being faster in the fast path?
> 
> Thanks,
> Mike

Mutex code is simpler. Mutex is used more often in the kernel than 
rw-semaphore, so using mutex causes less i-cache pollution.

Mikulas
