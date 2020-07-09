From: mwilck@suse.com
Subject: [PATCH 19/35] libmultipath: uevent: inline trivial
	functions
Date: Thu,  9 Jul 2020 12:16:04 +0200
Message-ID: <20200709101620.6786-20-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Export rather the not-quite-as-trivial getter functions, and
convert the accessors to inline wrappers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 34 ++--------------------------------
 libmultipath/uevent.h | 41 +++++++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index d74389e..d3061bf 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -136,7 +136,7 @@ invalid:
 	return NULL;
 }
 
-static int uevent_get_env_positive_int(const struct uevent *uev,
+int uevent_get_env_positive_int(const struct uevent *uev,
 				       const char *attr)
 {
 	const char *p = uevent_get_env_var(uev, attr);
@@ -657,22 +657,7 @@ out_udev:
 	return err;
 }
 
-int uevent_get_major(const struct uevent *uev)
-{
-	return uevent_get_env_positive_int(uev, "MAJOR");
-}
-
-int uevent_get_minor(const struct uevent *uev)
-{
-	return uevent_get_env_positive_int(uev, "MINOR");
-}
-
-int uevent_get_disk_ro(const struct uevent *uev)
-{
-	return uevent_get_env_positive_int(uev, "DISK_RO");
-}
-
-static char *uevent_get_dm_str(const struct uevent *uev, char *attr)
+char *uevent_get_dm_str(const struct uevent *uev, char *attr)
 {
 	const char *tmp = uevent_get_env_var(uev, attr);
 
@@ -681,21 +666,6 @@ static char *uevent_get_dm_str(const struct uevent *uev, char *attr)
 	return strdup(tmp);
 }
 
-char *uevent_get_dm_name(const struct uevent *uev)
-{
-	return uevent_get_dm_str(uev, "DM_NAME");
-}
-
-char *uevent_get_dm_path(const struct uevent *uev)
-{
-	return uevent_get_dm_str(uev, "DM_PATH");
-}
-
-char *uevent_get_dm_action(const struct uevent *uev)
-{
-	return uevent_get_dm_str(uev, "DM_ACTION");
-}
-
 bool uevent_is_mpath(const struct uevent *uev)
 {
 	const char *uuid = uevent_get_env_var(uev, "DM_UUID");
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 9a5b213..61ca1b5 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -30,13 +30,42 @@ int is_uevent_busy(void);
 int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
 		    void * trigger_data);
-int uevent_get_major(const struct uevent *uev);
-int uevent_get_minor(const struct uevent *uev);
-int uevent_get_disk_ro(const struct uevent *uev);
-char *uevent_get_dm_name(const struct uevent *uev);
-char *uevent_get_dm_path(const struct uevent *uev);
-char *uevent_get_dm_action(const struct uevent *uev);
 bool uevent_is_mpath(const struct uevent *uev);
 void uevent_get_wwid(struct uevent *uev);
 
+int uevent_get_env_positive_int(const struct uevent *uev,
+				const char *attr);
+
+static inline int uevent_get_major(const struct uevent *uev)
+{
+	return uevent_get_env_positive_int(uev, "MAJOR");
+}
+
+static inline int uevent_get_minor(const struct uevent *uev)
+{
+	return uevent_get_env_positive_int(uev, "MINOR");
+}
+
+static inline int uevent_get_disk_ro(const struct uevent *uev)
+{
+	return uevent_get_env_positive_int(uev, "DISK_RO");
+}
+
+char *uevent_get_dm_str(const struct uevent *uev, char *attr);
+
+static inline char *uevent_get_dm_name(const struct uevent *uev)
+{
+	return uevent_get_dm_str(uev, "DM_NAME");
+}
+
+static inline char *uevent_get_dm_path(const struct uevent *uev)
+{
+	return uevent_get_dm_str(uev, "DM_PATH");
+}
+
+static inline char *uevent_get_dm_action(const struct uevent *uev)
+{
+	return uevent_get_dm_str(uev, "DM_ACTION");
+}
+
 #endif /* _UEVENT_H */
-- 
2.26.2
