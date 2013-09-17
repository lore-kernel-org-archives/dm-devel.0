From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-snapshot: workaround for a lockdep warning
Date: Tue, 17 Sep 2013 19:24:18 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309171920050.18335@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1309171646050.550@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309171646050.550@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, Stephen Boyd <sboyd@codeaurora.org>
List-Id: dm-devel.ids

BTW. this patch is no longer needed on 3.11 because md->io_lock was 
removed there, so the false lockdep warning doesn't happen.

So we need to get this patch to stable trees 3.5 to 3.10, but not 
upstream. How to push the patch there without pushing it upstream?

Mikulas


On Tue, 17 Sep 2013, Mikulas Patocka wrote:

> dm-snapshot: workaround for a lockdep warning
> 
> The kernel reports a lockdep warning if a snapshot is invalidated because
> it runs out of space.
> 
> The lockdep warning was triggered by commit
> 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a in the kernel 3.5.
> 
> The warning is false positive. The real cause for the warning is that the
> lockdep engine treats different instances of md->lock as a single lock.
> 
> This patch is a workaround - we use flush_workqueue instead of flush_work.
> This code path is not performance sensitive (it is called only on
> initialization or invalidation), thus it doesn't matter that we flush the
> whole workqueue.
> 
> The real fix for the problem would be to teach the lockdep engine to treat
> different instances of md->lock as separate locks.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org		# 3.5+
> 
> Index: linux-2.6-devel/drivers/md/dm-snap-persistent.c
> ===================================================================
> --- linux-2.6-devel.orig/drivers/md/dm-snap-persistent.c	2013-05-10 18:27:31.132358000 +0200
> +++ linux-2.6-devel/drivers/md/dm-snap-persistent.c	2013-09-17 18:41:39.023940000 +0200
> @@ -256,7 +256,7 @@
>  	 */
>  	INIT_WORK_ONSTACK(&req.work, do_metadata);
>  	queue_work(ps->metadata_wq, &req.work);
> -	flush_work(&req.work);
> +	flush_workqueue(ps->metadata_wq);
>  
>  	return req.result;
>  }
> 
