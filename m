From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/7] libmultipath: refactor uevent_get_XXX
Date: Wed, 17 Jan 2018 08:49:35 +0100
Message-ID: <20180117074939.7795-4-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use common helper functions for uevent_get_XXX.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 159 +++++++++++++++++++++-----------------------------
 1 file changed, 67 insertions(+), 92 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 80bf1dd15372..13d468f7fce0 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -104,28 +104,69 @@ uevq_cleanup(struct list_head *tmpq)
 	}
 }
 
+static const char* uevent_get_env_var(const struct uevent *uev,
+				      const char *attr)
+{
+	int i, len;
+	const char *p = NULL;
+
+	if (attr == NULL)
+		goto invalid;
+
+	len = strlen(attr);
+	if (len == 0)
+		goto invalid;
+
+	for (i = 0; uev->envp[i] != NULL; i++) {
+		const char *var = uev->envp[i];
+
+		if (strlen(var) > len &&
+		    !memcmp(var, attr, len) && var[len] == '=') {
+			p = var + len + 1;
+			break;
+		}
+	}
+
+	condlog(4, "%s: %s -> '%s'", __func__, attr, p);
+	return p;
+
+invalid:
+	condlog(2, "%s: empty variable name", __func__);
+	return NULL;
+}
+
+static int uevent_get_env_positive_int(const struct uevent *uev,
+				       const char *attr)
+{
+	const char *p = uevent_get_env_var(uev, attr);
+	char *q;
+	int ret;
+
+	if (p == NULL || *p == '\0')
+		return -1;
+
+	ret = strtoul(p, &q, 10);
+	if (*q != '\0' || ret < 0) {
+		condlog(2, "%s: invalid %s: '%s'", __func__, attr, p);
+		return -1;
+	}
+	return ret;
+}
+
 void
 uevent_get_wwid(struct uevent *uev)
 {
-	int i;
 	char *uid_attribute;
+	const char *val;
 	struct config * conf;
 
 	conf = get_multipath_config();
 	uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, uev->kernel);
 	put_multipath_config(conf);
 
-	if (!uid_attribute)
-		return;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], uid_attribute, strlen(uid_attribute)) &&
-		    strlen(uev->envp[i]) > strlen(uid_attribute) &&
-		    uev->envp[i][strlen(uid_attribute)] == '=') {
-			uev->wwid = uev->envp[i] + strlen(uid_attribute) + 1;
-			break;
-		}
-	}
+	val = uevent_get_env_var(uev, uid_attribute);
+	if (val)
+		uev->wwid = (char*)val;
 	free(uid_attribute);
 }
 
@@ -852,105 +893,39 @@ out:
 
 int uevent_get_major(struct uevent *uev)
 {
-	char *p, *q;
-	int i, major = -1;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "MAJOR", 5) && strlen(uev->envp[i]) > 6) {
-			p = uev->envp[i] + 6;
-			major = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid major '%s'", p);
-				major = -1;
-			}
-			break;
-		}
-	}
-	return major;
+	return uevent_get_env_positive_int(uev, "MAJOR");
 }
 
 int uevent_get_minor(struct uevent *uev)
 {
-	char *p, *q;
-	int i, minor = -1;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "MINOR", 5) && strlen(uev->envp[i]) > 6) {
-			p = uev->envp[i] + 6;
-			minor = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid minor '%s'", p);
-				minor = -1;
-			}
-			break;
-		}
-	}
-	return minor;
+	return uevent_get_env_positive_int(uev, "MINOR");
 }
 
 int uevent_get_disk_ro(struct uevent *uev)
 {
-	char *p, *q;
-	int i, ro = -1;
+	return uevent_get_env_positive_int(uev, "DISK_RO");
+}
 
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DISK_RO", 7) && strlen(uev->envp[i]) > 8) {
-			p = uev->envp[i] + 8;
-			ro = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid read_only setting '%s'", p);
-				ro = -1;
-			}
-			break;
-		}
-	}
-	return ro;
+static char *uevent_get_dm_str(const struct uevent *uev, char *attr)
+{
+	char *tmp = uevent_get_env_var(uev, attr);
+
+	if (tmp == NULL)
+		return NULL;
+	return strdup(tmp);
 }
 
 char *uevent_get_dm_name(struct uevent *uev)
 {
-	char *p = NULL;
-	int i;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_NAME", 7) &&
-		    strlen(uev->envp[i]) > 8) {
-			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
-			strcpy(p, uev->envp[i] + 8);
-			break;
-		}
-	}
-	return p;
+	return uevent_get_dm_str(uev, "DM_NAME");
 }
 
 char *uevent_get_dm_path(struct uevent *uev)
 {
-	char *p = NULL;
-	int i;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_PATH", 7) &&
-		    strlen(uev->envp[i]) > 8) {
-			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
-			strcpy(p, uev->envp[i] + 8);
-			break;
-		}
-	}
-	return p;
+	return uevent_get_dm_str(uev, "DM_PATH");
 }
 
 char *uevent_get_dm_action(struct uevent *uev)
 {
-	char *p = NULL;
-	int i;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_ACTION", 9) &&
-		    strlen(uev->envp[i]) > 10) {
-			p = MALLOC(strlen(uev->envp[i] + 10) + 1);
-			strcpy(p, uev->envp[i] + 10);
-			break;
-		}
-	}
-	return p;
+	return uevent_get_dm_str(uev, "DM_ACTION");
 }
-- 
2.15.1
