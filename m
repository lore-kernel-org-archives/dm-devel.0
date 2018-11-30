From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: return just one value from
	part_in_flight
Date: Thu, 29 Nov 2018 19:30:18 -0500
Message-ID: <20181130003018.GB10015@redhat.com>
References: <20181128004251.504425345@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181128004251.504425345@debian.vm>
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

> The previous patches deleted all the code that needed the second value
> returned from part_in_flight - now the kernel only uses the first value.
> 
> Consequently, part_in_flight (and blk_mq_in_flight) may be changed so that
> it only returns one value.
> 
> This patch just refactors the code, there's no functional change.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  block/blk-mq.c            |    6 ++++--
>  block/blk-mq.h            |    3 +--
>  block/genhd.c             |   32 +++++++++++---------------------
>  block/partition-generic.c |    6 +++---
>  include/linux/genhd.h     |    3 +--
>  5 files changed, 20 insertions(+), 30 deletions(-)
> 
> Index: linux-block/block/blk-mq.c
> ===================================================================
> --- linux-block.orig/block/blk-mq.c	2018-11-28 00:39:16.000000000 +0100
> +++ linux-block/block/blk-mq.c	2018-11-28 00:39:16.000000000 +0100
> @@ -113,13 +113,15 @@ static bool blk_mq_check_inflight(struct
>  	return true;
>  }
>  
> -void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
> -		      unsigned int inflight[2])
> +unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part)
>  {
> +	unsigned inflight[2];
>  	struct mq_inflight mi = { .part = part, .inflight = inflight, };
>  
>  	inflight[0] = inflight[1] = 0;
>  	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
> +
> +	return inflight[0];
>  }


I don't think this change goes deep enough.  You're leaving unnecessary
work (relative to mi->inflight[1]) in blk_mq_check_inflight().

Mike
