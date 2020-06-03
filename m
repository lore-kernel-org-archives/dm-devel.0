From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Date: Wed, 3 Jun 2020 22:25:38 +1000
Message-ID: <20200603122537.GA31719@gondor.apana.org.au>
References: <20200601160418.171851200@debian-a64.vm>
 <20200602220516.GA20880@silpixa00400314>
 <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Mike Snitzer <msnitzer@redhat.com>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com, dm-devel@redhat.com, qat-linux@intel.com, linux-crypto@vger.kernel.org, guazhang@redhat.com, jpittman@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 03, 2020 at 04:31:54AM -0400, Mikulas Patocka wrote:
>
> > Should we just retry a number of times and then fail?
> 
> It's better to get stuck in an infinite loop than to cause random I/O 
> errors. The infinite loop requires reboot, but it doesn't damage data on 
> disks.
> 
> The proper solution would be to add the request to a queue and process the 
> queue when some other request ended - but it would need substantial 
> rewrite of the driver. Do you want to rewrite it using a queue?
> 
> > Or, should we just move to the crypto-engine?
> 
> What do you mean by the crypto-engine?

crypto-engine is the generic queueing mechanism that any crypto
driver can use to implement the queueing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
