From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3 v6] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Wed, 1 Jul 2020 11:49:34 +1000
Message-ID: <20200701014934.GA6710@gondor.apana.org.au>
References: <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
 <20200630163552.GA837@sol.localdomain>
 <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
 <20200630175746.GA2026704@gmail.com>
 <alpine.LRH.2.02.2006301414120.30526@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006301414580.30526@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006301414580.30526@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Mike Snitzer <msnitzer@redhat.com>, Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 30, 2020 at 02:15:55PM -0400, Mikulas Patocka wrote:
>
> Index: linux-2.6/crypto/pcrypt.c
> ===================================================================
> --- linux-2.6.orig/crypto/pcrypt.c	2020-06-29 16:03:07.346417000 +0200
> +++ linux-2.6/crypto/pcrypt.c	2020-06-30 20:11:56.636417000 +0200
> @@ -225,19 +225,21 @@ static int pcrypt_init_instance(struct c
>  	return 0;
>  }
>  
> -static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> -			      u32 type, u32 mask)
> +static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb)
>  {

Rather than removing these two arguments, I think you should pass
along algt instead.

>  	struct pcrypt_instance_ctx *ctx;
>  	struct crypto_attr_type *algt;
>  	struct aead_instance *inst;
>  	struct aead_alg *alg;
> +	u32 mask;
>  	int err;
>  
>  	algt = crypto_get_attr_type(tb);
>  	if (IS_ERR(algt))
>  		return PTR_ERR(algt);

Then we could remove this bit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
