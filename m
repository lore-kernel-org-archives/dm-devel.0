From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/15] dm-zoned: add 'message' callback
Date: Mon, 11 May 2020 10:24:17 +0200
Message-ID: <20200511082430.39455-3-hare@suse.de>
References: <20200511082430.39455-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511082430.39455-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add callback for 'dmsetup message' to allow the reclaim process
to be triggered manually.
Eg.

	dmsetup message /dev/dm-X 0 message

will start the reclaim process even if the default threshold
of 50 percent of free random zones is not reached.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/admin-guide/device-mapper/dm-zoned.rst | 12 ++++++++++++
 drivers/md/dm-zoned-target.c                         | 15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-zoned.rst b/Documentation/admin-guide/device-mapper/dm-zoned.rst
index 4165fbf1aeb6..7547ce635161 100644
--- a/Documentation/admin-guide/device-mapper/dm-zoned.rst
+++ b/Documentation/admin-guide/device-mapper/dm-zoned.rst
@@ -160,3 +160,15 @@ where <nr_zones> is the total number of zones, <nr_unmap_rnd> is the number
 of unmapped (ie free) random zones, <nr_rnd> the total number of zones,
 <nr_unmap_seq> the number of unmapped sequential zones, and <nr_seq> the
 total number of sequential zones.
+
+Normally the reclaim process will be started once there are less than 50
+percent free random zones. In order to start the reclaim process manually
+even before reaching this threshold the 'dmsetup message' function can be
+used:
+
+Ex::
+
+	dmsetup message /dev/dm-X 0 reclaim
+
+will start the reclaim process and random zones will be moved to sequential
+zones.
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 0b4b27d280fb..0bfe34162dbb 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -990,6 +990,20 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 	return;
 }
 
+static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
+		       char *result, unsigned int maxlen)
+{
+	struct dmz_target *dmz = ti->private;
+	int r = -EINVAL;
+
+	if (!strcasecmp(argv[0], "reclaim")) {
+		dmz_schedule_reclaim(dmz->reclaim);
+		r = 0;
+	} else
+		DMERR("unrecognized message %s", argv[0]);
+	return r;
+}
+
 static struct target_type dmz_type = {
 	.name		 = "zoned",
 	.version	 = {1, 1, 0},
@@ -1004,6 +1018,7 @@ static struct target_type dmz_type = {
 	.resume		 = dmz_resume,
 	.iterate_devices = dmz_iterate_devices,
 	.status		 = dmz_status,
+	.message	 = dmz_message,
 };
 
 static int __init dmz_init(void)
-- 
2.16.4
