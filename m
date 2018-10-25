From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm writecache: remove unused variable sz in
	writecache_status
Date: Wed, 24 Oct 2018 23:46:30 -0400
Message-ID: <20181025034630.GA17401@redhat.com>
References: <20181025023832.9766-1-shhuiw@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181025023832.9766-1-shhuiw@foxmail.com>
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 24 2018 at 10:38pm -0400,
Shenghui Wang <shhuiw@foxmail.com> wrote:

> sz defined but not used in writecache_status. Remove it.
> 
> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
> ---
>  drivers/md/dm-writecache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 5f1f80d424dd..562c32f644b8 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -2226,7 +2226,6 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
>  {
>  	struct dm_writecache *wc = ti->private;
>  	unsigned extra_args;
> -	unsigned sz = 0;
>  	uint64_t x;
>  
>  	switch (type) {

Have you even compile tested this patch?

DMEMIT implicitly uses sz.  Not saying I like this, but it is what it
is.

Nacked-by: Mike Snitzer <snitzer@redhat.com>
