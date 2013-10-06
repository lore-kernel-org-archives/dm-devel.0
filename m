From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] dm-writeboost testing
Date: Sun, 06 Oct 2013 11:14:50 +0900
Message-ID: <5250C79A.8060103@gmail.com>
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com> <524E27DD.2050809@gmail.com> <alpine.LRH.2.02.1310040923320.8473@file01.intranet.prod.int.rdu2.redhat.com> <524ECFC9.3000603@gmail.com> <alpine.LRH.2.02.1310041113230.22029@file01.intranet.prod.int.rdu2.redhat.com> <524FBA3F.3050409@gmail.com> <alpine.LRH.2.02.1310052044070.30547@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1310052044070.30547@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, david@fromorbit.com, linux-kernel@vger.kernel.org, tj@kernel.org, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com, ruby.wktk@gmail.com
List-Id: dm-devel.ids

Mikulas,

> The change seems ok. Please, also move this piece of code in flush_proc
> out of the spinlock:
>                         if (kthread_should_stop())
>                                 return 0;
> 
> It caused the workqueue warning I reported before and still causes warning 
> with kthreads:
> note: flush_daemon[5145] exited with preempt_count 1

You are right.
I fixed the bug.

diff --git a/Driver/dm-writeboost-daemon.c b/Driver/dm-writeboost-daemon.c
index 65974e2..cf790bf 100644
--- a/Driver/dm-writeboost-daemon.c
+++ b/Driver/dm-writeboost-daemon.c
@@ -29,7 +29,6 @@ int flush_proc(void *data)
                                cache->flush_wait_queue,
                                (!list_empty(&cache->flush_queue)),
                                msecs_to_jiffies(100));
-                       spin_lock_irqsave(&cache->flush_queue_lock, flags);

                        /*
                         * flush daemon can exit
@@ -37,6 +36,8 @@ int flush_proc(void *data)
                         */
                        if (kthread_should_stop())
                                return 0;
+                       else
+                               spin_lock_irqsave(&cache->flush_queue_lock, flags);
                }

> I will send you next email with more bugs that I found in your code
I will reply to you about this later.
So much bugs and some seems to be crucial.

Akira
