From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Date: Tue, 15 Feb 2011 17:41:28 +0100
Message-ID: <20110215164128.GQ3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
 <20110215161228.GN3160@htj.dyndns.org>
 <4D5AAB8F.50901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5AAB8F.50901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

On Tue, Feb 15, 2011 at 05:36:31PM +0100, Milan Broz wrote:
> Well, I am also not sure about that.
> 
> But the problem is that read-write open fails now while it worked before.
> (TBH I have no idea when that EROFS fallback worked - because the code
> opened device RW, issued EROGET ioctl and set read-only... for years.)
> 
> Anyway I think EROFS is used on block devices, just grep kernel source.

Ah, okay, so the fallback was there just in case.  It didn't really
trigger and right it wouldn't have triggered until now, so your
assertion about how many programs would break is kinda bogus.  You
just have single isolated case which hasn't been excercised till now.
There may as well be code pieces which check against EACCES or what
not.

That said, maybe -EROFS is the better fit.  I really have no idea.
Maybe we should just revert and leave rw accesses to ro block devices
alone.  Jens, what do you think?

Thanks.

-- 
tejun
