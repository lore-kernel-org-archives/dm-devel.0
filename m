Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1D3C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:12:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D965610FC
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D965610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618528338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OqZnWBkcHWq+ro9Y/Vgw9pkgLai+u3nXRjJyRscqO0g=;
	b=ixwkhr/sPIluxOgMuxn0vkKDSEB5Yc1gcWQeKlZShgvuJA8ds45Ot3TJhkPbYJTw+ypcBQ
	UDvRa4z/iCQfprcm1Yd/iwdPpGDdyWpnUGQG7KKtXoQqXmpYIM0ZmEdb5Z8zL9v9QvmcSG
	Uqa3aGkaL+h0prMdX45Ag5T1B6RnWMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-XmHewd1SMi6nXXoeE1pSLA-1; Thu, 15 Apr 2021 19:12:15 -0400
X-MC-Unique: XmHewd1SMi6nXXoeE1pSLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DF5F10060F9;
	Thu, 15 Apr 2021 23:12:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 352E810016DB;
	Thu, 15 Apr 2021 23:12:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D8A211806D15;
	Thu, 15 Apr 2021 23:12:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FNBeKQ010796 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 19:11:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E44436A032; Thu, 15 Apr 2021 23:11:40 +0000 (UTC)
Received: from localhost (thegoat.4a2m.lab.eng.bos.redhat.com [10.16.209.32])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5979260855;
	Thu, 15 Apr 2021 23:11:34 +0000 (UTC)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 15 Apr 2021 19:11:24 -0400
Message-Id: <20210415231126.8746-2-snitzer@redhat.com>
In-Reply-To: <20210415231126.8746-1-snitzer@redhat.com>
References: <20210415231126.8746-1-snitzer@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: [dm-devel] nvme: update failover handling to work with
	REQ_FAILFAST_TRANSPORT
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

BZ: 1948690
Upstream Status: RHEL-only

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

rhel-8.git commit f8fb6ea1226e2abc525c88da13b346118d548eea
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Aug 25 21:52:46 2020 -0400

    [nvme] nvme: update failover handling to work with REQ_FAILFAST_TRANSPORT
    
    Message-id: <20200825215248.2291-9-snitzer@redhat.com>
    Patchwork-id: 325177
    Patchwork-instance: patchwork
    O-Subject: [RHEL8.3 PATCH 08/10] nvme: update failover handling to work with REQ_FAILFAST_TRANSPORT
    Bugzilla: 1843515
    RH-Acked-by: David Milburn <dmilburn@redhat.com>
    RH-Acked-by: Gopal Tiwari <gtiwari@redhat.com>
    RH-Acked-by: Ewan Milne <emilne@redhat.com>
    
    BZ: 1843515
    Upstream Status: RHEL-only
    
    If REQ_FAILFAST_TRANSPORT is set it means the driver should not retry
    IO that completed with transport errors.  REQ_FAILFAST_TRANSPORT is
    set by multipathing software (e.g. dm-multipath) before it issues IO.
    Update NVMe to prepare for failover of requests marked with either
    REQ_NVME_MPATH or REQ_FAILFAST_TRANSPORT.  This allows such requests
    to be given a disposition of FAILOVER.
    
    Introduce nvme_end_req_with_failover() for use in nvme_complete_rq()
    if REQ_NVME_MPATH isn't set.  nvme_end_req_with_failover() ensures
    request is completed with a retryable IO error when appropriate.
    __nvme_end_req() was factored out for use by both nvme_end_req() and
    nvme_end_req_with_failover().
    
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>

---
 drivers/nvme/host/core.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

Index: linux-rhel9/drivers/nvme/host/core.c
===================================================================
--- linux-rhel9.orig/drivers/nvme/host/core.c
+++ linux-rhel9/drivers/nvme/host/core.c
@@ -311,7 +311,7 @@ static inline enum nvme_disposition nvme
 	    nvme_req(req)->retries >= nvme_max_retries)
 		return COMPLETE;
 
-	if (req->cmd_flags & REQ_NVME_MPATH) {
+	if (req->cmd_flags & (REQ_NVME_MPATH | REQ_FAILFAST_TRANSPORT)) {
 		if (nvme_is_path_error(nvme_req(req)->status) ||
 		    blk_queue_dying(req->q))
 			return FAILOVER;
@@ -323,10 +323,8 @@ static inline enum nvme_disposition nvme
 	return RETRY;
 }
 
-static inline void nvme_end_req(struct request *req)
+static inline void __nvme_end_req(struct request *req, blk_status_t status)
 {
-	blk_status_t status = nvme_error_status(nvme_req(req)->status);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    req_op(req) == REQ_OP_ZONE_APPEND)
 		req->__sector = nvme_lba_to_sect(req->q->queuedata,
@@ -336,6 +334,28 @@ static inline void nvme_end_req(struct r
 	blk_mq_end_request(req, status);
 }
 
+static inline void nvme_end_req(struct request *req)
+{
+	__nvme_end_req(req, nvme_error_status(nvme_req(req)->status));
+}
+
+static inline void nvme_end_req_with_failover(struct request *req)
+{
+	u16 nvme_status = nvme_req(req)->status;
+	blk_status_t status = nvme_error_status(nvme_status);
+
+	if (unlikely(nvme_status & NVME_SC_DNR))
+		goto out;
+
+	if (!blk_path_error(status)) {
+		pr_debug("Request meant for failover but blk_status_t (errno=%d) was not retryable.\n",
+			 blk_status_to_errno(status));
+		status = BLK_STS_IOERR;
+	}
+out:
+	__nvme_end_req(req, status);
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	trace_nvme_complete_rq(req);
@@ -352,7 +372,10 @@ void nvme_complete_rq(struct request *re
 		nvme_retry_req(req);
 		return;
 	case FAILOVER:
-		nvme_failover_req(req);
+		if (req->cmd_flags & REQ_NVME_MPATH)
+			nvme_failover_req(req);
+		else
+			nvme_end_req_with_failover(req);
 		return;
 	}
 }

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

