From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Wed, 23 Sep 2020 20:39:02 -0400
Message-ID: <20200924003902.GA10500@redhat.com>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 25 2020 at  7:31am -0400,
Matthew Wilcox (Oracle) <willy@infradead.org> wrote:

> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
>  include/linux/sched.h    |  1 +
>  include/linux/sched/mm.h | 12 ++++++++----
>  3 files changed, 17 insertions(+), 26 deletions(-)


Hi,

Curious on the state of this patchset?  Not seeing it in next-20200923

The dm-bufio cleanup looks desirable.

Thanks,
Mike
