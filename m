From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v5 2/7] fs: crypto: invoke crypto API for ESSIV handling
Date: Thu, 27 Jun 2019 09:39:38 -0700
Message-ID: <20190627163938.GD686@sol.localdomain>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
 <20190626204047.32131-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190626204047.32131-3-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: dm-devel.ids

On Wed, Jun 26, 2019 at 10:40:42PM +0200, Ard Biesheuvel wrote:
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index dcd91a3fbe49..82c7eb86ca00 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -19,8 +19,6 @@
>  #include <crypto/skcipher.h>
>  #include "fscrypt_private.h"

Can you remove the includes that become unused as a result of this patch?

#include <crypto/aes.h>
#include <crypto/sha.h>

> @@ -495,7 +412,6 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  		put_master_key(ci->ci_master_key);
>  	} else {
>  		crypto_free_skcipher(ci->ci_ctfm);
> -		crypto_free_cipher(ci->ci_essiv_tfm);
>  	}
>  	kmem_cache_free(fscrypt_info_cachep, ci);

Nit: should remove the curly braces here.

- Eric
