From: John Dorminy <jdorminy@redhat.com>
Subject: Re: block: be more careful about status in __bio_chain_endio
Date: Fri, 22 Feb 2019 22:10:39 -0500
Message-ID: <CAMeeMh9qLkTByWJewPR4o844wPkA-g5Hnm7aGjszuPopPAe8vA@mail.gmail.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <87eflmpqkb.fsf@notabene.neil.brown.name> <20190222211006.GA10987@redhat.com>
 <7f0aeb7b-fdaa-0625-f785-05c342047550@kernel.dk> <20190222235459.GA11726@redhat.com>
 <CAMeeMh-2ANOr_Sb66EyA_HULkVRudD7fyOZsDbpRpDrshwnR2w@mail.gmail.com> <20190223024402.GA12407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190223024402.GA12407@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

I'm also worried about the other two versions, though:

memory-barriers.txt#1724:

1724 (*) The compiler is within its rights to invent stores to a variable,

i.e. the compiler is free to decide __bio_chain_endio looks like this:

static struct bio *__bio_chain_endio(struct bio *bio)
{
  struct bio *parent = bio->bi_private;
  blk_status_t tmp = parent->bi_status;
  parent->bi_status = bio->bi_status;
  if (!bio->bi_status)
    parent->bi_status = tmp;
  bio_put(bio);
  return parent;
}

In which case, the read and later store on the two different threads
may overlap in such a way that bio_endio sometimes sees success, even
if one child had an error.

As a result, I believe the setting of parent->bi_status needs to be a
WRITE_ONCE() and the later reading needs to be a READ_ONCE()
[although, since the later reading happens in many different
functions, perhaps some other barrier to make sure all readers get the
correct value is in order.]
