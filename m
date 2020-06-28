From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Sun, 28 Jun 2020 15:04:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006281501230.347@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au> <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com> <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200626164617.GA211634@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, Jonathan Cameron <Jonathan.Cameron@Huawei.com>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
List-Id: dm-devel.ids



On Fri, 26 Jun 2020, Eric Biggers wrote:

> On Fri, Jun 26, 2020 at 12:16:33PM -0400, Mikulas Patocka wrote:
> > +/*
> > + * Pass these flags down through the crypto API.
> > + */
> > +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> 
> This comment is useless.  How about:
> 
> /*
>  * When an algorithm uses another algorithm (e.g., if it's an instance of a
>  * template), these are the flags that always get set on the "outer" algorithm
>  * if any "inner" algorithm has them set.  In some cases other flags are
>  * inherited too; these are just the flags that are *always* inherited.
>  */
> #define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> 
> Also I wonder about the case where the inner algorithm is a fallback rather than
> part of a template instance.  This patch only handles templates, not fallbacks.
> Is that intentional?  Isn't that technically a bug?

I'm not an expert in crypto internals, so I don't know. I'll send version 
3 of this patch and I'd like to ask you or Herbert to fix it.

> > +
> > +/*
> >   * Transform masks and values (for crt_flags).
> >   */
> >  #define CRYPTO_TFM_NEED_KEY		0x00000001
> > Index: linux-2.6/crypto/authenc.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
> >  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
> >  		return -EINVAL;
> >  
> > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > +	mask = crypto_requires_sync(algt->type, algt->mask) |
> > +	       crypto_requires_nomem(algt->type, algt->mask);
> 
> As I suggested earlier, shouldn't there be a function that returns the mask for
> all inherited flags, rather than handling each flag individually?

Yes - I've created crypto_requires_inherited for this purpose.

> >  
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> >  	if (!inst)
> > @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
> >  		goto err_free_inst;
> >  
> >  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> > -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> > +			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
> 
> Strange indentation here.  Likewise in most of the other files.

I was told that the code should be 80-characters wide.

> > Index: linux-2.6/crypto/xts.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -415,7 +415,7 @@ static int create(struct crypto_template
> >  	} else
> >  		goto err_free_inst;
> >  
> > -	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> > +	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
> >  	inst->alg.base.cra_priority = alg->base.cra_priority;
> >  	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
> >  	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
> 
> Need to set the mask correctly in this file.

I don't know what do you mean.

> > Index: linux-2.6/crypto/adiantum.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -507,7 +507,8 @@ static int adiantum_create(struct crypto
> >  	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
> >  		return -EINVAL;
> >  
> > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > +	mask = crypto_requires_sync(algt->type, algt->mask) |
> > +	       crypto_requires_nomem(algt->type, algt->mask);
> >  
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
> >  	if (!inst)
> 
> Need to use CRYPTO_ALG_INHERITED_FLAGS in this file.

OK.

> - Eric

Mikulas
