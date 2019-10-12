From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 51/72] libmultipath: make "checkint" unsigned
Date: Sat, 12 Oct 2019 21:28:40 +0000
Message-ID: <20191012212703.12989-52-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

path->checkint was unsigned already, now use this type everywhere.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h      |  4 ++--
 libmultipath/dict.c        |  4 ++--
 libmultipath/discovery.c   |  2 +-
 libmultipath/discovery.h   |  2 +-
 libmultipath/io_err_stat.c |  2 +-
 libmultipath/structs_vec.c |  2 +-
 multipathd/main.c          | 10 ++++++----
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index ffec3103..2ab7b42c 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -137,8 +137,8 @@ struct config {
 	int pgpolicy;
 	int minio;
 	int minio_rq;
-	int checkint;
-	int max_checkint;
+	unsigned int checkint;
+	unsigned int max_checkint;
 	int pgfailback;
 	int remove;
 	int rr_weight;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c23d525b..a90690fa 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -314,7 +314,7 @@ snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
 
 static int checkint_handler(struct config *conf, vector strvec)
 {
-	int rc = set_int(strvec, &conf->checkint);
+	int rc = set_uint(strvec, &conf->checkint);
 
 	if (rc)
 		return rc;
@@ -325,7 +325,7 @@ static int checkint_handler(struct config *conf, vector strvec)
 
 declare_def_snprint(checkint, print_int)
 
-declare_def_handler(max_checkint, set_int)
+declare_def_handler(max_checkint, set_uint)
 declare_def_snprint(max_checkint, print_int)
 
 declare_def_handler(verbosity, set_int)
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6288c3e0..4288c9fd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -754,7 +754,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 }
 
 int
-sysfs_set_scsi_tmo (struct multipath *mpp, int checkint)
+sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 {
 	struct path *pp;
 	int i;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 8d04c2af..0516e41b 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -42,7 +42,7 @@ int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
-int sysfs_set_scsi_tmo (struct multipath *mpp, int checkint);
+int sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint);
 int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
 int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 6b3a3e19..d7e296fa 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -357,7 +357,7 @@ int io_err_stat_handle_pathfail(struct path *path)
 		if (path->state != PATH_DOWN) {
 			struct config *conf;
 			int oldstate = path->state;
-			int checkint;
+			unsigned int checkint;
 
 			conf = get_multipath_config();
 			checkint = conf->checkint;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index c43b58fb..6991f9ac 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -292,7 +292,7 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 
 void enter_recovery_mode(struct multipath *mpp)
 {
-	int checkint;
+	unsigned int checkint;
 	struct config *conf = get_multipath_config();
 	checkint = conf->checkint;
 	put_multipath_config(conf);
diff --git a/multipathd/main.c b/multipathd/main.c
index 26d5aa9c..bb5c1f1d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -493,7 +493,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 			if (pp->state != PATH_DOWN) {
 				struct config *conf;
 				int oldstate = pp->state;
-				int checkint;
+				unsigned int checkint;
 
 				conf = get_multipath_config();
 				checkint = conf->checkint;
@@ -1985,7 +1985,7 @@ should_skip_path(struct path *pp){
  * and '0' otherwise
  */
 int
-check_path (struct vectors * vecs, struct path * pp, int ticks)
+check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -1993,7 +1993,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int add_active;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
-	int retrigger_tries, checkint, max_checkint, verbosity;
+	int retrigger_tries, verbosity;
+	unsigned int checkint, max_checkint;
 	struct config *conf;
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
@@ -2333,7 +2334,8 @@ checkerloop (void *ap)
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
-		int num_paths = 0, ticks = 0, strict_timing, rc = 0;
+		int num_paths = 0, strict_timing, rc = 0;
+		unsigned int ticks = 0;
 
 		get_monotonic_time(&start_time);
 		if (start_time.tv_sec && last_time.tv_sec) {
-- 
2.23.0
