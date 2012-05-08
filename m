From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] dm-multipath: 'default_hw_handler' feature
Date: Tue,  8 May 2012 16:18:07 +0200
Message-ID: <1336486687-31535-4-git-send-email-hare@suse.de>
References: <1336486687-31535-1-git-send-email-hare@suse.de>
	<1336486687-31535-2-git-send-email-hare@suse.de>
	<1336486687-31535-3-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336486687-31535-3-git-send-email-hare@suse.de>
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
Cc: Babu Moger <babu.moger@netapp.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This patch introduces a 'default_hw_handler' feature for
dm-mpath. When specifying the feature 'default_hw_handler'
dm-multipath will be using the currently attached hardware
handler instead of trying to re-attach with the one
specified during table creation.
If no hardware handler is attached the specified hardware
handler will be used.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6d3f2a8..c1ef41d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -57,6 +57,7 @@ struct priority_group {
 };
 
 #define FEATURE_NO_PARTITIONS 1
+#define FEATURE_DEFAULT_HW_HANDLER 2
 
 /* Multipath context */
 struct multipath {
@@ -589,14 +590,24 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	if (m->hw_handler_name) {
 		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+		const char *hw_handler_name = m->hw_handler_name;
 
-		r = scsi_dh_attach(q, m->hw_handler_name);
+		if (m->features & FEATURE_DEFAULT_HW_HANDLER)
+			hw_handler_name = NULL;
+
+		r = scsi_dh_attach(q, hw_handler_name);
 		if (r == -EBUSY) {
 			/*
 			 * Already attached to different hw_handler,
 			 * try to reattach with correct one.
 			 */
 			scsi_dh_detach(q);
+			r = scsi_dh_attach(q, hw_handler_name);
+		} else if (r == -EINVAL) {
+			/*
+			 * No hardware handler attached, use
+			 * the specified one.
+			 */
 			r = scsi_dh_attach(q, m->hw_handler_name);
 		}
 
@@ -761,7 +772,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 6, "invalid number of feature args"},
+		{0, 7, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
@@ -787,6 +798,11 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "default_hw_handler")) {
+			m->features |= FEATURE_DEFAULT_HW_HANDLER;
+			continue;
+		}
+
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1371,7 +1387,8 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      (m->features & FEATURE_NO_PARTITIONS));
+			      (m->features & FEATURE_NO_PARTITIONS) +
+			      (m->features & FEATURE_DEFAULT_HW_HANDLER));
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
@@ -1380,6 +1397,8 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
 		if (m->features & FEATURE_NO_PARTITIONS)
 			DMEMIT("no_partitions ");
+		if (m->features & FEATURE_DEFAULT_HW_HANDLER)
+			DMEMIT("default_hw_handler ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
-- 
1.6.0.2
