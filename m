From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
Date: Mon, 4 Nov 2013 12:12:04 -0800
Message-ID: <20131104201204.GA27733@kmo>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 04, 2013 at 10:06:00AM -0500, Mikulas Patocka wrote:
> 
> 
> On Fri, 1 Nov 2013, Jens Axboe wrote:
> 
> > On 11/01/2013 07:59 AM, Mike Snitzer wrote:
> > > Add the missing bi_remaining increment, required by the block layer's
> > > new bio-chaining code, to both the verity and old snapshot DM targets.
> > > 
> > > Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().
> > 
> > Thanks Mike, added to the mix.
> > 
> > -- 
> > Jens Axboe
> 
> Hi
> 
> This improves a little bit on the previous patch, by replacing costly 
> atomic_inc with cheap atomic_set.

IMO, this is a bad idea; the behaviour with this patch does _not_ match the
naming of bio_endio_nodec(), and the performance difference should be well in
the noise anyways because we're touching a cacheline we already have in cache
and won't be contended.

The fact that it's currently safe is accidental, I could see this easily
tripping people up and being a pain in the ass to debug in the future.

> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> dm: change atomic_inc to atomic_set(1)
> 
> There are places in dm where we save bi_endio and bi_private, set them to
> target's routine, submit the bio, from the target's bi_endio routine we
> restore bi_endio and bi_private and end the bio with bi_endio.
> 
> This causes underflow of bi_remaining, so we must restore bi_remaining
> before ending the bio from the target bi_endio routine.
> 
> The code uses atomic_inc for restoration of bi_remaining. This patch
> changes it to atomic_set(1) to avoid an interlocked instruction. In the
> target's bi_endio routine we are sure that bi_remaining is zero
> (otherwise, the bi_endio routine wouldn't be called) and there are no
> concurrent users of the bio, so we can replace atomic_inc with
> atomic_set(1).
