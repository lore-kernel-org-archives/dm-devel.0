Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E15AC43461
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:54:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA41F61152
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA41F61152
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618617240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wo5F3HSObdERulpTXp/BFgn/cJgUZzmJWK6i4IoKA9A=;
	b=cNl+7hSbiXNOfGxiW95V8OPi9yR8fMjPxhVne1NfflqlKCDhfn2wN/+RdC6XAFYn1ZES0J
	D7iAwu7m89UWtzY4qJAKkaeWYE0nRLgVgNdfm+AkpeikdV9mpaT97NpXBPVNr9zVpMNdTb
	rwBr7dFWihIKX7su6srUdwdqZvEvEvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-N2D3ypX1NWWjlPIXtkDFAQ-1; Fri, 16 Apr 2021 19:53:58 -0400
X-MC-Unique: N2D3ypX1NWWjlPIXtkDFAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B93718397A5;
	Fri, 16 Apr 2021 23:53:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7022B5947F;
	Fri, 16 Apr 2021 23:53:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 196843809;
	Fri, 16 Apr 2021 23:53:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GNri9X018901 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 19:53:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6991520FE6D9; Fri, 16 Apr 2021 23:53:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 636B420FE6DD
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D0F180231D
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:35 +0000 (UTC)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
	[209.85.222.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-214-6d5w4a9GNoekguZyEdcfjQ-1; Fri, 16 Apr 2021 19:53:31 -0400
X-MC-Unique: 6d5w4a9GNoekguZyEdcfjQ-1
Received: by mail-qk1-f177.google.com with SMTP id q136so9716741qka.7;
	Fri, 16 Apr 2021 16:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
	bh=QyhvZCSvtA03X8xN6o/W0M+lSp8c9SWEUE8ZmCr9STo=;
	b=gitJE1DW0YvGYIIf5IajBOBwZdxLwWmQ1q/7mFTp1OkWGKkn7xPXKmSN3csxbnhWY6
	u8fDvBOdXnEqBqftdd7ALB30oAzB9gIqakAIo/9VjgKcU13XaD9UFKHkRqa0jjqofgSM
	NoZiE3fLv6GOsccqDojQ/IidSPNoMU1O6z98NIs90MOWChH4Bc4hWGJBIUIfqkL1yvvi
	8VhoCmIzh4olMpu8Vp0CD5rNb4CdlMS3EmVlk4LvIBIp/fDtq4YnfXY8RLl/uUEuSC7H
	dgtm6FrkYUhAhrqfBc2MiqroZ3aR0OMQ3SdZ0A6hz42/F0Dz0xHYDeR3j/h+XmOB7qb0
	qQHQ==
X-Gm-Message-State: AOAM530XqssBJbQaFnET8rNmrOyaf+zBS+dcaqN7Y55ilubBv1TNb4gX
	vHSwDNsko3JLWyDija9XvHE=
X-Google-Smtp-Source: ABdhPJyxfAxWmx5hFRT5ylJQlPp9g7ESFqO4NhBYv63c6HS/QO0qUMBxMVRjxTlMTrV+x8HDbBMqNA==
X-Received: by 2002:a37:390:: with SMTP id 138mr406655qkd.136.1618617210999;
	Fri, 16 Apr 2021 16:53:30 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id 2sm5164675qko.134.2021.04.16.16.53.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 16:53:30 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 19:53:26 -0400
Message-Id: <20210416235329.49234-1-snitzer@redhat.com>
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
Subject: [dm-devel] [PATCH v3 0/4] nvme: improve error handling and
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patchset reflects changes needed to make NVMe error handling and
ANA state updates work well with dm-multipath (which always sets
REQ_FAILFAST_TRANSPORT).

RHEL8 has been carrying an older ~5.9 based version of this patchset
(since RHEL8.3, August 2020).

RHEL9 is coming, would really prefer that these changes land upstream
rather than carry them within RHEL.

All review/feedback welcome.

Thanks,
Mike

v3 -> v4, less is more:
- folded REQ_FAILFAST_TRANSPORT local retry and FAILUP patches
- simplified nvme_failup_req(), removes needless blk_path_error() et al
- removed comment block in nvme_decide_disposition()

v2 -> v3:
- Added Reviewed-by tags to BLK_STS_DO_NOT_RETRY patch.
- Eliminated __nvme_end_req() and added code comment to
  nvme_failup_req() in FAILUP handling patch.

Mike Snitzer (3):
  nvme: return BLK_STS_DO_NOT_RETRY if the DNR bit is set
  nvme: allow local retry and proper failover for REQ_FAILFAST_TRANSPORT
  nvme: decouple basic ANA log page re-read support from native
    multipathing

 drivers/nvme/host/core.c      | 22 +++++++++++++++++++---
 drivers/nvme/host/multipath.c | 16 +++++++++++-----
 drivers/nvme/host/nvme.h      |  4 ++++
 include/linux/blk_types.h     |  8 ++++++++
 4 files changed, 42 insertions(+), 8 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

