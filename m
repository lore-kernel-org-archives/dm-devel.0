From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/78] multipathd: implement 'list path <path>'
	cli command
Date: Mon, 16 Mar 2015 13:36:06 +0100
Message-ID: <1426509425-15978-20-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Implement CLI command for printing the status of a single path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli.c          |  1 +
 multipathd/cli_handlers.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |  1 +
 multipathd/main.c         |  1 +
 4 files changed, 47 insertions(+)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 2a5edfa..acc4249 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -425,6 +425,7 @@ cli_init (void) {
 
 	add_handler(LIST+PATHS, NULL);
 	add_handler(LIST+PATHS+FMT, NULL);
+	add_handler(LIST+PATH, NULL);
 	add_handler(LIST+STATUS, NULL);
 	add_handler(LIST+DAEMON, NULL);
 	add_handler(LIST+MAPS, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 43372d3..6abe72a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -71,6 +71,35 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style)
 }
 
 int
+show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
+	   char * style)
+{
+	char * c;
+	char * reply;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
+
+	get_path_layout(vecs->pathvec, 1);
+	reply = MALLOC(maxlen);
+
+	while (again) {
+		if (!reply)
+			return 1;
+
+		c = reply;
+
+		c += snprint_path(c, reply + maxlen - c, style, pp);
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
 show_map_topology (char ** r, int * len, struct multipath * mpp,
 		   struct vectors * vecs)
 {
@@ -239,6 +268,21 @@ cli_list_paths_fmt (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_list_path (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, PATH);
+	struct path *pp;
+
+	param = convert_dev(param, 1);
+	condlog(3, "%s: list path (operator)", param);
+
+	pp = find_path_by_dev(vecs->pathvec, param);
+
+	return show_path(reply, len, vecs, pp, "%o");
+}
+
+int
 cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 {
 	struct multipath * mpp;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index de51961..c4636d2 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -1,5 +1,6 @@
 int cli_list_paths (void * v, char ** reply, int * len, void * data);
 int cli_list_paths_fmt (void * v, char ** reply, int * len, void * data);
+int cli_list_path (void * v, char ** reply, int * len, void * data);
 int cli_list_status (void * v, char ** reply, int * len, void * data);
 int cli_list_daemon (void * v, char ** reply, int * len, void * data);
 int cli_list_maps (void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 3e22ad1..2107113 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -886,6 +886,7 @@ uxlsnrloop (void * ap)
 
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
+	set_handler_callback(LIST+PATH, cli_list_path);
 	set_handler_callback(LIST+MAPS, cli_list_maps);
 	set_handler_callback(LIST+STATUS, cli_list_status);
 	set_handler_callback(LIST+DAEMON, cli_list_daemon);
-- 
1.8.4.5
