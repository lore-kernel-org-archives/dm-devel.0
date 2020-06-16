From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [PATCH 4/4] crypto: fix the drivers that don't
 respect CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Jun 2020 10:50:22 -0700
Message-ID: <20200616175022.GD207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2020 at 11:02:50AM -0400, Mikulas Patocka wrote:
> Fix the crypto drivers that don't respect CRYPTO_TFM_REQ_MAY_SLEEP. If
> CRYPTO_TFM_REQ_MAY_SLEEP is not set, the driver must not do allocation
> that sleeps.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I think you need to split this up per driver with a proper explanation and a
"Fixes:" tag for each driver.

Also, these bugs should have been detected by the crypto self-tests already,
since they test having preemption disabled and CRYPTO_TFM_REQ_MAY_SLEEP cleared.
Can you double check whether these are all valid fixes?  One thing to watch out
for is that CRYPTO_TFM_REQ_MAY_SLEEP only applies to the function call like
crypto_skcipher_encrypt() itself.  If the implementation is asynchronous and the
request gets processed in the background (i.e. if crypto_skcipher_encrypt()
returns -EINPROGRESS), the background work doesn't have to honor
CRYPTO_TFM_REQ_MAY_SLEEP.

- Eric
