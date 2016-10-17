From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH] multipath-tools: release lock on handler
 failure
Date: Mon, 17 Oct 2016 10:02:58 +0200
Message-ID: <f8227018-ea94-19b4-4bd8-5eb9e38f90c2@profitbricks.com>
References: <a822c1be-b984-b47b-7418-48d5cf069801@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a822c1be-b984-b47b-7418-48d5cf069801@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

Dear maintainer, is this patch looks fine to you?

Regards,
Michael Wang

On 10/12/2016 10:54 AM, Michael Wang wrote:
> 
> Inside parse_cmd() the pthread_cleanup_pop() rely on '!r' as the
> indicator of locked or not, while this will be overwritten if the
> handler return failed, and the unlock will be missing.
> 
> This will lead into the situation that all the following operation
> will trying to hold a lock which will never be released.
> 
> This patch using a separate flag to record the status of locking to
> make sure the unlock and lock are in pairs.
> 
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  multipathd/cli.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index e8a9384..50161be 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -481,6 +481,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
>                 tmo.tv_sec = 0;
>         }
>         if (h->locked) {
> +               int locked = 0;
>                 struct vectors * vecs = (struct vectors *)data;
> 
>                 pthread_cleanup_push(cleanup_lock, &vecs->lock);
> @@ -491,10 +492,11 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
>                         r = 0;
>                 }
>                 if (r == 0) {
> +                       locked = 1;
>                         pthread_testcancel();
>                         r = h->fn(cmdvec, reply, len, data);
>                 }
> -               pthread_cleanup_pop(!r);
> +               pthread_cleanup_pop(locked);
>         } else
>                 r = h->fn(cmdvec, reply, len, data);
>         free_keys(cmdvec);
> 
