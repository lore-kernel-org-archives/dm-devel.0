From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/3 v4] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 30 Jun 2020 13:01:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
	<20200616173620.GA207319@gmail.com>
	<alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626044534.GA2870@gondor.apana.org.au>
	<alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626164617.GA211634@gmail.com>
	<alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
	<20200630163552.GA837@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200630163552.GA837@sol.localdomain>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 30 Jun 2020, Eric Biggers wrote:

> On Tue, Jun 30, 2020 at 09:56:22AM -0400, Mikulas Patocka wrote:
> > Index: linux-2.6/crypto/cryptd.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/cryptd.c	2020-06-29 16:03:07.346417000 +0200
> > +++ linux-2.6/crypto/cryptd.c	2020-06-30 15:49:04.206417000 +0200
> > @@ -202,6 +202,7 @@ static inline void cryptd_check_internal
> >  
> >  	*type |= algt->type & CRYPTO_ALG_INTERNAL;
> >  	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
> > +	*mask |= algt->mask & CRYPTO_ALG_INHERITED_FLAGS;
> >  }
> 
> This needs to use the correct logic (crypto_alg_inherited_mask) to decide which
> inherited flags to set in 'mask'.

I added "*mask |= crypto_alg_inherited_mask(algt->type, algt->mask);" 
there.


> > --- linux-2.6.orig/crypto/adiantum.c	2020-06-29 16:03:07.346417000 +0200
> > +++ linux-2.6/crypto/adiantum.c	2020-06-29 16:03:07.346417000 +0200
> > @@ -507,7 +507,7 @@ static int adiantum_create(struct crypto
> >  	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
> >  		return -EINVAL;
> >  
> > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
> >  
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
> >  	if (!inst)
> 
> This is still missing setting the flags correctly on the template instance being
> constructed.  The flags need to be inherited from all "inner" algorithms:
> 
> 	inst->alg.base.cra_flags = (streamcipher_alg->base.cra_flags |
> 				    blockcipher_alg->cra_flags |
> 				    hash_alg->base.cra_flags) &
> 				   CRYPTO_ALG_INHERITED_FLAGS;
> 
> If we don't do that, the template instance may allocate memory but not have
> CRYPTO_ALG_ALLOCATES_MEMORY set.

OK


> > Index: linux-2.6/crypto/pcrypt.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/pcrypt.c	2020-06-29 16:03:07.346417000 +0200
> > +++ linux-2.6/crypto/pcrypt.c	2020-06-30 15:47:32.776417000 +0200
> > @@ -263,7 +263,9 @@ static int pcrypt_create_aead(struct cry
> >  	if (err)
> >  		goto err_free_inst;
> >  
> > -	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
> > +	inst->alg.base.cra_flags =
> > +		CRYPTO_ALG_ASYNC |
> > +		(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
> >  
> >  	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
> >  	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);

What's wrong with this?


> And this is still missing setting the mask:
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 7240e8bbdebb..643f7f1cc91c 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
>  	struct crypto_attr_type *algt;
>  	struct aead_instance *inst;
>  	struct aead_alg *alg;
> +	u32 mask;
>  	int err;
>  
>  	algt = crypto_get_attr_type(tb);
>  	if (IS_ERR(algt))
>  		return PTR_ERR(algt);
>  
> +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
> +
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
>  	if (!inst)
>  		return -ENOMEM;
> @@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
>  		goto err_free_inst;
>  
>  	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
> -			       crypto_attr_alg_name(tb[1]), 0, 0);
> +			       crypto_attr_alg_name(tb[1]), 0, mask);
>  	if (err)
>  		goto err_free_inst;
>  

I added "mask" there - but there is still a "mask" argument that is 
unused - is it a bug to have two "mask" variables?


> Can you please think logically about what you're trying to accomplish?

I am not an expert in crypto code.

> In particular, if someone requests an algorithm that doesn't allocate memory
> (which is indicated by type=0, mask=CRYPTO_ALG_ALLOCATES_MEMORY), that request
> needs to be honored.
> 
> - Eric

Mikulas
