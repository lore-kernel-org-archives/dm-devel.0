From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [PATCH 2/4] crypto: pass the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 16 Jun 2020 10:42:40 -0700
Message-ID: <20200616174240.GB207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101380.28052@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161101380.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2020 at 11:01:58AM -0400, Mikulas Patocka wrote:
> Pass the flag CRYPTO_ALG_ALLOCATES_MEMORY down through the crypto API.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  crypto/adiantum.c         |    3 ++-
>  crypto/authenc.c          |    5 +++--
>  crypto/authencesn.c       |    5 +++--
>  crypto/ccm.c              |    7 ++++---
>  crypto/chacha20poly1305.c |    5 +++--
>  crypto/cryptd.c           |    7 +++++--
>  crypto/ctr.c              |    3 ++-
>  crypto/cts.c              |    5 +++--
>  crypto/essiv.c            |    5 +++--
>  crypto/gcm.c              |   15 +++++++++------
>  crypto/geniv.c            |    3 ++-
>  crypto/lrw.c              |    5 +++--
>  crypto/rsa-pkcs1pad.c     |    5 +++--
>  crypto/xts.c              |    2 +-
>  include/crypto/algapi.h   |    9 +++++++++
>  15 files changed, 55 insertions(+), 29 deletions(-)
> 
> Index: linux-2.6/crypto/authenc.c
> ===================================================================
> --- linux-2.6.orig/crypto/authenc.c
> +++ linux-2.6/crypto/authenc.c
> @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
>  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
>  		return -EINVAL;
>  
> -	mask = crypto_requires_sync(algt->type, algt->mask);
> +	mask = crypto_requires_sync(algt->type, algt->mask) |
> +	       crypto_requires_nomem(algt->type, algt->mask);
>  
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
>  	if (!inst)
> @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
>  		goto err_free_inst;
>  
>  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> +				    enc->base.cra_flags) & (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY);

ASYNC and ALLOCATES_MEMORY are both handled the same way.  They're both
"inherited" from inner algorithms to the template instance.  And if someone
requests that one of these flags be clear when instantiating a template, then we
have to honor the same for the inner algorithms too.

So, shouldn't we define something like crypto_algt_mask() and
CRYPTO_ALG_INHERITED_FLAGS and make them handle both ASYNC and ALLOCATES_MEMORY,
rather than explicitly handling each of these flags everywhere again?

- Eric
