From: guanjunxiong 00401709 <guanjunxiong@huawei.com>
Subject: [PATCH] add a cmd to display the topology links
Date: Tue, 7 Aug 2018 11:03:24 +0800
Message-ID: <1533611004-18376-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: guanjunxiong@huawei.com, wangzhoumengjian@huawei.com, dingwenyi@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

From: dingwenyi 00297106 <dingwenyi@huawei.com>

This patch adds a new parameter which named -k to display links information in the multipath command.
Command 'multipath -k' display paths with the same host wwn and target wwn as one link information.
The cmd display the following information to quickly and easily find the host and target information.
[root@localhost mp]# ./multipath -k
link host_wwnn=0x20000024ff2e8092 host_wwpn=0x21000024ff2e8092 target_wwnn=0x2100333435363738 target_wwpn=0x2201333435363738
link host_wwnn=0x20000024ff2e8092 host_wwpn=0x21000024ff2e8092 target_wwnn=0x2100333435363738 target_wwpn=0x2211333435363738
---
 libmultipath/config.h    |  1 +
 libmultipath/discovery.c | 38 ++++++++++++++++++++++++++++++++++++++
 libmultipath/discovery.h |  1 +
 libmultipath/print.c     | 28 ++++++++++++++++++++++++++++
 libmultipath/print.h     |  4 +++-
 libmultipath/structs.c   | 15 +++++++++++++++
 libmultipath/structs.h   |  1 +
 multipath/main.c         | 10 +++++++++-
 8 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 6bd42f06..27c36351 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -38,6 +38,7 @@ enum mpath_cmds {
 	CMD_ADD_WWID,
 	CMD_USABLE_PATHS,
 	CMD_DUMP_CONFIG,
+	CMD_LIST_LINKS,
 };
 
 enum force_reload_types {
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 573d98b1..b9fcaa29 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1992,3 +1992,41 @@ blank:
 
 	return PATHINFO_OK;
 }
+
+vector get_links_by_paths(vector pathvec)
+{
+	vector linkvec;
+	int i,j;
+	struct path * pp;
+	struct path * lp;
+	bool find;
+
+	linkvec = vector_alloc();
+	if(!linkvec)
+		return NULL;
+
+	vector_foreach_slot (pathvec, pp, i) {
+		if(!pp || pp->sg_id.host_no < 0)
+			continue;
+
+		find = false;
+		vector_foreach_slot (linkvec, lp, j) {
+			if(!lp || lp->sg_id.host_no < 0)
+				continue;
+
+			if (lp->sg_id.host_no == pp->sg_id.host_no &&
+				lp->sg_id.channel == pp->sg_id.channel &&
+				lp->sg_id.scsi_id == pp->sg_id.scsi_id) {
+				find = true;
+				continue;
+			}
+		}
+
+		if (find == false)
+			store_path(linkvec, pp);
+	}
+
+	return linkvec;
+}
+
+
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 9aacf75b..167d931b 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -53,6 +53,7 @@ ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev);
+vector get_links_by_paths(vector pathvec);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 222d2701..ecbe2517 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -2018,3 +2018,31 @@ void print_all_paths_custo(vector pathvec, int banner, char *fmt)
 	vector_foreach_slot (pathvec, pp, i)
 		print_path(pp, fmt);
 }
+
+
+void print_all_links(vector pathvec, int banner)
+{
+	int i;
+	struct path * pp; 
+	char *fmt = PRINT_LINK_SHORT;
+	vector linkvec = NULL;
+
+	if (!VECTOR_SIZE(pathvec)) {
+		if (banner)
+			fprintf(stdout, "===== no links =====\n");
+		return;
+	}
+
+	linkvec = get_links_by_paths(pathvec);
+	if (NULL == linkvec || !VECTOR_SIZE(linkvec)) {
+		if (banner)
+			fprintf(stdout, "===== no links =====\n");
+		return;
+	}
+
+	vector_foreach_slot (linkvec, pp, i)
+		print_path(pp, fmt);
+
+	free_linkvec(linkvec);
+}
+
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 608b7d5f..1c711f59 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -10,6 +10,7 @@
 #define PRINT_MAP_NAMES      "%n %d %w"
 #define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
 #define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
+#define PRINT_LINK_SHORT     "link host_wwnn=%N host_wwpn=%R target_wwnn=%n target_wwpn=%r"
 
 #define PRINT_JSON_MULTIPLIER     5
 #define PRINT_JSON_MAJOR_VERSION  0
@@ -68,7 +69,7 @@
 			     "            \"target_wwpn\" : \"%r\",\n" \
 			     "            \"host_adapter\" : \"%a\""
 
-#define MAX_LINE_LEN  80
+#define MAX_LINE_LEN  128
 #define MAX_LINES     64
 #define MAX_FIELD_LEN 128
 #define PROGRESS_LEN  10
@@ -141,6 +142,7 @@ void _print_multipath_topology (const struct gen_multipath * gmp,
 
 void print_all_paths (vector pathvec, int banner);
 void print_all_paths_custo (vector pathvec, int banner, char *fmt);
+void print_all_links(vector pathvec, int banner);
 
 int snprint_path_attr(const struct gen_path* gp,
 		      char *buf, int len, char wildcard);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index ae847d61..c4f9ae92 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -292,6 +292,21 @@ free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 	vector_free(mpvec);
 }
 
+void
+free_linkvec(vector vec)
+{
+	int i;
+	struct path * pp;
+
+	if (!vec || !VECTOR_SIZE(vec))
+		return;
+
+	vector_foreach_slot(vec, pp, i)
+		vector_del_slot(vec, i);
+
+	vector_free(vec);
+}
+
 int
 store_path (vector pathvec, struct path * pp)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e5b698b0..9e57cb89 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -407,6 +407,7 @@ void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void free_multipath_attributes (struct multipath *);
 void drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths);
 void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
+void free_linkvec(vector vec);
 
 struct adapter_group * alloc_adaptergroup(void);
 struct host_group * alloc_hostgroup(void);
diff --git a/multipath/main.c b/multipath/main.c
index fc5bf169..6b1bbca7 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -126,6 +126,7 @@ usage (char * progname)
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [-R num] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl] [-R num]\n", progname);
 	fprintf (stderr, "  %s [-t|-T]\n", progname);
+	fprintf (stderr, "  %s -k\n", progname);
 	fprintf (stderr, "  %s -h\n", progname);
 	fprintf (stderr,
 		"\n"
@@ -148,6 +149,7 @@ usage (char * progname)
 		"  -b fil  bindings file location\n"
 		"  -w      remove a device from the wwids file\n"
 		"  -W      reset the wwids file include only the current devices\n"
+		"  -k      display the links between host and storage\n"
 		"  -p pol  force all maps to specified path grouping policy :\n"
 		"          . failover            one path per priority group\n"
 		"          . multibus            all paths in one priority group\n"
@@ -683,6 +685,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	if (get_dm_mpvec(cmd, curmp, pathvec, refwwid))
 		goto out;
 
+	if (cmd == CMD_LIST_LINKS)
+		print_all_links(pathvec, 1);
+		
 	filter_pathvec(pathvec, refwwid);
 
 	if (cmd == CMD_DUMP_CONFIG) {
@@ -870,7 +875,7 @@ main (int argc, char *argv[])
 		exit(1);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
-	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adcChlk::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -957,6 +962,9 @@ main (int argc, char *argv[])
 		case 'W':
 			cmd = CMD_RESET_WWIDS;
 			break;
+		case 'k':
+			cmd = CMD_LIST_LINKS;
+			break;
 		case 'a':
 			cmd = CMD_ADD_WWID;
 			break;
-- 
2.12.0.windows.1
