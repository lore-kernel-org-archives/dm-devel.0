From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-mpath: requeue I/O during pg_init
Date: Tue, 5 Nov 2013 13:02:21 +0000
Message-ID: <20131105130221.GC27505@agk-dp.fab.redhat.com>
References: <1380620996-110162-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380620996-110162-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 01, 2013 at 11:49:56AM +0200, Hannes Reinecke wrote:
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -390,7 +390,11 @@ static int map_io(struct multipath *m, struct request *clone,
>  	if (was_queued)
>  		m->queue_size--;
>  
> -	if ((pgpath && m->queue_io) ||
> +	if (m->pg_init_required) {
> +		if (!m->pg_init_in_progress)
> +			queue_work(kmultipathd, &m->process_queued_ios);
> +		r = DM_MAPIO_REQUEUE;
> +	} else if ((pgpath && m->queue_io) ||
>  	    (!pgpath && m->queue_if_no_path)) {
>  		/* Queue for the daemon to resubmit */
>  		list_add_tail(&clone->queuelist, &m->queued_ios);

This sequence if...else if... is becoming more and more unreadable!
- Two cases now return REQUEUE; two cases now queue_work().

If it really can't be simplified, could we at least add some explanatory
comments inline?

Alasdair
