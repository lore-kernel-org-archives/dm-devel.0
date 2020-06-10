From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto API and GFP_ATOMIC
Date: Wed, 10 Jun 2020 11:04:50 +1000
Message-ID: <20200610010450.GA6449@gondor.apana.org.au>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jun 09, 2020 at 01:11:05PM -0400, Mikulas Patocka wrote:
>
> Do you have another idea how to solve this problem?

I think the better approach would be to modify the drivers to not
allocate any memory.  In general, any memory needed by the driver
to fulfil a request *should* be allocated within the crypto request
object.  That's why we have the reqsize field to indicate how much
memory could be needed per request.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
