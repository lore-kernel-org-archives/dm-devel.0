From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [dm-devel] [PATCH 3/4] crypto: set the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 16 Jun 2020 10:43:40 -0700
Message-ID: <20200616174340.GC207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102020.28052@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161102020.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2020 at 11:02:20AM -0400, Mikulas Patocka wrote:
> Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
> allocate memory.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c |    8 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c |    8 +-
>  drivers/crypto/amlogic/amlogic-gxl-core.c         |    4 -
>  drivers/crypto/axis/artpec6_crypto.c              |   20 +++--
>  drivers/crypto/bcm/cipher.c                       |   38 +++++-----
>  drivers/crypto/caam/caamalg.c                     |    4 -
>  drivers/crypto/caam/caamalg_qi.c                  |    4 -
>  drivers/crypto/caam/caamalg_qi2.c                 |    6 -
>  drivers/crypto/caam/caamhash.c                    |    2 
>  drivers/crypto/cavium/cpt/cptvf_algs.c            |   12 +--
>  drivers/crypto/cavium/nitrox/nitrox_aead.c        |    4 -
>  drivers/crypto/cavium/nitrox/nitrox_skcipher.c    |   16 ++--
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c          |    1 
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c        |    1 
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c           |    1 
>  drivers/crypto/ccp/ccp-crypto-aes.c               |    2 
>  drivers/crypto/ccp/ccp-crypto-des3.c              |    1 
>  drivers/crypto/ccp/ccp-crypto-sha.c               |    1 
>  drivers/crypto/chelsio/chcr_algo.c                |    6 -
>  drivers/crypto/hisilicon/sec/sec_algs.c           |   16 ++--
>  drivers/crypto/hisilicon/sec2/sec_crypto.c        |    4 -
>  drivers/crypto/inside-secure/safexcel_cipher.c    |   47 +++++++++++++
>  drivers/crypto/inside-secure/safexcel_hash.c      |   18 +++++
>  drivers/crypto/ixp4xx_crypto.c                    |    6 +
>  drivers/crypto/marvell/cesa/cipher.c              |   12 +--
>  drivers/crypto/marvell/cesa/hash.c                |    6 +
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.c  |   30 ++++----
>  drivers/crypto/n2_core.c                          |    2 
>  drivers/crypto/picoxcell_crypto.c                 |   17 ++++
>  drivers/crypto/qat/qat_common/qat_algs.c          |   12 +--
>  drivers/crypto/qce/sha.c                          |    2 
>  drivers/crypto/qce/skcipher.c                     |    1 
>  drivers/crypto/talitos.c                          |   78 +++++++++++-----------
>  drivers/crypto/virtio/virtio_crypto_algs.c        |    2 
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c            |    1 
>  35 files changed, 248 insertions(+), 145 deletions(-)

It would be helpful if there was a pointer to where the memory allocation
happens in each driver.

- Eric
