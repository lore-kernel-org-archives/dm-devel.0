From: crquan@gmail.com
Subject: [PATCH 1/3] dm-target: use the module's refcount instead
Date: Fri, 19 Dec 2008 12:19:43 +0800
Message-ID: <1229660385-17153-2-git-send-email-crquan@gmail.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752281AbYLSETh@vger.kernel.org>
In-Reply-To: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

The tt_internal's use field is superfluous, the module's refcount has done
the work properly.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/dm-target.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 835cf95..018df35 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -18,7 +18,6 @@ struct tt_internal {
 	struct target_type tt;
 
 	struct list_head list;
-	long use;
 };
 
 static LIST_HEAD(_targets);
@@ -44,12 +43,8 @@ static struct tt_internal *get_target_type(const char *name)
 	down_read(&_lock);
 
 	ti = __find_target_type(name);
-	if (ti) {
-		if ((ti->use == 0) && !try_module_get(ti->tt.module))
-			ti = NULL;
-		else
-			ti->use++;
-	}
+	if (ti && !try_module_get(ti->tt.module))
+		ti = NULL;
 
 	up_read(&_lock);
 	return ti;
@@ -77,10 +72,7 @@ void dm_put_target_type(struct target_type *t)
 	struct tt_internal *ti = (struct tt_internal *) t;
 
 	down_read(&_lock);
-	if (--ti->use == 0)
-		module_put(ti->tt.module);
-
-	BUG_ON(ti->use < 0);
+	module_put(ti->tt.module);
 	up_read(&_lock);
 
 	return;
@@ -140,7 +132,7 @@ int dm_unregister_target(struct target_type *t)
 		return -EINVAL;
 	}
 
-	if (ti->use) {
+	if (ti->tt.module && module_refcount(ti->tt.module)) {
 		up_write(&_lock);
 		return -ETXTBSY;
 	}
-- 
1.6.0.2.GIT
