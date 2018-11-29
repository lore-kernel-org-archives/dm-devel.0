From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] block: switch to per-cpu in-flight
	counters
Date: Thu, 29 Nov 2018 16:57:47 -0500
Message-ID: <20181129215746.GA9226@redhat.com>
References: <20181128004250.325095242@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181128004250.325095242@debian.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Tue, Nov 27 2018 at  7:42pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Now when part_round_stats is gone, we can switch to per-cpu in-flight
> counters.
> 
> We use the local-atomic type local_t, so that if part_inc_in_flight or
> part_dec_in_flight is reentrantly called from an interrupt, the value will
> be correct.
> 
> The other counters could be corrupted due to reentrant interrupt, but the
> corruption only results in slight counter skew - the in_flight counter
> must be exact, so it needs local_t.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  block/bio.c           |    4 ++--
>  block/blk-core.c      |    4 ++--
>  block/blk-merge.c     |    2 +-
>  block/genhd.c         |   47 +++++++++++++++++++++++++++++++++++------------
>  drivers/md/dm.c       |    4 +---
>  include/linux/genhd.h |    7 ++++---
>  6 files changed, 45 insertions(+), 23 deletions(-)
> 
...
> Index: linux-block/drivers/md/dm.c
> ===================================================================
> --- linux-block.orig/drivers/md/dm.c	2018-11-28 00:09:59.000000000 +0100
> +++ linux-block/drivers/md/dm.c	2018-11-28 00:09:59.000000000 +0100
> @@ -663,8 +663,7 @@ static void start_io_acct(struct dm_io *
>  	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
>  			      &dm_disk(md)->part0);
>  
> -	atomic_set(&dm_disk(md)->part0.in_flight[rw],
> -		   atomic_inc_return(&md->pending[rw]));
> +	atomic_inc(&md->pending[rw]);
>  
>  	if (unlikely(dm_stats_used(&md->stats)))
>  		dm_stats_account_io(&md->stats, bio_data_dir(bio),
> @@ -693,7 +692,6 @@ static void end_io_acct(struct dm_io *io
>  	 * a flush.
>  	 */
>  	pending = atomic_dec_return(&md->pending[rw]);
> -	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
>  	pending += atomic_read(&md->pending[rw^0x1]);
>  
>  	/* nudge anyone waiting on suspend queue */
> 


These dm.c hunks conflict with changes from you that I already staged in
dm-4.21, see:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=b5616f7a11592cc74860f4ec3e3c4fba6688eefa
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=78f95b53c203c969bbe6b86e405f7a891a43b6be

I'd really like to get away from DM maintaining its own ->pending
counters.

Mike
