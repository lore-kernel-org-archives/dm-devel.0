From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Mon, 29 Jun 2020 09:17:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006290905340.11293@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
	<20200616173620.GA207319@gmail.com>
	<alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626044534.GA2870@gondor.apana.org.au>
	<alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626164617.GA211634@gmail.com>
	<20200626170039.GB211634@gmail.com>
	<alpine.LRH.2.02.2006281505530.347@file01.intranet.prod.int.rdu2.redhat.com>
	<20200628200022.GE11197@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200628200022.GE11197@sol.localdomain>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org, Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com, George Cherian <gcherian@marvell.com>, linux-crypto@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Sun, 28 Jun 2020, Eric Biggers wrote:

> On Sun, Jun 28, 2020 at 03:07:49PM -0400, Mikulas Patocka wrote:
> > > 
> > > cryptd_create_skcipher(), cryptd_create_hash(), cryptd_create_aead(), and
> > > crypto_rfc4309_create() are also missing setting the mask.
> > > 
> > > pcrypt_create_aead() is missing both setting the mask and inheriting the flags.
> > 
> > I added CRYPTO_ALG_ALLOCATES_MEMORY there.
> 
> I don't see where the cryptd request processing functions allocate memory.
> 
> It seems that cryptd should just inherit the flag, like most other templates.
> 
> Likewise for pcrypt.
> 
> And also likewise for rfc4309.
> 
> Where are you seeing the memory allocations that would require
> CRYPTO_ALG_ALLOCATES_MEMORY to always be enabled for these?
> 
> - Eric

This was some misunderstanding. You said "cryptd_create_skcipher ... is 
missing both setting the mask and inheriting the flags.", so I understood 
it so that it should inherit CRYPTO_ALG_INHERITED_FLAGS and set 
CRYPTO_ALG_ALLOCATES_MEMORY unconditionally.

Mikulas
