From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] Linux 2.6.36-rc7
Date: Fri, 08 Oct 2010 19:02:11 +0200
Message-ID: <4CAF4E93.1040101@kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <4CAE1F47.3050105@kernel.org> <4CAE29CC.8030702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CAE29CC.8030702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, just.for.lkml@googlemail.com, hch@infradead.org, herbert@gondor.hengli.com.au
List-Id: dm-devel.ids

Hello, again.

On 10/07/2010 10:13 PM, Milan Broz wrote:
> Yes, XFS is very good to show up problems in dm-crypt:)
> 
> But there was no change in dm-crypt which can itself cause such problem,
> planned workqueue changes are not in 2.6.36 yet.
> Code is basically the same for the last few releases.
> 
> So it seems that workqueue processing really changed here under memory pressure.
> 
> Milan
> 
> p.s.
> Anyway, if you are able to reproduce it and you think that there is problem
> in per-device dm-crypt workqueue, there are patches from Andi for shared
> per-cpu workqueue, maybe it can help here. (But this is really not RC material.)
> 
> Unfortunately not yet in dm-devel tree, but I have them here ready for review:
> http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
> (all 4 patches must be applied, I hope Alasdair will put them in dm quilt soon.)

Okay, spent the whole day reproduing the problem and trying to
determine what's going on.  In the process, I've found a bug and a
potential issue (not sure whether it's an actual issue which should be
fixed for this release yet) but the hang doesn't seem to have anything
to do with workqueue update.  All the queues are behaving exactly as
expected during hang.

Also, it isn't a regression.  I can reliably trigger the same deadlock
on v2.6.35.

Here's the setup, which should be mostly similar to Torsten's setup I
used to trigger the problem.

The machine is dual quad-core Opteron (8 phys cores) w/ 4GiB memory.

* 80GB raid1 of two SATA disks
* On top of that, luks encrypted device w/ twofish-cbc-essiv:sha256
* In the encrypted device, xfs filesystem which hosts 8GiB swapfile
* 12GiB tmpfs

The workload is v2.6.35 allyesconfig -j 128 build in the tmpfs.  Not
too long after swap starts being used (several tens of secs), the
system hangs.  IRQ handling and all are fine but no IO gets through
with a lot of tasks stuck in bio allocation somewhere.

I suspected that with md and dm stacked together, something in the
upper layer ended up exhausting a shared bio pool and tried a couple
of things but haven't succeeded at finding where the culprit is.  It
probably would be best to run blktrace together and analyze how IO
gets stuck.

So, well, we seem to be broken the same way as before.  No need to
delay release for this one.

Thanks.

-- 
tejun
