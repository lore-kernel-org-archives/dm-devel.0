Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40834C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W+pNuiMhcOUivhVDFmYBfQ8eK6tY5cP/cEMYcOcJJOY=;
	b=PT0Gyozvj21M77fda8hzzqY2JZ8LosZJxJeOZGWQ0x9ZfhhS92k1KmgYtlu/8oDZm5ytdX
	RL6CmZD9lfJnd1c4mrp4wIjAyXnAU0r+hgR7/GVCCl4O2tLBIvHlpRR2R/m0FvuKbe24Vo
	Nmq27c52wLBNDDqyjJFKMC3mVl1Xl30=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-QSUDmw7rMbWKasZuRES45Q-1; Fri, 07 Oct 2022 13:36:02 -0400
X-MC-Unique: QSUDmw7rMbWKasZuRES45Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 845F186EB20;
	Fri,  7 Oct 2022 17:35:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 740ED145BEE3;
	Fri,  7 Oct 2022 17:35:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 659B21946A49;
	Fri,  7 Oct 2022 17:35:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 095C91946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F2BC2AB584; Fri,  7 Oct 2022 17:35:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 171BDAB5A9;
 Fri,  7 Oct 2022 17:35:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZnDo006772;
 Fri, 7 Oct 2022 12:35:50 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZnJN006771;
 Fri, 7 Oct 2022 12:35:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:40 -0500
Message-Id: <1665164144-6716-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 4/8] libmultipath: fix queue_mode feature handling
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

device-mapper is not able to change the queue_mode on a table reload.
Make sure that when multipath sets up the map, both on regular reloads
and reconfigures, it keeps the queue_mode the same.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  4 +++
 libmultipath/dmparser.c    |  2 ++
 libmultipath/propsel.c     | 55 ++++++++++++++++++++++++++++++++++++++
 libmultipath/structs.h     |  7 +++++
 multipath/multipath.conf.5 |  7 +++--
 5 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 8af7cd79..41641e30 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1075,6 +1075,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 	struct config *conf = NULL;
 	int allow_queueing;
 	struct bitfield *size_mismatch_seen;
+	struct multipath * cmpp;
 
 	/* ignore refwwid if it's empty */
 	if (refwwid && !strlen(refwwid))
@@ -1184,6 +1185,9 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		}
 		verify_paths(mpp);
 
+		cmpp = find_mp_by_wwid(curmp, mpp->wwid);
+		if (cmpp)
+			mpp->queue_mode = cmpp->queue_mode;
 		if (setup_map(mpp, &params, vecs)) {
 			remove_map(mpp, vecs->pathvec, NULL);
 			continue;
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 50d13c08..3b37a926 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -151,6 +151,8 @@ int disassemble_map(const struct _vector *pathvec,
 
 		free(word);
 	}
+	mpp->queue_mode = strstr(mpp->features, "queue_mode bio") ?
+			  QUEUE_MODE_BIO : QUEUE_MODE_RQ;
 
 	/*
 	 * hwhandler
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 98e3aad1..d4f19897 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -26,6 +26,7 @@
 #include "strbuf.h"
 #include <inttypes.h>
 #include <libudev.h>
+#include <ctype.h>
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -413,6 +414,59 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 	}
 }
 
+static void reconcile_features_with_queue_mode(struct multipath *mp)
+{
+	char *space = NULL, *val = NULL, *mode_str = NULL, *feat;
+	int features_mode = QUEUE_MODE_UNDEF;
+
+	if (!mp->features)
+		return;
+
+	pthread_cleanup_push(cleanup_free_ptr, &space);
+	pthread_cleanup_push(cleanup_free_ptr, &val);
+	pthread_cleanup_push(cleanup_free_ptr, &mode_str);
+
+	if (!(feat = strstr(mp->features, "queue_mode")) ||
+	    feat == mp->features || !isspace(*(feat - 1)) ||
+	    sscanf(feat, "queue_mode%m[ \f\n\r\t\v]%ms", &space, &val) != 2)
+		goto sync_mode;
+	if (asprintf(&mode_str, "queue_mode%s%s", space, val) < 0) {
+		condlog(1, "failed to allocate space for queue_mode feature string");
+		mode_str = NULL; /* value undefined on failure */
+		goto exit;
+	}
+
+	if (!strcmp(val, "rq") || !strcmp(val, "mq"))
+		features_mode = QUEUE_MODE_RQ;
+	else if (!strcmp(val, "bio"))
+		features_mode = QUEUE_MODE_BIO;
+	if (features_mode == QUEUE_MODE_UNDEF) {
+		condlog(2, "%s: ignoring invalid feature '%s'",
+			mp->alias, mode_str);
+		goto sync_mode;
+	}
+
+	if (mp->queue_mode == QUEUE_MODE_UNDEF)
+		mp->queue_mode = features_mode;
+	if (mp->queue_mode == features_mode)
+		goto exit;
+
+	condlog(2,
+		"%s: ignoring feature '%s' because queue_mode is set to '%s'",
+		mp->alias, mode_str,
+		(mp->queue_mode == QUEUE_MODE_RQ)? "rq" : "bio");
+
+sync_mode:
+	if (mode_str)
+		remove_feature(&mp->features, mode_str);
+	if (mp->queue_mode == QUEUE_MODE_BIO)
+		add_feature(&mp->features, "queue_mode bio");
+exit:
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+}
+
 int select_features(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
@@ -428,6 +482,7 @@ out:
 	reconcile_features_with_options(mp->alias, &mp->features,
 					&mp->no_path_retry,
 					&mp->retain_hwhandler);
+	reconcile_features_with_queue_mode(mp);
 	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 5a713d46..129bdf0e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -170,6 +170,12 @@ enum max_sectors_kb_states {
 	MAX_SECTORS_KB_MIN = 4,  /* can't be smaller than page size */
 };
 
+enum queue_mode_states {
+	QUEUE_MODE_UNDEF = 0,
+	QUEUE_MODE_BIO,
+	QUEUE_MODE_RQ,
+};
+
 enum scsi_protocol {
 	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
 	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
@@ -396,6 +402,7 @@ struct multipath {
 	int needs_paths_uevent;
 	int ghost_delay;
 	int ghost_delay_tick;
+	int queue_mode;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index e098d555..46a4126c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -459,8 +459,11 @@ precedence. See KNOWN ISSUES.
 <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR, which corresponds to
 bio-based, request-based, and block-multiqueue (blk-mq) request-based,
 respectively.
-The default depends on the kernel parameter \fBdm_mod.use_blk_mq\fR. It is
-\fImq\fR if the latter is set, and \fIrq\fR otherwise.
+Before kernel 4.20 The default depends on the kernel parameter
+\fBdm_mod.use_blk_mq\fR. It is \fImq\fR if the latter is set, and \fIrq\fR
+otherwise. Since kernel 4.20, \fIrq\fR and \fImq\fR both correspond to
+block-multiqueue. Once a multipath device has been created, its queue_mode
+cannot be changed.
 .TP
 The default is: \fB<unset>\fR
 .RE
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

