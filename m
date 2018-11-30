From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] block: switch to per-cpu in-flight
	counters
Date: Fri, 30 Nov 2018 16:44:33 -0500
Message-ID: <20181130214433.GA15049@redhat.com>
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
> Index: linux-block/block/genhd.c
> ===================================================================
> --- linux-block.orig/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
> +++ linux-block/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
> @@ -45,53 +45,76 @@ static void disk_add_events(struct gendi
>  static void disk_del_events(struct gendisk *disk);
>  static void disk_release_events(struct gendisk *disk);
>  
> -void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
> +void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
>  {
>  	if (queue_is_mq(q))
>  		return;
>  
> -	atomic_inc(&part->in_flight[rw]);
> +	local_inc(per_cpu_ptr(part->dkstats, cpu)->in_flight);
>  	if (part->partno)
> -		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
> +		local_inc(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
>  }
>  
> -void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
> +void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
>  {
>  	if (queue_is_mq(q))
>  		return;
>  
> -	atomic_dec(&part->in_flight[rw]);
> +	local_dec(per_cpu_ptr(part->dkstats, cpu)->in_flight);
>  	if (part->partno)
> -		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
> +		local_dec(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
>  }


The above is wrong, needs this incremental fix:

diff --git a/block/genhd.c b/block/genhd.c
index 2ed431098953..3397288a2926 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -50,9 +50,9 @@ void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part
 	if (queue_is_mq(q))
 		return;
 
-	local_inc(per_cpu_ptr(part->dkstats, cpu)->in_flight);
+	local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
 	if (part->partno)
-		local_inc(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
+		local_inc(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
 }
 
 void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
@@ -60,9 +60,9 @@ void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part
 	if (queue_is_mq(q))
 		return;
 
-	local_dec(per_cpu_ptr(part->dkstats, cpu)->in_flight);
+	local_dec(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
 	if (part->partno)
-		local_dec(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
+		local_dec(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
 }
 
 unsigned int part_in_flight(struct request_queue *q, struct hd_struct *part)
