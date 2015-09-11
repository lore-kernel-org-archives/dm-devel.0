From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Regression: Disk corruption with dm-crypt and kernels >= 4.0
Date: Fri, 11 Sep 2015 12:11:39 -0400
Message-ID: <20150911161139.GA25298@redhat.com>
References: <1430455027.7012.32.camel@memnix.com>
 <20150501211703.GA15030@redhat.com>
 <1430519090.5537.4.camel@memnix.com>
 <1430523735.5352.1.camel@memnix.com>
 <20150515150442.GB35834@hank.reardencode.com>
 <1431959798.19977.4.camel@memnix.com>
 <alpine.LRH.2.02.1506021345310.22804@file01.intranet.prod.int.rdu2.redhat.com>
 <1433298070.5798.1.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433298070.5798.1.camel@memnix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abelardo Ricart III <aricart@memnix.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Brandon Smith <freedom@reardencode.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Could you please try the following patch (against any of the kernels you
saw the corruption with.  be it 4.0, 4.1, 4.2) to see if the regression
you reported goes away?  Thanks, Mike

From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 9 Sep 2015 21:34:51 -0400
Subject: [PATCH] dm crypt: constrain crypt device's max_segment_size to
 PAGE_SIZE

Unfortunate constraint that is required to avoid the potential for
exceeding underlying device's max_segments limits -- due to
crypt_alloc_buffer() possibly allocating pages for the encryption bio
that are not as physically contiguous as the original bio.

Suggested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 76f1d6e..f717762 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -973,7 +973,8 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
 
 /*
  * Generate a new unfragmented bio with the given size
- * This should never violate the device limitations
+ * This should never violate the device limitations (but only because
+ * max_segment_size is being constrained to PAGE_SIZE).
  *
  * This function may be called concurrently. If we allocate from the mempool
  * concurrently, there is a possibility of deadlock. For example, if we have
@@ -2057,9 +2058,20 @@ static int crypt_iterate_devices(struct dm_target *ti,
 	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
+static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	/*
+	 * Unfortunate constraint that is required to avoid the potential
+	 * for exceeding underlying device's max_segments limits -- due to
+	 * crypt_alloc_buffer() possibly allocating pages for the encryption
+	 * bio that are not as physically contiguous as the original bio.
+	 */
+	limits->max_segment_size = PAGE_SIZE;
+}
+
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 14, 0},
+	.version = {1, 14, 1},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
@@ -2071,6 +2083,7 @@ static struct target_type crypt_target = {
 	.message = crypt_message,
 	.merge  = crypt_merge,
 	.iterate_devices = crypt_iterate_devices,
+	.io_hints = crypt_io_hints,
 };
 
 static int __init dm_crypt_init(void)
-- 
1.7.4.4
