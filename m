From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Wed, 11 Nov 2015 17:31:43 +0800
Message-ID: <cover.1447233227.git.baolin.wang@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com
Cc: jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, broonie@kernel.org, arnd@arndb.de, dineshg@quicinc.com, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
decrypt block data, which can only hanle one bio at one time. As we know,
one bio must use the sequential physical address and it also has a limitation
of length. Thus it may limit the big block encyrtion/decryption when some
hardware support the big block data encryption.

This patch series introduc the 'based-request' method to handle the data
encryption/decryption. One request can contain multiple bios, so it can
handle big block data to improve the efficiency.

Also this patch refers to the Dinesh K Garg <dineshg@codeaurora.org> and
franciscofranco <franciscofranco.1990@gmail.com> submission of 'Request
based dm-crypt', and the original link is:
https://github.com/major91/Zeta-Chromium-N5/commit/621d4821da04cfde383329ebdf4ce8711ec3329c

Now it can encrypt/decrypt successfully with read/write testing, and it shows
some efficiency improvements with hardware acceleration. But I really hope to
need more comments about the structure and conception. Thanks for your review.

Baolin Wang (2):
  block: Introduce BIO_ENDIO_FREE for bio flags
  md: dm-crypt: Introduce the request handling for dm-crypt

 block/blk-core.c              |    6 +-
 drivers/md/Kconfig            |    6 +
 drivers/md/dm-crypt.c         |  831 ++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               |   13 +-
 include/linux/blk_types.h     |    6 +
 include/linux/device-mapper.h |    5 +
 6 files changed, 861 insertions(+), 6 deletions(-)

-- 
1.7.9.5

