From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 02/26] block: Add bio_advance()
Date: Mon, 15 Oct 2012 13:09:05 -0700
Message-ID: <1350331769-14856-32-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>
List-Id: dm-devel.ids

This is prep work for immutable bio vecs; we first want to centralize
where bvecs are modified.

Next two patches convert some existing code to use this function.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index 4783e31..07587c0 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -750,6 +750,47 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+/**
+ * bio_advance - increment/complete a bio by some number of bytes
+ * @bio:	bio to advance
+ * @bytes:	number of bytes to complete
+ *
+ * This updates bi_sector, bi_size and bi_idx; if the number of bytes to
+ * complete doesn't align with a bvec boundary, then bv_len and bv_offset will
+ * be updated on the last bvec as well.
+ *
+ * @bio will then represent the remaining, uncompleted portion of the io.
+ */
+void bio_advance(struct bio *bio, unsigned bytes)
+{
+	if (bio_integrity(bio))
+		bio_integrity_advance(bio, bytes);
+
+	bio->bi_sector += bytes >> 0;
+	bio->bi_size -= bytes;
+
+	if (!bio->bi_size)
+		return;
+
+	while (bytes) {
+		if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
+			       __func__, bio->bi_idx, bio->bi_vcnt);
+			break;
+		}
+
+		if (bytes >= bio_iovec(bio)->bv_len) {
+			bytes -= bio_iovec(bio)->bv_len;
+			bio->bi_idx++;
+		} else {
+			bio_iovec(bio)->bv_len -= bytes;
+			bio_iovec(bio)->bv_offset += bytes;
+			bytes = 0;
+		}
+	}
+}
+EXPORT_SYMBOL(bio_advance);
+
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7873465..6763cdf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -248,6 +248,8 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+void bio_advance(struct bio *, unsigned);
+
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
 
-- 
1.7.12
