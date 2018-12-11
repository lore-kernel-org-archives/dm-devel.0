From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix inflight IO check
Date: Mon, 10 Dec 2018 19:32:05 -0500
Message-ID: <20181211003204.GA14673@redhat.com>
References: <4fec4b01-35f9-8008-22ec-2ac8af58b854@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4fec4b01-35f9-8008-22ec-2ac8af58b854@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Dec 10 2018 at  5:45pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> After switching to percpu inflight counters, the inflight check
> is totally buggy. It's perfectly valid for some counters to be
> non-zero while having a total inflight IO count of 0, that's how
> these kinds of counters work (inc on one CPU, dec on another).
> Fix the md_in_flight() check to sum all counters before returning
> a false positive, potentially.
> 
> While at it, remove the inflight read for IO completion. We don't
> need it, just wake anyone that's waiting for the IO count to drop
> to zero. The caller needs to re-check that value anyway when woken,
> which it does.
> 
> Fixes: 6f75723190d8 ("dm: remove the pending IO accounting")
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

I'm seeing that device-mapper-test-suite's "resize_io" test doesn't
pass.  Glad this resolves the xfstest issue but I think more work is
needed, so I'll build any additional changes on this fix.

Thanks.

Acked-by: Mike Snitzer <snitzer@redhat.com>


> 
> ---
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 70568f8b6c53..79ad4b3d215c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -650,14 +650,14 @@ static bool md_in_flight(struct mapped_device *md)
>  {
>  	int cpu;
>  	struct hd_struct *part = &dm_disk(md)->part0;
> +	long sum = 0;
>  
>  	for_each_possible_cpu(cpu) {
> -		if (part_stat_local_read_cpu(part, in_flight[0], cpu) ||
> -		    part_stat_local_read_cpu(part, in_flight[1], cpu))
> -			return true;
> +		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
> +		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
>  	}
>  
> -	return false;
> +	return sum != 0;
>  }

Heh, amazing any tests passed.. sorry for this
