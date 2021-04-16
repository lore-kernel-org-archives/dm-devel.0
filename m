Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A74C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:54:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A276361152
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A276361152
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618617238;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9LNVfs+asjB33ffk37DkexKwWVeUDpPVxPEAPbigWHM=;
	b=AHkpnr9SMs4lD4nPE9kLBUO2DOlULylS+48oNg0tIcRO2ZDahAY7zX47X+bqirh1yqGck1
	Q41PYBYvIxS9L7gycN+qamZR62ROfrZF40GD0LWhRV/TopmgeEhbf5z6AzI8lxo5czxN8V
	p+KJbHGgSJOEKk2FKRIuUxGS4iIazXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-ORA_N1YMNBKWKGHJRV0TIQ-1; Fri, 16 Apr 2021 19:53:56 -0400
X-MC-Unique: ORA_N1YMNBKWKGHJRV0TIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67EF28018A7;
	Fri, 16 Apr 2021 23:53:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AC8E614F5;
	Fri, 16 Apr 2021 23:53:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 25B561806D16;
	Fri, 16 Apr 2021 23:53:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GNrdO6018872 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 19:53:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 69E8820FE6DD; Fri, 16 Apr 2021 23:53:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6511220FE6DC
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CA6A1021E07
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:39 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
	[209.85.219.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-318-lW23PHH8MGuwWOg1r1lymQ-1; Fri, 16 Apr 2021 19:53:35 -0400
X-MC-Unique: lW23PHH8MGuwWOg1r1lymQ-1
Received: by mail-qv1-f47.google.com with SMTP id i3so8757642qvj.7;
	Fri, 16 Apr 2021 16:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=6W4dFuQZFZDxrcjNEtMiTx3DGVpbYyuLvbl05NbuH68=;
	b=l2zC4UK7kYWpOeNIC2E+JDLbSj1HH0ZjvdMUXOhTyBEmQm1oz3XhTx17kYe/kMKDZJ
	fKv5nnVW60G5gBrvGjCs26GtqWef/EnG5NB+GLhRcBjpTpdIP5WXjH/YkUUYg5ZeRQWX
	BVPHD08l5TjKo86cc1h3fwQ7DWNyfjM056IdEWsJmiaqUkrVBsH9vC7iL6lUw0E663nO
	WFm5xXGrLi4TwBq9OyTHQYFC9gqP8ICfMHPyA53DYE9xqq3H1i3wbUMBMSTMpfktT+Ob
	R0J+9cmlTCncMLz0yBr7V8xPlcqY/Ghe0P1VvNlkhLObnAYFlFSiM92j27dX5lD5mgVG
	fa4w==
X-Gm-Message-State: AOAM533GCx98i2EKxecgZGEyeuE4BpGfDRD9c9HWl6tkSB5KKUuEuVJF
	/LRRR0+Xhhy54P5nhqqu654=
X-Google-Smtp-Source: ABdhPJwh6XHQ4W/sFJBzn//P5eE+pQK3iiAapSkSAHYWj127GoJpxUHJsFoe6ImvSyp0IpaHo7CJxA==
X-Received: by 2002:a0c:b38b:: with SMTP id t11mr11025259qve.25.1618617214793; 
	Fri, 16 Apr 2021 16:53:34 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	l199sm768557qke.118.2021.04.16.16.53.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 16:53:34 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 19:53:29 -0400
Message-Id: <20210416235329.49234-4-snitzer@redhat.com>
In-Reply-To: <20210416235329.49234-1-snitzer@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: [dm-devel] [PATCH v4 3/3] nvme: decouple basic ANA log page re-read
	support from native multipathing
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Whether or not ANA is present is a choice of the target implementation;
the host (and whether it supports multipathing) has _zero_ influence on
this. If the target declares a path as 'inaccessible' the path _is_
inaccessible to the host. As such, ANA support should be functional
even if native multipathing is not.

Introduce ability to always re-read ANA log page as required due to ANA
error and make current ANA state available via sysfs -- even if native
multipathing is disabled on the host (e.g. nvme_core.multipath=N).
This is achieved by factoring out nvme_update_ana() and calling it in
nvme_complete_rq() for all FAILOVER requests.

This affords userspace access to the current ANA state independent of
which layer might be doing multipathing. This makes 'nvme list-subsys'
show ANA state for all NVMe subsystems with multiple controllers. It
also allows userspace multipath-tools to rely on the NVMe driver for
ANA support while dm-multipath takes care of multipathing.

And as always, if embedded NVMe users do not want any performance
overhead associated with ANA or native NVMe multipathing they can
disable CONFIG_NVME_MULTIPATH.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c      |  2 ++
 drivers/nvme/host/multipath.c | 16 +++++++++++-----
 drivers/nvme/host/nvme.h      |  4 ++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a12b10a1383c..83ca96292157 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -340,6 +340,8 @@ static inline void nvme_end_req(struct request *req)
 
 static inline void nvme_failup_req(struct request *req)
 {
+	nvme_update_ana(req);
+
 	nvme_req(req)->status = NVME_SC_HOST_PATH_ERROR;
 	nvme_end_req(req);
 }
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a1d476e1ac02..7d94250264aa 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -65,23 +65,29 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 	}
 }
 
-void nvme_failover_req(struct request *req)
+void nvme_update_ana(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 	u16 status = nvme_req(req)->status & 0x7ff;
-	unsigned long flags;
-
-	nvme_mpath_clear_current_path(ns);
 
 	/*
 	 * If we got back an ANA error, we know the controller is alive but not
-	 * ready to serve this namespace.  Kick of a re-read of the ANA
+	 * ready to serve this namespace.  Kick off a re-read of the ANA
 	 * information page, and just try any other available path for now.
 	 */
 	if (nvme_is_ana_error(status) && ns->ctrl->ana_log_buf) {
 		set_bit(NVME_NS_ANA_PENDING, &ns->flags);
 		queue_work(nvme_wq, &ns->ctrl->ana_work);
 	}
+}
+
+void nvme_failover_req(struct request *req)
+{
+	struct nvme_ns *ns = req->q->queuedata;
+	unsigned long flags;
+
+	nvme_mpath_clear_current_path(ns);
+	nvme_update_ana(req);
 
 	spin_lock_irqsave(&ns->head->requeue_lock, flags);
 	blk_steal_bios(&ns->head->requeue_list, req);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 07b34175c6ce..4eed8536625c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -664,6 +664,7 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
 void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 			struct nvme_ctrl *ctrl, int *flags);
 void nvme_failover_req(struct request *req);
+void nvme_update_ana(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
@@ -714,6 +715,9 @@ static inline void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 static inline void nvme_failover_req(struct request *req)
 {
 }
+static inline void nvme_update_ana(struct request *req)
+{
+}
 static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
 }
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

