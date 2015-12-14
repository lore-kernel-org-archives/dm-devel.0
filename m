From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: corruption causing crash in __queue_work
Date: Mon, 14 Dec 2015 10:31:47 -0500
Message-ID: <20151214153147.GA14957@redhat.com>
References: <566819D8.5090804@kyup.com>
 <20151209160803.GK30240@mtj.duckdns.org>
 <56685573.1020805@kyup.com>
 <20151209162744.GN30240@mtj.duckdns.org>
 <566945A2.1050208@kyup.com>
 <20151210152901.GR30240@mtj.duckdns.org>
 <566AF262.8050009@kyup.com>
 <20151211170805.GT30240@mtj.duckdns.org>
 <566E80AE.7020502@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566E80AE.7020502@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Cc: Tejun Heo <tj@kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Dec 14 2015 at  3:41P -0500,
Nikolay Borisov <kernel@kyup.com> wrote:
 
> Had another poke at the backtrace that is produced and here what the
> delayed_work looks like:
> 
> crash> struct delayed_work ffff88036772c8c0
> struct delayed_work {
>   work = {
>     data = {
>       counter = 1537
>     },
>     entry = {
>       next = 0xffff88036772c8c8,
>       prev = 0xffff88036772c8c8
>     },
>     func = 0xffffffffa0211a30 <do_waker>
>   },
>   timer = {
>     entry = {
>       next = 0x0,
>       prev = 0xdead000000200200
>     },
>     expires = 4349463655,
>     base = 0xffff88047fd2d602,
>     function = 0xffffffff8106da40 <delayed_work_timer_fn>,
>     data = 18446612146934696128,
>     slack = -1,
>     start_pid = -1,
>     start_site = 0x0,
>     start_comm =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
>   },
>   wq = 0xffff88030cf65400,
>   cpu = 21
> }
> 
> From this it seems that the timer is also cancelled/expired judging by
> the values in timer -> entry. But then again in dm-thin the pool is
> first suspended, which implies the following functions were called:
> 
> cancel_delayed_work(&pool->waker);
> cancel_delayed_work(&pool->no_space_timeout);
> flush_workqueue(pool->wq);
> 
> so at that point dm-thin's workqueue should be empty and it shouldn't be
> possible to queue any more delayed work. But the crashdump clearly shows
> that the opposite is happening. So far all of this points to a race
> condition and inserting some sleeps after umount and after vgchange -Kan
> (command to disable volume group and suspend, so the cancel_delayed_work
> is invoked) seems to reduce the frequency of crashes, though it doesn't
> eliminate them.

'vgchange -Kan' doesn't suspend the pool before it destroys the device.
So the cancel_delayed_work()s you referenced aren't applicable.

Can you try this patch?

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 63903a5..b201d887 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2750,8 +2750,11 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
-	if (pool->wq)
+	if (pool->wq) {
+		cancel_delayed_work(&pool->waker);
+		cancel_delayed_work(&pool->no_space_timeout);
 		destroy_workqueue(pool->wq);
+	}
 
 	if (pool->next_mapping)
 		mempool_free(pool->next_mapping, pool->mapping_pool);
