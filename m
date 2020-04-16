From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 1/2] md: Expose struct request to path selector
Date: Thu, 16 Apr 2020 17:13:35 -0400
Message-ID: <20200416211336.2423618-2-krisman@collabora.com>
References: <20200416211336.2423618-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200416211336.2423618-1-krisman@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org, khazhy@google.com, kernel@collabora.com, Gabriel Krisman Bertazi <krisman@collabora.com>
List-Id: dm-devel.ids

From: Khazhismel Kumykov <khazhy@google.com>

This allows a path selector to access metadata such as request start and
end time.  nr_bytes is retained for end_io, as blk_rq_bytes represents
the number of bytes *left* in a request, and is 0 after a request is
finished.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c         | 12 ++++++++++--
 drivers/md/dm-path-selector.h |  6 ++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2bc18c9c3abc..0cdd3a939d41 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -546,7 +546,12 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	*__clone = clone;
 
-	if (pgpath->pg->ps.type->start_io)
+	if (pgpath->pg->ps.type->start_io_rq)
+		pgpath->pg->ps.type->start_io_rq(&pgpath->pg->ps,
+					      &pgpath->path,
+					      clone ?: rq,
+					      nr_bytes);
+	else if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
 					      nr_bytes);
@@ -1614,7 +1619,10 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
 
-		if (ps->type->end_io)
+		if (ps->type->end_io_rq)
+			ps->type->end_io_rq(ps, &pgpath->path,
+					 clone, mpio->nr_bytes);
+		else if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb5365b1a4..98b6c9d4e21f 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -12,6 +12,7 @@
 #ifndef	DM_PATH_SELECTOR_H
 #define	DM_PATH_SELECTOR_H
 
+#include <linux/blkdev.h>
 #include <linux/device-mapper.h>
 
 #include "dm-mpath.h"
@@ -75,6 +76,11 @@ struct path_selector_type {
 			 size_t nr_bytes);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
 		       size_t nr_bytes);
+
+	int (*start_io_rq)(struct path_selector *ps, struct dm_path *path,
+			   const struct request *rq, size_t nr_bytes);
+	int (*end_io_rq)(struct path_selector *ps, struct dm_path *path,
+			 const struct request *rq, size_t nr_bytes);
 };
 
 /* Register a path selector */
-- 
2.26.0
