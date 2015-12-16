From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 0/2] Introduce the bulk IV mode for improving the crypto engine efficiency
Date: Wed, 16 Dec 2015 11:18:34 +0800
Message-ID: <cover.1450233399.git.baolin.wang@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

From the dm-crypt performance report, we found it shows low efficiency
with crypto engine for some mode (like ecb or xts mode). Because in dm
crypt, it will map the IO data buffer with scatterlist, and send the
scatterlist of one bio to the encryption engine, if send more scatterlists
with bigger size at one time, that helps the engine palys best performance,
which means a high encryption speed. 

But now the dm-crypt only map one segment (always one sector) of one bio
with one scatterlist to the crypto engine at one time. which is more
time-consuming and ineffective for the crypto engine. Especially for some
modes which don't need different IV for each sector, we can map the whole
bio with multiple scatterlists to improve the engine performance.

But this optimization is not support some ciphers and IV modes which should
do sector by sector and need different IV for each sector.

Change since v1:
 - Introduce one different IV mode.
 - Change the conditions for bulk mode.

Baolin Wang (2):
  block: Export the __blk_bios_map_sg() to map one bio
  md: dm-crypt: Introduce the bulk IV mode for bulk crypto

 block/blk-merge.c      |    7 +-
 drivers/md/dm-crypt.c  |  333 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    3 +
 3 files changed, 334 insertions(+), 9 deletions(-)

-- 
1.7.9.5

