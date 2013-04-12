From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Date: Fri, 12 Apr 2013 14:17:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304121405370.3359@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111943450.29691@file.rdu.redhat.com>
 <20130412002252.GD11956@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130412002252.GD11956@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 11 Apr 2013, Tejun Heo wrote:

> On Thu, Apr 11, 2013 at 08:06:10PM -0400, Mikulas Patocka wrote:
> > All that I can tell you is that adding an empty atomic operation 
> > "cmpxchg(&bio->bi_css->refcnt, bio->bi_css->refcnt, bio->bi_css->refcnt);" 
> > to bio_clone_context and bio_disassociate_task increases the time to run a 
> > benchmark from 23 to 40 seconds.
> 
> Right, linear target on ramdisk, very realistic, and you know what,
> hell with dm, let's just hand code everything into submit_bio().  I'm
> sure it will speed up your test case significantly.

The purpose of this benchmarking is not to optimize linear target on 
ramdisk. The purpose is to optimize the kernel for upcoming massively 
parallel servers, with possibly hundreds of energy-efficient cores or so. 
On these systems every single atomic reference really becomes a 
bottleneck. And since I don't have such massively parallel server, I am 
testing it on 12-core machine with ramdisk - the performance drop due to 
atomic accesses can be measured even on that.

I already eliminated most of the atomic operations with this patch 
http://people.redhat.com/~mpatocka/patches/kernel/dm-lock-optimization/dm-optimize.patch 
And I don't see a sense in adding more for cgroup, especially, if it can 
be easily avoided.

Mikulas
