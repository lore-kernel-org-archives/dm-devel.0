From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/checkers.h libchec ...
Date: 27 Jan 2010 16:46:51 -0000
Message-ID: <20100127164651.18344.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-01-27 16:46:49

Modified files:
	libcheckers    : checkers.h emc_clariion.c hp_sw.c rdac.c 
	                 readsector0.c tur.c 
	libmultipath   : config.h dict.c discovery.c discovery.h 
	                 propsel.c 

Log message:
	Fix for bz #553042.  Add a new config file parameter checker_timeout. If this
	is not set, the path checkers that call scsi commands that need explicit
	timeouts will pull their timeout from /sys/block/sd<x>/device/timeout.  If
	this is set, the commands will use this value for their timeout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.4&r2=1.5.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/emc_clariion.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.1&r2=1.6.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/hp_sw.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/rdac.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.4&r2=1.1.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/readsector0.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.4&r2=1.4.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.8&r2=1.18.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.11&r2=1.17.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.10&r2=1.32.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14.2.2&r2=1.14.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.3&r2=1.11.2.4

--- multipath-tools/libcheckers/checkers.h	2009/11/24 20:03:16	1.5.2.4
+++ multipath-tools/libcheckers/checkers.h	2010/01/27 16:46:48	1.5.2.5
@@ -24,21 +24,6 @@
 #define DEFAULT_CHECKER READSECTOR0
 
 /*
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
-#define DEF_TIMEOUT	300000
-
-/*
  * strings lengths
  */
 #define CHECKER_NAME_LEN 16
@@ -49,6 +34,7 @@
 struct checker {
 	int fd;
 	int sync;
+	unsigned int timeout;
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	char wwid[WWID_SIZE];                /* LUN wwid */
--- multipath-tools/libcheckers/emc_clariion.c	2007/04/16 18:32:52	1.6.2.1
+++ multipath-tools/libcheckers/emc_clariion.c	2010/01/27 16:46:48	1.6.2.2
@@ -57,7 +57,7 @@
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = c->timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, "emc_clariion_checker: sending query command failed");
--- multipath-tools/libcheckers/hp_sw.c	2006/07/13 19:49:22	1.4
+++ multipath-tools/libcheckers/hp_sw.c	2010/01/27 16:46:48	1.4.2.1
@@ -46,7 +46,7 @@
 
 static int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
-       void *resp, int mx_resp_len, int noisy)
+       void *resp, int mx_resp_len, int noisy, unsigned int timeout)
 {
         unsigned char inqCmdBlk[INQUIRY_CMDLEN] =
             { INQUIRY_CMD, 0, 0, 0, 0, 0 };
@@ -69,7 +69,7 @@
         io_hdr.dxferp = resp;
         io_hdr.cmdp = inqCmdBlk;
         io_hdr.sbp = sense_b;
-        io_hdr.timeout = DEF_TIMEOUT;
+        io_hdr.timeout = timeout;
  
         if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
                 return 1;
@@ -97,7 +97,7 @@
 }
 
 static int
-do_tur (int fd)
+do_tur (int fd, unsigned int timeout)
 {
         unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
         struct sg_io_hdr io_hdr;
@@ -110,7 +110,7 @@
         io_hdr.dxfer_direction = SG_DXFER_NONE;
         io_hdr.cmdp = turCmdBlk;
         io_hdr.sbp = sense_buffer;
-        io_hdr.timeout = DEF_TIMEOUT;
+        io_hdr.timeout = timeout;
         io_hdr.pack_id = 0;
 
         if (ioctl(fd, SG_IO, &io_hdr) < 0)
@@ -127,12 +127,12 @@
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
--- multipath-tools/libcheckers/Attic/rdac.c	2009/11/04 20:21:43	1.1.2.4
+++ multipath-tools/libcheckers/Attic/rdac.c	2010/01/27 16:46:48	1.1.2.5
@@ -18,7 +18,6 @@
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
 #define SENSE_BUFF_LEN		32
-#define RDAC_DEF_TIMEOUT	60000
 #define SCSI_CHECK_CONDITION	0x2
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
@@ -43,7 +42,8 @@
 }
 
 static int
-do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len)
+do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len,
+       unsigned int timeout)
 {
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = { INQUIRY_CMD, 1, 0, 0, 0, 0 };
 	unsigned char sense_b[SENSE_BUFF_LEN];
@@ -61,7 +61,7 @@
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = RDAC_DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
@@ -101,7 +101,8 @@
 {
 	struct volume_access_inq inq;
 
-	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
+	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
+			c->timeout)) {
 		MSG(c, MSG_RDAC_DOWN);
 		return PATH_DOWN;
 	} else {
--- multipath-tools/libcheckers/readsector0.c	2009/09/11 14:33:28	1.5.2.1
+++ multipath-tools/libcheckers/readsector0.c	2010/01/27 16:46:48	1.5.2.2
@@ -36,7 +36,7 @@
 }
 
 static int
-sg_read (int sg_fd, unsigned char * buff)
+sg_read (int sg_fd, unsigned char * buff, unsigned int timeout)
 {
 	/* defaults */
 	int blocks = 1;
@@ -72,7 +72,7 @@
 	io_hdr.dxferp = buff;
 	io_hdr.mx_sb_len = SENSE_BUFF_LEN;
 	io_hdr.sbp = senseBuff;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = (int)start_block;
 	if (diop && *diop)
 	io_hdr.flags |= SG_FLAG_DIRECT_IO;
@@ -121,7 +121,7 @@
 	unsigned char buf[512];
 	int ret;
 
-	ret = sg_read(c->fd, &buf[0]);
+	ret = sg_read(c->fd, &buf[0], c->timeout);
 
 	switch (ret)
 	{
--- multipath-tools/libcheckers/tur.c	2009/11/24 20:03:16	1.4.2.4
+++ multipath-tools/libcheckers/tur.c	2010/01/27 16:46:48	1.4.2.5
@@ -173,7 +173,7 @@
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = c->timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, MSG_TUR_DOWN);
--- multipath-tools/libmultipath/config.h	2009/05/15 21:01:26	1.18.2.8
+++ multipath-tools/libmultipath/config.h	2010/01/27 16:46:48	1.18.2.9
@@ -77,6 +77,7 @@
 	int attribute_flags;
 	int flush_on_last_del;
 	int queue_without_daemon;
+	int checker_timeout;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2009/05/15 21:01:26	1.17.2.11
+++ multipath-tools/libmultipath/dict.c	2010/01/27 16:46:48	1.17.2.12
@@ -350,6 +350,25 @@
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
@@ -1919,6 +1938,15 @@
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
@@ -2005,6 +2033,7 @@
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("queue_without_daemon", &def_queue_without_daemon, &snprint_def_queue_without_daemon);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
+	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
--- multipath-tools/libmultipath/discovery.c	2009/12/04 21:19:51	1.32.2.10
+++ multipath-tools/libmultipath/discovery.c	2010/01/27 16:46:48	1.32.2.11
@@ -238,6 +238,37 @@
 declare_sysfs_get_str(state, "%s/block/%s/device/state", 0);
 
 int
+sysfs_get_timeout (char * sysfs_path, char * dev, unsigned int *timeout)
+{
+	struct sysfs_attribute * attr;
+	char attr_path[SYSFS_PATH_SIZE];
+	int r;
+
+	if (safe_sprintf(attr_path, "%s/block/%s/device/timeout", sysfs_path,
+			 dev))
+		return 1;
+
+	attr = sysfs_open_attribute(attr_path);
+
+	if (!attr)
+		return 1;
+
+	if (0 > sysfs_read_attribute(attr))
+		goto out;
+
+	r = sscanf(attr->value, "%u\n", timeout);
+	sysfs_close_attribute(attr);
+
+	if (r != 1)
+		return 1;
+
+	return 0;
+out:
+	sysfs_close_attribute(attr);
+	return 1;
+}
+
+int
 sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
 {
 	struct sysfs_attribute * attr;
--- multipath-tools/libmultipath/discovery.h	2009/04/21 00:05:23	1.14.2.2
+++ multipath-tools/libmultipath/discovery.h	2010/01/27 16:46:48	1.14.2.3
@@ -32,6 +32,7 @@
 int sysfs_get_bustype (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_state (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
+int sysfs_get_timeout (char * sysfs_path, char * dev, unsigned int *timeout);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 void basename (char *, char *);
--- multipath-tools/libmultipath/propsel.c	2009/05/15 21:01:26	1.11.2.3
+++ multipath-tools/libmultipath/propsel.c	2010/01/27 16:46:48	1.11.2.4
@@ -16,6 +16,7 @@
 #include "alias.h"
 #include "defaults.h"
 #include "devmapper.h"
+#include "discovery.h"
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -221,17 +222,31 @@
 		checker_get(c, pp->hwe->checker);
 		condlog(3, "%s: path checker = %s (controller setting)",
 			pp->dev, checker_name(c));
-		return 0;
+		goto out;
 	}
 	if (conf->checker) {
 		checker_get(c, conf->checker);
 		condlog(3, "%s: path checker = %s (config file default)",
 			pp->dev, checker_name(c));
-		return 0;
+		goto out;
 	}
 	checker_get(c, checker_default());
 	condlog(3, "%s: path checker = %s (internal default)",
 		pp->dev, checker_name(c));
+out:
+	if (conf->checker_timeout) {
+		c->timeout = conf->checker_timeout;
+		condlog(3, "%s: checker timeout = %u (config file default)",
+			pp->dev, c->timeout);
+	}
+	else if (sysfs_get_timeout(sysfs_path, pp->dev, &c->timeout) == 0)
+		condlog(3, "%s: checker timeout = %u (sysfs setting)",
+			pp->dev, c->timeout);
+	else {
+		c->timeout = DEF_TIMEOUT;
+		condlog(3, "%s: checker timeout = %u (internal default)",
+			pp->dev, c->timeout);
+	}
 	return 0;
 }
 
