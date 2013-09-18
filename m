From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: workaround for a lockdep warning
Date: Wed, 18 Sep 2013 19:14:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309181904530.2927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1309171646050.550@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1309171920050.18335@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1309172006001.24061@file01.intranet.prod.int.rdu2.redhat.com>
	<52394ED9.5010308@redhat.com>
	<alpine.LRH.2.02.1309181156230.14936@file01.intranet.prod.int.rdu2.redhat.com>
	<5239F9FF.2010407@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5239F9FF.2010407@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 18 Sep 2013, Zdenek Kabelac wrote:

> Dne 18.9.2013 17:57, Mikulas Patocka napsal(a):
> > 
> > 
> > On Wed, 18 Sep 2013, Zdenek Kabelac wrote:
> > 
> > > Dne 18.9.2013 02:08, Mikulas Patocka napsal(a):
> > > > 
> > > > It's more complicated than that - the original Zdenek's report 
> > > > shows that the false warning happened on kernel 
> > > > "3.11.1-300.fc20.x86_64+debug". But I am not able to reproduce the 
> > > > bug on 3.11, I only reproduced it on 3.5-3.10 kernels.
> > > > 
> > > > Zdenek, could you reproduce the bug on kernel 3.11?
> > > > 
> > > > Mikulas
> > > > 
> > > 
> > > 
> > > Since I do not have clean 3.11 at my hands  - I've reproduced it with my
> > > -rc6
> > > kernel (few patches based on 8495e9c4a9616c9d19f23182d0536485902259db)
> > > With enabled kmemleak=on lockdep.prove_locking=1 lockdep.lock_stat=1.
> > 
> > So - try this patch and tell me if it fixes the problem:
> > 
> > Index: linux-2.6-devel/drivers/md/dm-snap-persistent.c
> > ===================================================================
> > --- linux-2.6-devel.orig/drivers/md/dm-snap-persistent.c	2013-05-10
> > 18:27:31.132358000 +0200
> > +++ linux-2.6-devel/drivers/md/dm-snap-persistent.c	2013-09-17
> > 18:41:39.023940000 +0200
> > @@ -256,7 +256,7 @@
> >   	 */
> >   	INIT_WORK_ONSTACK(&req.work, do_metadata);
> >   	queue_work(ps->metadata_wq, &req.work);
> > -	flush_work(&req.work);
> > +	flush_workqueue(ps->metadata_wq);
> > 
> >   	return req.result;
> >   }
> > 
> 
> Yes - this seems to eliminate reported INFO.

OK - so I am submitting the patch for the upstream kernel too.

> Though I'm getting curious why some tests are running much much much slower
> when kmemleak and lockdep is in use.

Because these checks slow things down - that's nothing unexpected.

> Zdenek

Mikulas

---

dm-snapshot: workaround for a lockdep warning

The kernel reports a lockdep warning if a snapshot is invalidated because
it runs out of space.

The lockdep warning was triggered by commit
0976dfc1d0cd80a4e9dfaf87bd8744612bde475a in the kernel 3.5.

The warning is false positive. The real cause for the warning is that the
lockdep engine treats different instances of md->lock as a single lock.

This patch is a workaround - we use flush_workqueue instead of flush_work.
This code path is not performance sensitive (it is called only on
initialization or invalidation), thus it doesn't matter that we flush the
whole workqueue.

The real fix for the problem would be to teach the lockdep engine to treat
different instances of md->lock as separate locks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Cc: stable@kernel.org # 3.5+

Index: linux-2.6-devel/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6-devel.orig/drivers/md/dm-snap-persistent.c	2013-05-10 18:27:31.132358000 +0200
+++ linux-2.6-devel/drivers/md/dm-snap-persistent.c	2013-09-17 18:41:39.023940000 +0200
@@ -256,7 +256,7 @@
 	 */
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
-	flush_work(&req.work);
+	flush_workqueue(ps->metadata_wq);
 
 	return req.result;
 }
