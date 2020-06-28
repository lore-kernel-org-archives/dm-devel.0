From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Sun, 28 Jun 2020 15:07:49 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006281505530.347@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200610121106.GA23137@gondor.apana.org.au>
	<alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
	<20200616173620.GA207319@gmail.com>
	<alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626044534.GA2870@gondor.apana.org.au>
	<alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626164617.GA211634@gmail.com>
	<20200626170039.GB211634@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200626170039.GB211634@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Zaibo Xu <xuzaibo@Huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@Huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 26 Jun 2020, Eric Biggers wrote:

> On Fri, Jun 26, 2020 at 09:46:17AM -0700, Eric Biggers wrote:
> > On Fri, Jun 26, 2020 at 12:16:33PM -0400, Mikulas Patocka wrote:
> > > +/*
> > > + * Pass these flags down through the crypto API.
> > > + */
> > > +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> > 
> > This comment is useless.  How about:
> > 
> > /*
> >  * When an algorithm uses another algorithm (e.g., if it's an instance of a
> >  * template), these are the flags that always get set on the "outer" algorithm
> >  * if any "inner" algorithm has them set.  In some cases other flags are
> >  * inherited too; these are just the flags that are *always* inherited.
> >  */
> > #define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> > 
> > Also I wonder about the case where the inner algorithm is a fallback rather than
> > part of a template instance.  This patch only handles templates, not fallbacks.
> > Is that intentional?  Isn't that technically a bug?
> 
> Also is CRYPTO_ALG_ALLOCATES_MEMORY meant to apply for algorithms of type
> "cipher" and "shash"?  The code doesn't handle those, so presumably not?
> 
> What about "akcipher"?

Yes - the patch should apply for these cases, but I don't know how to do 
it. Please, do it.

> > > Index: linux-2.6/crypto/xts.c
> > > ===================================================================
> > > --- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > > +++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > > @@ -415,7 +415,7 @@ static int create(struct crypto_template
> > >  	} else
> > >  		goto err_free_inst;
> > >  
> > > -	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> > > +	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
> > >  	inst->alg.base.cra_priority = alg->base.cra_priority;
> > >  	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
> > >  	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
> > 
> > Need to set the mask correctly in this file.
> 
> cryptd_create_skcipher(), cryptd_create_hash(), cryptd_create_aead(), and
> crypto_rfc4309_create() are also missing setting the mask.
> 
> pcrypt_create_aead() is missing both setting the mask and inheriting the flags.

I added CRYPTO_ALG_ALLOCATES_MEMORY there.

> Also, "seqiv" instances can be created without CRYPTO_ALG_ALLOCATES_MEMORY set,
> despite seqiv_aead_encrypt() allocating memory.
> 
> - Eric

Mikulas
