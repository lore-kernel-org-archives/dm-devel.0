From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v3 0/6] dm snapshot: Improve performance using a more
 fine-grained locking scheme
Date: Wed, 20 Mar 2019 15:06:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1903201506020.17844@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190317122258.21760-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317122258.21760-1-ntsironis@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, paulmck@linux.ibm.com, hch@infradead.org, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Acked-by: Mikulas Patocka <mpatocka@redhat.com>



On Sun, 17 Mar 2019, Nikos Tsironis wrote:

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
>   1. The first patch removes an unnecessary use of WRITE_ONCE() in
>      hlist_add_behind().
> 
>   2. The second patch adds two helper functions to linux/list_bl.h,
>      which is used to implement the per-bucket bit spinlocks in
>      dm-snapshot.
> 
>   3. The third patch removes the need to sleep holding the snapshot lock
>      in pending_complete(), thus allowing us to replace the mutex with
>      the per-bucket bit spinlocks.
> 
>   4. Patches 4, 5 and 6 change the locking scheme, as described
>      previously.
> 
> Changes in v3:
>   - Don't use WRITE_ONCE() in hlist_bl_add_behind(), as it's not needed.
>   - Fix hlist_add_behind() to also not use WRITE_ONCE().
>   - Use uintptr_t instead of unsigned long in hlist_bl_add_before().
> 
> v2: https://www.redhat.com/archives/dm-devel/2019-March/msg00007.html
> 
> Changes in v2:
>   - Split third patch of v1 into three patches: 3/5, 4/5, 5/5.
> 
> v1: https://www.redhat.com/archives/dm-devel/2018-December/msg00161.html
> 
> Nikos Tsironis (6):
>   list: Don't use WRITE_ONCE() in hlist_add_behind()
>   list_bl: Add hlist_bl_add_before/behind helpers
>   dm snapshot: Don't sleep holding the snapshot lock
>   dm snapshot: Replace mutex with rw semaphore
>   dm snapshot: Make exception tables scalable
>   dm snapshot: Use fine-grained locking scheme
> 
>  drivers/md/dm-exception-store.h |   3 +-
>  drivers/md/dm-snap.c            | 359 +++++++++++++++++++++++++++-------------
>  include/linux/list.h            |   2 +-
>  include/linux/list_bl.h         |  26 +++
>  4 files changed, 269 insertions(+), 121 deletions(-)
> 
> -- 
> 2.11.0
> 
