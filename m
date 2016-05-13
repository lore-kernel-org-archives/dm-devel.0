From: Todd Gill <tgill@redhat.com>
Subject: [PATCH v3 1/1] add display of map information in JSON
	format
Date: Fri, 13 May 2016 10:39:00 -0400
Message-ID: <1463150340-27174-2-git-send-email-tgill@redhat.com>
References: <1463150340-27174-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463150340-27174-1-git-send-email-tgill@redhat.com>
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
Cc: Todd Gill <tgill@redhat.com>
List-Id: dm-devel.ids

The patch adds these commands:

multipathd show maps json
multipathd show map $map json

Each command will output the requested map(s) in JSON.

For the "show maps json" command, the patch pre-allocates
INITIAL_REPLY_LEN * PRINT_JSON_MULTIPLIER(5).  The JSON text
is about 5x the size of the "show maps topology" text.

v3:

Added format specifiers at the map level to split out
vend/prod/rev.

A user can now specify the following with:

multipathd show map(s) format

%v - vend
%p - prod
%e - rev

Signed-off-by: Todd Gill <tgill@redhat.com>
---
 libmultipath/print.c      | 220 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h      |  65 ++++++++++++++
 multipathd/cli.c          |   3 +
 multipathd/cli.h          |   2 +
 multipathd/cli_handlers.c |  93 ++++++++++++++++++++
 multipathd/cli_handlers.h |   2 +
 multipathd/main.c         |   2 +
 7 files changed, 387 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7fec6e9..5d668bb 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -274,6 +274,61 @@ snprint_multipath_vpr (char * buff, size_t len, struct multipath * mpp)
 	return snprintf(buff, len, "##,##");
 }
 
+
+static int
+snprint_multipath_vend (char * buff, size_t len, struct multipath * mpp)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	int i, j;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		if (!pgp)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (strlen(pp->vendor_id))
+				return snprintf(buff, len, "%s", pp->vendor_id);
+		}
+	}
+	return snprintf(buff, len, "##");
+}
+
+static int
+snprint_multipath_prod (char * buff, size_t len, struct multipath * mpp)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	int i, j;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		if (!pgp)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (strlen(pp->product_id))
+				return snprintf(buff, len, "%s", pp->product_id);
+		}
+	}
+	return snprintf(buff, len, "##");
+}
+
+static int
+snprint_multipath_rev (char * buff, size_t len, struct multipath * mpp)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	int i, j;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		if (!pgp)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (strlen(pp->rev))
+				return snprintf(buff, len, "%s", pp->rev);
+		}
+	}
+	return snprintf(buff, len, "##");
+}
+
 static int
 snprint_action (char * buff, size_t len, struct multipath * mpp)
 {
@@ -577,6 +632,9 @@ struct multipath_data mpd[] = {
 	{'3', "total_q_time",  0, snprint_total_q_time},
 	{'4', "q_timeouts",    0, snprint_q_timeouts},
 	{'s', "vend/prod/rev", 0, snprint_multipath_vpr},
+	{'v', "vend",          0, snprint_multipath_vend},
+	{'p', "prod",          0, snprint_multipath_prod},
+	{'e', "rev",           0, snprint_multipath_rev},
 	{0, NULL, 0 , NULL}
 };
 
@@ -1000,6 +1058,168 @@ snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
 }
 
 static int
+snprint_json (char * buff, int len, int indent, char *json_str)
+{
+	int fwd = 0, i;
+
+	for (i = 0; i < indent; i++) {
+		fwd += snprintf(buff + fwd, len - fwd, PRINT_JSON_INDENT);
+		if (fwd > len)
+			return fwd;
+	}
+
+	fwd += snprintf(buff + fwd, len - fwd, "%s", json_str);
+	return fwd;
+}
+
+static int
+snprint_json_header (char * buff, int len)
+{
+	int fwd = 0;
+
+	fwd +=  snprint_json(buff, len, 0, PRINT_JSON_START_ELEM);
+	if (fwd > len)
+		return fwd;
+
+	fwd +=  snprintf(buff + fwd, len  - fwd, PRINT_JSON_START_VERSION,
+			PRINT_JSON_MAJOR_VERSION, PRINT_JSON_MINOR_VERSION);
+	return fwd;
+}
+
+static int
+snprint_json_elem_footer (char * buff, int len, int indent, int last)
+{
+	int fwd = 0, i;
+
+	for (i = 0; i < indent; i++) {
+		fwd += snprintf(buff + fwd, len - fwd, PRINT_JSON_INDENT);
+		if (fwd > len)
+			return fwd;
+	}
+
+	if (last == 1)
+		fwd += snprintf(buff + fwd, len - fwd, "%s", PRINT_JSON_END_LAST_ELEM);
+	else
+		fwd += snprintf(buff + fwd, len - fwd, "%s", PRINT_JSON_END_ELEM);
+	return fwd;
+}
+
+static int
+snprint_multipath_fields_json (char * buff, int len,
+		struct multipath * mpp, int last)
+{
+	int i, j, fwd = 0;
+	struct path *pp;
+	struct pathgroup *pgp;
+
+	fwd += snprint_multipath(buff, len, PRINT_JSON_MAP, mpp, 0);
+	if (fwd > len)
+		return fwd;
+
+	fwd += snprint_json(buff + fwd, len - fwd, 2, PRINT_JSON_START_GROUPS);
+	if (fwd > len)
+		return fwd;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+
+		pgp->selector = mpp->selector;
+		fwd += snprint_pathgroup(buff + fwd, len - fwd, PRINT_JSON_GROUP, pgp);
+		if (fwd > len)
+			return fwd;
+
+		fwd += snprint_json(buff + fwd, len - fwd, 3, PRINT_JSON_START_PATHS);
+		if (fwd > len)
+			return fwd;
+
+		vector_foreach_slot (pgp->paths, pp, j) {
+			fwd += snprint_path(buff + fwd, len - fwd, PRINT_JSON_PATH, pp, 0);
+			if (fwd > len)
+				return fwd;
+
+			fwd += snprint_json_elem_footer(buff + fwd,
+					len - fwd, 3, j + 1 == VECTOR_SIZE(pgp->paths));
+			if (fwd > len)
+				return fwd;
+		}
+		fwd += snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
+		if (fwd > len)
+			return fwd;
+
+		fwd +=  snprint_json_elem_footer(buff + fwd,
+				len - fwd, 2, i + 1 == VECTOR_SIZE(mpp->pg));
+		if (fwd > len)
+			return fwd;
+	}
+
+	fwd += snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
+	if (fwd > len)
+		return fwd;
+
+	fwd += snprint_json_elem_footer(buff + fwd, len - fwd, 1, last);
+	return fwd;
+}
+
+int
+snprint_multipath_map_json (char * buff, int len,
+		struct multipath * mpp, int last){
+	int fwd = 0;
+
+	memset(buff, 0, len);
+	fwd +=  snprint_json_header(buff, len);
+	if (fwd > len)
+		return len;
+
+	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_START_MAP);
+	if (fwd > len)
+		return len;
+
+	fwd += snprint_multipath_fields_json(buff + fwd, len - fwd, mpp, 1);
+	if (fwd > len)
+		return len;
+
+	fwd +=  snprint_json(buff + fwd, len - fwd, 0, "\n");
+	if (fwd > len)
+		return len;
+
+	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_LAST);
+	if (fwd > len)
+		return len;
+	return fwd;
+}
+
+int
+snprint_multipath_topology_json (char * buff, int len, struct vectors * vecs)
+{
+	int i, fwd = 0;
+	struct multipath * mpp;
+
+	memset(buff, 0, len);
+	fwd +=  snprint_json_header(buff, len);
+	if (fwd > len)
+		return len;
+
+	fwd +=  snprint_json(buff + fwd, len  - fwd, 1, PRINT_JSON_START_MAPS);
+	if (fwd > len)
+		return len;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		fwd += snprint_multipath_fields_json(buff + fwd, len - fwd,
+				mpp, i + 1 == VECTOR_SIZE(vecs->mpvec));
+		if (fwd > len)
+			return len;
+	}
+
+	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
+	if (fwd > len)
+		return len;
+
+	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_LAST);
+	if (fwd > len)
+		return len;
+	return fwd;
+}
+
+static int
 snprint_hwentry (char * buff, int len, struct hwentry * hwe)
 {
 	int i;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 8bd0bbc..92ade7e 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -7,6 +7,67 @@
 #define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
 #define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
 
+#define PRINT_JSON_MULTIPLIER     5
+#define PRINT_JSON_MAJOR_VERSION  0
+#define PRINT_JSON_MINOR_VERSION  1
+#define PRINT_JSON_START_VERSION  "   \"major_version \": %d,\n" \
+                                  "   \"minor_version \": %d,\n"
+#define PRINT_JSON_START_ELEM     "{\n"
+#define PRINT_JSON_START_MAP      "   \"map\":"
+#define PRINT_JSON_START_MAPS     "\"maps\": ["
+#define PRINT_JSON_START_PATHS    "\"paths\": ["
+#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
+#define PRINT_JSON_END_ELEM       "},"
+#define PRINT_JSON_END_LAST_ELEM  "}"
+#define PRINT_JSON_END_LAST       "}\n"
+#define PRINT_JSON_END_ARRAY      "]\n"
+#define PRINT_JSON_INDENT    "   "
+#define PRINT_JSON_MAP       "{\n" \
+                             "      \"name\" : \"%n\",\n" \
+                             "      \"uuid\" : \"%w\",\n" \
+                             "      \"sysfs\" : \"%d\",\n" \
+                             "      \"failback\" : \"%F\",\n" \
+                             "      \"queueing\" : \"%Q\",\n" \
+                             "      \"paths\" : %N,\n" \
+                             "      \"write_prot\" : \"%r\",\n" \
+                             "      \"dm-st\" : \"%t\",\n" \
+                             "      \"size\" : \"%S\",\n" \
+                             "      \"features\" : \"%f\",\n" \
+                             "      \"hwhandler\" : \"%h\",\n" \
+                             "      \"action\" : \"%A\",\n" \
+                             "      \"path_faults\" : %0,\n" \
+                             "      \"vend\" : \"%v\",\n" \
+							 "      \"prod\" : \"%p\",\n" \
+							 "      \"rev\" : \"%e\",\n" \
+                             "      \"switch_grp\" : %1,\n" \
+                             "      \"map_loads\" : %2,\n" \
+                             "      \"total_q_time\" : %3,\n" \
+                             "      \"q_timeouts\" : %4,"
+
+#define PRINT_JSON_GROUP     "{\n" \
+                             "         \"selector\" : \"%s\",\n" \
+                             "         \"pri\" : %p,\n" \
+                             "         \"dm_st\" : \"%t\","
+
+#define PRINT_JSON_PATH      "{\n" \
+                             "            \"uuid\" : \"%w\",\n" \
+                             "            \"hcil\" : \"%i\",\n" \
+                             "            \"dev\" : \"%d\",\n"\
+                             "            \"dev_t\" : \"%D\",\n" \
+                             "            \"dm_st\" : \"%t\",\n" \
+                             "            \"dev_st\" : \"%o\",\n" \
+                             "            \"chk_st\" : \"%T\",\n" \
+                             "            \"checker\" : \"%c\",\n" \
+                             "            \"next_check\" : \"%C\",\n" \
+                             "            \"pri\" : %p,\n" \
+                             "            \"size\" : \"%S\",\n" \
+                             "            \"serial\" : \"%z\",\n" \
+                             "            \"host WWNN\" : \"%N\",\n" \
+                             "            \"target WWNN\" : \"%n\",\n" \
+                             "            \"host WWPN\" : \"%R\",\n" \
+                             "            \"target WWPN\" : \"%r\",\n" \
+                             "            \"host adapter\" : \"%a\""
+
 #define MAX_LINE_LEN  80
 #define MAX_LINES     64
 #define MAX_FIELD_LEN 64
@@ -41,6 +102,10 @@ int snprint_path (char *, int, char *, struct path *, int);
 int snprint_multipath (char *, int, char *, struct multipath *, int);
 int snprint_multipath_topology (char *, int, struct multipath * mpp,
 				int verbosity);
+int snprint_multipath_topology_json (char * buff, int len,
+				struct vectors * vecs);
+int snprint_multipath_map_json (char * buff, int len,
+				struct multipath * mpp, int last);
 int snprint_defaults (char *, int);
 int snprint_blacklist (char *, int);
 int snprint_blacklist_except (char *, int);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index d991cd0..20ee3db 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -207,6 +207,7 @@ load_keys (void)
 	r += add_key(keys, "setprstatus", SETPRSTATUS, 0);
 	r += add_key(keys, "unsetprstatus", UNSETPRSTATUS, 0);
 	r += add_key(keys, "format", FMT, 1);
+	r += add_key(keys, "json", JSON, 0);
 
 	if (r) {
 		free_keys(keys);
@@ -537,8 +538,10 @@ cli_init (void) {
 	add_handler(LIST+MAPS+FMT, NULL);
 	add_handler(LIST+MAPS+RAW+FMT, NULL);
 	add_handler(LIST+MAPS+TOPOLOGY, NULL);
+	add_handler(LIST+MAPS+JSON, NULL);
 	add_handler(LIST+TOPOLOGY, NULL);
 	add_handler(LIST+MAP+TOPOLOGY, NULL);
+	add_handler(LIST+MAP+JSON, NULL);
 	add_handler(LIST+MAP+FMT, NULL);
 	add_handler(LIST+MAP+RAW+FMT, NULL);
 	add_handler(LIST+CONFIG, NULL);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 84ca40f..92cb41b 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -36,6 +36,7 @@ enum {
 	__SETPRSTATUS,
 	__UNSETPRSTATUS,
 	__FMT,
+	__JSON,
 };
 
 #define LIST		(1 << __LIST)
@@ -74,6 +75,7 @@ enum {
 #define SETPRSTATUS	(1ULL << __SETPRSTATUS)
 #define UNSETPRSTATUS	(1ULL << __UNSETPRSTATUS)
 #define FMT		(1ULL << __FMT)
+#define JSON		(1ULL << __JSON)
 
 #define INITIAL_REPLY_LEN	1200
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8b3cb9d..19cf2ff 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -156,6 +156,70 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 }
 
 int
+show_maps_json (char ** r, int * len, struct vectors * vecs)
+{
+	int i;
+	struct multipath * mpp;
+	char * c;
+	char * reply;
+	unsigned int maxlen = INITIAL_REPLY_LEN * PRINT_JSON_MULTIPLIER;
+	int again = 1;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (update_multipath(vecs, mpp->alias, 0)) {
+			return 1;
+		}
+	}
+
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return 1;
+
+		c = reply;
+
+		c += snprint_multipath_topology_json(c, reply + maxlen - c,
+				vecs);
+		again = ((c - reply) == maxlen);
+
+		REALLOC_REPLY(reply, again, maxlen);
+	}
+	*r = reply;
+	*len = (int)(c - reply + 1);
+	return 0;
+}
+
+int
+show_map_json (char ** r, int * len, struct multipath * mpp,
+		   struct vectors * vecs)
+{
+	char * c;
+	char * reply;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
+
+	if (update_multipath(vecs, mpp->alias, 0))
+		return 1;
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return 1;
+
+		c = reply;
+
+		c += snprint_multipath_map_json(c, reply + maxlen - c, mpp, 1);
+		again = ((c - reply) == maxlen);
+
+		REALLOC_REPLY(reply, again, maxlen);
+	}
+	*r = reply;
+	*len = (int)(c - reply + 1);
+	return 0;
+}
+
+int
 show_config (char ** r, int * len)
 {
 	char * c;
@@ -291,6 +355,35 @@ cli_list_maps_topology (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_list_map_json (void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+
+	param = convert_dev(param, 0);
+	get_path_layout(vecs->pathvec, 0);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return 1;
+
+	condlog(3, "list multipath json %s (operator)", param);
+
+	return show_map_json(reply, len, mpp, vecs);
+}
+
+int
+cli_list_maps_json (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+
+	condlog(3, "list multipaths json (operator)");
+
+	return show_maps_json(reply, len, vecs);
+}
+
+int
 cli_list_wildcards (void * v, char ** reply, int * len, void * data)
 {
 	char * c;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 5d51018..e838f19 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -13,6 +13,8 @@ int cli_list_maps_status (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_stats (void * v, char ** reply, int * len, void * data);
 int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_topology (void * v, char ** reply, int * len, void * data);
+int cli_list_map_json (void * v, char ** reply, int * len, void * data);
+int cli_list_maps_json (void * v, char ** reply, int * len, void * data);
 int cli_list_config (void * v, char ** reply, int * len, void * data);
 int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
 int cli_list_devices (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 58e8854..33f38cd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1120,9 +1120,11 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
 	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
 	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
+	set_handler_callback(LIST+MAPS+JSON, cli_list_maps_json);
 	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
 	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
+	set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
 	set_unlocked_handler_callback(LIST+CONFIG, cli_list_config);
 	set_unlocked_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
-- 
2.5.5
