From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 15/16] multipathd: allow /dev/<devnode> to be
	used for multipathd commands
Date: Wed, 11 Dec 2013 00:43:09 -0600
Message-ID: <1386744190-1295-16-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

Multipathd expects that path and map names used in its interactive
commands are sysfs names with no directory.  However, users often try
used /dev names instead.  This patch makes multipathd convert the /dev
names to sysfs names like the multipath command does.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/util.c       | 22 ++++++++++++++++++++++
 libmultipath/util.h       |  1 +
 multipath/main.c          | 23 +----------------------
 multipathd/cli_handlers.c | 18 ++++++++++++++++++
 4 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index a9f5939..5fedf03 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -235,6 +235,28 @@ skip_proc:
 	return 0;
 }
 
+/* This function returns a pointer inside of the supplied pathname string.
+ * If is_path_device is true, it may also modify the supplied string */
+char *convert_dev(char *name, int is_path_device)
+{
+	char *ptr;
+
+	if (!name)
+		return NULL;
+	if (is_path_device) {
+		ptr = strstr(name, "cciss/");
+		if (ptr) {
+			ptr += 5;
+			*ptr = '!';
+		}
+	}
+	if (!strncmp(name, "/dev/", 5) && strlen(name) > 5)
+		ptr = name + 5;
+	else
+		ptr = name;
+	return ptr;
+}
+
 dev_t parse_devt(const char *dev_t)
 {
 	int maj, min;
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 44184a1..0dd72ae 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -10,6 +10,7 @@ size_t strlcat(char *dst, const char *src, size_t size);
 void remove_trailing_chars(char *path, char c);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
+char *convert_dev(char *dev, int is_path_device);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/multipath/main.c b/multipath/main.c
index 842a787..91eab88 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -255,16 +255,7 @@ configure (void)
 	vecs.pathvec = pathvec;
 	vecs.mpvec = curmp;
 
-	/*
-	 * dev is "/dev/" . "sysfs block dev"
-	 */
-	if (conf->dev) {
-		if (!strncmp(conf->dev, "/dev/", 5) &&
-		    strlen(conf->dev) > 5)
-			dev = conf->dev + 5;
-		else
-			dev = conf->dev;
-	}
+	dev = convert_dev(conf->dev, (conf->dev_type == DEV_DEVNODE));
 
 	/*
 	 * if we have a blacklisted device parameter, exit early
@@ -428,16 +419,6 @@ get_dev_type(char *dev) {
 		return DEV_DEVMAP;
 }
 
-static void
-convert_dev(char *dev)
-{
-	char *ptr = strstr(dev, "cciss/");
-	if (ptr) {
-		ptr += 5;
-		*ptr = '!';
-	}
-}
-
 int
 main (int argc, char *argv[])
 {
@@ -552,8 +533,6 @@ main (int argc, char *argv[])
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
 		conf->dev_type = get_dev_type(conf->dev);
-		if (conf->dev_type == DEV_DEVNODE)
-			convert_dev(conf->dev);
 	}
 	conf->daemon = 0;
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index baa43c4..f7fc522 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -235,6 +235,7 @@ cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 	
+	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
@@ -416,6 +417,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	struct path *pp;
 	int r;
 
+	param = convert_dev(param, 1);
 	condlog(2, "%s: add path (operator)", param);
 
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
@@ -459,6 +461,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, PATH);
 	struct path *pp;
 
+	param = convert_dev(param, 1);
 	condlog(2, "%s: remove path (operator)", param);
 	pp = find_path_by_dev(vecs->pathvec, param);
 	if (!pp) {
@@ -478,6 +481,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	char *alias;
 	int rc;
 
+	param = convert_dev(param, 0);
 	condlog(2, "%s: add map (operator)", param);
 
 	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param) > 0) {
@@ -518,6 +522,7 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	char *alias;
 	int rc;
 
+	param = convert_dev(param, 0);
 	condlog(2, "%s: remove map (operator)", param);
 	minor = dm_get_minor(param);
 	if (minor < 0) {
@@ -549,6 +554,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 	struct multipath *mpp;
 	int minor;
 
+	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: reload map (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
@@ -593,6 +599,7 @@ cli_resize(void *v, char **reply, int *len, void *data)
 	struct pathgroup *pgp;
 	struct path *pp;
 
+	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: resize map (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
@@ -667,6 +674,7 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 	struct multipath *mpp;
 	int minor;
 
+	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: restore map queueing (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
@@ -718,6 +726,7 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 	struct multipath *mpp;
 	int minor;
 
+	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: disable map queueing (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
@@ -755,6 +764,7 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 	char * mapname = get_keyparam(v, MAP);
 	int groupnum = atoi(get_keyparam(v, GROUP));
 
+	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: switch to path group #%i (operator)", mapname, groupnum);
 
 	return dm_switchgroup(mapname, groupnum);
@@ -777,6 +787,7 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, MAP);
 	int r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param);
 
+	param = convert_dev(param, 0);
 	condlog(2, "%s: suspend (operator)", param);
 
 	if (!r) /* error */
@@ -798,6 +809,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, MAP);
 	int r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param);
 
+	param = convert_dev(param, 0);
 	condlog(2, "%s: resume (operator)", param);
 
 	if (!r) /* error */
@@ -819,6 +831,7 @@ cli_reinstate(void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, PATH);
 	struct path * pp;
 
+	param = convert_dev(param, 1);
 	pp = find_path_by_dev(vecs->pathvec, param);
 
 	if (!pp)
@@ -839,6 +852,7 @@ cli_reassign (void * v, char ** reply, int * len, void * data)
 {
 	char * param = get_keyparam(v, MAP);
 
+	param = convert_dev(param, 0);
 	condlog(3, "%s: reset devices (operator)", param);
 
 	dm_reassign(param);
@@ -853,6 +867,7 @@ cli_fail(void * v, char ** reply, int * len, void * data)
 	struct path * pp;
 	int r;
 
+	param = convert_dev(param, 1);
 	pp = find_path_by_dev(vecs->pathvec, param);
 
 	if (!pp)
@@ -964,6 +979,7 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 
+	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
@@ -993,6 +1009,7 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 
+	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
@@ -1015,6 +1032,7 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 
+	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
-- 
1.8.4.2
