From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 4/6] block: switch to per-cpu in-flight
	counters
Date: Wed, 5 Dec 2018 10:30:38 -0700
Message-ID: <d6a741cd-ea75-19d0-13e3-eb1321e617b4@kernel.dk>
References: <20181130222226.77216-1-snitzer@redhat.com>
	<20181130222226.77216-5-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181130222226.77216-5-snitzer@redhat.com>
Content-Language: en-US
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 11/30/18 3:22 PM, Mike Snitzer wrote:
> diff --git a/block/genhd.c b/block/genhd.c
> index cdf174d7d329..d4c9dd65def6 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -45,53 +45,76 @@ static void disk_add_events(struct gendisk *disk);
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
> +	local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);

I mentioned this in a previous email, but why isn't this just using
this_cpu_inc? There's also no need to pass in the cpu, if we're not
running with preempt disabled already we have a problem.

-- 
Jens Axboe
