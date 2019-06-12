From: John Dorminy <jdorminy@redhat.com>
Subject: Re: block: be more careful about status in __bio_chain_endio
Date: Tue, 11 Jun 2019 22:56:42 -0400
Message-ID: <CAMeeMh-6KMLgriX_7KT52ynjBMyT9yDWSMKv6YXW+yDpvv0=wA@mail.gmail.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <87eflmpqkb.fsf@notabene.neil.brown.name> <20190222211006.GA10987@redhat.com>
 <7f0aeb7b-fdaa-0625-f785-05c342047550@kernel.dk> <20190222235459.GA11726@redhat.com>
 <CAMeeMh-2ANOr_Sb66EyA_HULkVRudD7fyOZsDbpRpDrshwnR2w@mail.gmail.com>
 <20190223024402.GA12407@redhat.com> <CAMeeMh9qLkTByWJewPR4o844wPkA-g5Hnm7aGjszuPopPAe8vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMeeMh9qLkTByWJewPR4o844wPkA-g5Hnm7aGjszuPopPAe8vA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Having studied the code in question more thoroughly, my first email's
scenario can't occur, I believe. bio_put() contains a
atomic_dec_and_test(), which (according to
Documentation/atomic_t.txt), having a return value, are fully ordered
and therefore impose a general memory barrier. A general memory
barrier means that no value set before bio_put() may be observed
afterwards, if I accurately understand
Documentation/memory_barriers.txt. Thus, the scenario I imagined, with
a load from inside __bio_chain_endio() being visible in bi_end_io(),
cannot occur.

However, the second email's scenario, of a compiler making two stores
out of a conditional store, is still accurate according to my
understanding. I continue to believe setting parent->bi_status needs
to be a WRITE_ONCE() and any reading of parent->bi_status before
bio_put() needs to be at least a READ_ONCE(). The last thing in that
email is wrong for the same reason that the first email couldn't
happen: the bio_put() general barrier means later accesses to the
field from a single thread will freshly read the field and thereby not
get an incorrectly cached value.

As a concrete proposal, I believe either of the following work and fix
the race NeilB described, as well as the compiler (or CPU) race I
described:

 -     if (!parent->bi_status)
 -               parent->bi_status = bio->bi_status;
 +     if (bio->bi_status)
 +               WRITE_ONCE(parent->bi_status, bio->bi_status);

--or--

 -     if (!parent->bi_status)
 -               parent->bi_status = bio->bi_status;
 +     if (!READ_ONCE(parent->bi_status) && bio->bi_status)
 +               WRITE_ONCE(parent->bi_status, bio->bi_status);

I believe the second of these might, but is not guaranteed to,
preserve the first error observed in a child; I believe if you want to
definitely save the first error you need an atomic.
