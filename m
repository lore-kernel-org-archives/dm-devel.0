From: koverstreet@google.com
Subject: [PATCH 06/13] block: Add bio_reset()
Date: Thu, 17 May 2012 22:59:53 -0400
Message-ID: <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, agk@redhat.com
List-Id: dm-devel.ids

From: Kent Overstreet <koverstreet@google.com>

Reusing bios is something that's been highly frowned upon in the past,
but driver code keeps doing it anyways. If it's going to happen anyways,
we should provide a generic method.

This'll help with getting rid of bi_destructor.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c                  |    8 ++++++++
 include/linux/bio.h       |    1 +
 include/linux/blk_types.h |    6 ++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index de0733e..90e4c3a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -259,6 +259,14 @@ void bio_init(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_init);
 
+void bio_reset(struct bio *bio)
+{
+	memset(bio, 0, BIO_RESET_OFFSET);
+	bio->bi_flags = 1 << BIO_UPTODATE;
+
+}
+EXPORT_SYMBOL(bio_reset);
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b27f16b..35f7c4d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -228,6 +228,7 @@ extern struct bio *bio_clone(struct bio *, gfp_t);
 struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
+extern void bio_reset(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dc0e399..4a47783 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -57,6 +57,10 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	/*
+	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
+	 */
+
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	atomic_t		bi_cnt;		/* pin count */
@@ -83,6 +87,8 @@ struct bio {
 	struct bio_vec		bi_inline_vecs[0];
 };
 
+#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)
+
 /*
  * bio flags
  */
-- 
1.7.9.rc2
