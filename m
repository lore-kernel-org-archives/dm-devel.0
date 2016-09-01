From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] dm path selector: Avoid that device
 removal triggers an infinite loop
Date: Wed, 31 Aug 2016 22:49:31 -0400
Message-ID: <20160901024931.GA4741@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<242bfdfc-1af1-014a-48c6-301598b8ad65@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <242bfdfc-1af1-014a-48c6-301598b8ad65@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 31 2016 at  6:18pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> If pg_init_retries is set and a request is queued against a
> multipath device with all underlying block devices in the "dying"
> state then an infinite loop is triggered because activate_path()
> never succeeds and hence never calls pg_init_done(). Fix this by
> making ql_select_path() skip dying paths.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

Assuming DM multipath needs to be sprinkling these dying queue checks so
deep (which I'm not yet sold on):

Same would be needed in service-time and round-robin right?

> ---
>  drivers/md/dm-queue-length.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
> index 23f1786..a283c66 100644
> --- a/drivers/md/dm-queue-length.c
> +++ b/drivers/md/dm-queue-length.c
> @@ -199,11 +199,12 @@ static struct dm_path *ql_select_path(struct path_selector *ps, size_t nr_bytes)
>  	list_move_tail(s->valid_paths.next, &s->valid_paths);
>  
>  	list_for_each_entry(pi, &s->valid_paths, list) {
> -		if (!best ||
> -		    (atomic_read(&pi->qlen) < atomic_read(&best->qlen)))
> +		if ((!best ||
> +		     atomic_read(&pi->qlen) < atomic_read(&best->qlen)) &&
> +		    !blk_queue_dying(pi->path->dev->bdev->bd_queue))
>  			best = pi;
>  
> -		if (!atomic_read(&best->qlen))
> +		if (best && atomic_read(&best->qlen) == 0)
>  			break;
>  	}
>  
> -- 
> 2.9.3
> 
