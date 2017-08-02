From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] bio-integrity: Fix regression if profile verify_fn
        is NULL
Date: Wed, 2 Aug 2017 14:55:09 +0200
Message-ID: <20170802125509.GA18977@lst.de>
References: <20170802122750.12216-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802122750.12216-1-gmazyland@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-block@vger.kernel.org, hch@lst.de, axboe@kernel.dk, mpatocka@redhat.com, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Wed, Aug 02, 2017 at 02:27:50PM +0200, Milan Broz wrote:
> In dm-integrity target we register integrity profile that have
> both generate_fn and verify_fn callbacks set to NULL.
> 
> This is used if dm-integrity is stacked under a dm-crypt device
> for authenticated encryption (integrity payload contains authentication
> tag and IV seed).
> 
> In this case the verification is done through own crypto API
> processing inside dm-crypt; integrity profile is only holder
> of these data. (And memory is owned by dm-crypt as well.)

Maybe that's where the problem lies?  You're abusing the integrity
payload for something that is not end to end data integrity at all
and then wonder why it breaks?  Also the commit that introduced your
code had absolutely no review by Martin or any of the core block
folks.

The right fix is to revert the dm-crypt commit.
