From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context
Date: Fri, 12 Apr 2013 07:59:30 +0200
Message-ID: <5167A2C2.2060900@gmail.com>
References: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com> <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com> <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com> <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com> <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org> <Pine.LNX.4.64.1304111943450.29691@file.rdu.redhat.com> <20130412002252.GD11956@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130412002252.GD11956@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 12.4.2013 2:22, Tejun Heo wrote:
> On Thu, Apr 11, 2013 at 08:06:10PM -0400, Mikulas Patocka wrote:
>> All that I can tell you is that adding an empty atomic operation 
>> "cmpxchg(&bio->bi_css->refcnt, bio->bi_css->refcnt, bio->bi_css->refcnt);" 
>> to bio_clone_context and bio_disassociate_task increases the time to run a 
>> benchmark from 23 to 40 seconds.
> 
> Right, linear target on ramdisk, very realistic, and you know what,
> hell with dm, let's just hand code everything into submit_bio().  I'm
> sure it will speed up your test case significantly.
> 
> If this actually matters, improve it in *sane* way.  Make the refcnts
> per-cpu and not use atomic ops.  In fact, we already have proposed
> implementation of percpu refcnt which is being used by aio restructure
> patches and likely to be included in some form.  It's not quite ready
> yet, so please work on something useful like that instead of
> continuing this non-sense.

Hey, what's going on here?

Seems dmcrypt problem transformed into block level refcount flame :)

Mikulas, please, can you talk to Tejun and find some better way how
to solve DM & block level context bio contexts here?
(Ideally on some realistic scenario, you have enough hw in Red Hat to try,
some raid0 ssds with linear on top should be good example)
and later (when agreed) implement it on dmcrypt?

I definitely do not want dmcrypt becomes guinea pig here, it should
remain simple as possible and should do transparent _encryption_
and not any inline device-mapper super optimizing games.


Thanks,
Milan
