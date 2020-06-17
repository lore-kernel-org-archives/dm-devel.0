From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] crypto: fix the drivers that don't respect
 CRYPTO_TFM_REQ_MAY_SLEEP
Date: Wed, 17 Jun 2020 09:46:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616175022.GD207319@gmail.com> <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616182327.GE207319@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200616182327.GE207319@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 16 Jun 2020, Eric Biggers wrote:

> On Tue, Jun 16, 2020 at 02:18:17PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 16 Jun 2020, Eric Biggers wrote:
> > 
> > > On Tue, Jun 16, 2020 at 11:02:50AM -0400, Mikulas Patocka wrote:
> > > > Fix the crypto drivers that don't respect CRYPTO_TFM_REQ_MAY_SLEEP. If
> > > > CRYPTO_TFM_REQ_MAY_SLEEP is not set, the driver must not do allocation
> > > > that sleeps.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > I think you need to split this up per driver with a proper explanation and a
> > > "Fixes:" tag for each driver.
> > > 
> > > Also, these bugs should have been detected by the crypto self-tests already,
> > > since they test having preemption disabled and CRYPTO_TFM_REQ_MAY_SLEEP cleared.
> > > Can you double check whether these are all valid fixes?  One thing to watch out
> > > 
> > > for is that CRYPTO_TFM_REQ_MAY_SLEEP only applies to the function call like
> > > crypto_skcipher_encrypt() itself.  If the implementation is asynchronous and the
> > > request gets processed in the background (i.e. if crypto_skcipher_encrypt()
> > > returns -EINPROGRESS), the background work doesn't have to honor
> > > CRYPTO_TFM_REQ_MAY_SLEEP.
> > > 
> > > - Eric
> > 
> > I can only compile-test this patch. I don't have the hardware.
> > 
> 
> I'm just asking for you to check the code extra carefully.  The fact that the
> self-tests should have been detecting this type of bug implies that these might
> not actually be valid fixes.

I've checked it more thoroughly and found out that 3 out of 5 drivers do
the GFP_KERNEL allocation from crypto-engine callback. So, it is
supposedly OK.

> However, we do know that not all crypto drivers are being actively tested with
> the latest self-tests and with kernel debugging options enabled.  So it's
> expected that some are indeed broken.
> 
> - Eric

The broken ones are drivers/crypto/cavium/cpt/ and 
drivers/crypto/hisilicon/sec/

I'm sending patches for them.

Mikulas
