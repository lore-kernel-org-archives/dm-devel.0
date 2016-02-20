From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 2/3] dm: make mapped_device locking functions available
Date: Sat, 20 Feb 2016 10:13:51 -0800
Message-ID: <1455992032-14594-3-git-send-email-keescook@chromium.org>
References: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, Dan Ehrenberg <dehrenberg@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chen Yu <yu.c.chen@intel.com>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Will Drewry <wad@chromium.org>, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

For init to build a mapped_device, it must hold the appropriate locks,
so move these to the common header.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5: first version of this specific patch in the series
---
 drivers/md/dm.h               | 2 --
 include/linux/device-mapper.h | 6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7edcf97dfa5a..f21700431f67 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -78,8 +78,6 @@ bool dm_table_mq_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
-void dm_lock_md_type(struct mapped_device *md);
-void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 87afa0552398..48df518345fd 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -414,6 +414,12 @@ union map_info *dm_get_rq_mapinfo(struct request *rq);
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
 
 /*
+ * Lock functions.
+ */
+void dm_lock_md_type(struct mapped_device *md);
+void dm_unlock_md_type(struct mapped_device *md);
+
+/*
  * Geometry functions.
  */
 int dm_get_geometry(struct mapped_device *md, struct hd_geometry *geo);
-- 
2.6.3

