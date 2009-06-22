From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate
 cgroup
Date: Mon, 22 Jun 2009 09:45:41 +0800
Message-ID: <4A3EE245.7030409@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-16-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752586AbZFVBrv@vger.kernel.org>
In-Reply-To: <1245443858-8487-16-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> o So far we were assuming that a bio/rq belongs to the task who is submitting
>   it. It did not hold good in case of async writes. This patch makes use of
>   blkio_cgroup pataches to attribute the aysnc writes to right group instead
>   of task submitting the bio.
> 
> o For sync requests, we continue to assume that io belongs to the task
>   submitting it. Only in case of async requests, we make use of io tracking
>   patches to track the owner cgroup.
> 
> o So far cfq always caches the async queue pointer. With async requests now
>   not necessarily being tied to submitting task io context, caching the
>   pointer will not help for async queues. This patch introduces a new config
>   option CONFIG_TRACK_ASYNC_CONTEXT. If this option is not set, cfq retains
>   old behavior where async queue pointer is cached in task context. If it
>   is not set, async queue pointer is not cached and we take help of bio

Here "If it is not set" should be "If it is set".


-- 
Regards
Gui Jianfeng
