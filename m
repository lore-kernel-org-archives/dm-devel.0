From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] bio-integrity: Fix regression if profile verify_fn is NULL
Date: Wed, 02 Aug 2017 10:11:02 -0400
Message-ID: <yq1a83injpl.fsf@oracle.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
        <20170802125509.GA18977@lst.de>
        <f0eb700b-b2cb-1db8-98cb-f26dfb9e31c3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <f0eb700b-b2cb-1db8-98cb-f26dfb9e31c3@gmail.com> (Milan Broz's
        message of "Wed, 2 Aug 2017 15:15:19 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, axboe@kernel.dk, mpatocka@redhat.com, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


Milan,

> And the integrity profile is perfect interface for this, we register
> own profile through the proper interface.  (Any other solution for
> per-sector metadata would be worse, I tried...)

The DM use case seems a bit weird and I would like to take a closer look
later (a storm took out my power and internet so I'm a bit logistically
impaired right now). But the intent of the integrity infrastructure was
to be able to carry arbitrary metadata pinned to an I/O. The callback
hooks in the profile were really only intended for the case where the
block layer itself needed to generate and verify.

We already do sanity checking on the callback pointers in the prep
function. I guess don't have a problem doing the same in the completion
path.

Fundamentally, though, the verify function should only ever be called if
the profile has BLK_INTEGRITY_VERIFY set.

Previously that was done in the prep function by only adding the verify
endio hook when it was needed. Christoph's patch to kill the double
endio changed that subtly (FWIW, Jens originally objected to having an
integrity conditional in the regular bio completion path. That's why the
verification handling abused the endio function).

Anyway. So I think that the BLK_INTEGRITY_VERIFY logic needs to be
carried over to __bio_integrity_endio()...

-- 
Martin K. Petersen	Oracle Linux Engineering
