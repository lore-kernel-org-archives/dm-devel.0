Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DB6C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164162;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TEJs8um+hfIPvcA71R3n5eUVzIv2P2SZEJ06H8AcNHc=;
	b=DxuKJLDOIyJtoebNS8ZL+XonOnsJXhXfDOOdLMhS4CpDxLRcHQkefC4PME8eNJBDaGOXjc
	i7XXuUR+7d1TEMhoWYZ37i6CxJZ8+HAlOa0CN4ZCvYhbw7p55pwysXtCB49ZeeUaSTEzJx
	1dIFhEOu62D8cFyOQWl4x7gykxw8FBs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-gamCMNHvNz6XNpkKTSeOgw-1; Fri, 07 Oct 2022 13:35:58 -0400
X-MC-Unique: gamCMNHvNz6XNpkKTSeOgw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58700185A7A8;
	Fri,  7 Oct 2022 17:35:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4842C145BEE3;
	Fri,  7 Oct 2022 17:35:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 370FB1946A49;
	Fri,  7 Oct 2022 17:35:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 432321946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37A6140F9D76; Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B15D40EFB3F;
 Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZrtC006790;
 Fri, 7 Oct 2022 12:35:53 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZrQe006789;
 Fri, 7 Oct 2022 12:35:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:44 -0500
Message-Id: <1665164144-6716-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 8/8] libmultipath: enforce queue_mode bio for
 nmve:tcp paths
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

nvme:tcp devices set BLK_MQ_F_BLOCKING (they are the only block devices
which multipath supports that do so), meaning that block_mq expects that
they can block at certain points while servicing a request.  However,
due to the way device-mapper sets up its queue, it is not able to set
BLK_MQ_F_BLOCKING when it includes paths that set this flag.  Patches
were written to address this issue but they were rejected upstream

https://lore.kernel.org/linux-block/YcH%2FE4JNag0QYYAa@infradead.org/T/#t

The proposed solution was to have multipath use the bio queue_mode for
multipath devices that include nvme:tcp paths.

Multipath devices now automatically add the "queue_mode bio" feature if
they include nvme:tcp paths.  If a multipath devices was created with
"queue_mode rq", it will disallow the addition of nvme:tcp paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   | 17 ++++++++++++++++-
 libmultipath/structs_vec.c |  7 +++++++
 multipath/multipath.conf.5 |  4 +++-
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7c7babd9..e5249fc1 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -260,6 +260,7 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 {
 	struct pathgroup * pgp;
+	struct path *pp;
 	struct config *conf;
 	int i, marginal_pathgroups;
 	char *save_attr;
@@ -275,6 +276,14 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	if (mpp->disable_queueing && VECTOR_SIZE(mpp->paths) != 0)
 		mpp->disable_queueing = 0;
 
+	/* Force QUEUE_MODE_BIO for maps with nvme:tcp paths */
+	vector_foreach_slot(mpp->paths, pp, i) {
+		if (pp->bus == SYSFS_BUS_NVME &&
+		    pp->sg_id.proto_id == NVME_PROTOCOL_TCP) {
+			mpp->queue_mode = QUEUE_MODE_BIO;
+			break;
+		}
+	}
 	/*
 	 * If this map was created with add_map_without_path(),
 	 * mpp->hwe might not be set yet.
@@ -1148,6 +1157,13 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			continue;
 		}
 
+		cmpp = find_mp_by_wwid(curmp, pp1->wwid);
+		if (cmpp && cmpp->queue_mode == QUEUE_MODE_RQ &&
+		    pp1->bus == SYSFS_BUS_NVME && pp1->sg_id.proto_id ==
+		    NVME_PROTOCOL_TCP) {
+			orphan_path(pp1, "nvme:tcp path not allowed with request queue_mode multipath device");
+			continue;
+		}
 		/*
 		 * at this point, we know we really got a new mp
 		 */
@@ -1186,7 +1202,6 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		}
 		verify_paths(mpp);
 
-		cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 		if (cmpp)
 			mpp->queue_mode = cmpp->queue_mode;
 		if (setup_map(mpp, &params, vecs)) {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 645896c6..5a618767 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -264,6 +264,13 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 			}
 			if (pp->initialized == INIT_REMOVED)
 				continue;
+			if (mpp->queue_mode == QUEUE_MODE_RQ &&
+			    pp->bus == SYSFS_BUS_NVME &&
+			    pp->sg_id.proto_id == NVME_PROTOCOL_TCP) {
+				condlog(2, "%s: mulitpath device %s created with request queue_mode. Unable to add nvme:tcp paths",
+					pp->dev, mpp->alias);
+				continue;
+			}
 			if (!mpp->paths && !(mpp->paths = vector_alloc()))
 				goto err;
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 07476497..1fea9d5a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -463,7 +463,9 @@ Before kernel 4.20 The default depends on the kernel parameter
 \fBdm_mod.use_blk_mq\fR. It is \fImq\fR if the latter is set, and \fIrq\fR
 otherwise. Since kernel 4.20, \fIrq\fR and \fImq\fR both correspond to
 block-multiqueue. Once a multipath device has been created, its queue_mode
-cannot be changed.
+cannot be changed. \fInvme:tcp\fR paths are only supported in multipath
+devices with queue_mode set to \fIbio\fR. multipath will automatically
+set this when creating a device with \fInvme:tcp\fR paths.
 .TP
 The default is: \fB<unset>\fR
 .RE
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

