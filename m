From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Wed, 18 Jul 2018 09:11:52 -0400
Message-ID: <20180718131152.GA25685@redhat.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Milan Broz <gmazyland@gmail.com>
Cc: agk@redhat.com, herbert@gondor.apana.org.au, dm-devel@redhat.com, broonie@kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

On Wed, Jul 18 2018 at  4:16am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 18/07/18 09:30, Xiongfeng Wang wrote:
> > Currently, the IV generation algorithms are implemented in dm-crypt.c.
> > This patch implement these algorithms as template ciphers, so that
> > dm-crypt layer can be simplified, and also these algorithms can be
> > implemented in hardware for performance.
> > 
> > Synchronous crypto requests to encrypt/decrypt a sector are processed
> > sequentially. Asynchronous requests if processed in paralled, are freed
> > in the async callback.
> 
> So we are here again and moving INTERNAL dm-crypt functionality into
> cryptoapi.
> 
> The TCW,LMK  IVs generator make sense only for dm-crypt 
> for compatible old disk encryption mappings.
> 
> I strongly disagree to move this outside of dm-crypt.
> 
> Sorry, the last discussion was that it remains inside dm-crypt
> and it will be only registered through crypto API.
> 
> And this for all files:
> 
> > + * Copyright (C) 2018, Linaro
> 
> It is NOT YOUR code! Please keep copyright and authors as in dm-crypt.
> 
> Milan
> 
> > 
> > Interface to the crypto layer - include/crypto/geniv.h
> > 
> > This patch is based on the patchset originally started by
> > Binoy Jayan <binoy.jayan@linaro.org>
> > ( crypto: Add IV generation algorithms
> > https://patchwork.kernel.org/patch/9803469/ )
> > 
> > Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> > Signed-off-by: Xiongfeng Wang <wangxiongfeng2@linaro.org>
> > ---
> >  crypto/Kconfig         |    7 +
> >  crypto/Makefile        |    1 +
> >  crypto/geniv.c         | 2240 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/crypto/geniv.h |   47 +
> >  4 files changed, 2295 insertions(+)
> >  create mode 100644 crypto/geniv.c
> >  create mode 100644 include/crypto/geniv.h
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index f3e40ac..98f025a 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -257,6 +257,13 @@ config CRYPTO_GLUE_HELPER_X86
> >  config CRYPTO_ENGINE
> >  	tristate
> >  
> > +config CRYPTO_GENIV
> > +	tristate "IV Generator Template"
> > +	select CRYPTO_AEAD
> > +	select CRYPTO_BLKCIPHER
> > +	help
> > +	  Support for IV generator template, so that dm-crypt can rely on it.
> > +
> >  comment "Authenticated Encryption with Associated Data"
> >  
> >  config CRYPTO_CCM
> > diff --git a/crypto/Makefile b/crypto/Makefile
> > index 6d1d40e..1077d2f 100644
> > --- a/crypto/Makefile
> > +++ b/crypto/Makefile
> > @@ -23,6 +23,7 @@ crypto_blkcipher-y += skcipher.o
> >  obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
> >  obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
> >  obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
> > +obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
> >  
> >  crypto_hash-y += ahash.o
> >  crypto_hash-y += shash.o
> > diff --git a/crypto/geniv.c b/crypto/geniv.c
> > new file mode 100644
> > index 0000000..55d1212
> > --- /dev/null
> > +++ b/crypto/geniv.c
> > @@ -0,0 +1,2240 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * geniv.c - crypto template for generating IV
> > + *
> > + * Copyright (C) 2018, Linaro
> > + *
> > + * This file adds a crypto template to generate IV, so the dm-crypt can rely
> > + * on it and remove the existing generating IV code.
> > + */
> > +
> > +#include <linux/completion.h>
> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/key.h>
> > +#include <linux/bio.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/mempool.h>
> > +#include <linux/slab.h>
> > +#include <linux/crypto.h>
> > +#include <linux/atomic.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/ctype.h>
> > +#include <asm/page.h>
> > +#include <asm/unaligned.h>
> > +#include <crypto/hash.h>
> > +#include <crypto/md5.h>
> > +#include <crypto/algapi.h>
> > +#include <crypto/skcipher.h>
> > +#include <crypto/aead.h>
> > +#include <crypto/authenc.h>
> > +#include <crypto/geniv.h>
> > +#include <crypto/internal/aead.h>
> > +#include <crypto/internal/skcipher.h>
> > +#include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
> > +#include <keys/user-type.h>
> > +#include <linux/backing-dev.h>
> > +#include <linux/device-mapper.h>
> > +#include <linux/log2.h>
> > +
> > +#define DM_MSG_PREFIX		"crypt"

I agree with Milan, the code should remain where it currently is.  If
you want to plumb in generic access to it fine.  But crypto/geniv.c has
_no_ business defining DM_MSG_PREFIX.

And I'm sure there are other things that have no place in generic crypto
code.

Mike
