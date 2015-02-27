From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm-snapshot: suspend merging snapshot
 when doing exception handover
Date: Fri, 27 Feb 2015 14:23:12 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502271421410.32344@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502261140380.13050@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1502261140380.13050@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 26 Feb 2015, Mikulas Patocka wrote:

> There was a bug when that resulted in a crash when there were pending
> exceptions and snapshot exception store handover was performed at the
> same time - and there was a patch that fixed it.
> 
> However, a similar problem exists in snapshot merging. When snapshot
> merging is in progress, we use the target "snapshot-merge" instead of
> "snapshot-origin". Consequently, during exception store handover, we must
> find the snapshot-merge target and suspend it's associated md.
> 
> To avoid lockdep warnings, the target must be suspended and resumed
> without holding _origins_lock.
> 
> This patch introduces a function dm_hold that grabs a reference on
> mapped_device, but unlike dm_get, it doesn't crash if the devices has the
> flag DMF_FREEING, it returns and error in this case.
> 
> In snapshot_resume we grab the reference to the origin device using
> dm_hold while holding _origins_lock (_origins_lock guarantees that the
> device won't disappear). Then we release _origins_lock, suspend the
> device and grab _origins_lock again.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I forgot to add

Cc: stable@vger.kernel.org

When backporting to kernels 3.18 and older, use dm_internal_suspend and 
dm_internal_resume instead of dm_internal_suspend_fast and 
dm_internal_resume_fast.

Mikulas
