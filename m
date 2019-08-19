From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v12 1/4] crypto: essiv - create wrapper
 template for ESSIV generation
Date: Mon, 19 Aug 2019 16:32:18 +1000
Message-ID: <20190819063218.GA31821@gondor.apana.org.au>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
	<20190815192858.28125-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190815192858.28125-2-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Thu, Aug 15, 2019 at 10:28:55PM +0300, Ard Biesheuvel wrote:
>
> +	/* Synchronous hash, e.g., "sha256" */
> +	ictx->hash = crypto_alloc_shash(shash_name, 0, 0);
> +	if (IS_ERR(ictx->hash)) {
> +		err = PTR_ERR(ictx->hash);
> +		goto out_drop_skcipher;
> +	}

Holding a reference to this algorithm for the life-time of the
instance is not nice.  How about just doing a lookup as you were
doing before with crypto_alg_mod_lookup and getting the cra_name
from that?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
