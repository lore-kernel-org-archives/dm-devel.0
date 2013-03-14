From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] multipathd: Implement 'suspend/resume path'
Date: Thu, 14 Mar 2013 15:08:48 +0100
Message-ID: <1363270128-20900-7-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch implements a new CLI command pair
'suspend path' and 'resume path' to block and unblock
a remote FC port manually.
It also will block the remote FC port if a path checker
returns 'PATH_TIMEOUT'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli.c          |    2 ++
 multipathd/cli_handlers.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |    2 ++
 multipathd/main.c         |    7 +++++++
 4 files changed, 61 insertions(+)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index d95cba0..e278956 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -439,6 +439,8 @@ cli_init (void) {
 	add_handler(LIST+WILDCARDS, NULL);
 	add_handler(ADD+PATH, NULL);
 	add_handler(DEL+PATH, NULL);
+	add_handler(SUSPEND+PATH, NULL);
+	add_handler(RESUME+PATH, NULL);
 	add_handler(ADD+MAP, NULL);
 	add_handler(DEL+MAP, NULL);
 	add_handler(SWITCH+MAP+GROUP, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a1e4bde..6c8d8d8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -469,6 +469,56 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_block_path(void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, PATH);
+	struct path * pp;
+	int r;
+
+	pp = find_path_by_dev(vecs->pathvec, param);
+	if (!pp)
+		 pp = find_path_by_devt(vecs->pathvec, param);
+
+	if (!pp || !pp->mpp || !pp->mpp->alias) {
+		condlog(3, "%s: path not found\n", param);
+		return 1;
+	}
+	condlog(2, "%s: block path %s (operator)",
+		pp->mpp->alias, pp->dev_t);
+
+
+	r = sysfs_set_fc_rport_state(pp, 1);
+
+	return r ? 1 : 0;
+}
+
+int
+cli_unblock_path(void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * param = get_keyparam(v, PATH);
+	struct path * pp;
+	int r;
+
+	pp = find_path_by_dev(vecs->pathvec, param);
+	if (!pp)
+		 pp = find_path_by_devt(vecs->pathvec, param);
+
+	if (!pp || !pp->mpp || !pp->mpp->alias) {
+		condlog(3, "%s: path not found\n", param);
+		return 1;
+	}
+	condlog(2, "%s: unblock path %s (operator)",
+		pp->mpp->alias, pp->dev_t);
+
+
+	r = sysfs_set_fc_rport_state(pp, 0);
+
+	return r ? 1 : 0;
+}
+
+int
 cli_add_map (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index c62a273..8734610 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -14,6 +14,8 @@ int cli_list_devices (void * v, char ** reply, int * len, void * data);
 int cli_list_wildcards (void * v, char ** reply, int * len, void * data);
 int cli_add_path (void * v, char ** reply, int * len, void * data);
 int cli_del_path (void * v, char ** reply, int * len, void * data);
+int cli_block_path (void * v, char ** reply, int * len, void * data);
+int cli_unblock_path (void * v, char ** reply, int * len, void * data);
 int cli_add_map (void * v, char ** reply, int * len, void * data);
 int cli_del_map (void * v, char ** reply, int * len, void * data);
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 95264fc..30afb24 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -861,6 +861,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
 	set_handler_callback(ADD+PATH, cli_add_path);
 	set_handler_callback(DEL+PATH, cli_del_path);
+	set_handler_callback(SUSPEND+PATH, cli_block_path);
+	set_handler_callback(RESUME+PATH, cli_unblock_path);
 	set_handler_callback(ADD+MAP, cli_add_map);
 	set_handler_callback(DEL+MAP, cli_del_map);
 	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
@@ -1132,6 +1134,11 @@ check_path (struct vectors * vecs, struct path * pp)
 		pp->tick = 1;
 		return;
 	}
+	if (newstate == PATH_TIMEOUT) {
+		/* Command timeout, block path */
+		sysfs_set_fc_rport_state(pp, 1);
+		newstate = PATH_DOWN;
+	}
 	/*
 	 * Synchronize with kernel state
 	 */
-- 
1.7.10.4
