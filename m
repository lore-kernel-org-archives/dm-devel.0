From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-snap: optimize track_chunk
Date: Tue, 16 Oct 2012 20:01:15 -0400
Message-ID: <20121017000115.GA3540@redhat.com>
References: <Pine.LNX.4.64.1210161904120.19889@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210161904120.19889@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 16 2012 at  7:04pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-snap: optimize track_chunk
> 
> track_chunk is always called with interrupts enabled. Consequently, we
> do not need to save and restore interrupt state in "flags" variable.
> This patch changes spin_lock_irqsave to spin_lock_irq and
> spin_unlock_irqrestore to spin_unlock_irq.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-snap.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-3.6.2-fast/drivers/md/dm-snap.c
> ===================================================================
> --- linux-3.6.2-fast.orig/drivers/md/dm-snap.c	2012-10-17 00:43:01.000000000 +0200
> +++ linux-3.6.2-fast/drivers/md/dm-snap.c	2012-10-17 00:43:22.000000000 +0200
> @@ -201,14 +201,13 @@ static struct dm_snap_tracked_chunk *tra
>  {
>  	struct dm_snap_tracked_chunk *c = mempool_alloc(s->tracked_chunk_pool,
>  							GFP_NOIO);
> -	unsigned long flags;
>  
>  	c->chunk = chunk;
>  
> -	spin_lock_irqsave(&s->tracked_chunk_lock, flags);
> +	spin_lock_irq(&s->tracked_chunk_lock);

Does is make any sense to add "BUG_ON(irqs_disabled());" before the spin_lock_irq?
