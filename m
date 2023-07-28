Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22876C00528
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690571180;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iKst4/zyJAcLIfiN2voAkIMi/OJYkFjox7JWDjUOYcc=;
	b=Rruh7+Y/E+O92emO03ilcgLKIl1K/yPnHqz+6SuMndPbAMbOktIj4v7f3WrpxiyEjVLunV
	TIxpXaYMmwEXqURYfrbag4Q1yYDtfrA0t6d9FZHRMd4frkYXJGNGXy3LjbVzq1pBKfbuF7
	+1yBelbHApU+zY/Ai6JGgkGzmcmQkzQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-ZdCh9XRGMCqIEGRTno-VkA-1; Fri, 28 Jul 2023 15:06:16 -0400
X-MC-Unique: ZdCh9XRGMCqIEGRTno-VkA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8466830DBD;
	Fri, 28 Jul 2023 19:06:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4C4EC584E8;
	Fri, 28 Jul 2023 19:06:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6F4A31946A6C;
	Fri, 28 Jul 2023 19:06:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3FE0F19451C6
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Jul 2023 19:06:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B77D40C2072; Fri, 28 Jul 2023 19:06:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B29740C2071;
 Fri, 28 Jul 2023 19:06:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 36SJ602C008329;
 Fri, 28 Jul 2023 14:06:00 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 36SJ605H008328;
 Fri, 28 Jul 2023 14:06:00 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 28 Jul 2023 14:05:53 -0500
Message-Id: <1690571155-8283-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
References: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [RFC PATCH 2/4] libmultipath: make prioritizer timeouts
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Multipath's prioritizers previously didn't use the sysfs timeout for
scsi devices, and used a prioritizer specific default timeout (although
in practice, all the prioritizers except hds used 60 seconds). Now
prioritizers deal with timeouts the same way as the checkers. They first
use checker_time if set, then use the sysfs tiemout for scsi devices, or
30 seconds for non-scsi devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.c                   | 14 +++++++++-----
 libmultipath/prio.h                   |  3 +--
 libmultipath/prioritizers/alua.c      |  2 +-
 libmultipath/prioritizers/alua_rtpg.c |  5 ++---
 libmultipath/prioritizers/emc.c       |  5 +++--
 libmultipath/prioritizers/hds.c       |  4 ++--
 libmultipath/prioritizers/hp_sw.c     |  4 ++--
 libmultipath/prioritizers/ontap.c     |  7 +++----
 libmultipath/prioritizers/rdac.c      |  4 ++--
 9 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index cdd37529..69b71578 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -3,20 +3,24 @@
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
+unsigned int get_prio_timeout(struct path *pp, unsigned int timeout)
 {
-	if (timeout_ms)
-		return timeout_ms;
-	return default_timeout;
+	if (timeout)
+		return timeout;
+	timeout = DEF_TIMEOUT;
+	sysfs_get_timeout(pp, &timeout);
+	return timeout * 1000;
 }
 
 int init_prio(void)
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 184bf65f..20808fd7 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -52,8 +52,7 @@ struct prio {
 	int (*getprio)(struct path *, char *, unsigned int);
 };
 
-unsigned int get_prio_timeout(unsigned int checker_timeout,
-			      unsigned int default_timeout);
+unsigned int get_prio_timeout(struct path *pp, unsigned int checker_timeout);
 int init_prio(void);
 void cleanup_prio (void);
 struct prio * add_prio (const char *);
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index a28bca05..d3ba367f 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -109,7 +109,7 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 		return -ALUA_PRIO_NO_INFORMATION;
 
 	exclusive_pref = get_exclusive_pref_arg(args);
-	rc = get_alua_info(pp, timeout);
+	rc = get_alua_info(pp, get_prio_timeout(pp, timeout));
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 2db91536..49982545 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -31,7 +31,6 @@
 #include "alua_rtpg.h"
 
 #define SENSE_BUFF_LEN  32
-#define SGIO_TIMEOUT     60000
 
 #define PRINT_DEBUG(f, a...) \
 	condlog(4, "alua: " f, ##a)
@@ -162,7 +161,7 @@ retry:
 	hdr.dxfer_len		= resplen;
 	hdr.sbp			= sense;
 	hdr.mx_sb_len		= sizeof(sense);
-	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
+	hdr.timeout		= timeout;
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		PRINT_DEBUG("do_inquiry: IOCTL failed!");
@@ -316,7 +315,7 @@ retry:
 	hdr.dxfer_len		= resplen;
 	hdr.mx_sb_len		= sizeof(sense);
 	hdr.sbp			= sense;
-	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
+	hdr.timeout		= timeout;
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		condlog(2, "%s: sg ioctl failed: %s",
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 3b63cca0..97fde31b 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_emc_log(0, "sending query command failed");
@@ -84,5 +84,6 @@ out:
 int getprio (struct path *pp, __attribute__((unused)) char *args,
 	     unsigned int timeout)
 {
-	return emc_clariion_prio(pp->dev, pp->fd, timeout);
+	return emc_clariion_prio(pp->dev, pp->fd,
+				 get_prio_timeout(pp, timeout));
 }
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index d569f2d7..13f497cc 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = inqBuff;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = get_prio_timeout(timeout, 2000); /* TimeOut = 2 seconds */
+	io_hdr.timeout = timeout;
 
 	if (ioctl (fd, SG_IO, &io_hdr) < 0) {
 		pp_hds_log(0, "SG_IO error");
@@ -171,5 +171,5 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 int getprio (struct path * pp, __attribute__((unused)) char *args,
 	     unsigned int timeout)
 {
-	return hds_modular_prio(pp->dev, pp->fd, timeout);
+	return hds_modular_prio(pp->dev, pp->fd, get_prio_timeout(pp, timeout));
 }
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 5b85ad2e..b4cbc58f 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -46,7 +46,7 @@ int hp_sw_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 retry:
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
@@ -98,5 +98,5 @@ out:
 int getprio (struct path *pp, __attribute__((unused)) char *args,
 	     unsigned int timeout)
 {
-	return hp_sw_prio(pp->dev, pp->fd, timeout);
+	return hp_sw_prio(pp->dev, pp->fd, get_prio_timeout(pp, timeout));
 }
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 262e69d2..b9860974 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -28,7 +28,6 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIOVAL	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	60000
 
 #define pp_ontap_log(prio, fmt, args...) \
 	condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
@@ -90,7 +89,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
@@ -142,7 +141,7 @@ static int get_proxy(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = results;
 	io_hdr.cmdp = cdb;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, SG_TIMEOUT);
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_ontap_log(0, "ioctl sending inquiry command failed, "
@@ -244,5 +243,5 @@ prio_select:
 int getprio (struct path *pp, __attribute__((unused)) char *args,
 	     unsigned int timeout)
 {
-	return ontap_prio(pp->dev, pp->fd, timeout);
+	return ontap_prio(pp->dev, pp->fd, get_prio_timeout(pp, timeout));
 }
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index 92a2fb85..0faa8155 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = get_prio_timeout(timeout, 60000);
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_rdac_log(0, "sending inquiry command failed");
@@ -94,5 +94,5 @@ out:
 int getprio (struct path *pp, __attribute__((unused)) char *args,
 	     unsigned int timeout)
 {
-	return rdac_prio(pp->dev, pp->fd, timeout);
+	return rdac_prio(pp->dev, pp->fd, get_prio_timeout(pp, timeout));
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

