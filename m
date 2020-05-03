From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Possible null pointer dereference in __rh_alloc()
Date: Sun, 3 May 2020 14:38:20 +0100
Message-ID: <20200503133820.GA14134@agk-dp.fab.redhat.com>
References: <CAFSR4cuCx-wGOAVPUPh8+V4FqDP2Nvac0OeQL6onG89JnZTpyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFSR4cuCx-wGOAVPUPh8+V4FqDP2Nvac0OeQL6onG89JnZTpyQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Dongyang Zhan <zdyzztq@gmail.com>
Cc: dm-devel@redhat.com, "M: Mike Snitzer" <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, May 03, 2020 at 03:02:21PM +0800, Dongyang Zhan wrote:
>  I am a security researcher, my name is Dongyang Zhan. I found a potential bug in
>  /drivers/md/dm-region-hash.c in Linux 4.10.17. I hope you can help me to confirm it.
>  __rh_alloc() in /drivers/md/dm-region-hash.c mishandles the memory allocation failures of nreg.
>  Source code:
>  struct dm_region *reg, *nreg;
>  nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
>  if (unlikely(!nreg))
>                  nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
>  nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
>                  DM_RH_CLEAN : DM_RH_NOSYNC;
>  If the statement (nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);) fails,
>  dereferencing this pointer (nreg->state) will cause null pointer dereference.

 * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block
 * indefinitely but will never return with failure. Testing for
 * failure is pointless.

Alasdair
