From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] dm-raid1: remove the error flags in the mirror
	set when it's in sync
Date: Wed, 15 Apr 2015 18:50:39 +0800
Message-ID: <1429095040-12658-3-git-send-email-lzhong@suse.com>
References: <1429095040-12658-1-git-send-email-lzhong@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1429095040-12658-1-git-send-email-lzhong@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

Because it's in sync now, we can remove all kinds of error flags during
the recovery. Otherwise, it will affect the valid mirror legs and the write
bio.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/dm-raid1.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 8e32c4e..95ec822 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -372,6 +372,17 @@ static int recover(struct mirror_set *ms, struct dm_region *reg)
 	return r;
 }
 
+static void reset_ms_flags(struct mirror_set *ms)
+{
+	unsigned int m;
+
+	ms->leg_failure = 0;
+	for (m = 0; m < ms->nr_mirrors; m++) {
+		atomic_set(&(ms->mirror[m].error_count), 0);
+		ms->mirror[m].error_type = 0;
+	}
+}
+
 static void do_recovery(struct mirror_set *ms)
 {
 	struct dm_region *reg;
@@ -400,6 +411,7 @@ static void do_recovery(struct mirror_set *ms)
 		/* the sync is complete */
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
+		reset_ms_flags(ms);
 	}
 }
 
-- 
1.8.1.4
