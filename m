From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
Date: Thu, 25 Jun 2020 12:31:21 +0100
Message-ID: <20200625113122.7540-6-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

We're short on PF_* flags, so make memalloc_nocma its own bit where we
have plenty of space.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/sched.h    |  2 +-
 include/linux/sched/mm.h | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index eaf36ae1fde2..90336850e940 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -803,6 +803,7 @@ struct task_struct {
 #endif
 	unsigned			memalloc_noio:1;
 	unsigned			memalloc_nofs:1;
+	unsigned			memalloc_nocma:1;
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1514,7 +1515,6 @@ extern struct pid *cad_pid;
 #define PF_UMH			0x02000000	/* I'm an Usermodehelper process */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
-#define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
 #define PF_IO_WORKER		0x20000000	/* Task is an IO worker */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 08bc9d0606a8..6f7b59a848a6 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -175,12 +175,11 @@ static inline bool in_vfork(struct task_struct *tsk)
 
 /*
  * Applies per-task gfp context to the given allocation flags.
- * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely((current->flags & PF_MEMALLOC_NOCMA) ||
-		     current->memalloc_noio || current->memalloc_nofs)) {
+	if (unlikely(current->memalloc_noio || current->memalloc_nofs ||
+		     current->memalloc_nocma)) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -190,7 +189,8 @@ static inline gfp_t current_gfp_context(gfp_t flags)
 		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
 #ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
+		/* memalloc_nocma implies no allocation from movable region */
+		if (current->memalloc_nocma)
 			flags &= ~__GFP_MOVABLE;
 #endif
 	}
@@ -286,15 +286,14 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 #ifdef CONFIG_CMA
 static inline unsigned int memalloc_nocma_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOCMA;
-
-	current->flags |= PF_MEMALLOC_NOCMA;
+	unsigned int flags = current->memalloc_nocma;
+	current->memalloc_nocma = 1;
 	return flags;
 }
 
 static inline void memalloc_nocma_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOCMA) | flags;
+	current->memalloc_nocma = flags ? 1 : 0;
 }
 #else
 static inline unsigned int memalloc_nocma_save(void)
-- 
2.27.0
