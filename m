From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] crypto: introduce
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Wed, 17 Jun 2020 11:08:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616173620.GA207319@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200616173620.GA207319@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, Jonathan Cameron <Jonathan.Cameron@Huawei.com>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
List-Id: dm-devel.ids

I'm resending the patches with your comments resolved...

Mikulas



On Tue, 16 Jun 2020, Eric Biggers wrote:

> On Tue, Jun 16, 2020 at 11:01:31AM -0400, Mikulas Patocka wrote:
> > Introduce a new flag CRYPTO_ALG_ALLOCATES_MEMORY and modify dm-crypt, so
> > that it uses only drivers without this flag.
> > 
> > If the flag is set, then the crypto driver allocates memory in its request
> > routine. Such drivers are not suitable for disk encryption because
> > GFP_ATOMIC allocation can fail anytime (causing random I/O errors) and
> > GFP_KERNEL allocation can recurse into the block layer, causing a
> > deadlock.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Index: linux-2.6/include/linux/crypto.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/crypto.h
> > +++ linux-2.6/include/linux/crypto.h
> > @@ -97,9 +97,15 @@
> >  #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
> >  
> >  /*
> > + * The driver is allocating emmory in its encrypt or decrypt callback,
> > + * so it should not be used to encrypt block devices.
> > + */
> 
> "is allocating emmory" => "may allocate memory"
> 
> "so it should not be used to encrypt block devices" =>
> "so it shouldn't be used in cases where memory allocation failures aren't
>  acceptable, such as during block device encryption".
> 
> Also, which types of algorithms does this flag apply to?  E.g. if it applies to
> hash algorithms too, it's not sufficient to say "encrypt or decrypt callback".
> 
> How about:
> 
>  /*
>   * The driver may allocate memory during request processing, so it shouldn't be
>   * used in cases where memory allocation failures aren't acceptable, such as
>   * during block device encryption.
>   */
> 
> > +#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
> > +
> > +/*
> >   * Don't trigger module loading
> >   */
> > -#define CRYPTO_NOLOAD			0x00008000
> > +#define CRYPTO_NOLOAD			0x00010000
> >  
> >  /*
> >   * Transform masks and values (for crt_flags).
> > Index: linux-2.6/drivers/md/dm-crypt.c
> > ===================================================================
> 
> This would better belong as two separate patches: one to introduce
> CRYPTO_ALG_ALLOCATES_MEMORY, and one to make dm-crypt use it.
> 
> > --- linux-2.6.orig/drivers/md/dm-crypt.c
> > +++ linux-2.6/drivers/md/dm-crypt.c
> > @@ -419,7 +419,7 @@ static int crypt_iv_lmk_ctr(struct crypt
> >  		return -EINVAL;
> >  	}
> >  
> > -	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
> > +	lmk->hash_tfm = crypto_alloc_shash("md5", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> >  	if (IS_ERR(lmk->hash_tfm)) {
> >  		ti->error = "Error initializing LMK hash";
> >  		return PTR_ERR(lmk->hash_tfm);
> > @@ -581,7 +581,7 @@ static int crypt_iv_tcw_ctr(struct crypt
> >  		return -EINVAL;
> >  	}
> >  
> > -	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
> > +	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> >  	if (IS_ERR(tcw->crc32_tfm)) {
> >  		ti->error = "Error initializing CRC32 in TCW";
> >  		return PTR_ERR(tcw->crc32_tfm);
> > @@ -768,7 +768,7 @@ static int crypt_iv_elephant_ctr(struct
> >  	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
> >  	int r;
> >  
> > -	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
> > +	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> >  	if (IS_ERR(elephant->tfm)) {
> >  		r = PTR_ERR(elephant->tfm);
> >  		elephant->tfm = NULL;
> > @@ -2088,7 +2088,7 @@ static int crypt_alloc_tfms_skcipher(str
> >  		return -ENOMEM;
> >  
> >  	for (i = 0; i < cc->tfms_count; i++) {
> > -		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
> > +		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> 
> Despite the recent relaxation in rules, the preferred length of a line is still
> 80 columns.
> 
> - Eric
> 
