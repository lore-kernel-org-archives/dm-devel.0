From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Date: Tue, 6 Mar 2012 14:02:11 -0500
Message-ID: <20120306190211.GD32148@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
 <20120305210836.GD1263@google.com>
 <20120306150709.GA32148@redhat.com>
 <20120306162455.GB32148@redhat.com>
 <20120306183942.GC32148@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120306183942.GC32148@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 06, 2012 at 01:39:42PM -0500, Vivek Goyal wrote:
> On Tue, Mar 06, 2012 at 11:24:55AM -0500, Vivek Goyal wrote:
> > On Tue, Mar 06, 2012 at 10:07:09AM -0500, Vivek Goyal wrote:
> > 
> > [..]
> > > 
> > > My system is hanging during reboot. Last message I see is "Detaching DM
> > > devices" and nothing happens after that. I shall have to do some more 
> > > testing to figure out when did that start happening.
> > 
> > Ok, git bisect shows that very first patch to drain the queue is culprit.
> > 
> > 9e5b9f8 block: blk-throttle should be drained regardless of q->elevator
> > 
> > Will do some more debugging.
> 
> Hmm..., haven't reached to the bottom of the issue yet, but there is more
> data.

Ok, found it. Basically we have not initialized the q->queue_head during
queue creation. Hence we end up thinking that q->queue_head is not empty.

So following fixed the issue for me. I still don't understand the special
cased code (q->queue_head is not empty but don't kick queue).

 block/blk-core.c |    1 +
 1 file changed, 1 insertion(+)

Index: tejun-misc/block/blk-core.c
===================================================================
--- tejun-misc.orig/block/blk-core.c	2012-03-07 00:47:14.325852192 -0500
+++ tejun-misc/block/blk-core.c	2012-03-07 00:47:15.998853132 -0500
@@ -558,6 +558,7 @@ struct request_queue *blk_alloc_queue_no
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
+	INIT_LIST_HEAD(&q->queue_head);
 #ifdef CONFIG_BLK_CGROUP
 	INIT_LIST_HEAD(&q->blkg_list);
 #endif

Thanks
Vivek
