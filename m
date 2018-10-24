From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: flush metadata in single
 commit in init_memory
Date: Wed, 24 Oct 2018 10:38:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810241036400.17312@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181024105456.3204-1-shhuiw@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181024105456.3204-1-shhuiw@foxmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shenghui Wang <shhuiw@foxmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids



On Wed, 24 Oct 2018, Shenghui Wang wrote:

> Do not flush sb ->magic in second commit.

This is intentional. The magic is written last, so that if the machine 
crashes while formatting the device, the incomplete superblock won't be 
misidentified as already formatted.

Mikulas

> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
> ---
>  drivers/md/dm-writecache.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index d656bd1799ae..8e9e96a22f68 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -1749,6 +1749,8 @@ static int init_memory(struct dm_writecache *wc)
>  
>  	for (b = 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
>  		pmem_assign(sb(wc)->padding[b], cpu_to_le64(0));
> +
> +	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
>  	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION));
>  	pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_size));
>  	pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
> @@ -1759,9 +1761,6 @@ static int init_memory(struct dm_writecache *wc)
>  
>  	writecache_flush_all_metadata(wc);
>  	writecache_commit_flushed(wc);
> -	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
> -	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
> -	writecache_commit_flushed(wc);
>  
>  	return 0;
>  }
> -- 
> 2.18.0
> 
> 
> 
