Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAFCC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164161;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=h2hTSB9udFxYiAu5VpohAzMFkpgJ2CwsUwaiWRCAkGw=;
	b=DguSLYjDojE6jb9nINw6n9q+gvHnAKggZG9KXOXbxx/Zxa9IdQMQGJOZ5EZ7GtEwC/fcQS
	9Hk/jRfLclxIF2hDgLsIIerhxTGvfS7jknZIKgUcCdtj03Yp4z9vBR1dT5AQ+18mxao21U
	5yGCh0bMPa2t8r90BDiheXAjvfxV0Ag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-1Q3L4A7DMryQU5J-PQV-fw-1; Fri, 07 Oct 2022 13:35:56 -0400
X-MC-Unique: 1Q3L4A7DMryQU5J-PQV-fw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06049857F8F;
	Fri,  7 Oct 2022 17:35:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8839535D28;
	Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D22B11946A66;
	Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 321AB1946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24B86112C06F; Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01705112C069;
 Fri,  7 Oct 2022 17:35:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZpwY006780;
 Fri, 7 Oct 2022 12:35:51 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZpaG006779;
 Fri, 7 Oct 2022 12:35:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:42 -0500
Message-Id: <1665164144-6716-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 6/8] libmultipath: prepare proto_id for use by
 non-scsi devivces
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make sure that when we are checking for a scsi protocol, we are first
checking that we are working with a scsi path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  9 +++++----
 libmultipath/discovery.c   | 13 ++++++++-----
 libmultipath/print.c       |  6 ++++--
 libmultipath/structs.c     |  2 +-
 libmultipath/structs.h     |  4 +++-
 multipathd/fpin_handlers.c |  2 +-
 6 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 41641e30..7c7babd9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -218,10 +218,11 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 
 	total_paths = VECTOR_SIZE(pgp->paths);
 	vector_foreach_slot(pgp->paths, pp, i) {
-		if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP &&
-			pp->sg_id.proto_id != SCSI_PROTOCOL_SAS &&
-			pp->sg_id.proto_id != SCSI_PROTOCOL_ISCSI &&
-			pp->sg_id.proto_id != SCSI_PROTOCOL_SRP) {
+		if (pp->bus != SYSFS_BUS_SCSI ||
+		    (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP &&
+		     pp->sg_id.proto_id != SCSI_PROTOCOL_SAS &&
+		     pp->sg_id.proto_id != SCSI_PROTOCOL_ISCSI &&
+		     pp->sg_id.proto_id != SCSI_PROTOCOL_SRP)) {
 			/* return success as default path order
 			 * is maintained in path group
 			 */
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 15560f8c..e937f090 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -504,10 +504,11 @@ int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
 
 	proto_id = pp->sg_id.proto_id;
 
-	if (proto_id != SCSI_PROTOCOL_FCP &&
-	    proto_id != SCSI_PROTOCOL_SAS &&
-	    proto_id != SCSI_PROTOCOL_ISCSI &&
-	    proto_id != SCSI_PROTOCOL_SRP) {
+	if (pp->bus != SYSFS_BUS_SCSI ||
+	    (proto_id != SCSI_PROTOCOL_FCP &&
+	     proto_id != SCSI_PROTOCOL_SAS &&
+	     proto_id != SCSI_PROTOCOL_ISCSI &&
+	     proto_id != SCSI_PROTOCOL_SRP)) {
 		return 1;
 	}
 	/* iscsi doesn't have adapter info in sysfs
@@ -1810,8 +1811,10 @@ sysfs_pathinfo(struct path *pp, const struct _vector *hwtable)
 		pp->bus = SYSFS_BUS_CCISS;
 	if (!strncmp(pp->dev,"dasd", 4))
 		pp->bus = SYSFS_BUS_CCW;
-	if (!strncmp(pp->dev,"sd", 2))
+	if (!strncmp(pp->dev,"sd", 2)) {
 		pp->bus = SYSFS_BUS_SCSI;
+		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
+	}
 	if (!strncmp(pp->dev,"nvme", 4))
 		pp->bus = SYSFS_BUS_NVME;
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 68a793e7..d7d522c8 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -650,7 +650,8 @@ snprint_host_attr (struct strbuf *buff, const struct path * pp, char *attr)
 	const char *value = NULL;
 	int ret;
 
-	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
+	if (pp->bus != SYSFS_BUS_SCSI ||
+	    pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
 		return append_strbuf_str(buff, "[undef]");
 	sprintf(host_id, "host%d", pp->sg_id.host_no);
 	host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
@@ -689,7 +690,8 @@ snprint_tgt_wwpn (struct strbuf *buff, const struct path * pp)
 	const char *value = NULL;
 	int ret;
 
-	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
+	if (pp->bus != SYSFS_BUS_SCSI ||
+	    pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
 		return append_strbuf_str(buff, "[undef]");
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0f16c071..fb44cd64 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -116,7 +116,7 @@ alloc_path (void)
 		pp->sg_id.channel = -1;
 		pp->sg_id.scsi_id = -1;
 		pp->sg_id.lun = SCSI_INVALID_LUN;
-		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
+		pp->sg_id.proto_id = PROTOCOL_UNSET;
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->priority = PRIO_UNDEF;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 129bdf0e..d3054662 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -176,6 +176,8 @@ enum queue_mode_states {
 	QUEUE_MODE_RQ,
 };
 
+#define PROTOCOL_UNSET -1
+
 enum scsi_protocol {
 	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
 	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
@@ -291,7 +293,7 @@ struct sg_id {
 	uint64_t lun;
 	short h_cmd_per_lun;
 	short d_queue_depth;
-	enum scsi_protocol proto_id;
+	int proto_id;
 	int transport_id;
 };
 
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 03b2b9ad..a2de3011 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -227,7 +227,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 
 	vector_foreach_slot(vecs->pathvec, pp, k) {
 		/* Checks the host number and also for the SCSI FCP */
-		if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP || host_num !=  pp->sg_id.host_no)
+		if (pp->bus != SYSFS_BUS_SCSI || pp->sg_id.proto_id != SCSI_PROTOCOL_FCP || host_num !=  pp->sg_id.host_no)
 			continue;
 		sprintf(rport_id, "rport-%d:%d-%d",
 				pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

