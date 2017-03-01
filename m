From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] uevent_can_discard: optimize devpath check
Date: Wed,  1 Mar 2017 18:22:19 +0100
Message-ID: <20170301172219.9683-1-mwilck@suse.com>
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
To: tang.junhui@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

This uses roughly 10% cycles of the sscanf-based implementation.

Improves: ee8888f0 "multipath-tools: improve processing efficiency..."
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 6e2527bd..367e129a 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -143,26 +143,35 @@ uevent_need_merge(void)
 	return need_merge;
 }
 
+static bool
+uevent_can_discard_by_devpath(const char *devpath)
+{
+	static const char BLOCK[] = "/block/";
+	const char *tmp = strstr(devpath, BLOCK);
+
+	if (tmp == NULL) {
+		condlog(4, "no /block/ in '%s'", devpath);
+		return true;
+	}
+	tmp += sizeof(BLOCK) - 1;
+	if (*tmp == '\0')
+		/* just ".../block/" - discard */
+		return true;
+	/*
+	 * If there are more path elements after ".../block/xyz",
+	 * it's a partition - discard it; but don't discard ".../block/sda/".
+	 */
+	tmp = strchr(tmp, '/');
+	return tmp != NULL && *(tmp + 1) != '\0';
+}
+
 bool
 uevent_can_discard(struct uevent *uev)
 {
-	char *tmp;
-	char a[11], b[11];
 	struct config * conf;
 
-	/*
-	 * keep only block devices, discard partitions
-	 */
-	tmp = strstr(uev->devpath, "/block/");
-	if (tmp == NULL){
-		condlog(4, "no /block/ in '%s'", uev->devpath);
+	if (uevent_can_discard_by_devpath(uev->devpath))
 		return true;
-	}
-	if (sscanf(tmp, "/block/%10s", a) != 1 ||
-	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
-		condlog(4, "discard event on %s", uev->devpath);
-		return true;
-	}
 
 	/* 
 	 * do not filter dm devices by devnode
-- 
2.12.0
