From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] bio-integrity: Fix regression if profile verify_fn is
 NULL
Date: Wed, 2 Aug 2017 17:24:27 +0200
Message-ID: <aa4d5292-8484-f651-930d-84ed2f061a0a@gmail.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
 <20170802125509.GA18977@lst.de>
 <f0eb700b-b2cb-1db8-98cb-f26dfb9e31c3@gmail.com> <yq1a83injpl.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1a83injpl.fsf@oracle.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, axboe@kernel.dk, mpatocka@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids


On 08/02/2017 04:11 PM, Martin K. Petersen wrote:
>> And the integrity profile is perfect interface for this, we register
>> own profile through the proper interface.  (Any other solution for
>> per-sector metadata would be worse, I tried...)
> 
> The DM use case seems a bit weird and I would like to take a closer look
> later (a storm took out my power and internet so I'm a bit logistically
> impaired right now).

Hi Martin,

thanks!

I think it is actually pretty straightforward (if it can be said
about anything in the device-mapper little walled garden :-)

For the authenticated encryption (on the sector level) we cannot use
a length-preserving encryption (as it is dm-crypt in normal mode) but we need
some per-sector metadata to store additional authentication tag.

This is exactly what DIF/T10-PI already does, just we need more flexibility
(and larger metadata to use cryptographically sound modes).

So we developed dm-integrity target that takes a normal block device,
stores per-sector metadata on-disk in special sectors (interleaved with normal
data sectors).
(There is a journalling to provide atomicity of data + metadata writes.)

The dm-integrity can calculate some non-cryptographic integrity data itself,
but this mode does not use block integrity extension at all so it is not important here.

The second use case (that is currently broken by the block layer 4.13 changes)
is that dm-integrity can register a new integrity profile for the virtual device
(on top of normal block device) and present data sectors as normal bio layer and
metadata as the bio-integrity layer (dm-crypt will receive bio with the metadata
in integrity fields).

IOW dm-integrity is just "emulator" for the integrity-enabled block device,
just with configurable per-sector metadata size.

Then we can place dm-crypt above this device and process the bio the same way
as dm-crypt does, just it will add authentication tag mapped to the metadata
for that special integrity profile.

The dm-crypt already creates bio clones (and already owns the bio clone memory)
so we do exactly the same for integrity part of bio (clearing the BIP_BLOCK_INTEGRITY
flag to indicate that block layer should not free this memory).

Otherwise I think we use bio the exact way how the driver should register
and alloc memory for own integrity profile (see dm_crypt_integrity_io_alloc function).

Milan


> But the intent of the integrity infrastructure was
> to be able to carry arbitrary metadata pinned to an I/O. The callback
> hooks in the profile were really only intended for the case where the
> block layer itself needed to generate and verify.
> 
> We already do sanity checking on the callback pointers in the prep
> function. I guess don't have a problem doing the same in the completion
> path.
> 
> Fundamentally, though, the verify function should only ever be called if
> the profile has BLK_INTEGRITY_VERIFY set.
> 
> Previously that was done in the prep function by only adding the verify
> endio hook when it was needed. Christoph's patch to kill the double
> endio changed that subtly (FWIW, Jens originally objected to having an
> integrity conditional in the regular bio completion path. That's why the
> verification handling abused the endio function).
> 
> Anyway. So I think that the BLK_INTEGRITY_VERIFY logic needs to be
> carried over to __bio_integrity_endio()...
> 
