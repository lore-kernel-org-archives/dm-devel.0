From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: be more careful about status in __bio_chain_endio
Date: Fri, 22 Feb 2019 21:44:02 -0500
Message-ID: <20190223024402.GA12407@redhat.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <87eflmpqkb.fsf@notabene.neil.brown.name>
 <20190222211006.GA10987@redhat.com>
 <7f0aeb7b-fdaa-0625-f785-05c342047550@kernel.dk>
 <20190222235459.GA11726@redhat.com>
 <CAMeeMh-2ANOr_Sb66EyA_HULkVRudD7fyOZsDbpRpDrshwnR2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMeeMh-2ANOr_Sb66EyA_HULkVRudD7fyOZsDbpRpDrshwnR2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Dorminy <jdorminy@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Feb 22 2019 at  9:02pm -0500,
John Dorminy <jdorminy@redhat.com> wrote:

> I am perhaps not understanding the intricacies here, or not seeing a
> barrier protecting it, so forgive me if I'm off base. I think reading
> parent->bi_status here is unsafe.
> Consider the following sequence of events on two threads.
> 
> Thread 0                                 Thread 1
> In __bio_chain_endio:                    In __bio_chain_endio:
> [A] Child 0 reads parent->bi_status,
>     no error.
>                                          Child bio 1 reads parent, no error seen
>                                          It sets parent->bi_status to an error
>                                          It calls bio_put.
> Child bio 0 calls bio_put
> [end __bio_chain_endio]                  [end __bio_chain_endio]
>                                          In bio_chain_endio(), bio_endio(parent)
>                                          is called, calling bio_remaining_done()
>                                          which decrements __bi_remaining to 1
>                                          and returns false, so no further endio
>                                          stuff is done.
> In bio_chain_endio(), bio_endio(parent)
> is called, calling bio_remaining_done(),
> decrementing parent->__bi_remaining to
>  0, and continuing to finish parent.
> Either for block tracing or for parent's
> bi_end_io(), this thread tries to read
> parent->bi_status again.
> 
> The compiler or the CPU may cache the read from [A], and since there
> are no intervening barriers, parent->bi_status is still believed on
> thread 0 to be success. Thus the bio may still be falsely believed to
> have completed successfully, even though child 1 set an error in it.
> 
> Am I missing a subtlety here?

Either neilb's original or even Jens' suggestion would be fine though.

>       if (!parent->bi_status && bio->bi_status)
>               parent->bi_status = bio->bi_status;

Even if your scenario did play out (which I agree it looks possible)
it'd just degenerate to neilb's version:

>       if (bio->bi_status)
>               parent->bi_status = bio->bi_status;

Which also accomplishes fixing what Neil originally detailed in his
patch header.
