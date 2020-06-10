From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto API and GFP_ATOMIC
Date: Wed, 10 Jun 2020 22:11:07 +1000
Message-ID: <20200610121106.GA23137@gondor.apana.org.au>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 10, 2020 at 08:02:23AM -0400, Mikulas Patocka wrote:
>
> Yes, fixing the drivers would be the best - but you can hardly find any 
> person who has all the crypto hardware and who is willing to rewrite all 
> the drivers for it.

We don't have to rewrite them straight away.  We could mark the
known broken ones (or the known working ones) and then dm-crypt
can allocate only those using the types/mask to crypto_alloc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
