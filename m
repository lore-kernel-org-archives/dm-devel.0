From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/6] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date: Wed, 1 Jul 2020 03:59:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007010358390.6597@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks for cleaning this up.

Mikulas


On Tue, 30 Jun 2020, Eric Biggers wrote:

> This series introduces a flag that algorithms can set to indicate that
> they allocate memory during processing of typical inputs, and thus
> shouldn't be used in cases like dm-crypt where memory allocation
> failures aren't acceptable.
> 
> Compared to Mikulas's patches, I've made the following improvements:
> 
> - Tried to clearly document the semantics of
>   CRYPTO_ALG_ALLOCATES_MEMORY.  This includes documenting the usage
>   constraints, since there are actually lots of cases that were
>   overlooked where algorithms can still allocate memory in some edge
>   cases where inputs are misaligned, fragemented, etc.  E.g. see
>   crypto/skcipher.c and crypto/ahash.c.  Mikulas, please let me know if
>   there are any concerns for dm-crypt.
> 
> - Moved the common mechanism for inheriting flags to its own patch.
> 
> - crypto_grab_spawn() now handles propagating CRYPTO_ALG_INHERITED_FLAGS
>   to the new template instance.
> 
> - Inherit the flags in various places that were missed.
> 
> - Other cleanups.
> 
> Note: Mikulas's patch "crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY"
> still needs to be checked for cases where the flag no longer needs to be
> set due to the usage constraints I documented.
> 
> Eric Biggers (4):
>   crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
>   crypto: algapi - use common mechanism for inheriting flags
>   crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
>   crypto: algapi - remove crypto_check_attr_type()
> 
> Mikulas Patocka (2):
>   crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>   dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
> 
>  crypto/adiantum.c                             |   4 +-
>  crypto/algapi.c                               |  17 +--
>  crypto/authenc.c                              |   4 +-
>  crypto/authencesn.c                           |   4 +-
>  crypto/ccm.c                                  |  23 ++--
>  crypto/chacha20poly1305.c                     |   4 +-
>  crypto/cmac.c                                 |  15 ++-
>  crypto/cryptd.c                               |  59 ++++-----
>  crypto/ctr.c                                  |   8 +-
>  crypto/cts.c                                  |   3 +-
>  crypto/echainiv.c                             |   2 +-
>  crypto/essiv.c                                |  11 +-
>  crypto/gcm.c                                  |  10 +-
>  crypto/geniv.c                                |   9 +-
>  crypto/hmac.c                                 |  15 ++-
>  crypto/lrw.c                                  |   3 +-
>  crypto/pcrypt.c                               |  14 +--
>  crypto/rsa-pkcs1pad.c                         |   3 +-
>  crypto/seqiv.c                                |   2 +-
>  crypto/simd.c                                 |   6 +-
>  crypto/skcipher.c                             |   3 +-
>  crypto/vmac.c                                 |  15 ++-
>  crypto/xcbc.c                                 |  15 ++-
>  crypto/xts.c                                  |   3 +-
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  12 +-
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  12 +-
>  drivers/crypto/amlogic/amlogic-gxl-core.c     |   6 +-
>  drivers/crypto/axis/artpec6_crypto.c          |  20 ++-
>  drivers/crypto/bcm/cipher.c                   |  72 ++++++++---
>  drivers/crypto/caam/caamalg.c                 |   6 +-
>  drivers/crypto/caam/caamalg_qi.c              |   6 +-
>  drivers/crypto/caam/caamalg_qi2.c             |   8 +-
>  drivers/crypto/caam/caamhash.c                |   2 +-
>  drivers/crypto/cavium/cpt/cptvf_algs.c        |  18 ++-
>  drivers/crypto/cavium/nitrox/nitrox_aead.c    |   4 +-
>  .../crypto/cavium/nitrox/nitrox_skcipher.c    |  16 +--
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |   1 +
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c    |   1 +
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   1 +
>  drivers/crypto/ccp/ccp-crypto-aes.c           |   2 +
>  drivers/crypto/ccp/ccp-crypto-des3.c          |   1 +
>  drivers/crypto/ccp/ccp-crypto-sha.c           |   1 +
>  drivers/crypto/chelsio/chcr_algo.c            |   7 +-
>  drivers/crypto/hisilicon/sec/sec_algs.c       |  24 ++--
>  drivers/crypto/hisilicon/sec2/sec_crypto.c    |   4 +-
>  .../crypto/inside-secure/safexcel_cipher.c    |  47 +++++++
>  drivers/crypto/inside-secure/safexcel_hash.c  |  18 +++
>  drivers/crypto/ixp4xx_crypto.c                |   6 +-
>  drivers/crypto/marvell/cesa/cipher.c          |  18 ++-
>  drivers/crypto/marvell/cesa/hash.c            |   6 +
>  .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  30 ++---
>  drivers/crypto/n2_core.c                      |   3 +-
>  drivers/crypto/picoxcell_crypto.c             |  17 ++-
>  drivers/crypto/qat/qat_common/qat_algs.c      |  12 +-
>  drivers/crypto/qce/skcipher.c                 |   1 +
>  drivers/crypto/talitos.c                      | 117 ++++++++++++------
>  drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
>  drivers/md/dm-crypt.c                         |  17 ++-
>  include/crypto/algapi.h                       |  23 +++-
>  include/crypto/internal/geniv.h               |   2 +-
>  include/linux/crypto.h                        |  32 +++++
>  62 files changed, 550 insertions(+), 279 deletions(-)
> 
> -- 
> 2.27.0
> 
