From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] bio-integrity: Fix regression if profile verify_fn is
 NULL
Date: Wed, 2 Aug 2017 15:15:19 +0200
Message-ID: <f0eb700b-b2cb-1db8-98cb-f26dfb9e31c3@gmail.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
 <20170802125509.GA18977@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170802125509.GA18977@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, mpatocka@redhat.com, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On 08/02/2017 02:55 PM, Christoph Hellwig wrote:
> On Wed, Aug 02, 2017 at 02:27:50PM +0200, Milan Broz wrote:
>> In dm-integrity target we register integrity profile that have
>> both generate_fn and verify_fn callbacks set to NULL.
>>
>> This is used if dm-integrity is stacked under a dm-crypt device
>> for authenticated encryption (integrity payload contains authentication
>> tag and IV seed).
>>
>> In this case the verification is done through own crypto API
>> processing inside dm-crypt; integrity profile is only holder
>> of these data. (And memory is owned by dm-crypt as well.)
> 
> Maybe that's where the problem lies?  You're abusing the integrity
> payload for something that is not end to end data integrity at all
> and then wonder why it breaks?  Also the commit that introduced your
> code had absolutely no review by Martin or any of the core block
> folks.
> 
> The right fix is to revert the dm-crypt commit.

Hi Christoph,

Why revert? The data there are integrity protection data, just it must to be
processed together with encryption through crypto API call (it is just AEAD,
it must take data + auth tag together).

And the integrity profile is perfect interface for this, we register
own profile through the proper interface.
(Any other solution for per-sector metadata would be worse, I tried...)

And yes, I agree that there should have been review form Martin,
TBH it was not intention to squeeze it there, seems everyone forgot
about this (but the patch went through dm-devel for months).
(Initially it was part of my research work so I care about idea and not patches
just it becomes production code too fast :-)

Anyway, we have it in 4.12 and from my point of view (as cryptsetup
maintainer) this is very needed functionality.

So what do you suggest to do now? I do not think we break anything,
just we need to agree how to use that integrity extension for additional
profiles.

Milan
