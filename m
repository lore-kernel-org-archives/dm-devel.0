From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [PATCH 1/3 v4] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 30 Jun 2020 10:57:46 -0700
Message-ID: <20200630175746.GA2026704@gmail.com>
References: <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
 <20200630163552.GA837@sol.localdomain>
 <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 30, 2020 at 01:01:16PM -0400, Mikulas Patocka wrote:
> > diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> > index 7240e8bbdebb..643f7f1cc91c 100644
> > --- a/crypto/pcrypt.c
> > +++ b/crypto/pcrypt.c
> > @@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> >  	struct crypto_attr_type *algt;
> >  	struct aead_instance *inst;
> >  	struct aead_alg *alg;
> > +	u32 mask;
> >  	int err;
> >  
> >  	algt = crypto_get_attr_type(tb);
> >  	if (IS_ERR(algt))
> >  		return PTR_ERR(algt);
> >  
> > +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
> > +
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> >  	if (!inst)
> >  		return -ENOMEM;
> > @@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> >  		goto err_free_inst;
> >  
> >  	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
> > -			       crypto_attr_alg_name(tb[1]), 0, 0);
> > +			       crypto_attr_alg_name(tb[1]), 0, mask);
> >  	if (err)
> >  		goto err_free_inst;
> >  
> 
> I added "mask" there - but there is still a "mask" argument that is 
> unused - is it a bug to have two "mask" variables?

Right, I didn't see that algt->type and algt->mask are already being passed to 
pcrypt_create_aead().  It's redundant because pcrypt_create_aead() has access to
those via crypto_get_attr_type() anyway.

How about just removing those two arguments for now?

- Eric
