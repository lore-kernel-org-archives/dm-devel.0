From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 15/20] io-controller: map async requests to
	appropriate cgroup
Date: Mon, 22 Jun 2009 11:39:10 -0400
Message-ID: <20090622153910.GB15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-16-git-send-email-vgoyal@redhat.com>
	<4A3EE245.7030409@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A3EE245.7030409@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jun 22, 2009 at 09:45:41AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > o So far we were assuming that a bio/rq belongs to the task who is submitting
> >   it. It did not hold good in case of async writes. This patch makes use of
> >   blkio_cgroup pataches to attribute the aysnc writes to right group instead
> >   of task submitting the bio.
> > 
> > o For sync requests, we continue to assume that io belongs to the task
> >   submitting it. Only in case of async requests, we make use of io tracking
> >   patches to track the owner cgroup.
> > 
> > o So far cfq always caches the async queue pointer. With async requests now
> >   not necessarily being tied to submitting task io context, caching the
> >   pointer will not help for async queues. This patch introduces a new config
> >   option CONFIG_TRACK_ASYNC_CONTEXT. If this option is not set, cfq retains
> >   old behavior where async queue pointer is cached in task context. If it
> >   is not set, async queue pointer is not cached and we take help of bio
> 
> Here "If it is not set" should be "If it is set".

Yes, in last line it should be "If it is set". Thanks Gui. Will fix the
comment.

Vivek
