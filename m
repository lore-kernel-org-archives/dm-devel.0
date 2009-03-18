From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Free prio_name and checker_name now that we
	dynamically allocate them.
Date: Wed, 18 Mar 2009 19:38:06 -0400
Message-ID: <1237419489-3303-2-git-send-email-konrad@virtualiron.com>
References: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
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
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

In earlier releases the prio_name and checker_name would point
to statically allocated values. Now that we strdup them, we need
to free them during shutdown.
---
 libmultipath/config.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6d731d2..7307fc0 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -152,6 +152,11 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->bl_product)
 		FREE(hwe->bl_product);
 
+	if (hwe->prio_name)
+		FREE(hwe->prio_name);
+
+	if (hwe->checker_name)
+		FREE(hwe->checker_name);
 	FREE(hwe);
 }
 
@@ -250,7 +255,7 @@ set_param_str(char * str)
 #define merge_str(s) \
 	if (hwe2->s) { \
 		if (hwe1->s) \
-			free(hwe1->s); \
+			FREE(hwe1->s); \
 		if (!(hwe1->s = set_param_str(hwe2->s))) \
 			return 1; \
 	}
@@ -393,6 +398,12 @@ free_config (struct config * conf)
 	if (conf->hwhandler)
 		FREE(conf->hwhandler);
 
+	if (conf->prio_name)
+		FREE(conf->prio_name);
+
+	if (conf->checker_name)
+		FREE(conf->checker_name);
+
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
-- 
1.5.4.1
