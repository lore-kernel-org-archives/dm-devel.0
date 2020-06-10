From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: crypto API and GFP_ATOMIC
Date: Wed, 10 Jun 2020 08:02:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200610010450.GA6449@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Wed, 10 Jun 2020, Herbert Xu wrote:

> On Tue, Jun 09, 2020 at 01:11:05PM -0400, Mikulas Patocka wrote:
> >
> > Do you have another idea how to solve this problem?
> 
> I think the better approach would be to modify the drivers to not
> allocate any memory.  In general, any memory needed by the driver
> to fulfil a request *should* be allocated within the crypto request
> object.  That's why we have the reqsize field to indicate how much
> memory could be needed per request.
> 
> Thanks,

Yes, fixing the drivers would be the best - but you can hardly find any 
person who has all the crypto hardware and who is willing to rewrite all 
the drivers for it.

Another possibility - I was thinking about setting 
CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt and calling the crypto function under 
memalloc_noio_save. But there are some drivers that do GFP_ATOMIC 
allocation regardless of CRYPTO_TFM_REQ_MAY_SLEEP.

Mikulas
