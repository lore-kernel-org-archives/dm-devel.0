From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2 5/5] multipathd: remove useless memset
 after MALLOC in alloc_waiteri func
Date: Fri, 21 Aug 2020 13:18:50 +0200
Message-ID: <464a716fb1598b8859c3441bf09b1146e49675bb.camel@suse.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
	<ab034ec7-c80d-6d40-b9bf-1942e2ad5067@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ab034ec7-c80d-6d40-b9bf-1942e2ad5067@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-08-21 at 19:01 +0800, Zhiqiang Liu wrote:
> MALLOC(x) maps to calloc(1, x), which already init var to zero.
> In alloc_waiter func, the superfluous memset(wp) call is useless,
> and it should be removed.
> 
> V1->V2:
> - remove useless memset call after MALLOC (as suggested by Martin)

Reading this, I realize that we don't need alloc_waiter() at all.
Anyway:

Reviewed-by: Martin Wilck <mwilck@suse.com>

> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/waiter.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/multipathd/waiter.c b/multipathd/waiter.c
> index e6457663..da4017b9 100644
> --- a/multipathd/waiter.c
> +++ b/multipathd/waiter.c
> @@ -29,13 +29,7 @@ struct mutex_lock waiter_lock = { .mutex =
> PTHREAD_MUTEX_INITIALIZER };
> 
>  static struct event_thread *alloc_waiter (void)
>  {
> -
> -	struct event_thread *wp;
> -
> -	wp = (struct event_thread *)MALLOC(sizeof(struct
> event_thread));
> -	memset(wp, 0, sizeof(struct event_thread));
> -
> -	return wp;
> +	return (struct event_thread *)MALLOC(sizeof(struct
> event_thread));
>  }
> 
>  static void free_waiter (void *data)
