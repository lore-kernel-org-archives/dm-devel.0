From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
 I/O hang
Date: Tue, 08 Jul 2014 11:43:14 +0200
Message-ID: <53BBBD32.7030404@acm.org>
References: <53AD6B62.2020407@acm.org>
	<20140627133345.GA6150@redhat.com>	<20140702220223.GA23894@redhat.com>
	<53B56120.8040802@acm.org>	<20140703140516.GB28104@redhat.com>
	<53B569E1.1010405@acm.org>
	<11AF7C027C4C02408624617A4986078401311EA8@BPXM12GP.gisp.nec.co.jp>
	<53BAA35B.30204@acm.org>
	<11AF7C027C4C02408624617A498607840132038A@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A498607840132038A@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 07/08/14 02:55, Junichi Nomura wrote:
> pg_ready() checks the current state of the multipath and may return
> false even if a new IO is needed to change the state.
> 
> OTOH, if multipath_busy() returns busy, a new IO will not be sent
> to multipath target and the state change won't happen. That results
> in lock up.
> 
> The intent of multipath_busy() is to avoid unnecessary cycles of
> dequeue + request_fn + requeue if it is known that multipath device
> will requeue.
> 
> Such situation would be:
>   - path group is being activated
>   - there is no path and the multipath is setup to requeue if no path
> 
> This patch should fix the problem introduced as a part of this commit:
>   commit e809917735ebf1b9a56c24e877ce0d320baee2ec
>   dm mpath: push back requests instead of queueing
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index ebfa411..d58343e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1620,8 +1620,9 @@ static int multipath_busy(struct dm_target *ti)
>  
>  	spin_lock_irqsave(&m->lock, flags);
>  
> -	/* pg_init in progress, requeue until done */
> -	if (!pg_ready(m)) {
> +	/* pg_init in progress or no paths available */
> +	if (m->pg_init_in_progress ||
> +	    (!m->nr_valid_paths && m->queue_if_no_path)) {
>  		busy = 1;
>  		goto out;
>  	}
> 

This patch seems to fix the issue reported at the start of this thread -
with this patch applied my test passes.

Thanks !

Bart.
