From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: fix typo in error msg for
 creating writecache_flush_thread
Date: Wed, 24 Oct 2018 10:41:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810241038410.17312@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181024080436.2230-1-shhuiw@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181024080436.2230-1-shhuiw@foxmail.com>
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

> The error msg should be "flush thread" instead of "endio thread"
> for writecache_flush_thread.
> 
> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>

OK.

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 5f1f80d424dd..d656bd1799ae 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -2064,7 +2064,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		if (IS_ERR(wc->flush_thread)) {
>  			r = PTR_ERR(wc->flush_thread);
>  			wc->flush_thread = NULL;
> -			ti->error = "Couldn't spawn endio thread";
> +			ti->error = "Couldn't spawn flush thread";
>  			goto bad;
>  		}
>  		wake_up_process(wc->flush_thread);
> -- 
> 2.18.0
> 
> 
> 
