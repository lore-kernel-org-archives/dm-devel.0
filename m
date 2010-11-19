From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add checker_timeout default config
	option
Date: Thu, 18 Nov 2010 22:34:11 -0600
Message-ID: <20101119043411.GC13763@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Due to errors with some storage arrays, occasionally a scsi request will get
competely dropped. When this happens, fast_io_fail_tmo and dev_loss_tmo don't
get triggered, and a sychronous checker function might have to wait for the
full timeout.  Right now those timeouts are hard-coded to 5 minutes.  This
patch changes them to use the scsi cmd timeout,
/sys/block/sd<x>/device/timeout, by default.  This can be overridden by the new
default config parameter, checker_timeout, so that user can manually set
an upper bound on how long a sychronous checker might be blocked, without
modifying the generic scsi cmd timeout.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.h              |   15 +--------------
 libmultipath/checkers/emc_clariion.c |    4 ++--
 libmultipath/checkers/hp_sw.c        |   12 ++++++------
 libmultipath/checkers/libsg.c        |    5 +++--
 libmultipath/checkers/libsg.h        |    3 ++-
 libmultipath/checkers/rdac.c         |    9 +++++----
 libmultipath/checkers/readsector0.c  |    2 +-
 libmultipath/checkers/tur.c          |    2 +-
 libmultipath/config.h                |    1 +
 libmultipath/dict.c                  |   29 +++++++++++++++++++++++++++++
 libmultipath/discovery.c             |   27 +++++++++++++++++++++++++++
 libmultipath/discovery.h             |    1 +
 libmultipath/propsel.c               |   19 +++++++++++++++++--
 multipath.conf.annotated             |    9 +++++++++
 multipath/multipath.conf.5           |    5 +++++
 15 files changed, 110 insertions(+), 33 deletions(-)

Index: multipath-tools-101104/libmultipath/checkers.h
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers.h
+++ multipath-tools-101104/libmultipath/checkers.h
@@ -68,20 +68,6 @@ enum path_check_state {
 
 #define DEFAULT_CHECKER DIRECTIO
 
-/*
- * Overloaded storage response time can be very long.
- * SG_IO timouts after DEF_TIMEOUT milliseconds, and checkers interprets this
- * as a path failure. multipathd then proactively evicts the path from the DM
- * multipath table in this case.
- *
- * This generaly snow balls and ends up in full eviction and IO errors for end
- * users. Bad. This may also cause SCSI bus resets, causing disruption for all
- * local and external storage hardware users.
- * 
- * Provision a long timeout. Longer than any real-world application would cope
- * with.
- */
-#define DEF_TIMEOUT		300000
 #define ASYNC_TIMEOUT_SEC	30
 
 /*
@@ -96,6 +82,7 @@ struct checker {
 	struct list_head node;
 	int fd;
 	int sync;
+	unsigned int timeout;
 	int disable;
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
Index: multipath-tools-101104/libmultipath/checkers/emc_clariion.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/emc_clariion.c
+++ multipath-tools-101104/libmultipath/checkers/emc_clariion.c
@@ -113,7 +113,7 @@ int libcheck_check (struct checker * c)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = c->timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, "emc_clariion_checker: sending query command failed");
@@ -182,7 +182,7 @@ int libcheck_check (struct checker * c)
 		unsigned char buf[4096];
 
 		memset(buf, 0, 4096);
-		ret = sg_read(c->fd, &buf[0], sbb = &sb[0]);
+		ret = sg_read(c->fd, &buf[0], sbb = &sb[0], c->timeout);
 		if (ret == PATH_DOWN) {
 			hexadecimal_to_ascii(ct->wwn, wwnstr);
 
Index: multipath-tools-101104/libmultipath/checkers/hp_sw.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/hp_sw.c
+++ multipath-tools-101104/libmultipath/checkers/hp_sw.c
@@ -46,7 +46,7 @@ void libcheck_free (struct checker * c)
 
 static int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
-       void *resp, int mx_resp_len, int noisy)
+       void *resp, int mx_resp_len, int noisy, unsigned int timeout)
 {
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] =
 		{ INQUIRY_CMD, 0, 0, 0, 0, 0 };
@@ -70,7 +70,7 @@ do_inq(int sg_fd, int cmddt, int evpd, u
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
@@ -98,7 +98,7 @@ do_inq(int sg_fd, int cmddt, int evpd, u
 }
 
 static int
-do_tur (int fd)
+do_tur (int fd, unsigned int timeout)
 {
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
 	struct sg_io_hdr io_hdr;
@@ -111,7 +111,7 @@ do_tur (int fd)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 
 	if (ioctl(fd, SG_IO, &io_hdr) < 0)
@@ -128,12 +128,12 @@ libcheck_check (struct checker * c)
 {
 	char buff[MX_ALLOC_LEN];
 
-	if (0 != do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0)) {
+	if (0 != do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0, c->timeout)) {
 		MSG(c, MSG_HP_SW_DOWN);
 		return PATH_DOWN;
 	}
 
-	if (do_tur(c->fd)) {
+	if (do_tur(c->fd, c->timeout)) {
 		MSG(c, MSG_HP_SW_GHOST);
 		return PATH_GHOST;
 	}
Index: multipath-tools-101104/libmultipath/checkers/libsg.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/libsg.c
+++ multipath-tools-101104/libmultipath/checkers/libsg.c
@@ -11,7 +11,8 @@
 #include "../libmultipath/sg_include.h"
 
 int
-sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff)
+sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff,
+	 unsigned int timeout)
 {
 	/* defaults */
 	int blocks = 1;
@@ -51,7 +52,7 @@ sg_read (int sg_fd, unsigned char * buff
 	io_hdr.dxferp = buff;
 	io_hdr.mx_sb_len = SENSE_BUFF_LEN;
 	io_hdr.sbp = senseBuff;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = (int)start_block;
 	if (diop && *diop)
 	io_hdr.flags |= SG_FLAG_DIRECT_IO;
Index: multipath-tools-101104/libmultipath/checkers/libsg.h
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/libsg.h
+++ multipath-tools-101104/libmultipath/checkers/libsg.h
@@ -3,6 +3,7 @@
 
 #define SENSE_BUFF_LEN 32
 
-int sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff);
+int sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff,
+	     unsigned int timeout);
 
 #endif /* _LIBSG_H */
Index: multipath-tools-101104/libmultipath/checkers/rdac.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/rdac.c
+++ multipath-tools-101104/libmultipath/checkers/rdac.c
@@ -18,7 +18,6 @@
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
 #define SENSE_BUFF_LEN		32
-#define RDAC_DEF_TIMEOUT	60000
 #define SCSI_CHECK_CONDITION	0x2
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
@@ -43,7 +42,8 @@ void libcheck_free (struct checker * c)
 }
 
 static int
-do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len)
+do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len,
+       unsigned int timeout)
 {
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = { INQUIRY_CMD, 1, 0, 0, 0, 0 };
 	unsigned char sense_b[SENSE_BUFF_LEN];
@@ -62,7 +62,7 @@ do_inq(int sg_fd, unsigned int pg_op, vo
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = RDAC_DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
@@ -104,7 +104,8 @@ libcheck_check (struct checker * c)
 	int ret;
 
 	memset(&inq, 0, sizeof(struct volume_access_inq));
-	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
+	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
+			c->timeout)) {
 		ret = PATH_DOWN;
 		goto done;
 	} else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
Index: multipath-tools-101104/libmultipath/checkers/readsector0.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/readsector0.c
+++ multipath-tools-101104/libmultipath/checkers/readsector0.c
@@ -29,7 +29,7 @@ int libcheck_check (struct checker * c)
 	unsigned char sbuf[SENSE_BUFF_LEN];
 	int ret;
 
-	ret = sg_read(c->fd, &buf[0], &sbuf[0]);
+	ret = sg_read(c->fd, &buf[0], &sbuf[0], c->timeout);
 
 	switch (ret)
 	{
Index: multipath-tools-101104/libmultipath/checkers/tur.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/checkers/tur.c
+++ multipath-tools-101104/libmultipath/checkers/tur.c
@@ -55,7 +55,7 @@ libcheck_check (struct checker * c)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = c->timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, MSG_TUR_DOWN);
Index: multipath-tools-101104/libmultipath/config.h
===================================================================
--- multipath-tools-101104.orig/libmultipath/config.h
+++ multipath-tools-101104/libmultipath/config.h
@@ -79,6 +79,7 @@ struct config {
 	int max_fds;
 	int force_reload;
 	int queue_without_daemon;
+	int checker_timeout;
 	int daemon;
 	int flush_on_last_del;
 	int attribute_flags;
Index: multipath-tools-101104/libmultipath/dict.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/dict.c
+++ multipath-tools-101104/libmultipath/dict.c
@@ -406,6 +406,25 @@ def_queue_without_daemon(vector strvec)
 }
 
 static int
+def_checker_timeout_handler(vector strvec)
+{
+	unsigned int checker_timeout;
+	char *buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (sscanf(buff, "%u", &checker_timeout) == 1)
+		conf->checker_timeout = checker_timeout;
+	else
+		conf->checker_timeout = 0;
+
+	free(buff);
+	return 0;
+}
+
+static int
 def_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -2097,6 +2116,15 @@ snprint_def_queue_without_daemon (char *
 }
 
 static int
+snprint_def_checker_timeout (char *buff, int len, void *data)
+{
+	if (!conf->checker_timeout)
+		return 0;
+
+	return snprintf(buff, len, "%u", conf->checker_timeout);
+}
+
+static int
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
 	if (conf->pg_timeout == DEFAULT_PGTIMEOUT)
@@ -2207,6 +2235,7 @@ init_keywords(void)
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
+	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
Index: multipath-tools-101104/libmultipath/discovery.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/discovery.c
+++ multipath-tools-101104/libmultipath/discovery.c
@@ -165,6 +165,31 @@ sysfs_get_dev (struct sysfs_device * dev
 }
 
 int
+sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout)
+{
+	char *attr;
+	char attr_path[SYSFS_PATH_SIZE];
+	int r;
+	unsigned int t;
+
+	if (safe_sprintf(attr_path, "%s/device", dev->devpath))
+		return 1;
+
+	attr = sysfs_attr_get_value(dev->devpath, "timeout");
+	if (!attr)
+		return 1;
+
+	r = sscanf(attr, "%u\n", &t);
+
+	if (r != 1)
+		return 1;
+
+	*timeout = t * 1000;
+
+	return 0;
+}
+
+int
 sysfs_get_size (struct sysfs_device * dev, unsigned long long * size)
 {
 	char *attr;
@@ -813,6 +838,8 @@ get_state (struct path * pp, int daemon)
 	}
 	if (daemon)
 		checker_set_async(c);
+	if (!conf->checker_timeout)
+		sysfs_get_timeout(pp->sysdev, &(c->timeout));
 	state = checker_check(c);
 	condlog(3, "%s: state = %i", pp->dev, state);
 	if (state == PATH_DOWN && strlen(checker_message(c)))
Index: multipath-tools-101104/libmultipath/propsel.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/propsel.c
+++ multipath-tools-101104/libmultipath/propsel.c
@@ -16,6 +16,7 @@
 #include "defaults.h"
 #include "devmapper.h"
 #include "prio.h"
+#include "discovery.h"
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -307,17 +308,31 @@ select_checker(struct path *pp)
 		checker_get(c, pp->hwe->checker_name);
 		condlog(3, "%s: path checker = %s (controller setting)",
 			pp->dev, checker_name(c));
-		return 0;
+		goto out;
 	}
 	if (conf->checker_name) {
 		checker_get(c, conf->checker_name);
 		condlog(3, "%s: path checker = %s (config file default)",
 			pp->dev, checker_name(c));
-		return 0;
+		goto out;
 	}
 	checker_get(c, DEFAULT_CHECKER);
 	condlog(3, "%s: path checker = %s (internal default)",
 		pp->dev, checker_name(c));
+out:
+	if (conf->checker_timeout) {
+		c->timeout = conf->checker_timeout * 1000;
+		condlog(3, "%s: checker timeout = %u ms (config file default)",
+				pp->dev, c->timeout);
+	}
+	else if (sysfs_get_timeout(pp->sysdev, &c->timeout) == 0)
+		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
+				pp->dev, c->timeout);
+	else {
+		c->timeout = DEF_TIMEOUT;
+		condlog(3, "%s: checker timeout = %u ms (internal default)",
+				pp->dev, c->timeout);
+	}
 	return 0;
 }
 
Index: multipath-tools-101104/multipath.conf.annotated
===================================================================
--- multipath-tools-101104.orig/multipath.conf.annotated
+++ multipath-tools-101104/multipath.conf.annotated
@@ -211,6 +211,15 @@
 #	gid disk
 #
 #	#
+#	# name    : checker_timeout
+#	# scope   : multipath & multipathd
+#	# desc    : The timeout to use for path checkers that issue scsi
+#	#           commands with an explicit timeout, in seconds.
+#	# values  : n > 0
+#	# default : taken from /sys/block/sd<x>/device/timeout
+#	checker_timeout 60
+#
+#	#
 #	# name    : fast_io_fail_tmo
 #	# scope   : multipath & multipathd
 #	# desc    : The number of seconds the scsi layer will wait after a
Index: multipath-tools-101104/libmultipath/discovery.h
===================================================================
--- multipath-tools-101104.orig/libmultipath/discovery.h
+++ multipath-tools-101104/libmultipath/discovery.h
@@ -35,6 +35,7 @@ int pathinfo (struct path *, vector hwta
 struct path * store_pathinfo (vector pathvec, vector hwtable,
 			      char * devname, int flag);
 int sysfs_set_scsi_tmo (struct multipath *mpp);
+int sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout);
 
 /*
  * discovery bitmask
Index: multipath-tools-101104/multipath/multipath.conf.5
===================================================================
--- multipath-tools-101104.orig/multipath/multipath.conf.5
+++ multipath-tools-101104/multipath/multipath.conf.5
@@ -261,6 +261,11 @@ maximum number of open fds is taken from
 1024. To be safe, this should be set to the maximum number of paths plus 32,
 if that number is greated than 1024.
 .TP
+.B checker_timeout
+Specify the timeout to user for path checkers that issue scsi commands with an
+explict timeout, in seconds; default taken from
+.I /sys/block/sd<x>/device/timeout
+.TP
 .B fast_io_fail_tmo
 Specify the number of seconds the scsi layer will wait after a problem has been
 detected on a FC remote port before failing IO to devices on that remote port.
