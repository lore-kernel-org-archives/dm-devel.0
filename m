Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90140EE49B2
	for <dm-devel@archiver.kernel.org>; Thu, 31 Aug 2023 21:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693519055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Qm9bp9yNUY+h1AcHf6iTYw9KS5BbWyj4+jp9AaqNwc4=;
	b=Vj6/CqZx/WvxntcVFfzIyS30roLT3i+mS8cSuUj67bc95BBC6htOeFBZJUg+8lgk9nA+YT
	e/X1DnLP4PjuSL02CfKDpeiMSj59sz6AdL98rJBRIXtE4J6ZFlNIp/YUIvPsxC7ExMyL59
	XMO6MUMLlH6xOM34ZrYNpglD2kXrR1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232---EKp43EPPa2duqkUzjw9A-1; Thu, 31 Aug 2023 17:57:32 -0400
X-MC-Unique: --EKp43EPPa2duqkUzjw9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFBC1856F67;
	Thu, 31 Aug 2023 21:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBF8B2026D35;
	Thu, 31 Aug 2023 21:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D264194658D;
	Thu, 31 Aug 2023 21:57:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC7F119465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Aug 2023 21:57:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C0FC40D283A; Thu, 31 Aug 2023 21:57:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ED7D40D2839;
 Thu, 31 Aug 2023 21:57:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37VLvHs0030163;
 Thu, 31 Aug 2023 16:57:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37VLvHbw030162;
 Thu, 31 Aug 2023 16:57:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 31 Aug 2023 16:57:11 -0500
Message-Id: <1693519032-30111-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 3/4] libmultipath: make prioritizer timeouts
 work like checker timeouts
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Multipath's prioritizers previously didn't use the sysfs timeout for
scsi devices, and used a prioritizer specific default timeout (although
in practice, all the prioritizers except hds used 60 seconds). Now
prioritizers deal with timeouts the same way as the checkers. When
selecting a prioritizer, select_checker_timeout() is called if the path
doesn't already have a checker_timeout set, an the prioritizers that use
timeouts now all use the path's checker_timeout. This change also
incidentally fixes some bugs where the detect_alua() function and the
path_latency prioritizer were assuming that the timeout was in a
different unit than it was (seconds vs milliseconds).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c                 | 18 +++++---------
 libmultipath/libmultipath.version        |  4 +--
 libmultipath/prio.c                      | 21 ++++++++++------
 libmultipath/prio.h                      |  9 +++----
 libmultipath/prioritizers/alua.c         | 12 ++++-----
 libmultipath/prioritizers/alua_rtpg.c    | 31 ++++++++++++------------
 libmultipath/prioritizers/alua_rtpg.h    |  7 +++---
 libmultipath/prioritizers/ana.c          |  3 +--
 libmultipath/prioritizers/const.c        |  3 +--
 libmultipath/prioritizers/datacore.c     |  3 +--
 libmultipath/prioritizers/emc.c          |  9 +++----
 libmultipath/prioritizers/hds.c          |  9 +++----
 libmultipath/prioritizers/hp_sw.c        |  9 +++----
 libmultipath/prioritizers/iet.c          |  3 +--
 libmultipath/prioritizers/ontap.c        | 20 +++++++--------
 libmultipath/prioritizers/path_latency.c |  9 ++++---
 libmultipath/prioritizers/random.c       |  3 +--
 libmultipath/prioritizers/rdac.c         |  9 +++----
 libmultipath/prioritizers/sysfs.c        |  3 +--
 libmultipath/prioritizers/weightedpath.c |  3 +--
 libmultipath/propsel.c                   |  2 ++
 21 files changed, 89 insertions(+), 101 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c90c51a6..e4de48e7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1015,18 +1015,13 @@ detect_alua(struct path * pp)
 {
 	int ret;
 	int tpgs;
-	unsigned int timeout;
-
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		pp->tpgs = TPGS_NONE;
 		return;
 	}
 
-	if (sysfs_get_timeout(pp, &timeout) <= 0)
-		timeout = DEF_TIMEOUT;
-
-	tpgs = get_target_port_group_support(pp, timeout);
+	tpgs = get_target_port_group_support(pp);
 	if (tpgs == -RTPG_INQUIRY_FAILED)
 		return;
 	else if (tpgs <= 0) {
@@ -1037,8 +1032,8 @@ detect_alua(struct path * pp)
 	if (pp->fd == -1 || pp->offline)
 		return;
 
-	ret = get_target_port_group(pp, timeout);
-	if (ret < 0 || get_asymmetric_access_state(pp, ret, timeout) < 0) {
+	ret = get_target_port_group(pp);
+	if (ret < 0 || get_asymmetric_access_state(pp, ret) < 0) {
 		int state;
 
 		if (ret == -RTPG_INQUIRY_FAILED)
@@ -1976,7 +1971,7 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 }
 
 static int
-get_prio (struct path * pp, int timeout)
+get_prio (struct path * pp)
 {
 	struct prio * p;
 	struct config *conf;
@@ -1999,7 +1994,7 @@ get_prio (struct path * pp, int timeout)
 		}
 	}
 	old_prio = pp->priority;
-	pp->priority = prio_getprio(p, pp, timeout);
+	pp->priority = prio_getprio(p, pp);
 	if (pp->priority < 0) {
 		/* this changes pp->offline, but why not */
 		int state = path_offline(pp);
@@ -2477,8 +2472,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	  */
 	if ((mask & DI_PRIO) && path_state == PATH_UP && strlen(pp->wwid)) {
 		if (pp->state != PATH_DOWN || pp->priority == PRIO_UNDEF) {
-			get_prio(pp, (pp->state != PATH_DOWN)?
-				     (conf->checker_timeout * 1000) : 10);
+			get_prio(pp);
 		}
 	}
 
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 20a5056c..a7b8c337 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_19.0.0 {
+LIBMULTIPATH_20.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -214,7 +214,7 @@ global:
 
 	/* prioritizers */
 	get_asymmetric_access_state;
-	get_prio_timeout;
+	get_prio_timeout_ms;
 	get_target_port_group;
 	get_target_port_group_support;
 	libmp_nvme_ana_log;
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index cdd37529..a54487f3 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -3,20 +3,25 @@
 #include <stddef.h>
 #include <dlfcn.h>
 #include <sys/stat.h>
+#include <libudev.h>
 
 #include "debug.h"
 #include "util.h"
 #include "prio.h"
+#include "structs.h"
+#include "discovery.h"
 
 static const char * const prio_dir = MULTIPATH_DIR;
 static LIST_HEAD(prioritizers);
 
-unsigned int get_prio_timeout(unsigned int timeout_ms,
-			      unsigned int default_timeout)
+unsigned int get_prio_timeout_ms(const struct path *pp)
 {
-	if (timeout_ms)
-		return timeout_ms;
-	return default_timeout;
+	if (pp->state == PATH_DOWN)
+		return 10;
+	else if (pp->checker_timeout)
+		return pp->checker_timeout * 1000;
+	else
+		return DEF_TIMEOUT;
 }
 
 int init_prio(void)
@@ -136,7 +141,7 @@ struct prio *add_prio (const char *name)
 				errstr);
 		goto out;
 	}
-	p->getprio = (int (*)(struct path *, char *, unsigned int)) dlsym(p->handle, "getprio");
+	p->getprio = (int (*)(struct path *, char *)) dlsym(p->handle, "getprio");
 	errstr = dlerror();
 	if (errstr != NULL)
 		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
@@ -149,9 +154,9 @@ out:
 	return NULL;
 }
 
-int prio_getprio (struct prio * p, struct path * pp, unsigned int timeout)
+int prio_getprio (struct prio * p, struct path * pp)
 {
-	return p->getprio(pp, p->args, timeout);
+	return p->getprio(pp, p->args);
 }
 
 int prio_selected (const struct prio * p)
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 184bf65f..318d2608 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -49,15 +49,14 @@ struct prio {
 	struct list_head node;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
-	int (*getprio)(struct path *, char *, unsigned int);
+	int (*getprio)(struct path *, char *);
 };
 
-unsigned int get_prio_timeout(unsigned int checker_timeout,
-			      unsigned int default_timeout);
+unsigned int get_prio_timeout_ms(const struct path *);
 int init_prio(void);
 void cleanup_prio (void);
 struct prio * add_prio (const char *);
-int prio_getprio (struct prio *, struct path *, unsigned int);
+int prio_getprio (struct prio *, struct path *);
 void prio_get (struct prio *, const char *, const char *);
 void prio_put (struct prio *);
 int prio_selected (const struct prio *);
@@ -66,6 +65,6 @@ const char * prio_args (const struct prio *);
 int prio_set_args (struct prio *, const char *);
 
 /* The only function exported by prioritizer dynamic libraries (.so) */
-int getprio(struct path *, char *, unsigned int);
+int getprio(struct path *, char *);
 
 #endif /* _PRIO_H */
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index a28bca05..ec68f370 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -51,15 +51,15 @@ static const char *aas_print_string(int rc)
 }
 
 int
-get_alua_info(struct path * pp, unsigned int timeout)
+get_alua_info(struct path * pp)
 {
 	int	rc;
 	int	tpg;
 	bool	diff_tpg;
 
-	tpg = get_target_port_group(pp, timeout);
+	tpg = get_target_port_group(pp);
 	if (tpg < 0) {
-		rc = get_target_port_group_support(pp, timeout);
+		rc = get_target_port_group_support(pp);
 		if (rc < 0)
 			return -ALUA_PRIO_TPGS_FAILED;
 		if (rc == TPGS_NONE)
@@ -70,7 +70,7 @@ get_alua_info(struct path * pp, unsigned int timeout)
 	pp->tpg_id = tpg;
 	condlog((diff_tpg) ? 2 : 4, "%s: reported target port group is %i",
 		pp->dev, tpg);
-	rc = get_asymmetric_access_state(pp, tpg, timeout);
+	rc = get_asymmetric_access_state(pp, tpg);
 	if (rc < 0) {
 		condlog(2, "%s: get_asymmetric_access_state returned %d",
 			__func__, rc);
@@ -98,7 +98,7 @@ int get_exclusive_pref_arg(char *args)
 	return 1;
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path * pp, char * args)
 {
 	int rc;
 	int aas;
@@ -109,7 +109,7 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 		return -ALUA_PRIO_NO_INFORMATION;
 
 	exclusive_pref = get_exclusive_pref_arg(args);
-	rc = get_alua_info(pp, timeout);
+	rc = get_alua_info(pp);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 2db91536..dd2224c4 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -136,7 +136,7 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
  */
 static int
 do_inquiry_sg(int fd, int evpd, unsigned int codepage,
-	      void *resp, int resplen, unsigned int timeout)
+	      void *resp, int resplen, unsigned int timeout_ms)
 {
 	struct inquiry_command	cmd;
 	struct sg_io_hdr	hdr;
@@ -162,7 +162,7 @@ retry:
 	hdr.dxfer_len		= resplen;
 	hdr.sbp			= sense;
 	hdr.mx_sb_len		= sizeof(sense);
-	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
+	hdr.timeout		= timeout_ms;
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		PRINT_DEBUG("do_inquiry: IOCTL failed!");
@@ -185,7 +185,7 @@ retry:
 }
 
 int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
-	       void *resp, int resplen, unsigned int timeout)
+	       void *resp, int resplen)
 {
 	struct udev_device *ud = NULL;
 
@@ -206,7 +206,8 @@ int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
 			return 0;
 		}
 	}
-	return do_inquiry_sg(pp->fd, evpd, codepage, resp, resplen, timeout);
+	return do_inquiry_sg(pp->fd, evpd, codepage, resp, resplen,
+			     get_prio_timeout_ms(pp));
 }
 
 /*
@@ -214,13 +215,13 @@ int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
  * data returned by the standard inquiry command.
  */
 int
-get_target_port_group_support(const struct path *pp, unsigned int timeout)
+get_target_port_group_support(const struct path *pp)
 {
 	struct inquiry_data	inq;
 	int			rc;
 
 	memset((unsigned char *)&inq, 0, sizeof(inq));
-	rc = do_inquiry(pp, 0, 0x00, &inq, sizeof(inq), timeout);
+	rc = do_inquiry(pp, 0, 0x00, &inq, sizeof(inq));
 	if (!rc) {
 		rc = inquiry_data_get_tpgs(&inq);
 	}
@@ -229,7 +230,7 @@ get_target_port_group_support(const struct path *pp, unsigned int timeout)
 }
 
 int
-get_target_port_group(const struct path * pp, unsigned int timeout)
+get_target_port_group(const struct path * pp)
 {
 	unsigned char		*buf;
 	const struct vpd83_data *	vpd83;
@@ -246,7 +247,7 @@ get_target_port_group(const struct path * pp, unsigned int timeout)
 	}
 
 	memset(buf, 0, buflen);
-	rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
+	rc = do_inquiry(pp, 1, 0x83, buf, buflen);
 	if (rc < 0)
 		goto out;
 
@@ -263,7 +264,7 @@ get_target_port_group(const struct path * pp, unsigned int timeout)
 		}
 		buflen = scsi_buflen;
 		memset(buf, 0, buflen);
-		rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
+		rc = do_inquiry(pp, 1, 0x83, buf, buflen);
 		if (rc < 0)
 			goto out;
 	}
@@ -293,7 +294,7 @@ out:
 }
 
 int
-do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
+do_rtpg(int fd, void* resp, long resplen, unsigned int timeout_ms)
 {
 	struct rtpg_command	cmd;
 	struct sg_io_hdr	hdr;
@@ -316,7 +317,7 @@ retry:
 	hdr.dxfer_len		= resplen;
 	hdr.mx_sb_len		= sizeof(sense);
 	hdr.sbp			= sense;
-	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
+	hdr.timeout		= timeout_ms;
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		condlog(2, "%s: sg ioctl failed: %s",
@@ -340,8 +341,7 @@ retry:
 }
 
 int
-get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
-			    unsigned int timeout)
+get_asymmetric_access_state(const struct path *pp, unsigned int tpg)
 {
 	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
@@ -349,6 +349,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
 	int			rc;
 	unsigned int		buflen;
 	uint64_t		scsi_buflen;
+	unsigned int		timeout_ms = get_prio_timeout_ms(pp);
 	int fd = pp->fd;
 
 	buflen = VPD_BUFLEN;
@@ -359,7 +360,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
 		return -RTPG_RTPG_FAILED;
 	}
 	memset(buf, 0, buflen);
-	rc = do_rtpg(fd, buf, buflen, timeout);
+	rc = do_rtpg(fd, buf, buflen, timeout_ms);
 	if (rc < 0) {
 		PRINT_DEBUG("%s: do_rtpg returned %d", __func__, rc);
 		goto out;
@@ -377,7 +378,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
 		}
 		buflen = scsi_buflen;
 		memset(buf, 0, buflen);
-		rc = do_rtpg(fd, buf, buflen, timeout);
+		rc = do_rtpg(fd, buf, buflen, timeout_ms);
 		if (rc < 0)
 			goto out;
 	}
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index 675709ff..c5f9a8f9 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -22,9 +22,8 @@
 #define RTPG_RTPG_FAILED			3
 #define RTPG_TPG_NOT_FOUND			4
 
-int get_target_port_group_support(const struct path *pp, unsigned int timeout);
-int get_target_port_group(const struct path *pp, unsigned int timeout);
-int get_asymmetric_access_state(const struct path *pp,
-				unsigned int tpg, unsigned int timeout);
+int get_target_port_group_support(const struct path *pp);
+int get_target_port_group(const struct path *pp);
+int get_asymmetric_access_state(const struct path *pp, unsigned int tpg);
 
 #endif /* __RTPG_H__ */
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index b5c7873d..e9827dca 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -203,8 +203,7 @@ static int get_ana_info(struct path * pp)
  * - ALUA's LBA-dependent state has no ANA equivalent.
  */
 
-int getprio(struct path *pp, __attribute__((unused)) char *args,
-	    __attribute__((unused)) unsigned int timeout)
+int getprio(struct path *pp, __attribute__((unused)) char *args)
 {
 	int rc;
 
diff --git a/libmultipath/prioritizers/const.c b/libmultipath/prioritizers/const.c
index 059d8593..2b07f47b 100644
--- a/libmultipath/prioritizers/const.c
+++ b/libmultipath/prioritizers/const.c
@@ -3,8 +3,7 @@
 #include "prio.h"
 
 int getprio(__attribute__((unused)) struct path * pp,
-	    __attribute__((unused)) char * args,
-	    __attribute__((unused)) unsigned int timeout)
+	    __attribute__((unused)) char * args)
 {
 	return 1;
 }
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index d1d473d4..74e15f3e 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -98,8 +98,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	return 0;
 }
 
-int getprio(struct path * pp, char * args,
-	    __attribute__((unused)) unsigned int timeout)
+int getprio(struct path * pp, char * args)
 {
 	return datacore_prio(pp->dev, pp->fd, args);
 }
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 3b63cca0..856c23d6 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -12,7 +12,7 @@
 
 #define pp_emc_log(prio, msg) condlog(prio, "%s: emc prio: " msg, dev)
 
-int emc_clariion_prio(const char *dev, int fd, unsigned int timeout)
+int emc_clariion_prio(const char *dev, int fd, unsigned int timeout_ms)
 {
 	unsigned char sense_buffer[128];
 	unsigned char sb[128];
@@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout_ms;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_emc_log(0, "sending query command failed");
@@ -81,8 +81,7 @@ out:
 	return(ret);
 }
 
-int getprio (struct path *pp, __attribute__((unused)) char *args,
-	     unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args)
 {
-	return emc_clariion_prio(pp->dev, pp->fd, timeout);
+	return emc_clariion_prio(pp->dev, pp->fd, get_prio_timeout_ms(pp));
 }
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index d569f2d7..212301ea 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -84,7 +84,7 @@
 #define pp_hds_log(prio, fmt, args...) \
 	condlog(prio, "%s: hds prio: " fmt, dev, ##args)
 
-int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
+int hds_modular_prio (const char *dev, int fd, unsigned int timeout_ms)
 {
 	int k;
 	char vendor[9];
@@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = inqBuff;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = get_prio_timeout(timeout, 2000); /* TimeOut = 2 seconds */
+	io_hdr.timeout = timeout_ms;
 
 	if (ioctl (fd, SG_IO, &io_hdr) < 0) {
 		pp_hds_log(0, "SG_IO error");
@@ -168,8 +168,7 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 	return -1;
 }
 
-int getprio (struct path * pp, __attribute__((unused)) char *args,
-	     unsigned int timeout)
+int getprio (struct path * pp, __attribute__((unused)) char *args)
 {
-	return hds_modular_prio(pp->dev, pp->fd, timeout);
+	return hds_modular_prio(pp->dev, pp->fd, get_prio_timeout_ms(pp));
 }
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 5b85ad2e..5570271d 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -32,7 +32,7 @@
 #define pp_hp_sw_log(prio, fmt, args...) \
 	condlog(prio, "%s: hp_sw prio: " fmt, dev, ##args)
 
-int hp_sw_prio(const char *dev, int fd, unsigned int timeout)
+int hp_sw_prio(const char *dev, int fd, unsigned int timeout_ms)
 {
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
 	unsigned char sb[128];
@@ -46,7 +46,7 @@ int hp_sw_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout_ms;
 	io_hdr.pack_id = 0;
 retry:
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
@@ -95,8 +95,7 @@ out:
 	return(ret);
 }
 
-int getprio (struct path *pp, __attribute__((unused)) char *args,
-	     unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args)
 {
-	return hp_sw_prio(pp->dev, pp->fd, timeout);
+	return hp_sw_prio(pp->dev, pp->fd, get_prio_timeout_ms(pp));
 }
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 167a46b0..f3bf64c5 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -138,8 +138,7 @@ int iet_prio(const char *dev, char * args)
 	return 10;
 }
 
-int getprio(struct path * pp, char * args,
-	    __attribute__((unused)) unsigned int timeout)
+int getprio(struct path * pp, char * args)
 {
 	return iet_prio(pp->dev, args);
 }
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 262e69d2..117886ea 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -28,7 +28,6 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIOVAL	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	60000
 
 #define pp_ontap_log(prio, fmt, args...) \
 	condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
@@ -72,7 +71,7 @@ static void process_sg_error(struct sg_io_hdr *io_hdr)
  */
 static int send_gva(const char *dev, int fd, unsigned char pg,
 		    unsigned char *results, int *results_size,
-		    unsigned int timeout)
+		    unsigned int timeout_ms)
 {
 	unsigned char sb[128];
 	unsigned char cdb[10] = {0xc0, 0, 0x1, 0xa, 0x98, 0xa,
@@ -90,7 +89,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
+	io_hdr.timeout = timeout_ms;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
@@ -123,7 +122,7 @@ out:
  *  0: Device _not_ proxy path
  *  1: Device _is_ proxy path
  */
-static int get_proxy(const char *dev, int fd, unsigned int timeout)
+static int get_proxy(const char *dev, int fd, unsigned int timeout_ms)
 {
 	unsigned char results[256];
 	unsigned char sb[128];
@@ -142,7 +141,7 @@ static int get_proxy(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
+	io_hdr.timeout = timeout_ms;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "ioctl sending inquiry command failed, "
@@ -183,7 +182,7 @@ out:
  * 2: iSCSI software
  * 1: FCP proxy
  */
-static int ontap_prio(const char *dev, int fd, unsigned int timeout)
+static int ontap_prio(const char *dev, int fd, unsigned int timeout_ms)
 {
 	unsigned char results[RESULTS_MAX];
 	int results_size=RESULTS_MAX;
@@ -196,7 +195,7 @@ static int ontap_prio(const char *dev, int fd, unsigned int timeout)
 	is_iscsi_software = is_iscsi_hardware = is_proxy = 0;
 
 	memset(&results, 0, sizeof (results));
-	rc = send_gva(dev, fd, 0x41, results, &results_size, timeout);
+	rc = send_gva(dev, fd, 0x41, results, &results_size, timeout_ms);
 	if (rc >= 0) {
 		tot_len = get_unaligned_be32(&results[0]);
 		if (tot_len <= 8) {
@@ -221,7 +220,7 @@ static int ontap_prio(const char *dev, int fd, unsigned int timeout)
 	}
 
 try_fcp_proxy:
-	rc = get_proxy(dev, fd, timeout);
+	rc = get_proxy(dev, fd, timeout_ms);
 	if (rc >= 0) {
 		is_proxy = rc;
 	}
@@ -241,8 +240,7 @@ prio_select:
 	}
 }
 
-int getprio (struct path *pp, __attribute__((unused)) char *args,
-	     unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args)
 {
-	return ontap_prio(pp->dev, pp->fd, timeout);
+	return ontap_prio(pp->dev, pp->fd, get_prio_timeout_ms(pp));
 }
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 2f5be9b9..f4142577 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -104,10 +104,10 @@ static void cleanup_directio_read(int fd, char *buf, int restore_flags)
 	}
 }
 
-static int do_directio_read(int fd, unsigned int timeout, char *buf, int sz)
+static int do_directio_read(int fd, unsigned int timeout_ms, char *buf, int sz)
 {
 	fd_set read_fds;
-	struct timeval tm = { .tv_sec = timeout };
+	struct timeval tm = { .tv_sec = timeout_ms / 1000};
 	int ret;
 	int num_read;
 
@@ -208,7 +208,7 @@ int calcPrio(double lg_avglatency, double lg_maxavglatency,
 	return lg_maxavglatency - lg_avglatency;
 }
 
-int getprio(struct path *pp, char *args, unsigned int timeout)
+int getprio(struct path *pp, char *args)
 {
 	int rc, temp;
 	int io_num = 0;
@@ -247,7 +247,8 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 
 		(void)clock_gettime(CLOCK_MONOTONIC, &tv_before);
 
-		if (do_directio_read(pp->fd, timeout, buf, blksize)) {
+		if (do_directio_read(pp->fd, get_prio_timeout_ms(pp), buf,
+				     blksize)) {
 			pp_pl_log(0, "%s: path down", pp->dev);
 			cleanup_directio_read(pp->fd, buf, restore_flags);
 			return -1;
diff --git a/libmultipath/prioritizers/random.c b/libmultipath/prioritizers/random.c
index b742ac23..148b957d 100644
--- a/libmultipath/prioritizers/random.c
+++ b/libmultipath/prioritizers/random.c
@@ -6,8 +6,7 @@
 #include "prio.h"
 
 int getprio(__attribute__((unused)) struct path *pp,
-	    __attribute__((unused)) char *args,
-	    __attribute__((unused)) unsigned int timeout)
+	    __attribute__((unused)) char *args)
 {
 	struct timeval tv;
 
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index 92a2fb85..f40cd841 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -12,7 +12,7 @@
 
 #define pp_rdac_log(prio, msg) condlog(prio, "%s: rdac prio: " msg, dev)
 
-int rdac_prio(const char *dev, int fd, unsigned int timeout)
+int rdac_prio(const char *dev, int fd, unsigned int timeout_ms)
 {
 	unsigned char sense_buffer[128];
 	unsigned char sb[128];
@@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout_ms;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_rdac_log(0, "sending inquiry command failed");
@@ -91,8 +91,7 @@ out:
 	return(ret);
 }
 
-int getprio (struct path *pp, __attribute__((unused)) char *args,
-	     unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args)
 {
-	return rdac_prio(pp->dev, pp->fd, timeout);
+	return rdac_prio(pp->dev, pp->fd, get_prio_timeout_ms(pp));
 }
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
index a6feb421..5e8adc05 100644
--- a/libmultipath/prioritizers/sysfs.c
+++ b/libmultipath/prioritizers/sysfs.c
@@ -36,8 +36,7 @@ int get_exclusive_pref_arg(char *args)
 	return 1;
 }
 
-int getprio (struct path * pp, char *args,
-	     __attribute__((unused)) unsigned int timeout)
+int getprio (struct path * pp, char *args)
 {
 	int prio = 0, rc, i;
 	char buff[512];
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 561ebb48..de51a9e7 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -125,8 +125,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	return priority;
 }
 
-int getprio(struct path *pp, char *args,
-	    __attribute__((unused)) unsigned int timeout)
+int getprio(struct path *pp, char *args)
 {
 	return prio_path_weight(pp, args);
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 91a59880..d6bce129 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -813,6 +813,8 @@ int select_prio(struct config *conf, struct path *pp)
 	struct prio * p = &pp->prio;
 	int log_prio = 3;
 
+	if (!pp->checker_timeout)
+		select_checker_timeout(conf, pp);
 	if (pp->detect_prio == DETECT_PRIO_ON) {
 		detect_prio(pp);
 		if (prio_selected(p)) {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

