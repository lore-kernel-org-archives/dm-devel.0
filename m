From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 27/30] libmultipath: fix memory leak with
	"uid_attrs" config option
Date: Fri,  7 Jun 2019 15:05:49 +0200
Message-ID: <20190607130552.13203-28-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Tang Junhui <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

pp->uid_attribute is normally just a pointer to memory that belongs
to the configuration. But if "uid_attrs" is used, it's a pointer
to strdup()d memory returned by parse_uid_attribute_by_attrs().
Consequently, this strdup()'d memory is never freed.

Fix this by splitting the uid_attrs string when the configuration is
read, and using just a refererence to this memory in pp->uid_attribute.
A side effect is that this makes the code more efficient in both
memory and CPU terms.

This requires a change for the uevents test, as uid_attrs must now be
set up differently.

Cc: Tang Junhui <tang.junhui@zte.com.cn>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c  | 51 +++++++++++++++++++++++++++++++++++++++---
 libmultipath/config.h  |  6 ++++-
 libmultipath/dict.c    | 36 ++++++++++++++++++++++++++---
 libmultipath/propsel.c |  4 ++--
 libmultipath/uevent.c  |  5 ++---
 libmultipath/util.c    | 42 ----------------------------------
 libmultipath/util.h    |  1 -
 tests/globals.c        |  1 -
 tests/uevent.c         |  9 ++++++++
 9 files changed, 99 insertions(+), 56 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 141f092b..20e3b8bf 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -585,8 +585,7 @@ free_config (struct config * conf)
 	if (conf->uid_attribute)
 		FREE(conf->uid_attribute);
 
-	if (conf->uid_attrs)
-		FREE(conf->uid_attrs);
+	vector_reset(&conf->uid_attrs);
 
 	if (conf->getuid)
 		FREE(conf->getuid);
@@ -718,7 +717,6 @@ load_config (char * file)
 	conf->remove_retries = 0;
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
-
 	/*
 	 * preload default hwtable
 	 */
@@ -853,3 +851,50 @@ out:
 	free_config(conf);
 	return NULL;
 }
+
+char *get_uid_attribute_by_attrs(struct config *conf,
+				 const char *path_dev)
+{
+	vector uid_attrs = &conf->uid_attrs;
+	int j;
+	char *att, *col;
+
+	vector_foreach_slot(uid_attrs, att, j) {
+		col = strrchr(att, ':');
+		if (!col)
+			continue;
+		if (!strncmp(path_dev, att, col - att))
+			return col + 1;
+	}
+	return NULL;
+}
+
+int parse_uid_attrs(char *uid_attrs, struct config *conf)
+{
+	vector attrs  = &conf->uid_attrs;
+	char *uid_attr_record, *tmp;
+	int  ret = 0, count;
+
+	if (!uid_attrs)
+		return 1;
+
+	count = get_word(uid_attrs, &uid_attr_record);
+	while (uid_attr_record) {
+		tmp = strchr(uid_attr_record, ':');
+		if (!tmp) {
+			condlog(2, "invalid record in uid_attrs: %s",
+				uid_attr_record);
+			free(uid_attr_record);
+			ret = 1;
+		} else if (!vector_alloc_slot(attrs)) {
+			free(uid_attr_record);
+			ret = 1;
+		} else
+			vector_set_slot(attrs, uid_attr_record);
+		if (!count)
+			break;
+		uid_attrs += count;
+		count = get_word(uid_attrs, &uid_attr_record);
+	}
+	return ret;
+}
diff --git a/libmultipath/config.h b/libmultipath/config.h
index f5bf5b1b..ff2b4e86 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -190,7 +190,7 @@ struct config {
 
 	char * multipath_dir;
 	char * selector;
-	char * uid_attrs;
+	struct _vector uid_attrs;
 	char * uid_attribute;
 	char * getuid;
 	char * features;
@@ -250,4 +250,8 @@ void free_config (struct config * conf);
 extern struct config *get_multipath_config(void);
 extern void put_multipath_config(void *);
 
+int parse_uid_attrs(char *uid_attrs, struct config *conf);
+char *get_uid_attribute_by_attrs(struct config *conf,
+				 const char *path_dev);
+
 #endif
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 96815f8a..c6eba0f6 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -374,8 +374,38 @@ declare_ovr_snprint(selector, print_str)
 declare_mp_handler(selector, set_str)
 declare_mp_snprint(selector, print_str)
 
-declare_def_handler(uid_attrs, set_str)
-declare_def_snprint(uid_attrs, print_str)
+static int snprint_uid_attrs(struct config *conf, char *buff, int len,
+			     const void *dummy)
+{
+	char *p = buff;
+	int n, j;
+	const char *att;
+
+	vector_foreach_slot(&conf->uid_attrs, att, j) {
+		n = snprintf(p, len, "%s%s", j == 0 ? "" : " ", att);
+		if (n >= len)
+			return (p - buff) + n;
+		p += n;
+		len -= n;
+	}
+	return p - buff;
+}
+
+static int uid_attrs_handler(struct config *conf, vector strvec)
+{
+	char *val;
+
+	vector_reset(&conf->uid_attrs);
+	val = set_value(strvec);
+	if (!val)
+		return 1;
+	if (parse_uid_attrs(val, conf))
+		condlog(1, "error parsing uid_attrs: \"%s\"", val);
+	condlog(3, "parsed %d uid_attrs", VECTOR_SIZE(&conf->uid_attrs));
+	FREE(val);
+	return 0;
+}
+
 declare_def_handler(uid_attribute, set_str)
 declare_def_snprint_defstr(uid_attribute, print_str, DEFAULT_UID_ATTRIBUTE)
 declare_ovr_handler(uid_attribute, set_str)
@@ -1618,7 +1648,7 @@ init_keywords(vector keywords)
 	install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_pgpolicy);
-	install_keyword("uid_attrs", &def_uid_attrs_handler, &snprint_def_uid_attrs);
+	install_keyword("uid_attrs", &uid_attrs_handler, &snprint_uid_attrs);
 	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
 	install_keyword("getuid_callout", &def_getuid_handler, &snprint_def_getuid);
 	install_keyword("prio", &def_prio_name_handler, &snprint_def_prio_name);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e6263e9b..6af2513d 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -536,9 +536,9 @@ int select_getuid(struct config *conf, struct path *pp)
 {
 	const char *origin;
 
-	pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, pp->dev);
+	pp->uid_attribute = get_uid_attribute_by_attrs(conf, pp->dev);
 	if (pp->uid_attribute) {
-		origin = "(setting: multipath.conf defaults section)";
+		origin = "(setting: multipath.conf defaults section / uid_attrs)";
 		goto out;
 	}
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index f73de8cc..8f7b2ef5 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -163,13 +163,12 @@ uevent_get_wwid(struct uevent *uev)
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, uev->kernel);
+	uid_attribute = get_uid_attribute_by_attrs(conf, uev->kernel);
 	pthread_cleanup_pop(1);
 
 	val = uevent_get_env_var(uev, uid_attribute);
 	if (val)
 		uev->wwid = val;
-	FREE(uid_attribute);
 }
 
 bool
@@ -179,7 +178,7 @@ uevent_need_merge(void)
 	bool need_merge = false;
 
 	conf = get_multipath_config();
-	if (conf->uid_attrs)
+	if (VECTOR_SIZE(&conf->uid_attrs) > 0)
 		need_merge = true;
 	put_multipath_config(conf);
 
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 8a4be787..28cbf4b9 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -273,48 +273,6 @@ dev_t parse_devt(const char *dev_t)
 	return makedev(maj, min);
 }
 
-char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev)
-{
-	char *uid_attribute;
-	char *uid_attr_record;
-	char *dev;
-	char *attr;
-	char *tmp;
-	int  count;
-
-	if(!uid_attrs || !path_dev)
-		return NULL;
-
-	count = get_word(uid_attrs, &uid_attr_record);
-	while (uid_attr_record) {
-		tmp = strrchr(uid_attr_record, ':');
-		if (!tmp) {
-			free(uid_attr_record);
-			if (!count)
-				break;
-			uid_attrs += count;
-			count = get_word(uid_attrs, &uid_attr_record);
-			continue;
-		}
-		dev = uid_attr_record;
-		attr = tmp + 1;
-		*tmp = '\0';
-
-		if(!strncmp(path_dev, dev, strlen(dev))) {
-			uid_attribute = STRDUP(attr);
-			free(uid_attr_record);
-			return uid_attribute;
-		}
-
-		free(uid_attr_record);
-		if (!count)
-			break;
-		uid_attrs += count;
-		count = get_word(uid_attrs, &uid_attr_record);
-	}
-	return NULL;
-}
-
 void
 setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 {
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 1e0d832c..693991c1 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -15,7 +15,6 @@ size_t strlcat(char *dst, const char *src, size_t size);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
-char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 int systemd_service_enabled(const char *dev);
 int get_linux_version_code(void);
diff --git a/tests/globals.c b/tests/globals.c
index aeb7723f..8add5eb7 100644
--- a/tests/globals.c
+++ b/tests/globals.c
@@ -5,7 +5,6 @@
 struct udev *udev;
 int logsink = -1;
 struct config conf = {
-	.uid_attrs = "sd:ID_BOGUS",
 	.verbosity = 4,
 };
 
diff --git a/tests/uevent.c b/tests/uevent.c
index b0d0bfda..215d97ad 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -43,7 +43,11 @@ void uevent_get_wwid(struct uevent *uev);
 
 static int setup_uev(void **state)
 {
+	static char test_uid_attrs[] =
+		"dasd:ID_SPAM   sd:ID_BOGUS nvme:ID_EGGS    ";
+
 	struct uevent *uev = alloc_uevent();
+	struct config *conf;
 
 	if (uev == NULL)
 		return -1;
@@ -51,11 +55,16 @@ static int setup_uev(void **state)
 	*state = uev;
 	uev->kernel = "sdo";
 	uev->envp[0] = "MAJOR=" str(MAJOR);
+	uev->envp[1] = "ID_SPAM=nonsense";
 	uev->envp[1] = "ID_BOGUS=" WWID;
 	uev->envp[2] = "MINOR=" str(MINOR);
 	uev->envp[3] = "DM_NAME=" DM_NAME;
 	uev->envp[4] = "DISK_RO=" str(DISK_RO);
 	uev->envp[5] = NULL;
+
+	conf = get_multipath_config();
+	parse_uid_attrs(test_uid_attrs, conf);
+	put_multipath_config(conf);
 	return 0;
 }
 
-- 
2.21.0
