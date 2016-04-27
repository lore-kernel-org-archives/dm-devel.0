From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 53/57] multipathd: implement 'show map $map
	format $fmt'
Date: Wed, 27 Apr 2016 13:10:54 +0200
Message-ID: <1461755458-29225-54-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Similar to the existing 'show map $map topology', but allowing
formatted content.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli.c          |  2 ++
 multipathd/cli_handlers.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |  2 ++
 multipathd/main.c         |  2 ++
 4 files changed, 73 insertions(+)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index ab1365b..3c9cdbf 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -497,6 +497,8 @@ cli_init (void) {
 	add_handler(LIST+MAPS+TOPOLOGY, NULL);
 	add_handler(LIST+TOPOLOGY, NULL);
 	add_handler(LIST+MAP+TOPOLOGY, NULL);
+	add_handler(LIST+MAP+FMT, NULL);
+	add_handler(LIST+MAP+RAW+FMT, NULL);
 	add_handler(LIST+CONFIG, NULL);
 	add_handler(LIST+BLACKLIST, NULL);
 	add_handler(LIST+DEVICES, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 886a5fd..dbdcbc2 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -349,6 +349,33 @@ show_daemon (char ** r, int *len)
 }
 
 int
+show_map (char ** r, int *len, struct multipath * mpp, char * style,
+	  int pretty)
+{
+	char * c;
+	char * reply;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
+
+	reply = MALLOC(maxlen);
+	while (again) {
+		if (!reply)
+			return 1;
+
+		c = reply;
+		c += snprint_multipath(c, reply + maxlen - c, style,
+				       mpp, pretty);
+
+		again = ((c - reply) == (maxlen - 1));
+
+		REALLOC_REPLY(reply, again, maxlen);
+	}
+	*r = reply;
+	*len = (int)(c - reply + 1);
+	return 0;
+}
+
+int
 show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 	   int pretty)
 {
@@ -407,6 +434,46 @@ cli_list_maps_raw (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_list_map_fmt (void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+	char * fmt = get_keyparam(v, FMT);
+
+	param = convert_dev(param, 0);
+	get_path_layout(vecs->pathvec, 0);
+	get_multipath_layout(vecs->mpvec, 1);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+	if (!mpp)
+		return 1;
+
+	condlog(3, "list map %s fmt %s (operator)", param, fmt);
+
+	return show_map(reply, len, mpp, fmt, 1);
+}
+
+int
+cli_list_map_raw (void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, MAP);
+	char * fmt = get_keyparam(v, FMT);
+
+	param = convert_dev(param, 0);
+	get_path_layout(vecs->pathvec, 0);
+	get_multipath_layout(vecs->mpvec, 1);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+	if (!mpp)
+		return 1;
+
+	condlog(3, "list map %s fmt %s (operator)", param, fmt);
+
+	return show_map(reply, len, mpp, fmt, 0);
+}
+
+int
 cli_list_maps (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 799f8da..5d51018 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -7,6 +7,8 @@ int cli_list_daemon (void * v, char ** reply, int * len, void * data);
 int cli_list_maps (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_fmt (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_raw (void * v, char ** reply, int * len, void * data);
+int cli_list_map_fmt (void * v, char ** reply, int * len, void * data);
+int cli_list_map_raw (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_status (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_stats (void * v, char ** reply, int * len, void * data);
 int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index d8fa88f..a58dae5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -990,6 +990,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
 	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
 	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
+	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
+	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+CONFIG, cli_list_config);
 	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
-- 
2.6.6
