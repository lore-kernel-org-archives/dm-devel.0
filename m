From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 1/7] crypto: essiv - create wrapper
 template for ESSIV generation
Date: Fri, 28 Jun 2019 21:23:27 -0700
Message-ID: <20190629042327.GB886@sol.localdomain>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
	<20190628152112.914-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190628152112.914-2-ard.biesheuvel@linaro.org>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, Jun 28, 2019 at 05:21:06PM +0200, Ard Biesheuvel wrote:
> Implement a template that wraps a (skcipher,cipher,shash) or
> (aead,cipher,shash) tuple so that we can consolidate the ESSIV handling
> in fscrypt and dm-crypt and move it into the crypto API. This will result
> in better test coverage, and will allow future changes to make the bare
> cipher interface internal to the crypto subsystem, in order to increase
> robustness of the API against misuse.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  |   4 +
>  crypto/Makefile |   1 +
>  crypto/essiv.c  | 640 ++++++++++++++++++++
>  3 files changed, 645 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 3d056e7da65f..1aa47087c1a2 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1917,6 +1917,10 @@ config CRYPTO_STATS
>  config CRYPTO_HASH_INFO
>  	bool
>  
> +config CRYPTO_ESSIV
> +	tristate
> +	select CRYPTO_AUTHENC
> +

One more request: can you make this symbol explicitly selectable, with prompt
string and help text?

As discussed earlier, to reduce bloat I don't really want FS_ENCRYPTION to
select this.  So the user will need a way to select CRYPTO_ESSIV if they need
it.

- Eric
