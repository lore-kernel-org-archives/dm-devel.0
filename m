From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace multipath configuration
	output
Date: Thu, 24 Nov 2016 23:44:27 +0100
Message-ID: <20161124224427.12609-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

sysfs setting           -> setting: kernel sysfs

detected setting        -> setting: array autodetected

controller setting      -> setting: array configuration

internal default        -> setting: multipath internal

overrides setting       -> setting: multipath.conf overrides section

LUN setting             -> setting: multipath.conf multipaths section

config file default
config file setting     -> setting: multipath.conf defaults/devices section


Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c | 66 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d1db7c3..c0bc616 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -41,28 +41,28 @@ do {									\
 #define do_default(dest, value)						\
 do {									\
 	dest = value;							\
-	origin = "(internal default)";					\
+	origin = "(setting: multipath internal)";			\
 } while(0)
 
 #define mp_set_mpe(var)							\
-do_set(var, mp->mpe, mp->var, "(LUN setting)")
+do_set(var, mp->mpe, mp->var, "(setting: multipath.conf multipaths section)")
 #define mp_set_hwe(var)							\
-do_set(var, mp->hwe, mp->var, "(controller setting)")
+do_set(var, mp->hwe, mp->var, "(setting: array configuration)")
 #define mp_set_ovr(var)							\
-do_set(var, conf->overrides, mp->var, "(overrides setting)")
+do_set(var, conf->overrides, mp->var, "(setting: multipath.conf overrides section)")
 #define mp_set_conf(var)						\
-do_set(var, conf, mp->var, "(config file default)")
+do_set(var, conf, mp->var, "(setting: multipath.conf defaults/devices section)")
 #define mp_set_default(var, value)					\
 do_default(mp->var, value)
 
 #define pp_set_mpe(var)							\
-do_set(var, mpe, pp->var, "(LUN setting)")
+do_set(var, mpe, pp->var, "(setting: multipath.conf multipaths section)")
 #define pp_set_hwe(var)							\
-do_set(var, pp->hwe, pp->var, "(controller setting)")
+do_set(var, pp->hwe, pp->var, "(setting: array configuration)")
 #define pp_set_conf(var)						\
-do_set(var, conf, pp->var, "(config file default)")
+do_set(var, conf, pp->var, "(setting: multipath.conf defaults/devices section)")
 #define pp_set_ovr(var)							\
-do_set(var, conf->overrides, pp->var, "(overrides setting)")
+do_set(var, conf->overrides, pp->var, "(setting: multipath.conf overrides section)")
 #define pp_set_default(var, value)					\
 do_default(pp->var, value)
 
@@ -77,9 +77,9 @@ do {									\
 } while(0)
 
 #define set_attr_mpe(var, shift)					\
-do_attr_set(var, mp->mpe, shift, "(LUN setting)")
+do_attr_set(var, mp->mpe, shift, "(setting: multipath.conf multipaths section)")
 #define set_attr_conf(var, shift)					\
-do_attr_set(var, conf, shift, "(config file default)")
+do_attr_set(var, conf, shift, "(setting: multipath.conf defaults/devices section)")
 
 int select_mode(struct config *conf, struct multipath *mp)
 {
@@ -214,13 +214,13 @@ want_user_friendly_names(struct config *conf, struct multipath * mp)
 	int user_friendly_names;
 
 	do_set(user_friendly_names, mp->mpe, user_friendly_names,
-	       "(LUN setting)");
+	       "(setting: multipath.conf multipaths section)");
 	do_set(user_friendly_names, conf->overrides, user_friendly_names,
-	       "(overrides setting)");
+	       "(setting: multipath.conf overrides section)");
 	do_set(user_friendly_names, mp->hwe, user_friendly_names,
-	       "(controller setting)");
+	       "(setting: array configuration)");
 	do_set(user_friendly_names, conf, user_friendly_names,
-	       "(config file setting)");
+	       "(setting: multipath.conf defaults/devices section)");
 	do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
 out:
 	condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
@@ -235,7 +235,7 @@ int select_alias(struct config *conf, struct multipath * mp)
 
 	if (mp->mpe && mp->mpe->alias) {
 		mp->alias = STRDUP(mp->mpe->alias);
-		origin = "(LUN setting)";
+		origin = "(setting: multipath.conf multipaths section)";
 		goto out;
 	}
 
@@ -312,24 +312,24 @@ int select_checker(struct config *conf, struct path *pp)
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
-	do_set(checker_name, conf->overrides, checker_name, "(overrides setting)");
-	do_set(checker_name, pp->hwe, checker_name, "(controller setting)");
-	do_set(checker_name, conf, checker_name, "(config file setting)");
+	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
+	do_set(checker_name, pp->hwe, checker_name, "(setting: array configuration)");
+	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
 	do_default(checker_name, DEFAULT_CHECKER);
 out:
 	checker_get(conf->multipath_dir, c, checker_name);
 	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
 	if (conf->checker_timeout) {
 		c->timeout = conf->checker_timeout;
-		condlog(3, "%s: checker timeout = %u s (config file default)",
+		condlog(3, "%s: checker timeout = %u s (setting: multipath.conf defaults/devices section)",
 				pp->dev, c->timeout);
 	}
 	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
-		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
+		condlog(3, "%s: checker timeout = %u ms (setting: kernel sysfs)",
 				pp->dev, c->timeout);
 	else {
 		c->timeout = DEF_TIMEOUT;
-		condlog(3, "%s: checker timeout = %u ms (internal default)",
+		condlog(3, "%s: checker timeout = %u ms (setting: multipath internal)",
 				pp->dev, c->timeout);
 	}
 	return 0;
@@ -397,17 +397,17 @@ int select_prio(struct config *conf, struct path *pp)
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(conf, pp);
 		if (prio_selected(p)) {
-			origin = "(detected setting)";
+			origin = "(setting: array autodetected)";
 			goto out;
 		}
 	}
 	mpe = find_mpe(conf->mptable, pp->wwid);
-	set_prio(conf->multipath_dir, mpe, "(LUN setting)");
-	set_prio(conf->multipath_dir, conf->overrides, "(overrides setting)");
-	set_prio(conf->multipath_dir, pp->hwe, "controller setting)");
-	set_prio(conf->multipath_dir, conf, "(config file default)");
+	set_prio(conf->multipath_dir, mpe, "(setting: multipath.conf multipaths section)");
+	set_prio(conf->multipath_dir, conf->overrides, "(setting: multipath.conf overrides section)");
+	set_prio(conf->multipath_dir, pp->hwe, "(setting: array configuration)");
+	set_prio(conf->multipath_dir, conf, "(setting: multipath.conf defaults/devices section)");
 	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
-	origin = "(internal default)";
+	origin = "(setting: multipath internal)";
 out:
 	/*
 	 * fetch tpgs mode for alua, if its not already obtained
@@ -448,7 +448,7 @@ out:
 		condlog(3, "%s: no_path_retry = %s (inherited setting)",
 			mp->alias, buff);
 	else
-		condlog(3, "%s: no_path_retry = undef (internal default)",
+		condlog(3, "%s: no_path_retry = undef (setting: multipath internal)",
 			mp->alias);
 	return 0;
 }
@@ -458,10 +458,10 @@ select_minio_rq (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
-	do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
-	do_set(minio_rq, conf->overrides, mp->minio, "(overrides setting)");
-	do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
-	do_set(minio_rq, conf, mp->minio, "(config file setting)");
+	do_set(minio_rq, mp->mpe, mp->minio, "(setting: multipath.conf multipaths section)");
+	do_set(minio_rq, conf->overrides, mp->minio, "(setting: multipath.conf overrides section)");
+	do_set(minio_rq, mp->hwe, mp->minio, "(setting: array configuration)");
+	do_set(minio_rq, conf, mp->minio, "(setting: multipath.conf defaults/devices section)");
 	do_default(mp->minio, DEFAULT_MINIO_RQ);
 out:
 	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
-- 
2.10.2
