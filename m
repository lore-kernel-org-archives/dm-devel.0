From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] arm64 aes: fix encryption of unaligned data
Date: Mon, 28 Jul 2014 22:02:19 +0800
Message-ID: <20140728140219.GA11859@gondor.apana.org.au>
References: <alpine.LRH.2.02.1407251937110.11227@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407251937110.11227@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "David S. Miller" <davem@davemloft.net>, Andy Polyakov <appro@openssl.org>, Nicolas Pitre <nico@linaro.org>, "Alasdair G. Kergon" <agk@redhat.com>, linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 25, 2014 at 07:40:20PM -0400, Mikulas Patocka wrote:
> cryptsetup fails on arm64 when using kernel encryption via AF_ALG socket.
> See https://bugzilla.redhat.com/show_bug.cgi?id=1122937
> 
> The bug is caused by incorrect handling of unaligned data in
> arch/arm64/crypto/aes-glue.c. Cryptsetup creates a buffer that is aligned
> on 8 bytes, but not on 16 bytes. It opens AF_ALG socket and uses the
> socket to encrypt data in the buffer. The arm64 crypto accelerator causes
> data corruption or crashes in the scatterwalk_pagedone.
> 
> This patch fixes the bug by passing the residue bytes that were not
> processed as the last parameter to blkcipher_walk_done.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Both patches applied to crypto.  Thanks for catching this!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
