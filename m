From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 23/28] multipathd: implement "show config local"
Date: Fri,  8 Jun 2018 12:20:36 +0200
Message-ID: <20180608102041.22904-24-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This new command is like "show config", but only those "device" sections are
dumped that match actually present devices in the system. Furthermore, empty
"multipath" sections for all detected multipath maps are dumped. This way,
the output is suitable as a template for creating "multipath.conf".

"multipathd show config local" should produce output that,
when used as configuration file, creates the same configuration
as was in place while it was dumped. Add a test for this to the
test suite.

Some minor differences in the configuration dump can't be avoided
because the ordering of hwtable entries may change (e.g. if a user
adds a device entry for a device which is also in the built-in hwtable,
these entries will be merged end the merged entry will be at the position
of the new entry, i.e. after all built-in hwtable entries), and multipath
sections are added to the configuration. But by all means, path
and mulitpath objects should have the same properties than before.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c          |  2 ++
 multipathd/cli.h          |  2 ++
 multipathd/cli_handlers.c | 28 +++++++++++++++++++++++++---
 multipathd/cli_handlers.h |  1 +
 multipathd/main.c         |  1 +
 multipathd/multipathd.8   |  5 +++++
 6 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index d5ee4ff0..a75afe3f 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -212,6 +212,7 @@ load_keys (void)
 	r += add_key(keys, "setprkey", SETPRKEY, 0);
 	r += add_key(keys, "unsetprkey", UNSETPRKEY, 0);
 	r += add_key(keys, "key", KEY, 1);
+	r += add_key(keys, "local", LOCAL, 0);
 
 
 	if (r) {
@@ -549,6 +550,7 @@ cli_init (void) {
 	add_handler(LIST+MAP+FMT, NULL);
 	add_handler(LIST+MAP+RAW+FMT, NULL);
 	add_handler(LIST+CONFIG, NULL);
+	add_handler(LIST+CONFIG+LOCAL, NULL);
 	add_handler(LIST+BLACKLIST, NULL);
 	add_handler(LIST+DEVICES, NULL);
 	add_handler(LIST+WILDCARDS, NULL);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 021f25b7..7cc7e4be 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -44,6 +44,7 @@ enum {
 	__SETPRKEY,
 	__UNSETPRKEY,
 	__KEY,
+	__LOCAL,
 };
 
 #define LIST		(1 << __LIST)
@@ -87,6 +88,7 @@ enum {
 #define SETPRKEY	(1ULL << __SETPRKEY)
 #define UNSETPRKEY	(1ULL << __UNSETPRKEY)
 #define KEY		(1ULL << __KEY)
+#define LOCAL		(1ULL << __LOCAL)
 
 #define INITIAL_REPLY_LEN	1200
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0ac00155..a6ee92b1 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -246,14 +246,15 @@ show_map_json (char ** r, int * len, struct multipath * mpp,
 }
 
 static int
-show_config (char ** r, int * len, const struct _vector *hwtable)
+show_config (char ** r, int * len, const struct _vector *hwtable,
+	     const struct _vector *mpvec)
 {
 	struct config *conf;
 	char *reply;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	reply = snprint_config(conf, len, hwtable, NULL);
+	reply = snprint_config(conf, len, hwtable, mpvec);
 	pthread_cleanup_pop(1);
 	if (reply == NULL)
 		return 1;
@@ -277,7 +278,28 @@ cli_list_config (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "list config (operator)");
 
-	return show_config(reply, len, NULL);
+	return show_config(reply, len, NULL, NULL);
+}
+
+static void v_free(void *x)
+{
+	vector_free(x);
+}
+
+int
+cli_list_config_local (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	vector hwes;
+	int ret;
+
+	condlog(3, "list config local (operator)");
+
+	hwes = get_used_hwes(vecs->pathvec);
+	pthread_cleanup_push(v_free, hwes);
+	ret = show_config(reply, len, hwes, vecs->mpvec);
+	pthread_cleanup_pop(1);
+	return ret;
 }
 
 int
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 78a3a435..edbdf063 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -16,6 +16,7 @@ int cli_list_maps_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_map_json (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_json (void * v, char ** reply, int * len, void * data);
 int cli_list_config (void * v, char ** reply, int * len, void * data);
+int cli_list_config_local (void * v, char ** reply, int * len, void * data);
 int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
 int cli_list_devices (void * v, char ** reply, int * len, void * data);
 int cli_list_wildcards (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 0db88eea..4d891508 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1494,6 +1494,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
+	set_handler_callback(LIST+CONFIG+LOCAL, cli_list_config_local);
 	set_handler_callback(LIST+CONFIG, cli_list_config);
 	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index e78ac9ed..94c3f973 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -135,6 +135,11 @@ Show the currently used configuration, derived from default values and values
 specified within the configuration file \fI/etc/multipath.conf\fR.
 .
 .TP
+.B list|show config local
+Show the currently used configuration like \fIshow config\fR, but limiting
+the devices section to those devices that are actually present in the system.
+.
+.TP
 .B list|show blacklist
 Show the currently used blacklist rules, derived from default values and values
 specified within the configuration file \fI/etc/multipath.conf\fR.
-- 
2.17.0
