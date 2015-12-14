From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 0/2] Optimize the dm-crypt for XTS mode
Date: Mon, 14 Dec 2015 16:23:38 +0800
Message-ID: <cover.1450080755.git.baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

In now dm-crypt code, we find it only send one scatterlist which maps
one segment of one bio to the crypto engine at one time. But that will
be more time-consuming and ineffective for the crypto engine.

For XTS mode, it can map the whole bio with multiple scatterlists,
and send all the scatterlists to the crypto engine which can improve
the performance.

Baolin Wang (2):
  block: Export the __blk_bios_map_sg() to map one bio
  md: dm-crypt: Optimize the dm-crypt for XTS mode

 block/blk-merge.c      |    7 +-
 drivers/md/dm-crypt.c  |  315 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    3 +
 3 files changed, 316 insertions(+), 9 deletions(-)

-- 
1.7.9.5
