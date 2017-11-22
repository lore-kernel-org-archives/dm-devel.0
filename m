From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: new patchset to eliminate DM's use of BIOSET_NEED_RESCUER
Date: Wed, 22 Nov 2017 13:49:31 -0500
Message-ID: <20171122184931.GA28348@redhat.com>
References: <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com>
 <20171121121049.GA17014@redhat.com>
 <20171121124311.GA17243@redhat.com>
 <20171121194709.GA18903@redhat.com>
 <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
 <20171121225119.GA19630@redhat.com>
 <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
 <87bmjv0xos.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 22 2017 at  1:24pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:
 
> Another problem is this:
> 
> struct bio *b = bio_clone_bioset(bio, GFP_NOIO, md->queue->bio_split);
> bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
> bio_chain(b, bio);
> 
> What if it blocks because the bioset is exhausted?
> 
> The code basically builds a chain of bios of unlimited length (suppose for 
> example a case when we are splitting on every sector boundary, so there 
> will be one bio for every sector in the original bio), it could exhaust 
> the bioset easily.
> 
> It would be better to use mechanism from md-raid that chains all the 
> sub-bios to the same master bio and doesn't create long chains of bios:
> 
>         if (max_sectors < bio_sectors(bio)) {
>                 struct bio *split = bio_split(bio, max_sectors,
>                                               gfp, conf->bio_split);
>                 bio_chain(split, bio);
>                 generic_make_request(bio);
>                 bio = split;
>                 r1_bio->master_bio = bio;
>                 r1_bio->sectors = max_sectors;
>         }

I'd be happy to take an incremental patch that improves on this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=b46d6a08f1ae7bf53e4cde28e0ccdf91567d432e

But short of that I'll have to come back to this.

Thanks,
Mike
