From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 4/5] dm mpath: add 'default_hw_handler' feature
Date: Tue,  8 May 2012 17:56:06 -0400
Message-ID: <1336514167-15393-5-git-send-email-snitzer@redhat.com>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
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
Cc: babu.moger@netapp.com, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When specifying the feature 'default_hw_handler' multipath will be use
the currently attached hardware handler instead of trying to attach the
one specified during table load.  If no hardware handler is attached the
specified hardware handler will be used.

Leverages scsi_dh_attach's ability to increment the scsi_dh's reference
count if the same scsi_dh name is provided when attaching -- currently
attached scsi_dh name is determined with scsi_dh_attached_handler_name.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c351607..0fc6849 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -84,6 +84,7 @@ struct multipath {
 	unsigned queue_io:1;		/* Must we queue all I/O? */
 	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
+	unsigned use_default_hw_handler:1; /* Use attached device handler */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -567,6 +568,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	int r;
 	struct pgpath *p;
 	struct multipath *m = ti->private;
+	struct request_queue *q = NULL;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -585,9 +587,18 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (m->hw_handler_name) {
-		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+	if (m->use_default_hw_handler || m->hw_handler_name)
+		q = bdev_get_queue(p->path.dev->bdev);
+
+	if (m->use_default_hw_handler) {
+		const char *attached_handler_name = scsi_dh_attached_handler_name(q);
+		if (attached_handler_name) {
+			kfree(m->hw_handler_name);
+			m->hw_handler_name = kstrdup(attached_handler_name, GFP_KERNEL);
+		}
+	}
 
+	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
 			/*
@@ -759,7 +770,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 5, "invalid number of feature args"},
+		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
@@ -780,6 +791,11 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "default_hw_handler")) {
+			m->use_default_hw_handler = 1;
+			continue;
+		}
+
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1363,13 +1379,16 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
-			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2);
+			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
+			      m->use_default_hw_handler);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
+		if (m->use_default_hw_handler)
+			DMEMIT("default_hw_handler ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
-- 
1.7.4.4
