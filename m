From: John Pittman <jpittman@redhat.com>
Subject: [PATCH] dm cache: require io_mode cache feature selection to be mutually exclusive
Date: Thu, 21 Jun 2018 17:35:33 -0400
Message-ID: <1529616933-11644-1-git-send-email-jpittman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, loberman@redhat.com, John Pittman <jpittman@redhat.com>
List-Id: dm-devel.ids

Due to commit 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature"),
when creating a dm cache device, more than one io_mode can be selected.
As the io_mode selections are incompatible with one another, we should 
force them to be selected exclusively.  Add simple ctr to check for 
more than one io_mode selection.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/md/dm-cache-target.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index ce14a3d..45e3bed 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2250,7 +2250,7 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 		{0, 2, "Invalid number of cache feature arguments"},
 	};
 
-	int r;
+	int r, mode_ctr = 0;
 	unsigned argc;
 	const char *arg;
 	struct cache_features *cf = &ca->features;
@@ -2264,14 +2264,20 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 	while (argc--) {
 		arg = dm_shift_arg(as);
 
-		if (!strcasecmp(arg, "writeback"))
+		if (!strcasecmp(arg, "writeback")) {
 			cf->io_mode = CM_IO_WRITEBACK;
+			mode_ctr++;
+		}
 
-		else if (!strcasecmp(arg, "writethrough"))
+		else if (!strcasecmp(arg, "writethrough")) {
 			cf->io_mode = CM_IO_WRITETHROUGH;
+			mode_ctr++;
+		}
 
-		else if (!strcasecmp(arg, "passthrough"))
+		else if (!strcasecmp(arg, "passthrough")) {
 			cf->io_mode = CM_IO_PASSTHROUGH;
+			mode_ctr++;
+		}
 
 		else if (!strcasecmp(arg, "metadata2"))
 			cf->metadata_version = 2;
@@ -2282,6 +2288,11 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 		}
 	}
 
+	if (mode_ctr > 1) {
+		*error = "Invalid number of cache io_mode features requested";
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.7.5
