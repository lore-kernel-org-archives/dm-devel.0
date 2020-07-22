From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date: Wed, 22 Jul 2020 17:29:32 +1000
Message-ID: <20200722072932.GA27544@gondor.apana.org.au>
References: <20200716115538.GA31461@gondor.apana.org.au>
 <8eefed8b-5ad5-424b-ab32-85e0cbac0a15@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8eefed8b-5ad5-424b-ab32-85e0cbac0a15@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Eric Biggers <ebiggers@kernel.org>, mpatocka@redhat.com, linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 17, 2020 at 05:42:43PM +0300, Horia Geantă wrote:
>
> Looks like there's no mention of a limit on src, dst scatterlists size
> that crypto implementations could use when pre-allocating memory
> and crypto users needing CRYPTO_ALG_ALLOCATES_MEMORY should be aware of
> (for the contract to be honoured):
> https://lore.kernel.org/linux-crypto/780cb500-2241-61bc-eb44-6f872ad567d3@nxp.com

Good point.  I think we should limit this flag only to the cases
applicable to dm-crypt, which seems to be 4 entries maximum.

Anything else should be allowed to allocate extra memory as needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
