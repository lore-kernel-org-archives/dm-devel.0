From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: skip writecache_wait for pmem mode
Date: Wed, 4 Sep 2019 04:48:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1909040444440.11252@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190902100450.10600-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190902100450.10600-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: snitzer@redhat.com, agk@redhat.com, prarit@redhat.com, tyu1@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Mon, 2 Sep 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> The array bio_in_progress[2] only have chance to be increased and
> decreased with ssd mode. For pmem mode, they are not involved at all.
> So skip writecache_wait_for_ios in writecache_flush for pmem.
> 
> Suggested-by: Doris Yu <tyu1@lenovo.com>
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> ---
>  drivers/md/dm-writecache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index c481947..d06b8aa 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -726,7 +726,8 @@ static void writecache_flush(struct dm_writecache *wc)
>  	}
>  	writecache_commit_flushed(wc);
>  
> -	writecache_wait_for_ios(wc, WRITE);
> +	if (!WC_MODE_PMEM(wc))
> +		writecache_wait_for_ios(wc, WRITE);
>  
>  	wc->seq_count++;
>  	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
> -- 
> 1.8.3.1

I think this is not needed - wait_event in writecache_wait_for_ios exits 
immediatelly if the condition is true.

This code path is not so hot that we would need microoptimizations like 
this to avoid function calls.

Mikulas
