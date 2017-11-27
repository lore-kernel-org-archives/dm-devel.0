From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use cloned bio as head, not remainder, in
 __split_and_process_bio()
Date: Mon, 27 Nov 2017 09:23:44 -0500
Message-ID: <20171127142344.GA25881@redhat.com>
References: <20171121013533.GA14520@redhat.com>
 <20171121121049.GA17014@redhat.com>
 <20171121124311.GA17243@redhat.com>
 <20171121194709.GA18903@redhat.com>
 <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
 <20171121225119.GA19630@redhat.com>
 <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
 <87bmjv0xos.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
 <878tewzjz3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878tewzjz3.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 23 2017 at  5:52pm -0500,
NeilBrown <neilb@suse.com> wrote:

> 
> When we use bio_clone_bioset() to split off the front part of a bio
> and chain the two together and submit the remainder to
> generic_make_request(), it is important that the newly allocated
> bio is used as the head to be processed immediately, and the original
> bio gets "bio_advance()"d and sent to generic_make_request() as the
> remainder.
> 
> If the newly allocated bio is used as the remainder, and if it then
> needs to be split again, then the next bio_clone_bioset() call will
> be made while holding a reference a bio (result of the first clone)
> from the same bioset.  This can potentially exhaust the bioset mempool
> and result in a memory allocation deadlock.
> 
> So the result of the bio_clone_bioset() must be attached to the new
> dm_io struct, and the original must be resubmitted.  The current code
> is backwards.
> 
> Note that there is no race caused by reassigning cio.io->bio after already
> calling __map_bio().  This bio will only be dereferenced again after
> dec_pending() has found io->io_count to be zero, and this cannot happen
> before the dec_pending() call at the end of __split_and_process_bio().
> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
> 
> Hi,
>  I think this should resolve the problem Mikulas noticed that the
>  bios form a deep chain instead of a wide tree.

I'm inclined to just fold this into the original commit.
I'd update that header to make mention of the details captured in this
header.

Would you be OK with that?

Mike
