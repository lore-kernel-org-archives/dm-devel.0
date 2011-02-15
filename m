From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Date: Tue, 15 Feb 2011 17:12:28 +0100
Message-ID: <20110215161228.GN3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5AA45C.7050600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 05:05:48PM +0100, Milan Broz wrote:
> On 02/15/2011 04:50 PM, Tejun Heo wrote:
> >> That's why I'm arguing EACCES is not a good error to return and EROFS is
> >> more appropriate.
> > 
> > Frankly, I don't really mind one way or the other but EROFS isn't
> > usually used in those areas.  It might make sense for this use case
> > and then there will be cases it just feels awkward.  This being a dm
> > thing, wouldn't it be just better to let dm massage the return value?
> 
> It is not DM thing. That code was checking for generic block device.
> No DM there (it was from cryptsetup code but not related to DM part).

Hmmm... I'm confused now.  Where was that -EROFS from then?  I don't
recall changing -EROFS to -EACCES.  What did I miss?

-- 
tejun
