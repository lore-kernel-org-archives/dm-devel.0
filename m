From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH RFC] multipath-tools: replace multipath
	configuration output
Date: Sun, 16 Oct 2016 18:03:41 +0200
Message-ID: <20161016160341.8710-1-xose.vazquez@gmail.com>
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


	This is a RFC patch!



internal default	-> multipathd: internal setting

LUN setting		-> multipath.conf: <multipaths section> setting

overrides setting	-> multipath.conf: <overrides section> setting

config file default	-> multipath.conf: file setting
config file setting	-> multipath.conf: file setting

controller setting	-> hardware: array controller setting
detected setting	-> hardware: array controller setting

sysfs setting		-> kernel: sysfs setting

inherited setting	-> ??? unchanged ???



Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c | 66 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 1625990..450b1e3 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -41,28 +41,28 @@ do {									\
 #define do_default(dest, value)						\
 do {									\
 	dest = value;							\
-	origin = "(internal default)";					\
+	origin = "(multipathd: internal setting)";			\
 } while(0)
 
 #define mp_set_mpe(var)							\
-do_set(var, mp->mpe, mp->var, "(LUN setting)")
+do_set(var, mp->mpe, mp->var, "(multipath.conf: <multipaths section> setting)")
 #define mp_set_hwe(var)							\
-do_set(var, mp->hwe, mp->var, "(controller setting)")
+do_set(var, mp->hwe, mp->var, "(hardware: array controller setting)")
 #define mp_set_ovr(var)							\
-do_set(var, conf->overrides, mp->var, "(overrides setting)")
+do_set(var, conf->overrides, mp->var, "(multipath.conf: <overrides section> setting)")
 #define mp_set_conf(var)						\
-do_set(var, conf, mp->var, "(config file default)")
+do_set(var, conf, mp->var, "(multipath.conf: file setting)")
 #define mp_set_default(var, value)					\
 do_default(mp->var, value)
 
 #define pp_set_mpe(var)							\
-do_set(var, mpe, pp->var, "(LUN setting)")
+do_set(var, mpe, pp->var, "(multipath.conf: <multipaths section> setting)")
 #define pp_set_hwe(var)							\
-do_set(var, pp->hwe, pp->var, "(controller setting)")
+do_set(var, pp->hwe, pp->var, "(hardware: array controller setting)")
 #define pp_set_conf(var)						\
-do_set(var, conf, pp->var, "(config file default)")
+do_set(var, conf, pp->var, "(multipath.conf: file setting)")
 #define pp_set_ovr(var)							\
-do_set(var, conf->overrides, pp->var, "(overrides setting)")
+do_set(var, conf->overrides, pp->var, "(multipath.conf: <overrides section> setting)")
 #define pp_set_default(var, value)					\
 do_default(pp->var, value)
 
@@ -77,9 +77,9 @@ do {									\
 } while(0)
 
 #define set_attr_mpe(var, shift)					\
-do_attr_set(var, mp->mpe, shift, "(LUN setting)")
+do_attr_set(var, mp->mpe, shift, "(multipath.conf: <multipaths section> setting)")
 #define set_attr_conf(var, shift)					\
-do_attr_set(var, conf, shift, "(config file default)")
+do_attr_set(var, conf, shift, "(multipath.conf: file setting)")
 
 extern int
 select_mode (struct config *conf, struct multipath *mp)
@@ -221,13 +221,13 @@ want_user_friendly_names(struct config *conf, struct multipath * mp)
 	int user_friendly_names;
 
 	do_set(user_friendly_names, mp->mpe, user_friendly_names,
-	       "(LUN setting)");
+	       "(multipath.conf: <multipaths section> setting)");
 	do_set(user_friendly_names, conf->overrides, user_friendly_names,
-	       "(overrides setting)");
+	       "(multipath.conf: <overrides section> setting)");
 	do_set(user_friendly_names, mp->hwe, user_friendly_names,
-	       "(controller setting)");
+	       "(hardware: array controller setting)");
 	do_set(user_friendly_names, conf, user_friendly_names,
-	       "(config file setting)");
+	       "(multipath.conf: file setting)");
 	do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
 out:
 	condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
@@ -243,7 +243,7 @@ select_alias (struct config *conf, struct multipath * mp)
 
 	if (mp->mpe && mp->mpe->alias) {
 		mp->alias = STRDUP(mp->mpe->alias);
-		origin = "(LUN setting)";
+		origin = "(multipath.conf: <multipaths section> setting)";
 		goto out;
 	}
 
@@ -323,24 +323,24 @@ select_checker(struct config *conf, struct path *pp)
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
-	do_set(checker_name, conf->overrides, checker_name, "(overrides setting)");
-	do_set(checker_name, pp->hwe, checker_name, "(controller setting)");
-	do_set(checker_name, conf, checker_name, "(config file setting)");
+	do_set(checker_name, conf->overrides, checker_name, "(multipath.conf: <overrides section> setting)");
+	do_set(checker_name, pp->hwe, checker_name, "(hardware: array controller setting)");
+	do_set(checker_name, conf, checker_name, "(multipath.conf: file setting)");
 	do_default(checker_name, DEFAULT_CHECKER);
 out:
 	checker_get(conf->multipath_dir, c, checker_name);
 	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
 	if (conf->checker_timeout) {
 		c->timeout = conf->checker_timeout;
-		condlog(3, "%s: checker timeout = %u s (config file default)",
+		condlog(3, "%s: checker timeout = %u s (multipath.conf: file setting)",
 				pp->dev, c->timeout);
 	}
 	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
-		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
+		condlog(3, "%s: checker timeout = %u ms (kernel: sysfs setting)",
 				pp->dev, c->timeout);
 	else {
 		c->timeout = DEF_TIMEOUT;
-		condlog(3, "%s: checker timeout = %u ms (internal default)",
+		condlog(3, "%s: checker timeout = %u ms (multipathd: internal setting)",
 				pp->dev, c->timeout);
 	}
 	return 0;
@@ -410,17 +410,17 @@ select_prio (struct config *conf, struct path * pp)
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(conf, pp);
 		if (prio_selected(p)) {
-			origin = "(detected setting)";
+			origin = "(hardware: array controller setting)";
 			goto out;
 		}
 	}
 	mpe = find_mpe(conf->mptable, pp->wwid);
-	set_prio(conf->multipath_dir, mpe, "(LUN setting)");
-	set_prio(conf->multipath_dir, conf->overrides, "(overrides setting)");
-	set_prio(conf->multipath_dir, pp->hwe, "controller setting)");
-	set_prio(conf->multipath_dir, conf, "(config file default)");
+	set_prio(conf->multipath_dir, mpe, "(multipath.conf: <multipaths section> setting)");
+	set_prio(conf->multipath_dir, conf->overrides, "(multipath.conf: <overrides section> setting)");
+	set_prio(conf->multipath_dir, pp->hwe, "(hardware: array controller setting)");
+	set_prio(conf->multipath_dir, conf, "(multipath.conf: file setting)");
 	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
-	origin = "(internal default)";
+	origin = "(multipathd: internal setting)";
 out:
 	/*
 	 * fetch tpgs mode for alua, if its not already obtained
@@ -462,7 +462,7 @@ out:
 		condlog(3, "%s: no_path_retry = %s (inherited setting)",
 			mp->alias, buff);
 	else
-		condlog(3, "%s: no_path_retry = undef (internal default)",
+		condlog(3, "%s: no_path_retry = undef (multipathd: internal setting)",
 			mp->alias);
 	return 0;
 }
@@ -472,10 +472,10 @@ select_minio_rq (struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
-	do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
-	do_set(minio_rq, conf->overrides, mp->minio, "(overrides setting)");
-	do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
-	do_set(minio_rq, conf, mp->minio, "(config file setting)");
+	do_set(minio_rq, mp->mpe, mp->minio, "(multipath.conf: <multipaths section> setting)");
+	do_set(minio_rq, conf->overrides, mp->minio, "(multipath.conf: <overrides section> setting)");
+	do_set(minio_rq, mp->hwe, mp->minio, "(hardware: array controller setting)");
+	do_set(minio_rq, conf, mp->minio, "(multipath.conf: file setting)");
 	do_default(mp->minio, DEFAULT_MINIO_RQ);
 out:
 	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
-- 
2.10.1
