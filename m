From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v6 2/7] fs: crypto: invoke crypto API for
	ESSIV handling
Date: Fri, 28 Jun 2019 20:09:54 +0200
Message-ID: <CAKv+Gu9=6uWSy2V4=7CVU6oqVUA0GFrjXHp48aiZ6sd_YQH-Uw@mail.gmail.com>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
	<20190628152112.914-3-ard.biesheuvel@linaro.org>
	<20190628180037.GC103946@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190628180037.GC103946@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, 28 Jun 2019 at 20:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 05:21:07PM +0200, Ard Biesheuvel wrote:
> > diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> > index dcd91a3fbe49..f39667d4316a 100644
> > --- a/fs/crypto/keyinfo.c
> > +++ b/fs/crypto/keyinfo.c
> > @@ -13,14 +13,10 @@
> >  #include <linux/hashtable.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/ratelimit.h>
> > -#include <crypto/aes.h>
> >  #include <crypto/algapi.h>
> > -#include <crypto/sha.h>
> >  #include <crypto/skcipher.h>
> >  #include "fscrypt_private.h"
> >
> > -static struct crypto_shash *essiv_hash_tfm;
> > -
> >  /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
> >  static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
> >  static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
> > @@ -144,10 +140,9 @@ static struct fscrypt_mode available_modes[] = {
> >       },
> >       [FS_ENCRYPTION_MODE_AES_128_CBC] = {
> >               .friendly_name = "AES-128-CBC",
> > -             .cipher_str = "cbc(aes)",
> > +             .cipher_str = "essiv(cbc(aes),aes,sha256)",
> >               .keysize = 16,
> > -             .ivsize = 16,
> > -             .needs_essiv = true,
> > +             .ivsize = 8,
> >       },
>
> Now that the essiv template takes the same size IV, the .ivsize here needs to be
> left as 16.
>

indeed. Thanks for spotting that.
