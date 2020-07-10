From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting
 flags
Date: Thu, 9 Jul 2020 23:24:03 -0700
Message-ID: <20200710062403.GB2805@sol.localdomain>
References: <20200701045217.121126-3-ebiggers@kernel.org>
 <20200709053126.GA5510@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200709053126.GA5510@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mpatocka@redhat.com, linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 03:31:26PM +1000, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > @@ -875,14 +873,21 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
> > 
> > static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> > {
> > +       struct crypto_attr_type *algt;
> >        struct shash_instance *inst;
> >        struct crypto_cipher_spawn *spawn;
> >        struct crypto_alg *alg;
> > +       u32 mask;
> >        int err;
> > 
> > -       err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
> > -       if (err)
> > -               return err;
> > +       algt = crypto_get_attr_type(tb);
> > +       if (IS_ERR(algt))
> > +               return PTR_ERR(algt);
> > +
> > +       if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
> > +               return -EINVAL;
> > +
> > +       mask = crypto_algt_inherited_mask(algt);
> 
> How about moving the types check into crypto_algt_inherited_mask,
> e.g.,
> 
> 	u32 mask;
> 	int err;
> 
> 	err = crypto_algt_inherited_mask(tb, CRYPTO_ALG_TYPE_SHASH);
> 	if (err < 0)
> 		return err;
> 
> 	mask = err;
> 
> This could then be used to simplify other templates too, such as
> gcm.
> 

I decided to make crypto_check_attr_type() return the mask instead, and do so
via a pointer argument instead of the return value (so that we don't overload an
errno return value and prevent flag 0x80000000 from working).
Please take a look at v2.  Thanks!

- Eric
