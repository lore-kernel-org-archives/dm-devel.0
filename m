From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Sun, 28 Jun 2020 13:00:22 -0700
Message-ID: <20200628200022.GE11197@sol.localdomain>
References: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <20200626170039.GB211634@gmail.com>
 <alpine.LRH.2.02.2006281505530.347@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006281505530.347@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Sun, Jun 28, 2020 at 03:07:49PM -0400, Mikulas Patocka wrote:
> > 
> > cryptd_create_skcipher(), cryptd_create_hash(), cryptd_create_aead(), and
> > crypto_rfc4309_create() are also missing setting the mask.
> > 
> > pcrypt_create_aead() is missing both setting the mask and inheriting the flags.
> 
> I added CRYPTO_ALG_ALLOCATES_MEMORY there.

I don't see where the cryptd request processing functions allocate memory.

It seems that cryptd should just inherit the flag, like most other templates.

Likewise for pcrypt.

And also likewise for rfc4309.

Where are you seeing the memory allocations that would require
CRYPTO_ALG_ALLOCATES_MEMORY to always be enabled for these?

- Eric
