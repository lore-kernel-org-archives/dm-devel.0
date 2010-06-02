From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 2 Jun 2010 16:07:02 +1000
Message-ID: <20100602060702.GA6319@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <20100601043901.GA25693@gondor.apana.org.au> <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com> <20100602051403.GA5784@gondor.apana.org.au> <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

On Wed, Jun 02, 2010 at 01:25:11AM -0400, Mikulas Patocka wrote:
>
> Are you sure that you know what you're talking about? pcrypt_alloc 
> contains this:
> switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
> case CRYPTO_ALG_TYPE_AEAD:
>         return pcrypt_alloc_aead(tb);
> }
> 
> return ERR_PTR(-EINVAL);
> --- so for anything other byt AEAD it returns -EINVAL.

So someone needs to write the ablkcipher plugins for pcrypt.

This is the whole point of pcrypt, to implement parallelisation
exactly once, in the crypto layer.

> For what? For avoiding cache bounces? But the encrypting is 
> order-of-magnitude slower than memory speed.

Have you benchmarked the Nehalem AES performance lately?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
