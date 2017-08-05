From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Sat, 05 Aug 2017 16:19:30 -0400
Message-ID: <yq13795epil.fsf@oracle.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
        <20170802125509.GA18977@lst.de>
        <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
        <20170805134418.GB17694@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170805134418.GB17694@lst.de> (Christoph Hellwig's message of
        "Sat, 5 Aug 2017 15:44:18 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


Christoph,

> We can simply add another bio flag to get back to the previous
> behavior.  That being said thing to do in the end is to verify it
> at the top of the stack, and not the bottom eventuall.  I can cook
> up a patch for that.

Yeah, the original code was careful about only adding the verification
hook to the top bio.

A bio flag is probably the path of least resistance. It already exists,
actually: BIP_BLOCK_INTEGRITY. But we'll need to make sure it gets
masked out when a bio is cloned. And then we can key off of that and
REQ_OP_READ in the endio function.

I prefer that approach to reverting Christoph's commit.

-- 
Martin K. Petersen	Oracle Linux Engineering
