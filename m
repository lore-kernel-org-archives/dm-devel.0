From: Ritika Srivastava <ritika.srivastava@oracle.com>
Subject: [PATCH 1/1] multipath-tools: Skip CHANGE uevent for
	non-mpath devices
Date: Fri,  6 Oct 2017 13:32:47 -0700
Message-ID: <1507321967-12942-1-git-send-email-ritika.srivastava@oracle.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

On removal of lv device snapshot using lvremove, CHANGE uevent and REMOVE uevent is generated for the dm device.
When multipath tries to process the CHANGE uevent, it is not able to find the dm/map name and
returns 1 due to which the following error is printed
"uevent trigger error"
This scenario is not actually an error and is misleading.

To fix it, the proposal is to only process the change uevent in multipath for a multipath device.

Signed-off-by: Ritika Srivastava <ritika.srivastava@oracle.com>
---
 libmultipath/uevent.c | 16 ++++++++++++++++
 libmultipath/uevent.h |  1 +
 multipathd/main.c     |  8 +++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0cbcc59..2afc2a9 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -922,3 +922,19 @@ char *uevent_get_dm_name(struct uevent *uev)
 	}
 	return p;
 }
+
+char *uevent_get_dm_uuid(struct uevent *uev)
+{
+	char *p = NULL;
+	int i;
+
+	for (i = 0; uev->envp[i] != NULL; i++) {
+		if (!strncmp(uev->envp[i], "DM_UUID", 6) &&
+		    strlen(uev->envp[i]) > 7) {
+			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
+			strcpy(p, uev->envp[i] + 8);
+			break;
+		}
+	}
+	return p;
+}
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 61a4207..1a7b549 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -37,5 +37,6 @@ int uevent_get_major(struct uevent *uev);
 int uevent_get_minor(struct uevent *uev);
 int uevent_get_disk_ro(struct uevent *uev);
 char *uevent_get_dm_name(struct uevent *uev);
+char *uevent_get_dm_uuid(struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index 8049da2..457d95d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1129,6 +1129,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	int r = 0;
 	struct vectors * vecs;
 	struct uevent *merge_uev, *tmp;
+	char *dm_uuid;
 
 	vecs = (struct vectors *)trigger_data;
 
@@ -1149,7 +1150,12 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 */
 	if (!strncmp(uev->kernel, "dm-", 3)) {
 		if (!strncmp(uev->action, "change", 6)) {
-			r = uev_add_map(uev, vecs);
+			dm_uuid = uevent_get_dm_uuid(uev);
+			if (dm_uuid) {
+				if (!strncmp(dm_uuid, "mpath-", 6))
+					r = uev_add_map(uev, vecs);
+				FREE(dm_uuid);
+			}
 			goto out;
 		}
 		if (!strncmp(uev->action, "remove", 6)) {
-- 
1.8.3.1
