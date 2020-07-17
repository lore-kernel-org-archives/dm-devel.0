From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2 0/7] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date: Fri, 17 Jul 2020 17:42:43 +0300
Message-ID: <8eefed8b-5ad5-424b-ab32-85e0cbac0a15@nxp.com>
References: <20200716115538.GA31461@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200716115538.GA31461@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>
Cc: mpatocka@redhat.com, linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 7/16/2020 2:55 PM, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
>> This series introduces a flag that algorithms can set to indicate that
>> they allocate memory during processing of typical inputs, and thus
>> shouldn't be used in cases like dm-crypt where memory allocation
>> failures aren't acceptable.
>>
>> Compared to Mikulas's patches, I've made the following improvements:
>>
>> - Tried to clearly document the semantics of
>>  CRYPTO_ALG_ALLOCATES_MEMORY.  This includes documenting the usage
>>  constraints, since there are actually lots of cases that were
>>  overlooked where algorithms can still allocate memory in some edge
>>  cases where inputs are misaligned, fragemented, etc.  E.g. see
>>  crypto/skcipher.c and crypto/ahash.c.  Mikulas, please let me know if
>>  there are any concerns for dm-crypt.
>>
>> - Moved the common mechanism for inheriting flags to its own patch.
>>
>> - crypto_grab_spawn() now handles propagating CRYPTO_ALG_INHERITED_FLAGS
>>  to the new template instance.
>>
>> - Inherit the flags in various places that were missed.
>>
>> - Other cleanups.
>>
>> Additional changes v1 => v2:
>>
>> - Made crypto_check_attr_type() return the mask.
>>
>> - Added patch that adds NEED_FALLBACK to INHERITED_FLAGS.
>>
>> - Added patch that removes seqiv_create().
>>
>> Eric Biggers (5):
>>  crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
>>  crypto: seqiv - remove seqiv_create()
>>  crypto: algapi - use common mechanism for inheriting flags
>>  crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
>>  crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
>>
>> Mikulas Patocka (2):
>>  crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>>  dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
>>
>> crypto/adiantum.c                             |  14 +--
>> crypto/algapi.c                               |  21 +++-
>> crypto/authenc.c                              |  14 +--
>> crypto/authencesn.c                           |  14 +--
>> crypto/ccm.c                                  |  33 ++---
>> crypto/chacha20poly1305.c                     |  14 +--
>> crypto/cmac.c                                 |   5 +-
>> crypto/cryptd.c                               |  59 ++++-----
>> crypto/ctr.c                                  |  17 +--
>> crypto/cts.c                                  |  13 +-
>> crypto/echainiv.c                             |   2 +-
>> crypto/essiv.c                                |  11 +-
>> crypto/gcm.c                                  |  40 ++----
>> crypto/geniv.c                                |  19 +--
>> crypto/hmac.c                                 |   5 +-
>> crypto/lrw.c                                  |  13 +-
>> crypto/pcrypt.c                               |  14 +--
>> crypto/rsa-pkcs1pad.c                         |  13 +-
>> crypto/seqiv.c                                |  18 +--
>> crypto/simd.c                                 |   6 +-
>> crypto/skcipher.c                             |  13 +-
>> crypto/vmac.c                                 |   5 +-
>> crypto/xcbc.c                                 |   5 +-
>> crypto/xts.c                                  |  15 +--
>> .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  12 +-
>> .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  12 +-
>> drivers/crypto/amlogic/amlogic-gxl-core.c     |   6 +-
>> drivers/crypto/axis/artpec6_crypto.c          |  20 ++-
>> drivers/crypto/bcm/cipher.c                   |  72 ++++++++---
>> drivers/crypto/caam/caamalg.c                 |   6 +-
>> drivers/crypto/caam/caamalg_qi.c              |   6 +-
>> drivers/crypto/caam/caamalg_qi2.c             |   8 +-
>> drivers/crypto/caam/caamhash.c                |   2 +-
>> drivers/crypto/cavium/cpt/cptvf_algs.c        |  18 ++-
>> drivers/crypto/cavium/nitrox/nitrox_aead.c    |   4 +-
>> .../crypto/cavium/nitrox/nitrox_skcipher.c    |  16 +--
>> drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |   1 +
>> drivers/crypto/ccp/ccp-crypto-aes-galois.c    |   1 +
>> drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   1 +
>> drivers/crypto/ccp/ccp-crypto-aes.c           |   2 +
>> drivers/crypto/ccp/ccp-crypto-des3.c          |   1 +
>> drivers/crypto/ccp/ccp-crypto-sha.c           |   1 +
>> drivers/crypto/chelsio/chcr_algo.c            |   7 +-
>> drivers/crypto/hisilicon/sec/sec_algs.c       |  24 ++--
>> drivers/crypto/hisilicon/sec2/sec_crypto.c    |   4 +-
>> .../crypto/inside-secure/safexcel_cipher.c    |  47 +++++++
>> drivers/crypto/inside-secure/safexcel_hash.c  |  18 +++
>> drivers/crypto/ixp4xx_crypto.c                |   6 +-
>> drivers/crypto/marvell/cesa/cipher.c          |  18 ++-
>> drivers/crypto/marvell/cesa/hash.c            |   6 +
>> .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  30 ++---
>> drivers/crypto/n2_core.c                      |   3 +-
>> drivers/crypto/picoxcell_crypto.c             |  17 ++-
>> drivers/crypto/qat/qat_common/qat_algs.c      |  13 +-
>> drivers/crypto/qce/skcipher.c                 |   1 +
>> drivers/crypto/talitos.c                      | 117 ++++++++++++------
>> drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
>> drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
>> drivers/md/dm-crypt.c                         |  17 ++-
>> include/crypto/algapi.h                       |  25 ++--
>> include/crypto/internal/geniv.h               |   2 +-
>> include/linux/crypto.h                        |  36 +++++-
>> 62 files changed, 562 insertions(+), 405 deletions(-)
> 
> Patches 1-6 applied.  Thanks.
> 
Looks like there's no mention of a limit on src, dst scatterlists size
that crypto implementations could use when pre-allocating memory
and crypto users needing CRYPTO_ALG_ALLOCATES_MEMORY should be aware of
(for the contract to be honoured):
https://lore.kernel.org/linux-crypto/780cb500-2241-61bc-eb44-6f872ad567d3@nxp.com

Another thing I would like to clarify, if possible.

Before forcing all crypto drivers to pre-allocate memory,
shouldn't alternatives have been investigated?

The discussion below mentions one, which IIUC was not explored / discussed.
https://lore.kernel.org/linux-crypto/alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com

Another possibility - I was thinking about setting 
CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt and calling the crypto function under 
memalloc_noio_save. But there are some drivers that do GFP_ATOMIC 
allocation regardless of CRYPTO_TFM_REQ_MAY_SLEEP.

Thanks,
Horia
