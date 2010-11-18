From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 9 of 9] dm raid message fn
Date: Thu, 18 Nov 2010 17:43:45 -0600
Message-ID: <201011182343.oAINhjN6011041@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Patch name: dm-raid-message-fn.patch

Addition of the .message function to provide the
ability to:
 - change the size of the stripe cache
 - change the speed limiter on resync.

<JB> Would it make sense to provide a way to set these
     via the CTR also?

Signed-off-by: NeilBrown <neilb@suse.de>
RFC-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -504,6 +504,31 @@ static void raid_resume(struct dm_target
 	mddev_resume(&rs->md);
 }
 
+/* Parse and handle a message from userspace
+ * Messages are:
+ *    stripecache  N  (pages per devices)
+ *    minspeed  N          (kibibytes per seconds)
+ */
+static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct raid_set *rs = ti->private;
+
+	if (argc == 2 && strcmp(argv[0], "stripecache") == 0) {
+		unsigned long size;
+		if (strict_strtoul(argv[1], 10, &size))
+			return -EINVAL;
+		return raid5_set_cache_size(&rs->md, size);
+	}
+	if (argc == 2 && strcmp(argv[0], "minspeed") == 0) {
+		unsigned long speed;
+		if (strict_strtoul(argv[1], 10, &speed))
+			return -EINVAL;
+		rs->md.sync_speed_min = speed;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static struct target_type raid_target = {
 	.name = "raid",
 	.version = {1, 0, 0},
@@ -517,6 +542,7 @@ static struct target_type raid_target = 
 	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.resume = raid_resume,
+	.message = raid_message,
 };
 
 static int __init dm_raid_init(void)
