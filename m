From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: crypto API and GFP_ATOMIC
Date: Tue, 16 Jun 2020 11:01:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
	<20200610010450.GA6449@gondor.apana.org.au>
	<alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
	<20200610121106.GA23137@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200610121106.GA23137@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 10 Jun 2020, Herbert Xu wrote:

> On Wed, Jun 10, 2020 at 08:02:23AM -0400, Mikulas Patocka wrote:
> >
> > Yes, fixing the drivers would be the best - but you can hardly find any 
> > person who has all the crypto hardware and who is willing to rewrite all 
> > the drivers for it.
> 
> We don't have to rewrite them straight away.  We could mark the
> known broken ones (or the known working ones) and then dm-crypt
> can allocate only those using the types/mask to crypto_alloc.
> 
> Cheers,

I triaged the drivers in drivers/crypto and unfortunatelly, most of them 
do memory allocation in the encryption routine. Some of the do GFP_KERNEL 
allocation even in the absence of CRYPTO_TFM_REQ_MAY_SLEEP.

I'm sending the patches:

The first patch adds a new flag CRYPTO_ALG_ALLOCATES_MEMORY.

The second patch passes CRYPTO_ALG_ALLOCATES_MEMORY through the crypto API 
stack (please check it - I am not an expert in this area).

The third patch sets CRYPTO_ALG_ALLOCATES_MEMORY on drivers that allocate 
memory in the encrypt/decrypt routine.

The fourth patch fixes the drivers that use GFP_KERNEL in non-blocking 
context.

Mikulas
