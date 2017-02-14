From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 6/7] multipathd: allow resetting stats
Date: Mon, 13 Feb 2017 22:06:52 -0600
Message-ID: <1487045213-15776-7-git-send-email-bmarzins@redhat.com>
References: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

This patch adds two multipathd interactive commands:

multipathd reset maps stats

and

multipathd reset map <map> stats

to reset the statistics that are shown with the "show stats" commands.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.c          |  2 ++
 multipathd/cli_handlers.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |  2 ++
 multipathd/main.c         |  2 ++
 4 files changed, 50 insertions(+)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 50161be..32d4976 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -547,6 +547,8 @@ cli_init (void) {
 	add_handler(LIST+BLACKLIST, NULL);
 	add_handler(LIST+DEVICES, NULL);
 	add_handler(LIST+WILDCARDS, NULL);
+	add_handler(RESET+MAPS+STATS, NULL);
+	add_handler(RESET+MAP+STATS, NULL);
 	add_handler(ADD+PATH, NULL);
 	add_handler(DEL+PATH, NULL);
 	add_handler(ADD+MAP, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b0eeca6..b20b054 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -277,6 +277,17 @@ show_config (char ** r, int * len)
 	return 0;
 }
 
+void
+reset_stats(struct multipath * mpp)
+{
+	mpp->stat_switchgroup = 0;
+	mpp->stat_path_failures = 0;
+	mpp->stat_map_loads = 0;
+	mpp->stat_total_queueing_time = 0;
+	mpp->stat_queueing_timeouts = 0;
+	mpp->stat_map_failures = 0;
+}
+
 int
 cli_list_config (void * v, char ** reply, int * len, void * data)
 {
@@ -627,6 +638,39 @@ cli_list_daemon (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_reset_maps_stats (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	int i;
+	struct multipath * mpp;
+
+	condlog(3, "reset multipaths stats (operator)");
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		reset_stats(mpp);
+	}
+	return 0;
+}
+
+int
+cli_reset_map_stats (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath * mpp;
+	char * param = get_keyparam(v, MAP);
+
+	param = convert_dev(param, 0);
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
+		return 1;
+
+	condlog(3, "reset multipath %s stats (operator)", param);
+	reset_stats(mpp);
+	return 0;
+}
+
+int
 cli_add_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 19e003d..f4d02cc 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -19,6 +19,8 @@ int cli_list_config (void * v, char ** reply, int * len, void * data);
 int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
 int cli_list_devices (void * v, char ** reply, int * len, void * data);
 int cli_list_wildcards (void * v, char ** reply, int * len, void * data);
+int cli_reset_maps_stats (void * v, char ** reply, int * len, void * data);
+int cli_reset_map_stats (void * v, char ** reply, int * len, void * data);
 int cli_add_path (void * v, char ** reply, int * len, void * data);
 int cli_del_path (void * v, char ** reply, int * len, void * data);
 int cli_add_map (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 33b7ad6..aa6c72e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1228,6 +1228,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
 	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
+	set_handler_callback(RESET+MAPS+STATS, cli_reset_maps_stats);
+	set_handler_callback(RESET+MAP+STATS, cli_reset_map_stats);
 	set_handler_callback(ADD+PATH, cli_add_path);
 	set_handler_callback(DEL+PATH, cli_del_path);
 	set_handler_callback(ADD+MAP, cli_add_map);
-- 
1.8.3.1
