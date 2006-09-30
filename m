From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Thoughts on removing the remap cache
Date: Sat, 30 Sep 2006 11:46:38 +0900
Message-ID: <200609300246.k8U2khwi004095@r-dd.iij4u.or.jp>
References: <m3d59e1hj9.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3d59e1hj9.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: [dm-devel] Thoughts on removing the remap cache
Date: Fri, 29 Sep 2006 14:36:58 -0700

> However, all of my tests up until now have been with dbench.  I think
> that dbench works well in cases where latency is high, which is of
> course the case since we're sending all requests to userspace.  When I
> try to boot a Xen domU with root on dm-userspace (without the
> caching), it is *painfully* slow.  I assume this is because the domU
> boot is doing a lot of synchronous, sequential operations.
> 
> Since domU performance was good when I was caching mappings in the
> kernel, I would assume that the difference in performance is related
> to the caching.

I guess that dbench generates relatively large size I/Os than common
workloads, which is more sensitive to latency.

Seems that Xen camp is pretty happy with blktap. So dm-userspace
should be ok with domU. Maybe it's time to try ring buffer stuff
again. :)

Ok, I'll salvage and update the old patch, post a new patch compatible
with the current code.
