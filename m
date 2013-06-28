From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/8] Fix multipath rename from user_friendly_name
	to wwid
Date: Fri, 28 Jun 2013 18:26:16 -0500
Message-ID: <1372461981-6333-4-git-send-email-bmarzins@redhat.com>
References: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When multipath was selecting an alias for a device on reload, if it
didn't have an explicit alias, and user_friendly_names wasn't set,
multipath would use the existing alias, if one existed.  This made it
impossible to turn off user_friendly_names, and then reconfigure to
change the device names back to wwids.

Instead, multipath should just use the wwid as an alias, if that's
what it's configured to do, regardless of the existing name.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 45 ---------------------------------------------
 libmultipath/devmapper.h |  1 -
 libmultipath/propsel.c   |  2 --
 3 files changed, 48 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 67481c4..1f3b64c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -917,51 +917,6 @@ out:
 	return r;
 }
 
-extern char *
-dm_get_name(char *uuid)
-{
-	struct dm_task *dmt;
-	struct dm_info info;
-	char *prefixed_uuid, *name = NULL;
-	const char *nametmp;
-
-	dmt = dm_task_create(DM_DEVICE_INFO);
-	if (!dmt)
-		return NULL;
-
-	prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
-	if (!prefixed_uuid) {
-		condlog(0, "cannot create prefixed uuid : %s",
-			strerror(errno));
-		goto freeout;
-	}
-	sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid);
-	if (!dm_task_set_uuid(dmt, prefixed_uuid))
-		goto freeout;
-
-	if (!dm_task_run(dmt))
-		goto freeout;
-
-	if (!dm_task_get_info(dmt, &info) || !info.exists)
-		goto freeout;
-
-	nametmp = dm_task_get_name(dmt);
-	if (nametmp && strlen(nametmp)) {
-		name = MALLOC(strlen(nametmp) + 1);
-		if (name)
-			strcpy(name, nametmp);
-	} else {
-		condlog(2, "%s: no device-mapper name found", uuid);
-	}
-
-freeout:
-	if (prefixed_uuid)
-		FREE(prefixed_uuid);
-	dm_task_destroy(dmt);
-
-	return name;
-}
-
 int
 dm_geteventnr (char *name)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index bf8ee91..d27fe7f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -40,7 +40,6 @@ int dm_remove_partmaps (const char * mapname, int need_sync);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
-char * dm_get_name(char * uuid);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a7e1fc2..8ba3b44 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -263,8 +263,6 @@ select_alias (struct multipath * mp)
 					conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
 		}
 		if (mp->alias == NULL)
-			mp->alias = dm_get_name(mp->wwid);
-		if (mp->alias == NULL)
 			mp->alias = STRDUP(mp->wwid);
 	}
 
-- 
1.8.2
