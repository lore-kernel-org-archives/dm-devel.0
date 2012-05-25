From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/2] multipath: Fix warnings from stricter
	compile options.
Date: Thu, 24 May 2012 23:57:43 -0500
Message-ID: <1337921863-26482-3-git-send-email-bmarzins@redhat.com>
References: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
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

With stricter compilation options, multipath printed number of
warnings during compilation. Some of them were actual bugs. Others
couldn't cause any problems.  This patch cleans up all the new
warnings.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c  |   10 +++++++---
 libmpathpersist/mpath_pr_ioctl.c |    9 +++++++++
 libmultipath/alias.c             |    8 ++++++--
 mpathpersist/main.c              |    2 --
 multipathd/main.c                |   24 +++++++++++++++++++-----
 5 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index d99c0da..3041089 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -177,8 +177,10 @@ int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
 		goto out;
 	}
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER))
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
+	}
 
 	/* get info of all paths from the dm device	*/
 	if (get_mpvec (curmp, pathvec, alias)){
@@ -265,8 +267,10 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
                 goto out;
         }
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER))
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
+	}
 
 	/* get info of all paths from the dm device     */
 	if (get_mpvec(curmp, pathvec, alias)){
@@ -408,7 +412,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	int rc;
 	int count=0;
 	int status = MPATH_PR_SUCCESS;
-	uint64_t sa_key;	
+	uint64_t sa_key = 0;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR; 
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 2d4d968..de3292e 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -314,6 +314,11 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 	else
 		mx_resp_len = get_prin_length(rq_servact);
 
+	if (mx_resp_len == 0) {
+		status = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
 	cdb[1] = (unsigned char)(rq_servact & 0x1f);
 	cdb[7] = (unsigned char)((mx_resp_len >> 8) & 0xff);
 	cdb[8] = (unsigned char)(mx_resp_len & 0xff);
@@ -569,6 +574,10 @@ int get_prin_length(int rq_servact)
                 case MPATH_PRIN_RFSTAT_SA:
                         mx_resp_len = sizeof(struct print_fulldescr_list) + sizeof(struct prin_fulldescr *)*32;
                         break;
+		default:
+			condlog(0, "invalid service action, %d", rq_servact);
+			mx_resp_len = 0;
+			break;
         }
         return mx_resp_len;
 }
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 4159ec6..ec3a225 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -165,7 +165,9 @@ open_bindings_file(char *file, int *can_write)
 				"Cannot write header to bindings file : %s",
 				strerror(errno));
 			/* cleanup partially written header */
-			ftruncate(fd, 0);
+			if (ftruncate(fd, 0))
+				condlog(0, "Cannot truncate the header : %s",
+					strerror(errno));
 			goto fail;
 		}
 		fsync(fd);
@@ -337,7 +339,9 @@ allocate_binding(int fd, char *wwid, int id, char *prefix)
 		condlog(0, "Cannot write binding to bindings file : %s",
 			strerror(errno));
 		/* clear partial write */
-		ftruncate(fd, offset);
+		if (ftruncate(fd, offset))
+			condlog(0, "Cannot truncate the header : %s",
+				strerror(errno));
 		return NULL;
 	}
 	c = strchr(buf, ' ');
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 33dad90..465fcb1 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -736,7 +736,6 @@ mpath_print_transport_id(struct prin_fulldescr *fdesc)
 int
 construct_transportid(const char * lcp, struct transportid transid[], int num_transportids)
 {
-	unsigned char * tidp;
 	int k = 0;
 	int j, n, b, c, len, alen;
 	const char * ecp;
@@ -792,7 +791,6 @@ construct_transportid(const char * lcp, struct transportid transid[], int num_tr
 		if (ecp && (isip > ecp))
 			isip = NULL;
 		len = ecp ? (ecp - lcp) : (int)strlen(lcp);
-		memset(&tidp, 0, 24);
 		transid[num_transportids].format_code = (isip ? MPATH_WWUI_PORT_IDENTIFIER:MPATH_WWUI_DEVICE_NAME);
 		transid[num_transportids].protocol_id = MPATH_PROTOCOL_ID_ISCSI;
 		alen = len + 1; /* at least one trailing null */
diff --git a/multipathd/main.c b/multipathd/main.c
index 69cef3c..5dea995 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -664,7 +664,7 @@ fail:
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
-	int retval, ro;
+	int ro, retval = 0;
 
 	ro = uevent_get_disk_ro(uev);
 
@@ -1755,11 +1755,23 @@ daemonize(void)
 	}
 
 	close(STDIN_FILENO);
-	dup(dev_null_fd);
+	if (dup(dev_null_fd) < 0) {
+		fprintf(stderr, "cannot dup /dev/null to stdin : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
 	close(STDOUT_FILENO);
-	dup(dev_null_fd);
+	if (dup(dev_null_fd) < 0) {
+		fprintf(stderr, "cannot dup /dev/null to stdout : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
 	close(STDERR_FILENO);
-	dup(dev_null_fd);
+	if (dup(dev_null_fd) < 0) {
+		fprintf(stderr, "cannot dup /dev/null to stderr : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
 	close(dev_null_fd);
 	daemon_pid = getpid();
 	return 0;
@@ -1783,7 +1795,9 @@ main (int argc, char *argv[])
 	}
 
 	/* make sure we don't lock any path */
-	chdir("/");
+	if (chdir("/") < 0)
+		fprintf(stderr, "can't chdir to root directory : %s\n",
+			strerror(errno));
 	umask(umask(077) | 022);
 
 	conf = alloc_config();
-- 
1.7.7
