From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Fri, 26 Jun 2020 11:02:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
prevents both filesystem recursion and i/o recursion.

Note that any I/O can recurse into a filesystem via the loop device, thus 
it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
and PF_MEMALLOC_NOIO is not set.

Mikulas

On Thu, 25 Jun 2020, Matthew Wilcox (Oracle) wrote:

> I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> for an upcoming patch series, and Jens also wants it for non-blocking
> io_uring.  It turns out we already have dm-bufio which could benefit
> from memalloc_nowait, so it may as well go into the tree now.
> 
> The biggest problem is that we're basically out of PF_ flags, so we need
> to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> out the PF_ flags are really supposed to be used for flags which are
> accessed from other tasks, and the MEMALLOC flags are only going to
> be used by this task.  So shuffling everything around frees up some PF
> flags and generally makes the world a better place.
> 
> Patch series also available from
> http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
> 
> Matthew Wilcox (Oracle) (6):
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
>   mm: Add become_kswapd and restore_kswapd
>   xfs: Convert to memalloc_nofs_save
>   mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
>   mm: Add memalloc_nowait
> 
>  drivers/block/loop.c           |  3 +-
>  drivers/md/dm-bufio.c          | 30 ++++--------
>  drivers/md/dm-zoned-metadata.c |  5 +-
>  fs/iomap/buffered-io.c         |  2 +-
>  fs/xfs/kmem.c                  |  2 +-
>  fs/xfs/libxfs/xfs_btree.c      | 14 +++---
>  fs/xfs/xfs_aops.c              |  4 +-
>  fs/xfs/xfs_buf.c               |  2 +-
>  fs/xfs/xfs_linux.h             |  6 ---
>  fs/xfs/xfs_trans.c             | 14 +++---
>  fs/xfs/xfs_trans.h             |  2 +-
>  include/linux/sched.h          |  7 +--
>  include/linux/sched/mm.h       | 84 ++++++++++++++++++++++++++--------
>  kernel/sys.c                   |  8 ++--
>  mm/vmscan.c                    | 16 +------
>  15 files changed, 105 insertions(+), 94 deletions(-)
> 
> -- 
> 2.27.0
> 
