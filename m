From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 0/5] dm snapshot: Improve performance
 using a more fine-grained locking scheme
Date: Sun, 3 Mar 2019 16:16:12 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903031614310.26093@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190301165151.1352-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190301165151.1352-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids


Acked-by: Mikulas Patocka <mpatocka@redhat.com>


On Fri, 1 Mar 2019, Nikos Tsironis wrote:

> dm-snapshot uses a single mutex to serialize every access to the
> snapshot state, including accesses to the exception hash tables. This
> mutex is a bottleneck preventing dm-snapshot to scale as the number of
> threads doing IO increases.
> 
> The major contention points are __origin_write()/snapshot_map() and
> pending_complete(), i.e., the submission and completion of pending
> exceptions.
> 
> This patchset substitutes the single mutex with:
> 
>   * A read-write semaphore, which protects the mostly read fields of the
>     snapshot structure.
> 
>   * Per-bucket bit spinlocks, that protect accesses to the exception
>     hash tables.
> 
> fio benchmarks using the null_blk device show significant performance
> improvements as the number of worker processes increases. Write latency
> is almost halved and write IOPS are nearly doubled.
> 
> The relevant patch provides detailed benchmark results.
> 
> A summary of the patchset follows:
> 
>   1. The first patch adds two helper functions to linux/list_bl.h, which
>      is used to implement the per-bucket bit spinlocks in dm-snapshot.
> 
>   2. The second patch removes the need to sleep holding the snapshot
>      lock in pending_complete(), thus allowing us to replace the mutex
>      with the per-bucket bit spinlocks.
> 
>   3. The third patch changes the locking scheme, as described previously.
> 
> Changes in v2:
>   - Split third patch of v1 into three patches: 3/5, 4/5, 5/5.
> 
> v1: https://www.redhat.com/archives/dm-devel/2018-December/msg00161.html
> 
> Nikos Tsironis (5):
>   list_bl: Add hlist_bl_add_before/behind helpers
>   dm snapshot: Don't sleep holding the snapshot lock
>   dm snapshot: Replace mutex with rw semaphore
>   dm snapshot: Make exception tables scalable
>   dm snapshot: Use fine-grained locking scheme
> 
>  drivers/md/dm-exception-store.h |   3 +-
>  drivers/md/dm-snap.c            | 359 +++++++++++++++++++++++++++-------------
>  include/linux/list_bl.h         |  27 +++
>  3 files changed, 269 insertions(+), 120 deletions(-)
> 
> -- 
> 2.11.0
> 
