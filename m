From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/26] libmultipath: use 'timeout' as argument
	for getprio()
Date: Mon, 20 Jun 2016 10:09:07 +0200
Message-ID: <1466410153-23896-21-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Pass in the 'checker_timeout' as explicit argument when calling
getprio().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c              |  2 +-
 libmultipath/prio.c                   | 16 ++++++------
 libmultipath/prio.h                   |  8 +++---
 libmultipath/prioritizers/alua.c      | 12 ++++-----
 libmultipath/prioritizers/alua_rtpg.c | 25 ++++++++++---------
 libmultipath/prioritizers/alua_rtpg.h |  6 ++---
 libmultipath/prioritizers/emc.c       |  8 +++---
 libmultipath/prioritizers/hds.c       |  8 +++---
 libmultipath/prioritizers/hp_sw.c     | 46 +++++++++++++++++------------------
 libmultipath/prioritizers/ontap.c     | 19 ++++++++-------
 libmultipath/prioritizers/rdac.c      |  8 +++---
 libmultipath/propsel.c                | 11 ++++++---
 12 files changed, 87 insertions(+), 82 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b32c57e..f7d7d1b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1459,7 +1459,7 @@ get_prio (struct path * pp)
 			return 1;
 		}
 	}
-	pp->priority = prio_getprio(p, pp);
+	pp->priority = prio_getprio(p, pp, conf->checker_timeout);
 	if (pp->priority < 0) {
 		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
 		pp->priority = PRIO_UNDEF;
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index c37d1b0..7fce921 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -6,14 +6,14 @@
 
 #include "debug.h"
 #include "prio.h"
-#include "config.h"
 
 static LIST_HEAD(prioritizers);
 
-unsigned int get_prio_timeout(unsigned int default_timeout)
+unsigned int get_prio_timeout(unsigned int checker_timeout,
+			      unsigned int default_timeout)
 {
-	if (conf->checker_timeout)
-		return conf->checker_timeout * 1000;
+	if (checker_timeout)
+		return checker_timeout * 1000;
 	return default_timeout;
 }
 
@@ -67,7 +67,7 @@ void cleanup_prio(void)
 	}
 }
 
-struct prio * prio_lookup (char * name)
+static struct prio * prio_lookup (char * name)
 {
 	struct prio * p;
 
@@ -112,7 +112,7 @@ struct prio * add_prio (char *multipath_dir, char * name)
 				errstr);
 		goto out;
 	}
-	p->getprio = (int (*)(struct path *, char *)) dlsym(p->handle, "getprio");
+	p->getprio = (int (*)(struct path *, char *, unsigned int)) dlsym(p->handle, "getprio");
 	errstr = dlerror();
 	if (errstr != NULL)
 		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
@@ -125,9 +125,9 @@ out:
 	return NULL;
 }
 
-int prio_getprio (struct prio * p, struct path * pp)
+int prio_getprio (struct prio * p, struct path * pp, unsigned int timeout)
 {
-	return p->getprio(pp, p->args);
+	return p->getprio(pp, p->args, timeout);
 }
 
 int prio_selected (struct prio * p)
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index ce72a54..7195986 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -49,15 +49,15 @@ struct prio {
 	struct list_head node;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
-	int (*getprio)(struct path *, char *);
+	int (*getprio)(struct path *, char *, unsigned int);
 };
 
-unsigned int get_prio_timeout(unsigned int default_timeout);
+unsigned int get_prio_timeout(unsigned int checker_timeout,
+			      unsigned int default_timeout);
 int init_prio (char *);
 void cleanup_prio (void);
 struct prio * add_prio (char *, char *);
-struct prio * prio_lookup (char *);
-int prio_getprio (struct prio *, struct path *);
+int prio_getprio (struct prio *, struct path *, unsigned int);
 void prio_get (char *, struct prio *, char *, char *);
 void prio_put (struct prio *);
 int prio_selected (struct prio *);
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 90dfb71..b6c5176 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -51,14 +51,14 @@ static const char *aas_print_string(int rc)
 }
 
 int
-get_alua_info(struct path * pp)
+get_alua_info(struct path * pp, unsigned int timeout)
 {
 	int	rc;
 	int	tpg;
 
-	tpg = get_target_port_group(pp);
+	tpg = get_target_port_group(pp, timeout);
 	if (tpg < 0) {
-		rc = get_target_port_group_support(pp->fd);
+		rc = get_target_port_group_support(pp->fd, timeout);
 		if (rc < 0)
 			return -ALUA_PRIO_TPGS_FAILED;
 		if (rc == TPGS_NONE)
@@ -66,7 +66,7 @@ get_alua_info(struct path * pp)
 		return -ALUA_PRIO_RTPG_FAILED;
 	}
 	condlog(3, "reported target port group is %i", tpg);
-	rc = get_asymmetric_access_state(pp->fd, tpg);
+	rc = get_asymmetric_access_state(pp->fd, tpg, timeout);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
 
@@ -91,7 +91,7 @@ int get_exclusive_perf_arg(char *args)
 	return 1;
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
 	int rc;
 	int aas;
@@ -102,7 +102,7 @@ int getprio (struct path * pp, char * args)
 		return -ALUA_PRIO_NO_INFORMATION;
 
 	exclusive_perf = get_exclusive_perf_arg(args);
-	rc = get_alua_info(pp);
+	rc = get_alua_info(pp, timeout);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 1134fd8..ec8bd22 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -115,7 +115,8 @@ scsi_error(struct sg_io_hdr *hdr)
  * Helper function to setup and run a SCSI inquiry command.
  */
 int
-do_inquiry(int fd, int evpd, unsigned int codepage, void *resp, int resplen)
+do_inquiry(int fd, int evpd, unsigned int codepage,
+	   void *resp, int resplen, unsigned int timeout)
 {
 	struct inquiry_command	cmd;
 	struct sg_io_hdr	hdr;
@@ -139,7 +140,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage, void *resp, int resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.sbp			= sense;
 	hdr.mx_sb_len		= sizeof(sense);
-	hdr.timeout		= get_prio_timeout(SGIO_TIMEOUT);
+	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		PRINT_DEBUG("do_inquiry: IOCTL failed!\n");
@@ -160,13 +161,13 @@ do_inquiry(int fd, int evpd, unsigned int codepage, void *resp, int resplen)
  * data returned by the standard inquiry command.
  */
 int
-get_target_port_group_support(int fd)
+get_target_port_group_support(int fd, unsigned int timeout)
 {
 	struct inquiry_data	inq;
 	int			rc;
 
 	memset((unsigned char *)&inq, 0, sizeof(inq));
-	rc = do_inquiry(fd, 0, 0x00, &inq, sizeof(inq));
+	rc = do_inquiry(fd, 0, 0x00, &inq, sizeof(inq), timeout);
 	if (!rc) {
 		rc = inquiry_data_get_tpgs(&inq);
 	}
@@ -194,7 +195,7 @@ get_sysfs_pg83(struct path *pp, unsigned char *buff, int buflen)
 }
 
 int
-get_target_port_group(struct path * pp)
+get_target_port_group(struct path * pp, unsigned int timeout)
 {
 	unsigned char		*buf;
 	struct vpd83_data *	vpd83;
@@ -215,7 +216,7 @@ get_target_port_group(struct path * pp)
 	rc = get_sysfs_pg83(pp, buf, buflen);
 
 	if (rc < 0) {
-		rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen);
+		rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen, timeout);
 		if (rc < 0)
 			goto out;
 
@@ -233,7 +234,7 @@ get_target_port_group(struct path * pp)
 			}
 			buflen = scsi_buflen;
 			memset(buf, 0, buflen);
-			rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen);
+			rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen, timeout);
 			if (rc < 0)
 				goto out;
 		}
@@ -264,7 +265,7 @@ out:
 }
 
 int
-do_rtpg(int fd, void* resp, long resplen)
+do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
 {
 	struct rtpg_command	cmd;
 	struct sg_io_hdr	hdr;
@@ -285,7 +286,7 @@ do_rtpg(int fd, void* resp, long resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.mx_sb_len		= sizeof(sense);
 	hdr.sbp			= sense;
-	hdr.timeout		= get_prio_timeout(SGIO_TIMEOUT);
+	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0)
 		return -RTPG_RTPG_FAILED;
@@ -300,7 +301,7 @@ do_rtpg(int fd, void* resp, long resplen)
 }
 
 int
-get_asymmetric_access_state(int fd, unsigned int tpg)
+get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 {
 	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
@@ -317,7 +318,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 		return -RTPG_RTPG_FAILED;
 	}
 	memset(buf, 0, buflen);
-	rc = do_rtpg(fd, buf, buflen);
+	rc = do_rtpg(fd, buf, buflen, timeout);
 	if (rc < 0)
 		goto out;
 	scsi_buflen = (buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3]) + 4;
@@ -333,7 +334,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 		}
 		buflen = scsi_buflen;
 		memset(buf, 0, buflen);
-		rc = do_rtpg(fd, buf, buflen);
+		rc = do_rtpg(fd, buf, buflen, timeout);
 		if (rc < 0)
 			goto out;
 	}
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index b1b177a..dc16eb7 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -22,9 +22,9 @@
 #define RTPG_RTPG_FAILED			3
 #define RTPG_TPG_NOT_FOUND			4
 
-int get_target_port_group_support(int fd);
-int get_target_port_group(struct path * pp);
-int get_asymmetric_access_state(int fd, unsigned int tpg);
+int get_target_port_group_support(int fd, unsigned int timeout);
+int get_target_port_group(struct path * pp, unsigned int timeout);
+int get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout);
 
 #endif /* __RTPG_H__ */
 
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index e49809c..58640ec 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -12,7 +12,7 @@
 
 #define pp_emc_log(prio, msg) condlog(prio, "%s: emc prio: " msg, dev)
 
-int emc_clariion_prio(const char *dev, int fd)
+int emc_clariion_prio(const char *dev, int fd, unsigned int timeout)
 {
 	unsigned char sense_buffer[128];
 	unsigned char sb[128];
@@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(60000);
+	io_hdr.timeout = get_prio_timeout(timeout, 60000);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_emc_log(0, "sending query command failed");
@@ -81,7 +81,7 @@ out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
-	return emc_clariion_prio(pp->dev, pp->fd);
+	return emc_clariion_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 5170626..be00e44 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -84,7 +84,7 @@
 #define pp_hds_log(prio, fmt, args...) \
         condlog(prio, "%s: hds prio: " fmt, dev, ##args)
 
-int hds_modular_prio (const char *dev, int fd)
+int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 {
 	int k;
 	char vendor[9];
@@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd)
 	io_hdr.dxferp = inqBuff;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = get_prio_timeout(2000); /* TimeOut = 2 seconds */
+	io_hdr.timeout = get_prio_timeout(timeout, 2000); /* TimeOut = 2 seconds */
 
 	if (ioctl (fd, SG_IO, &io_hdr) < 0) {
 		pp_hds_log(0, "SG_IO error");
@@ -168,7 +168,7 @@ int hds_modular_prio (const char *dev, int fd)
 	return -1;
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
-	return hds_modular_prio(pp->dev, pp->fd);
+	return hds_modular_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 4950cf7..9fbb1ff 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -30,11 +30,11 @@
 #define HP_PATH_FAILED		0x00
 
 #define pp_hp_sw_log(prio, fmt, args...) \
-        condlog(prio, "%s: hp_sw prio: " fmt, dev, ##args)
+	condlog(prio, "%s: hp_sw prio: " fmt, dev, ##args)
 
-int hp_sw_prio(const char *dev, int fd)
+int hp_sw_prio(const char *dev, int fd, unsigned int timeout)
 {
-        unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
+	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
 	unsigned char sb[128];
 	struct sg_io_hdr io_hdr;
 	int ret = HP_PATH_FAILED;
@@ -46,37 +46,37 @@ int hp_sw_prio(const char *dev, int fd)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(60000);
+	io_hdr.timeout = get_prio_timeout(timeout, 60000);
 	io_hdr.pack_id = 0;
  retry:
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_hp_sw_log(0, "sending tur command failed");
 		goto out;
 	}
-        io_hdr.status &= 0x7e;
-        if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
-            (0 == io_hdr.driver_status)) {
+	io_hdr.status &= 0x7e;
+	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
+	    (0 == io_hdr.driver_status)) {
 		/* Command completed normally, path is active */
-                ret = HP_PATH_ACTIVE;
+		ret = HP_PATH_ACTIVE;
 	}
 
-        if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
-            (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
-            (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
-                if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
-                        int sense_key, asc, asq;
-                        unsigned char * sense_buffer = io_hdr.sbp;
-                        if (sense_buffer[0] & 0x2) {
-                                sense_key = sense_buffer[1] & 0xf;
+	if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
+	    (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
+	    (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
+		if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+			int sense_key, asc, asq;
+			unsigned char * sense_buffer = io_hdr.sbp;
+			if (sense_buffer[0] & 0x2) {
+				sense_key = sense_buffer[1] & 0xf;
 				asc = sense_buffer[2];
 				asq = sense_buffer[3];
 			} else {
-                                sense_key = sense_buffer[2] & 0xf;
+				sense_key = sense_buffer[2] & 0xf;
 				asc = sense_buffer[12];
 				asq = sense_buffer[13];
 			}
-                        if(RECOVERED_ERROR == sense_key)
-                                ret = HP_PATH_ACTIVE;
+			if(RECOVERED_ERROR == sense_key)
+				ret = HP_PATH_ACTIVE;
 			if(NOT_READY == sense_key) {
 				if (asc == 0x04 && asq == 0x02) {
 					/* This is a standby path */
@@ -89,13 +89,13 @@ int hp_sw_prio(const char *dev, int fd)
 					goto retry;
 				}
 			}
-                }
-        }
+		}
+	}
 out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
-	return hp_sw_prio(pp->dev, pp->fd);
+	return hp_sw_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 5e82a17..d6872fe 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -71,7 +71,8 @@ static void process_sg_error(struct sg_io_hdr *io_hdr)
  *  0: success
  */
 static int send_gva(const char *dev, int fd, unsigned char pg,
-		    unsigned char *results, int *results_size)
+		    unsigned char *results, int *results_size,
+		    unsigned int timeout)
 {
 	unsigned char sb[128];
 	unsigned char cdb[10] = {0xc0, 0, 0x1, 0xa, 0x98, 0xa,
@@ -89,7 +90,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
+	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
@@ -122,7 +123,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
  *  0: Device _not_ proxy path
  *  1: Device _is_ proxy path
  */
-static int get_proxy(const char *dev, int fd)
+static int get_proxy(const char *dev, int fd, unsigned int timeout)
 {
 	unsigned char results[256];
 	unsigned char sb[128];
@@ -141,7 +142,7 @@ static int get_proxy(const char *dev, int fd)
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
+	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "ioctl sending inquiry command failed, "
@@ -182,7 +183,7 @@ static int get_proxy(const char *dev, int fd)
  * 2: iSCSI software
  * 1: FCP proxy
  */
-static int ontap_prio(const char *dev, int fd)
+static int ontap_prio(const char *dev, int fd, unsigned int timeout)
 {
 	unsigned char results[RESULTS_MAX];
 	int results_size=RESULTS_MAX;
@@ -195,7 +196,7 @@ static int ontap_prio(const char *dev, int fd)
 	is_iscsi_software = is_iscsi_hardware = is_proxy = 0;
 
 	memset(&results, 0, sizeof (results));
-	rc = send_gva(dev, fd, 0x41, results, &results_size);
+	rc = send_gva(dev, fd, 0x41, results, &results_size, timeout);
 	if (rc >= 0) {
 		tot_len = results[0] << 24 | results[1] << 16 |
 			  results[2] << 8 | results[3];
@@ -221,7 +222,7 @@ static int ontap_prio(const char *dev, int fd)
 	}
 
  try_fcp_proxy:
-	rc = get_proxy(dev, fd);
+	rc = get_proxy(dev, fd, timeout);
 	if (rc >= 0) {
 		is_proxy = rc;
 	}
@@ -241,7 +242,7 @@ static int ontap_prio(const char *dev, int fd)
 	}
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
-	return ontap_prio(pp->dev, pp->fd);
+	return ontap_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index a210055..bbd73bd 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -12,7 +12,7 @@
 
 #define pp_rdac_log(prio, msg) condlog(prio, "%s: rdac prio: " msg, dev)
 
-int rdac_prio(const char *dev, int fd)
+int rdac_prio(const char *dev, int fd, unsigned int timeout)
 {
 	unsigned char sense_buffer[128];
 	unsigned char sb[128];
@@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(60000);
+	io_hdr.timeout = get_prio_timeout(timeout, 60000);
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_rdac_log(0, "sending inquiry command failed");
@@ -91,7 +91,7 @@ out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args)
+int getprio (struct path * pp, char * args, unsigned int timeout)
 {
-	return rdac_prio(pp->dev, pp->fd);
+	return rdac_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a97e80f..8932e1d 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -374,14 +374,15 @@ detect_prio(struct path * pp)
 	int ret;
 	struct prio *p = &pp->prio;
 	int tpgs = 0;
+	unsigned int timeout = conf->checker_timeout;
 
-	if ((tpgs = get_target_port_group_support(pp->fd)) <= 0)
+	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
 		return;
 	pp->tpgs = tpgs;
-	ret = get_target_port_group(pp);
+	ret = get_target_port_group(pp, timeout);
 	if (ret < 0)
 		return;
-	if (get_asymmetric_access_state(pp->fd, ret) < 0)
+	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
 		return;
 	prio_get(conf->multipath_dir, p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
@@ -422,8 +423,10 @@ out:
 	 */
 	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
 		int tpgs = 0;
+		unsigned int timeout = conf->checker_timeout;
+
 		if(!pp->tpgs &&
-		   (tpgs = get_target_port_group_support(pp->fd)) >= 0)
+		   (tpgs = get_target_port_group_support(pp->fd, timeout)) >= 0)
 			pp->tpgs = tpgs;
 	}
 	condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
-- 
2.6.6
