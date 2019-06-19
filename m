From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 2/6] fs: crypto: invoke crypto API for
	ESSIV handling
Date: Wed, 19 Jun 2019 15:45:51 -0700
Message-ID: <20190619224550.GD33328@gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
	<20190619162921.12509-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-3-ard.biesheuvel@linaro.org>
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

On Wed, Jun 19, 2019 at 06:29:17PM +0200, Ard Biesheuvel wrote:
> Instead of open coding the calculations for ESSIV handling, use a
> ESSIV skcipher which does all of this under the hood.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  fs/crypto/Kconfig           |  1 +
>  fs/crypto/crypto.c          |  5 --
>  fs/crypto/fscrypt_private.h |  9 --
>  fs/crypto/keyinfo.c         | 88 +-------------------
>  4 files changed, 3 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 24ed99e2eca0..b0292da8613c 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -5,6 +5,7 @@ config FS_ENCRYPTION
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
>  	select CRYPTO_ECB
> +	select CRYPTO_ESSIV
>  	select CRYPTO_XTS
>  	select CRYPTO_CTS
>  	select CRYPTO_SHA256

Selecting CRYPTO_ESSIV is fine for now, but I'd really like to de-bloat the
dependencies of FS_ENCRYPTION (probably in a separate patch) by removing
CRYPTO_ESSIV and CRYPTO_SHA256 and documenting in the encryption modes section
of Documentation/filesystems/fscrypt.rst that people need to select them
themselves if they want to use AES-128-CBC.  I already took that approach when I
added Adiantum support, so we don't force all fscrypt users to build Adiantum,
ChaCha, Poly1305, etc. into their kernels.

- Eric
