Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE01EC433ED
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:02:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5988360FE5
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5988360FE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618617739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=awZqIDkpS6kX9k41AdECx3utufG13Jq21E+zJD5BIoY=;
	b=KKo8PogBAPWjq7kqgs75KCeuGaVL7x4llkiFlILLs4u1xBQOUCqE6IpJ/ZEbsITa7qRIe4
	A47DhuYd4KEok+WUGqPBVhKChcleVBiQYtR9Uzv/BkSiCPHYy7yelCG18i3FkAVWSNxHXA
	iHOrIgVbIhKm98+2PQhGmeT9PLPVSJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-NtLpY2Q_OgK_0JgxJFQw2w-1; Fri, 16 Apr 2021 20:02:14 -0400
X-MC-Unique: NtLpY2Q_OgK_0JgxJFQw2w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCE9F18397A3;
	Sat, 17 Apr 2021 00:02:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7719F5D9C0;
	Sat, 17 Apr 2021 00:02:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB13744A5E;
	Sat, 17 Apr 2021 00:02:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13H027iN019568 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 20:02:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D48CD5D766; Sat, 17 Apr 2021 00:02:07 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7D4C5D6D3;
	Sat, 17 Apr 2021 00:02:03 +0000 (UTC)
Date: Fri, 16 Apr 2021 20:02:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Message-ID: <20210417000203.GA22241@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210416235329.49234-1-snitzer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v4 0/4] nvme: improve error handling and
 ana_state to work well with dm-multipath
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 16 2021 at  7:53pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi,
> 
> This patchset reflects changes needed to make NVMe error handling and
> ANA state updates work well with dm-multipath (which always sets
> REQ_FAILFAST_TRANSPORT).
> 
> RHEL8 has been carrying an older ~5.9 based version of this patchset
> (since RHEL8.3, August 2020).
> 
> RHEL9 is coming, would really prefer that these changes land upstream
> rather than carry them within RHEL.
> 
> All review/feedback welcome.
> 
> Thanks,
> Mike
> 
> v3 -> v4, less is more:
> - folded REQ_FAILFAST_TRANSPORT local retry and FAILUP patches
> - simplified nvme_failup_req(), removes needless blk_path_error() et al
> - removed comment block in nvme_decide_disposition()
> 
> v2 -> v3:
> - Added Reviewed-by tags to BLK_STS_DO_NOT_RETRY patch.
> - Eliminated __nvme_end_req() and added code comment to
>   nvme_failup_req() in FAILUP handling patch.
> 
> Mike Snitzer (3):
>   nvme: return BLK_STS_DO_NOT_RETRY if the DNR bit is set
>   nvme: allow local retry and proper failover for REQ_FAILFAST_TRANSPORT
>   nvme: decouple basic ANA log page re-read support from native
>     multipathing
> 
>  drivers/nvme/host/core.c      | 22 +++++++++++++++++++---
>  drivers/nvme/host/multipath.c | 16 +++++++++++-----
>  drivers/nvme/host/nvme.h      |  4 ++++
>  include/linux/blk_types.h     |  8 ++++++++
>  4 files changed, 42 insertions(+), 8 deletions(-)

Sorry for all the noise, but I had a cut-and-paste issue with this cover
letter; should've said "[PATCH v4 0/4] ..."

While I'm replying, I _think_ there is consensus that patch 1 is
worthwile and acceptable. Here is a combined diff of patches 2+3 to
illustrate just how minimalist these proposed changes are:

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 540d6fd8ffef..83ca96292157 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -299,6 +299,7 @@ enum nvme_disposition {
 	COMPLETE,
 	RETRY,
 	FAILOVER,
+	FAILUP,
 };
 
 static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
@@ -306,15 +307,16 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if (likely(nvme_req(req)->status == 0))
 		return COMPLETE;
 
-	if (blk_noretry_request(req) ||
+	if ((req->cmd_flags & (REQ_FAILFAST_DEV | REQ_FAILFAST_DRIVER)) ||
 	    (nvme_req(req)->status & NVME_SC_DNR) ||
 	    nvme_req(req)->retries >= nvme_max_retries)
 		return COMPLETE;
 
-	if (req->cmd_flags & REQ_NVME_MPATH) {
+	if (req->cmd_flags & (REQ_NVME_MPATH | REQ_FAILFAST_TRANSPORT)) {
 		if (nvme_is_path_error(nvme_req(req)->status) ||
 		    blk_queue_dying(req->q))
-			return FAILOVER;
+			return (req->cmd_flags & REQ_NVME_MPATH) ?
+				FAILOVER : FAILUP;
 	} else {
 		if (blk_queue_dying(req->q))
 			return COMPLETE;
@@ -336,6 +338,14 @@ static inline void nvme_end_req(struct request *req)
 	blk_mq_end_request(req, status);
 }
 
+static inline void nvme_failup_req(struct request *req)
+{
+	nvme_update_ana(req);
+
+	nvme_req(req)->status = NVME_SC_HOST_PATH_ERROR;
+	nvme_end_req(req);
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	trace_nvme_complete_rq(req);
@@ -354,6 +364,9 @@ void nvme_complete_rq(struct request *req)
 	case FAILOVER:
 		nvme_failover_req(req);
 		return;
+	case FAILUP:
+		nvme_failup_req(req);
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
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
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

