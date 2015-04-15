From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] dm-raid1: fix the parameter passed into the
	kernel
Date: Wed, 15 Apr 2015 18:50:38 +0800
Message-ID: <1429095040-12658-2-git-send-email-lzhong@suse.com>
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

If the userspace does not pass the new feature parameter, it will lead
to a kernel crash

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/dm-raid1.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 00b1fbd..8e32c4e 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -990,6 +990,7 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 	unsigned num_features;
 	struct dm_target *ti = ms->ti;
 	char dummy;
+	int i;
 
 	*args_used = 0;
 
@@ -1010,19 +1011,18 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 		return -EINVAL;
 	}
 
-	if (!strcmp("handle_errors", argv[0]))
-		ms->features |= DM_RAID1_HANDLE_ERRORS;
-	else {
-		ti->error = "Unrecognised feature requested";
-		return -EINVAL;
-	}
-
-	argc--;
-	argv++;
-	(*args_used)++;
+	for (i = 0; i < num_features; i++) {
+		if (!strcmp("handle_errors", argv[0]))
+			ms->features |= DM_RAID1_HANDLE_ERRORS;
+		else if (!strcmp("keep_log", argv[0])) 
+			ms->features |= DM_RAID1_KEEP_LOG;
+		else {
+			ti->error = "Unrecognised feature requested";
+			return -EINVAL;
+		}
 
-	if (!strcmp("keep_log", argv[0])) {
-		ms->features |= DM_RAID1_KEEP_LOG;
+		argc--;
+		argv++;
 		(*args_used)++;
 	}
 
-- 
1.8.1.4
