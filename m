From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: pass the flag CRYPTO_ALG_ALLOCATES_MEMORY
Date: Fri, 26 Jun 2020 14:45:34 +1000
Message-ID: <20200626044534.GA2870@gondor.apana.org.au>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, Jonathan Cameron <Jonathan.Cameron@Huawei.com>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
List-Id: dm-devel.ids

On Wed, Jun 17, 2020 at 11:09:28AM -0400, Mikulas Patocka wrote:
>
> Index: linux-2.6/include/linux/crypto.h
> ===================================================================
> --- linux-2.6.orig/include/linux/crypto.h
> +++ linux-2.6/include/linux/crypto.h
> @@ -97,9 +97,18 @@
>  #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
>  
>  /*
> + * The driver may allocate memory during request processing, so it shouldn't be
> + * used in cases where memory allocation failures aren't acceptable, such as
> + * during block device encryption.
> + */
> +#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
> +
> +/*
>   * Don't trigger module loading
>   */
> -#define CRYPTO_NOLOAD			0x00008000
> +#define CRYPTO_NOLOAD			0x00010000
> +
> +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)

Any reason why you need to renumber NOLOAD? If not please keep
the existing values.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
