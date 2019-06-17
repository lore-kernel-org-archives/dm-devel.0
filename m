From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: be more careful about status in __bio_chain_endio
Date: Mon, 17 Jun 2019 09:32:39 +0200
Message-ID: <b023cf7a-ca86-5516-b441-30bec442dee6@suse.de>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <87eflmpqkb.fsf@notabene.neil.brown.name> <20190222211006.GA10987@redhat.com>
 <7f0aeb7b-fdaa-0625-f785-05c342047550@kernel.dk>
 <20190222235459.GA11726@redhat.com>
 <CAMeeMh-2ANOr_Sb66EyA_HULkVRudD7fyOZsDbpRpDrshwnR2w@mail.gmail.com>
 <20190223024402.GA12407@redhat.com>
 <CAMeeMh9qLkTByWJewPR4o844wPkA-g5Hnm7aGjszuPopPAe8vA@mail.gmail.com>
 <CAMeeMh-6KMLgriX_7KT52ynjBMyT9yDWSMKv6YXW+yDpvv0=wA@mail.gmail.com>
 <20190612070110.GA11707@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612070110.GA11707@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, John Dorminy <jdorminy@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 6/12/19 9:01 AM, Christoph Hellwig wrote:
> On Tue, Jun 11, 2019 at 10:56:42PM -0400, John Dorminy wrote:
>> I believe the second of these might, but is not guaranteed to,
>> preserve the first error observed in a child; I believe if you want to
>> definitely save the first error you need an atomic.
> 
> Is there any reason not to simply use a cmpxchg?  Yes, it is a
> relatively expensive operation, but once we are chaining bios we are out
> of the super hot path anyway.  We do something similar in xfs and iomap
> already.
> 
Agree.
Thing is, we need to check if the parent status is NULL, _and_ the
parent status might be modified asynchronously.
So even a READ_ONCE() wouldn't cut it, as it would tell us that the
parent status _was_ NULL, not that the parent status _is_ NULL by the
time we're setting it.
So cmpxchg() is it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
