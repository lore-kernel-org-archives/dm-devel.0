From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v4 14/24] block: Add bio_copy_data()
Date: Mon, 15 Oct 2012 13:08:48 -0700
Message-ID: <1350331769-14856-15-git-send-email-koverstreet@google.com>
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
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, vgoyal@redhat.com
List-Id: dm-devel.ids

This gets open coded quite a bit and it's tricky to get right, so make a
generic version and convert some existing users over to it instead.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  2 ++
 2 files changed, 72 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index aeb74b8..d698f29d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -827,6 +827,76 @@ void bio_advance(struct bio *bio, unsigned bytes)
 }
 EXPORT_SYMBOL(bio_advance);
 
+/**
+ * bio_copy_data - copy contents of data buffers from one chain of bios to
+ * another
+ * @src: source bio list
+ * @dst: destination bio list
+ *
+ * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
+ * @src and @dst as linked lists of bios.
+ *
+ * Stops when it reaches the end of either @src or @dst - that is, copies
+ * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
+ */
+void bio_copy_data(struct bio *dst, struct bio *src)
+{
+	struct bio_vec *src_bv, *dst_bv;
+	unsigned src_offset, dst_offset, bytes;
+	void *src_p, *dst_p;
+
+	src_bv = bio_iovec(src);
+	dst_bv = bio_iovec(dst);
+
+	src_offset = src_bv->bv_offset;
+	dst_offset = dst_bv->bv_offset;
+
+	while (1) {
+		if (src_offset == src_bv->bv_offset + src_bv->bv_len) {
+			src_bv++;
+			if (src_bv == bio_iovec_idx(src, src->bi_vcnt)) {
+				src = src->bi_next;
+				if (!src)
+					break;
+
+				src_bv = bio_iovec(src);
+			}
+
+			src_offset = src_bv->bv_offset;
+		}
+
+		if (dst_offset == dst_bv->bv_offset + dst_bv->bv_len) {
+			dst_bv++;
+			if (dst_bv == bio_iovec_idx(dst, dst->bi_vcnt)) {
+				dst = dst->bi_next;
+				if (!dst)
+					break;
+
+				dst_bv = bio_iovec(dst);
+			}
+
+			dst_offset = dst_bv->bv_offset;
+		}
+
+		bytes = min(dst_bv->bv_offset + dst_bv->bv_len - dst_offset,
+			    src_bv->bv_offset + src_bv->bv_len - src_offset);
+
+		src_p = kmap_atomic(src_bv->bv_page);
+		dst_p = kmap_atomic(dst_bv->bv_page);
+
+		memcpy(dst_p + dst_bv->bv_offset,
+		       src_p + src_bv->bv_offset,
+		       bytes);
+
+		kunmap_atomic(dst_p);
+		kunmap_atomic(src_p);
+
+		src_offset += bytes;
+		dst_offset += bytes;
+	}
+}
+EXPORT_SYMBOL(bio_copy_data);
+
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b20a9cd..90d36c6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -286,6 +286,8 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 }
 #endif
 
+extern void bio_copy_data(struct bio *dst, struct bio *src);
+
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
-- 
1.7.12
