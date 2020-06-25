From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 4/6] mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
Date: Thu, 25 Jun 2020 12:31:20 +0100
Message-ID: <20200625113122.7540-5-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

We're short on PF_* flags, so make memalloc_nofs its own bit where we
have plenty of space.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c   |  2 +-
 include/linux/sched.h    |  2 +-
 include/linux/sched/mm.h | 13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bcfc288dba3f..87d66c13bf5c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1502,7 +1502,7 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 	 * Given that we do not allow direct reclaim to call us, we should
 	 * never be called in a recursive filesystem reclaim context.
 	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
+	if (WARN_ON_ONCE(current->memalloc_nofs))
 		goto redirty;
 
 	/*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf18a3d2bc4c..eaf36ae1fde2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -802,6 +802,7 @@ struct task_struct {
 	unsigned			in_memstall:1;
 #endif
 	unsigned			memalloc_noio:1;
+	unsigned			memalloc_nofs:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1505,7 +1506,6 @@ extern struct pid *cad_pid;
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
-#define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index b0089eadc367..08bc9d0606a8 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,20 +175,19 @@ static inline bool in_vfork(struct task_struct *tsk)
 
 /*
  * Applies per-task gfp context to the given allocation flags.
- * PF_MEMALLOC_NOFS implies GFP_NOFS
  * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags & (PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA) ||
-		     current->memalloc_noio)) {
+	if (unlikely((current->flags & PF_MEMALLOC_NOCMA) ||
+		     current->memalloc_noio || current->memalloc_nofs)) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
 		if (current->memalloc_noio)
 			flags &= ~(__GFP_IO | __GFP_FS);
-		else if (current->flags & PF_MEMALLOC_NOFS)
+		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
 #ifdef CONFIG_CMA
 		if (current->flags & PF_MEMALLOC_NOCMA)
@@ -254,8 +253,8 @@ static inline void memalloc_noio_restore(unsigned int flags)
  */
 static inline unsigned int memalloc_nofs_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOFS;
-	current->flags |= PF_MEMALLOC_NOFS;
+	unsigned int flags = current->memalloc_nofs;
+	current->memalloc_nofs = 1;
 	return flags;
 }
 
@@ -269,7 +268,7 @@ static inline unsigned int memalloc_nofs_save(void)
  */
 static inline void memalloc_nofs_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
+	current->memalloc_nofs = flags ? 1 : 0;
 }
 
 static inline unsigned int memalloc_noreclaim_save(void)
-- 
2.27.0
