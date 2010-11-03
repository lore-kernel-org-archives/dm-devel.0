From: Tejun Heo <tj@kernel.org>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 03 Nov 2010 10:46:22 +0100
Message-ID: <4CD12F6E.8040501@kernel.org>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101102220207.GD23680@redhat.com>
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
Cc: Christophe Saout <christophe@saout.de>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hello, Mike.

On 11/02/2010 11:02 PM, Mike Snitzer wrote:
> 1) scale down the number of workqueue threads associated with N devices
>    (w/ 2 workqueue threads per device) so that the number of threads is
>    reasonable ("reasonable" is TBD but I'd imagine it doesn't buy us a
>    lot to have 2 single thread workqueues dedicated to each dm-crypt
>    device).
> 
>    [seems dm-crypt will already get this "for free" using
>     create_singlethread_workqueue's WQ_UNBOUND?]

Workqueues no longer need dedicated worker threads for usual cases.
Dedicated threads are only necessary to guarantee forward progress
under memory pressure.  So, unless dm crypts are stacked, there only
needs to be one rescuer.  If dm crypts are stacked, you would need
single workqueue w/ WQ_MEM_RECLAIM set at each level.  If figuring
that out is too cumbersome, it might make sense to use one per
instance tho.

Also, unless you need strict execution ordering of queued works,
there's no reason to use alloc_ordered_workqueue().  It probably is a
better idea to use non-reentrant workqueue.  I'm not quite sure
whether using unbound would be better or not tho.

> 2) scale up the number of workqueue threads used for a single dm-crypt
>    device so that a device can realize per-cpu concurrency (to address
>    Andi's scalability concerns: https://patchwork.kernel.org/patch/244031/)
> 
>    [the desired locality is currently missing due to dm-crypt's current
>     use of WQ_UNBOUND; so it is clear the way the workqueues are created
>     will be important]

I don't know enough about dm-crypt workload to tell whether per-cpu
affinity would be better or not, but it's really a simple matter of
adding or omitting WQ_UNBOUND, so playing with it is very easy.  I
think the flags to use would be WQ_MEM_RECLAIM | WQ_NON_REENTRANT |
WQ_CPU_INTENSIVE (| WQ_UNBOUND).

I wish I could be more helpful but I would need a bit more details.
If you have some design on mind, please let me know.

Thanks.

-- 
tejun
