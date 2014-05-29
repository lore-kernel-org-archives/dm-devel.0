From: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: RE: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq
Date: Thu, 29 May 2014 01:58:02 +0000
Message-ID: <1267BB84A242B24E81E0C0C8955CFFC061A18542@G9W0343.americas.hpqcorp.net>
References: <1401258172-17381-1-git-send-email-zhen-hual@hp.com>
 <20140528150314.GB25249@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140528150314.GB25249@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

I tested it on 3.14-rc5.
I will checkout the latest kernel and test it on my system for this bug.

Thanks
Zhenhua

-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: Wednesday, May 28, 2014 11:03 PM
To: Li, Zhen-Hua
Cc: linux-kernel@vger.kernel.org; Alasdair Kergon; dm-devel@redhat.com; Neil Brown; linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq

On Wed, May 28 2014 at  2:22am -0400,
Li, Zhen-Hua <zhen-hual@hp.com> wrote:

> This patch is trying to fix a kernel crash bug.
> 
> When kernel boots on a HP large system, it crashes.
> The reason is when blk_rq_init is called, the second parameter rq , which
> is a member as q->flush_rq, is NULL. Kernel does not allocate space for it.
> 
> This fix adds an alloc for flush_rq member when request_queue is created in
> struct mapped_device *alloc_dev(int minor);
> 
> Bug Details:
> Error message:
> 
> [   62.931942] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   62.931949] IP: [<ffffffff812b3f30>] blk_rq_init+0x40/0x160^M
> [   62.931949] PGD 0 ^M
> [   62.931951] Oops: 0002 [#1] SMP

You didn't specify which kernel you're running.  But this was fixed for
v3.15-rc6 via linux.git commit 7982e90c3a5 ("block: fix q->flush_rq NULL
pointer crash on dm-mpath flush").  And then there was the follow-on fix
from linux.git commit 708f04d2ab ("block: free q->flush_rq in
blk_init_allocated_queue error paths")

So all this is to say: Nack to your patch, we've already fixed the issue
differently.
