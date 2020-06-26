From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] cpt-crypto: don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP
 was not specified
Date: Fri, 26 Jun 2020 16:07:43 +1000
Message-ID: <20200626060743.GA20860@gondor.apana.org.au>
References: <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616175022.GD207319@gmail.com>
 <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616182327.GE207319@gmail.com>
 <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006170946590.18714@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006170946590.18714@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 17, 2020 at 09:48:56AM -0400, Mikulas Patocka wrote:
> There is this call chain:
> cvm_encrypt -> cvm_enc_dec -> cptvf_do_request -> process_request -> kzalloc
> where we call sleeping allocator function even if CRYPTO_TFM_REQ_MAY_SLEEP 
> was not specified.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v4.11+
> Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
> 
> ---
>  drivers/crypto/cavium/cpt/cptvf_algs.c       |    1 +
>  drivers/crypto/cavium/cpt/cptvf_reqmanager.c |   12 ++++++------
>  drivers/crypto/cavium/cpt/request_manager.h  |    2 ++
>  3 files changed, 9 insertions(+), 6 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
