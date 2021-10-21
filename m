Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E971C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 15:00:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A5EFC60F9F
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 15:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A5EFC60F9F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634828416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5ummdnpnsX0Xt5VQJNJ8GUTigqVs9oVuYxJ6DLczW7A=;
	b=KcxIt/Xi29W1t/oGpGSscltmQZOIXSj9T4gTV7KxODDIpXQ750/6vI63OoRL+lkEwv79sQ
	Rjvpm7lJEexJIJp2o2g0z1TsKO3dDtjoVUUPRPnEY20rMbVZZOisnOBvv202SANjiDVzFg
	EdAO0AS0M2QCVSCTuuRXZ+cvMTGVS/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-81GIL3QmOVuZVdX2NGnkcQ-1; Thu, 21 Oct 2021 11:00:14 -0400
X-MC-Unique: 81GIL3QmOVuZVdX2NGnkcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2B9B101F000;
	Thu, 21 Oct 2021 15:00:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E2B10246F4;
	Thu, 21 Oct 2021 15:00:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9C9284E58F;
	Thu, 21 Oct 2021 14:59:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LExw4X031547 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 10:59:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 03F357944B; Thu, 21 Oct 2021 14:59:58 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 385ED6788F;
	Thu, 21 Oct 2021 14:59:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 21 Oct 2021 22:59:15 +0800
Message-Id: <20211021145918.2691762-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Yi Zhang <yi.zhang@redhat.com>, linux-scsi@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [dm-devel] [PATCH 0/3] block: keep quiesce & unquiesce balanced for
	scsi/dm
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

Hello Jens,

Recently we merge the patch of e70feb8b3e68 ("blk-mq: support concurrent queue
quiesce/unquiesce") for fixing race between driver and block layer wrt.
queue quiesce.

Yi reported that srp/002 is broken with this patch, turns out scsi and
dm don't keep the two balanced actually.

So fix dm and scsi and make srp/002 pass again.


Ming Lei (3):
  scsi: avoid to quiesce sdev->request_queue two times
  scsi: make sure that request queue queiesce and unquiesce balanced
  dm: don't stop request queue after the dm device is suspended

 drivers/md/dm.c            | 10 ------
 drivers/scsi/scsi_lib.c    | 70 ++++++++++++++++++++++++++------------
 include/scsi/scsi_device.h |  1 +
 3 files changed, 49 insertions(+), 32 deletions(-)

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

