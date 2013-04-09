From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt parallelization patches
Date: Tue, 9 Apr 2013 14:08:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com> <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com> <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com> <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130409175753.GA6186@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>
List-Id: dm-devel.ids



On Tue, 9 Apr 2013, Tejun Heo wrote:

> On Tue, Apr 09, 2013 at 01:51:43PM -0400, Mikulas Patocka wrote:
> > The patch dm-crypt-sort-requests.patch sorts write requests submitted by a 
> > single thread. The requests are sorted according to the sector number, 
> > rb-tree is used for efficient sorting.
> 
> Hmmm? Why not just keep the issuing order along with plugging
> boundaries?

What do you mean?

I used to have a patch that keeps order of requests as they were 
introduced, but sorting the requests according to sector number is a bit 
simpler.

> > So it seems that CFQ has some deficiency that it cannot merge adjacent 
> > requests done by different processes.
> 
> As I wrote before, please use bio_associate_current().  Currently,
> dm-crypt is completely messing up all the context information that cfq
> depends on to schedule IOs.  Of course, it doesn't perform well.

bio_associate_current() is only valid on a system with cgroups and there 
are no cgroups on the kernel where I tested it. It is an empty function:

static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }

Mikulas

> Thanks.
> 
> -- 
> tejun
> 
