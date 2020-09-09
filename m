From: Satya Tangirala <satyat@google.com>
Subject: [PATCH 3/3] dm: enable may_passthrough_inline_crypto on some targets
Date: Wed,  9 Sep 2020 23:44:22 +0000
Message-ID: <20200909234422.76194-4-satyat@google.com>
References: <20200909234422.76194-1-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200909234422.76194-1-satyat@google.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Satya Tangirala <satyat@google.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

dm-linear and dm-flakey obviously can pass through inline crypto support.

dm-zero should declare that it passes through inline crypto support, since
any reads from dm-zero should return zeroes, and blk-crypto should not
attempt to decrypt data returned from dm-zero.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/md/dm-flakey.c | 1 +
 drivers/md/dm-linear.c | 1 +
 drivers/md/dm-zero.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index a2cc9e45cbba..655286dacc35 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -253,6 +253,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->per_io_data_size = sizeof(struct per_bio_data);
 	ti->private = fc;
+	ti->may_passthrough_inline_crypto = true;
 	return 0;
 
 bad:
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index e1db43446327..6d81878e2ca8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->may_passthrough_inline_crypto = true;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index b65ca8dcfbdc..07e02f3a9cd1 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -26,6 +26,7 @@ static int zero_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * Silently drop discards, avoiding -EOPNOTSUPP.
 	 */
 	ti->num_discard_bios = 1;
+	ti->may_passthrough_inline_crypto = true;
 
 	return 0;
 }
-- 
2.28.0.618.gf4bc123cb7-goog
