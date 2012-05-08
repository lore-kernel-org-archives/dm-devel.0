From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] dm-multipath: disable partition scan feature
Date: Tue,  8 May 2012 16:18:06 +0200
Message-ID: <1336486687-31535-3-git-send-email-hare@suse.de>
References: <1336486687-31535-1-git-send-email-hare@suse.de>
	<1336486687-31535-2-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336486687-31535-2-git-send-email-hare@suse.de>
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

When multipath devices are being used as disks for VM Guests
any partition scanning / setup should be done within the VM Guest,
not from host. So we need to switch off partitions scanning via
kpartx there.
For this I've implemented a new feature 'no_partitions' which
just serves as a notifier to kpartx to _not_ create partitions
on these devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 922a338..6d3f2a8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -56,6 +56,8 @@ struct priority_group {
 	struct list_head pgpaths;
 };
 
+#define FEATURE_NO_PARTITIONS 1
+
 /* Multipath context */
 struct multipath {
 	struct list_head list;
@@ -87,6 +89,7 @@ struct multipath {
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
+	unsigned features;		/* Additional selected features */
 
 	struct work_struct process_queued_ios;
 	struct list_head queued_ios;
@@ -758,7 +761,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 5, "invalid number of feature args"},
+		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
@@ -779,6 +782,11 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "no_partitions")) {
+			m->features |= FEATURE_NO_PARTITIONS;
+			continue;
+		}
+
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1362,13 +1370,16 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
-			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2);
+			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
+			      (m->features & FEATURE_NO_PARTITIONS));
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
+		if (m->features & FEATURE_NO_PARTITIONS)
+			DMEMIT("no_partitions ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
-- 
1.6.0.2
