From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/3] block: fix up bio_crypt_ctx allocation
Date: Tue, 15 Sep 2020 20:53:12 -0700
Message-ID: <20200916035315.34046-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, Satya Tangirala <satyat@google.com>, Miaohe Lin <linmiaohe@huawei.com>
List-Id: dm-devel.ids

This series makes allocation of encryption contexts either able to fail,
or explicitly require __GFP_DIRECT_RECLAIM (via WARN_ON_ONCE).

This applies to linux-block/for-next.

Changed since v1 (https://lkml.kernel.org/r/20200902051511.79821-1-ebiggers@kernel.org):
    - Added patches 2 and 3.
    - Added kerneldoc for bio_crypt_clone().
    - Adjusted commit message.

Eric Biggers (3):
  block: make bio_crypt_clone() able to fail
  block: make blk_crypto_rq_bio_prep() able to fail
  block: warn if !__GFP_DIRECT_RECLAIM in bio_crypt_set_ctx()

 block/bio.c                 | 20 +++++++++-----------
 block/blk-core.c            |  8 +++++---
 block/blk-crypto-internal.h | 21 ++++++++++++++++-----
 block/blk-crypto.c          | 33 ++++++++++++++++++++-------------
 block/blk-mq.c              |  7 ++++++-
 block/bounce.c              | 19 +++++++++----------
 drivers/md/dm.c             |  7 ++++---
 include/linux/blk-crypto.h  | 20 ++++++++++++++++----
 8 files changed, 85 insertions(+), 50 deletions(-)


base-commit: 99faa39ec56f33591ed3cc4d3ef62ac2878fad7e
-- 
2.28.0
