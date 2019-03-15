From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/9] libmultipath: alua: make API more
	consistent
Date: Fri, 15 Mar 2019 18:19:23 +0100
Message-ID: <20190315171930.28335-3-mwilck@suse.com>
References: <20190315171930.28335-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315171930.28335-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Let all alua functions take "const struct path *" as first
argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c              |  4 ++--
 libmultipath/prioritizers/alua.c      |  4 ++--
 libmultipath/prioritizers/alua_rtpg.c | 28 +++++++++++++++++----------
 libmultipath/prioritizers/alua_rtpg.h |  7 ++++---
 libmultipath/propsel.c                |  2 +-
 5 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 65d651d4..6b4a420b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -839,12 +839,12 @@ detect_alua(struct path * pp, struct config *conf)
 	int tpgs;
 	unsigned int timeout = conf->checker_timeout;
 
-	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0) {
+	if ((tpgs = get_target_port_group_support(pp, timeout)) <= 0) {
 		pp->tpgs = TPGS_NONE;
 		return;
 	}
 	ret = get_target_port_group(pp, timeout);
-	if (ret < 0 || get_asymmetric_access_state(pp->fd, ret, timeout) < 0) {
+	if (ret < 0 || get_asymmetric_access_state(pp, ret, timeout) < 0) {
 		pp->tpgs = TPGS_NONE;
 		return;
 	}
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index b24e2d48..0ab06e2b 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -58,7 +58,7 @@ get_alua_info(struct path * pp, unsigned int timeout)
 
 	tpg = get_target_port_group(pp, timeout);
 	if (tpg < 0) {
-		rc = get_target_port_group_support(pp->fd, timeout);
+		rc = get_target_port_group_support(pp, timeout);
 		if (rc < 0)
 			return -ALUA_PRIO_TPGS_FAILED;
 		if (rc == TPGS_NONE)
@@ -66,7 +66,7 @@ get_alua_info(struct path * pp, unsigned int timeout)
 		return -ALUA_PRIO_RTPG_FAILED;
 	}
 	condlog(3, "%s: reported target port group is %i", pp->dev, tpg);
-	rc = get_asymmetric_access_state(pp->fd, tpg, timeout);
+	rc = get_asymmetric_access_state(pp, tpg, timeout);
 	if (rc < 0) {
 		condlog(2, "%s: get_asymmetric_access_state returned %d",
 			__func__, rc);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 811ce7a2..d9215a88 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -135,9 +135,9 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
 /*
  * Helper function to setup and run a SCSI inquiry command.
  */
-int
-do_inquiry(int fd, int evpd, unsigned int codepage,
-	   void *resp, int resplen, unsigned int timeout)
+static int
+do_inquiry_sg(int fd, int evpd, unsigned int codepage,
+	      void *resp, int resplen, unsigned int timeout)
 {
 	struct inquiry_command	cmd;
 	struct sg_io_hdr	hdr;
@@ -185,18 +185,24 @@ retry:
 	return 0;
 }
 
+int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
+	       void *resp, int resplen, unsigned int timeout)
+{
+	return do_inquiry_sg(pp->fd, evpd, codepage, resp, resplen, timeout);
+}
+
 /*
  * This function returns the support for target port groups by evaluating the
  * data returned by the standard inquiry command.
  */
 int
-get_target_port_group_support(int fd, unsigned int timeout)
+get_target_port_group_support(const struct path *pp, unsigned int timeout)
 {
 	struct inquiry_data	inq;
 	int			rc;
 
 	memset((unsigned char *)&inq, 0, sizeof(inq));
-	rc = do_inquiry(fd, 0, 0x00, &inq, sizeof(inq), timeout);
+	rc = do_inquiry(pp, 0, 0x00, &inq, sizeof(inq), timeout);
 	if (!rc) {
 		rc = inquiry_data_get_tpgs(&inq);
 	}
@@ -205,7 +211,7 @@ get_target_port_group_support(int fd, unsigned int timeout)
 }
 
 static int
-get_sysfs_pg83(struct path *pp, unsigned char *buff, int buflen)
+get_sysfs_pg83(const struct path *pp, unsigned char *buff, int buflen)
 {
 	struct udev_device *parent = pp->udev;
 
@@ -224,7 +230,7 @@ get_sysfs_pg83(struct path *pp, unsigned char *buff, int buflen)
 }
 
 int
-get_target_port_group(struct path * pp, unsigned int timeout)
+get_target_port_group(const struct path * pp, unsigned int timeout)
 {
 	unsigned char		*buf;
 	struct vpd83_data *	vpd83;
@@ -245,7 +251,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
 	rc = get_sysfs_pg83(pp, buf, buflen);
 
 	if (rc < 0) {
-		rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen, timeout);
+		rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
 		if (rc < 0)
 			goto out;
 
@@ -263,7 +269,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
 			}
 			buflen = scsi_buflen;
 			memset(buf, 0, buflen);
-			rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen, timeout);
+			rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
 			if (rc < 0)
 				goto out;
 		}
@@ -341,7 +347,8 @@ retry:
 }
 
 int
-get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
+get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
+			    unsigned int timeout)
 {
 	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
@@ -349,6 +356,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 	int			rc;
 	int			buflen;
 	uint64_t		scsi_buflen;
+	int fd = pp->fd;
 
 	buflen = 4096;
 	buf = (unsigned char *)malloc(buflen);
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index 35cffaf3..675709ff 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -22,8 +22,9 @@
 #define RTPG_RTPG_FAILED			3
 #define RTPG_TPG_NOT_FOUND			4
 
-int get_target_port_group_support(int fd, unsigned int timeout);
-int get_target_port_group(struct path * pp, unsigned int timeout);
-int get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout);
+int get_target_port_group_support(const struct path *pp, unsigned int timeout);
+int get_target_port_group(const struct path *pp, unsigned int timeout);
+int get_asymmetric_access_state(const struct path *pp,
+				unsigned int tpg, unsigned int timeout);
 
 #endif /* __RTPG_H__ */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 98068f34..624dc6ef 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -632,7 +632,7 @@ out:
 		unsigned int timeout = conf->checker_timeout;
 
 		if(!pp->tpgs &&
-		   (tpgs = get_target_port_group_support(pp->fd, timeout)) >= 0)
+		   (tpgs = get_target_port_group_support(pp, timeout)) >= 0)
 			pp->tpgs = tpgs;
 	}
 	condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
-- 
2.21.0
