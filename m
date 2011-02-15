From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Date: Tue, 15 Feb 2011 16:56:18 +0000
Message-ID: <20110215165618.GA28164@agk-dp.fab.redhat.com>
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org> <20110215154625.GG5825@agk-dp.fab.redhat.com> <20110215155018.GM3160@htj.dyndns.org> <4D5AA45C.7050600@redhat.com> <20110215161228.GN3160@htj.dyndns.org> <4D5AAB8F.50901@redhat.com> <20110215164128.GQ3160@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215164128.GQ3160@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 05:41:28PM +0100, Tejun Heo wrote:
> That said, maybe -EROFS is the better fit.  I really have no idea.
> Maybe we should just revert and leave rw accesses to ro block devices
> alone.
 
I'd agree that the change to enforce readonly devs is a desirable change
to make.  But we're still discovering exactly what things it breaks and
as well as further kernel patches some userspace changes seem
unavoidable.  Personally I'd prefer it if this change went back into
linux-next to give us more time to prepare for it cleanly.  It's
unfortunate none of us picked up on these problems sooner.

Alasdair
