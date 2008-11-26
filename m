From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 4/4] dm-log: interface update for multiple
	log devices
Date: Tue, 25 Nov 2008 19:01:43 -0500
Message-ID: <492C91E7.5030000@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
List-Id: dm-devel.ids

This patch introduces a new interface for multi-log devices. disk log
has two interfaces, constructor and status, and disk_ctr function and
disk_status functions are extended to handle multiple log device paths.

 - Current interface

    disk_ctr():
        log_path region_size [[no]sync]

    disk_status() - STATUSTYPE_INFO:
        nr_params disk log_path log_status:"A" or "D"

    disk_status() - STATUSTYPE_TABLE:
        disk nr_params log_path region_size [[no]sync]


 - Proposed interface

    disk_ctr():
        [log_path]{1,} region_size [[no]sync]

    disk_status() - STATUSTYPE_INFO:
        nr_params disk [log_path]{1,} [log_status:"A" or "D"]{1,}

    disk_status() - STATUSTYPE_TABLE:
        disk nr_params [log_path]{1,} region_size [[no]sync]


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-log.c   |   75 ++++++++++++++++++++++++++++++++++++++------------
 drivers/md/dm-raid1.c |    2 -
 2 files changed, 59 insertions(+), 18 deletions(-)

Index: linux-2.6.28-rc4/drivers/md/dm-log.c
===================================================================
--- linux-2.6.28-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.28-rc4/drivers/md/dm-log.c
@@ -11,7 +11,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dm-io.h>
 #include <linux/dm-dirty-log.h>
-
+#include <linux/dm-kcopyd.h>
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "dirty region log"
@@ -536,8 +536,40 @@ static size_t log_buffer_size(struct log
 }
 
 static int parse_params(unsigned int argc, char **argv,
-			uint32_t *region_size, enum sync *sync)
+			unsigned int *nr_logs, uint32_t *region_size,
+			enum sync *sync)
 {
+	unsigned long tmp_region;
+	int i;
+
+	if (argc && nr_logs) {
+		/*
+		 * case of disk log
+		 *
+		 * find region_size param from the end as a number string
+		 * and get the number of log devices
+		 */
+		for (i = argc - 1; i >= 0; i--)
+			if (!strict_strtoul(argv[i], 10, &tmp_region))
+				break;
+
+		if (i < 0) {
+			DMWARN("invalid region size to dirty region log");
+			return -EINVAL;
+		}
+
+		/* limit the same number as mirror disk */
+		if (i < 1 || i > DM_KCOPYD_MAX_REGIONS + 1) {
+			DMWARN("Invalid number of dirty region log devices");
+			return -EINVAL;
+		}
+
+		*nr_logs = i;
+
+		argc -= i;
+		argv += i;
+	}
+
 	/*
 	 * check number of parameters
 	 */
@@ -757,7 +789,7 @@ static int core_ctr(struct dm_dirty_log 
 	enum sync sync;
 	int r;
 
-	r = parse_params(argc, argv, &region_size, &sync);
+	r = parse_params(argc, argv, NULL, &region_size, &sync);
 	if (r)
 		return r;
 
@@ -786,26 +818,22 @@ static void core_dtr(struct dm_dirty_log
 /*----------------------------------------------------------------
  * disks log constructor/destructor
  *
- * argv contains log_device region_size followed optionally by [no]sync
+ * argv contains [log_path]{1,} region_size [[no]sync]
  *--------------------------------------------------------------*/
 static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
 	struct log_c *lc;
+	unsigned int nr_logs;
 	uint32_t region_size;
 	enum sync sync;
 	int r;
 
-	if (!argc) {
-		DMWARN("wrong number of arguments to dirty region log");
-		return -EINVAL;
-	}
-
-	r = parse_params(argc-1, argv+1, &region_size, &sync);
+	r = parse_params(argc, argv, &nr_logs, &region_size, &sync);
 	if (r)
 		return r;
 
-	lc = create_log_context(ti, 1, region_size, sync);
+	lc = create_log_context(ti, nr_logs, region_size, sync);
 	if (!lc)
 		return -ENOMEM;
 
@@ -1032,19 +1060,32 @@ static int core_status(struct dm_dirty_l
 static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
-	int sz = 0;
 	struct log_c *lc = log->context;
+	char buffer[lc->nr_logs + 1];
+	unsigned int i;
+	int sz = 0;
+	int params;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("3 %s %s %c", log->type->name, lc->log[0].dev->name,
-		       lc->log[0].failed ? 'D' : 'A');
+		DMEMIT("%d %s ", lc->nr_logs + 2, log->type->name);
+		for (i = 0; i < lc->nr_logs; i++) {
+			DMEMIT("%s ", lc->log[i].dev->name);
+			buffer[i] = lc->log[i].failed ? 'D' : 'A';
+		}
+		buffer[i] = '\0';
+		DMEMIT("%s", buffer);
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log[0].dev->name,
-		       lc->region_size);
+		params = lc->nr_logs + 1;
+		params += (lc->sync == DEFAULTSYNC) ? 0 : 1;
+		DMEMIT("%s %d ", log->type->name, params);
+
+		for (i = 0; i < lc->nr_logs; i++)
+			DMEMIT("%s ", lc->log[i].dev->name);
+
+		DMEMIT("%u ", lc->region_size);
 		DMEMIT_SYNC;
 	}
 
Index: linux-2.6.28-rc4/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.28-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.28-rc4/drivers/md/dm-raid1.c
@@ -926,7 +926,7 @@ static int parse_features(struct mirror_
  * [#features <features>]
  *
  * log_type is "core" or "disk"
- * #log_params is between 1 and 3
+ * #log_params is more than 0
  *
  * If present, features must be "handle_errors".
  */
