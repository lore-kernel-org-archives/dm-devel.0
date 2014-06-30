From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 11/12] make prioritizers use checker_timeout,
	if set
Date: Mon, 30 Jun 2014 00:14:02 -0500
Message-ID: <1404105243-5071-12-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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

The multipath prioritizers can get stuck issuing scsi commands that
don't return quickly, just like the checkers. So if checker_timeout
is set, the prioritizers should should it for their cmd timeouts as
well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.c                   | 7 +++++++
 libmultipath/prio.h                   | 1 +
 libmultipath/prioritizers/alua_rtpg.c | 5 +++--
 libmultipath/prioritizers/emc.c       | 2 +-
 libmultipath/prioritizers/hds.c       | 2 +-
 libmultipath/prioritizers/hp_sw.c     | 2 +-
 libmultipath/prioritizers/ontap.c     | 4 ++--
 libmultipath/prioritizers/rdac.c      | 2 +-
 multipath.conf.annotated              | 5 +++--
 multipath/multipath.conf.5            | 4 ++--
 10 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 05a8cf1..6ee0b9c 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -10,6 +10,13 @@
 
 static LIST_HEAD(prioritizers);
 
+unsigned int get_prio_timeout(unsigned int default_timeout)
+{
+	if (conf->checker_timeout)
+		return conf->checker_timeout * 1000;
+	return default_timeout;
+}
+
 int init_prio (void)
 {
 	if (!add_prio(DEFAULT_PRIO))
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 4eeb216..495688f 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -51,6 +51,7 @@ struct prio {
 	int (*getprio)(struct path *, char *);
 };
 
+unsigned int get_prio_timeout(unsigned int default_timeout);
 int init_prio (void);
 void cleanup_prio (void);
 struct prio * add_prio (char *);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 981ba06..6d04fc1 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -21,6 +21,7 @@
 #define __user
 #include <scsi/sg.h>
 
+#include "../prio.h"
 #include "alua_rtpg.h"
 
 #define SENSE_BUFF_LEN  32
@@ -134,7 +135,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage, void *resp, int resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.sbp			= sense;
 	hdr.mx_sb_len		= sizeof(sense);
-	hdr.timeout		= DEF_TIMEOUT;
+	hdr.timeout		= get_prio_timeout(DEF_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		PRINT_DEBUG("do_inquiry: IOCTL failed!\n");
@@ -253,7 +254,7 @@ do_rtpg(int fd, void* resp, long resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.mx_sb_len		= sizeof(sense);
 	hdr.sbp			= sense;
-	hdr.timeout		= DEF_TIMEOUT;
+	hdr.timeout		= get_prio_timeout(DEF_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0)
 		return -RTPG_RTPG_FAILED;
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 91b3d90..e49809c 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = 60000;
+	io_hdr.timeout = get_prio_timeout(60000);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_emc_log(0, "sending query command failed");
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index f748707..8043b5b 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd)
 	io_hdr.dxferp = inqBuff;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = 2000;	/* TimeOut = 2 seconds */
+	io_hdr.timeout = get_prio_timeout(2000); /* TimeOut = 2 seconds */
 
 	if (ioctl (fd, SG_IO, &io_hdr) < 0) {
 		pp_hds_log(0, "SG_IO error");
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index c24baad..4950cf7 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -46,7 +46,7 @@ int hp_sw_prio(const char *dev, int fd)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = 60000;
+	io_hdr.timeout = get_prio_timeout(60000);
 	io_hdr.pack_id = 0;
  retry:
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 026d45d..5e82a17 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -89,7 +89,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = SG_TIMEOUT;
+	io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
@@ -141,7 +141,7 @@ static int get_proxy(const char *dev, int fd)
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = SG_TIMEOUT;
+	io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "ioctl sending inquiry command failed, "
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index 2bf1443..a210055 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = 60000;
+	io_hdr.timeout = get_prio_timeout(60000);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_rdac_log(0, "sending inquiry command failed");
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 235e130..f158746 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -243,8 +243,9 @@
 #	#
 #	# name    : checker_timeout
 #	# scope   : multipath & multipathd
-#	# desc    : The timeout to use for path checkers that issue scsi
-#	#           commands with an explicit timeout, in seconds.
+#	# desc    : The timeout to use for path checkers and prioritizers
+#	#           that issue scsi commands with an explicit timeout, in
+#	#           seconds.
 #	# values  : n > 0
 #	# default : taken from /sys/block/sd<x>/device/timeout
 #	checker_timeout 60
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1a904e9..195e663 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -330,8 +330,8 @@ maximum number of open fds is taken from the calling process. It is usually
 if that number is greated than 1024.
 .TP
 .B checker_timeout
-Specify the timeout to user for path checkers that issue scsi commands with an
-explicit timeout, in seconds; default taken from
+Specify the timeout to use for path checkers and prioritizers that issue scsi
+commands with an explicit timeout, in seconds; default taken from
 .I /sys/block/sd<x>/device/timeout
 .TP
 .B fast_io_fail_tmo
-- 
1.8.3.1
