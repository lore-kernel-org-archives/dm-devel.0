Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8180DC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:08:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20EFD610F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20EFD610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618610886;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4l7yP3tqg+/7NLvt1IA17cfOmk90hIX8OwAm8e+OU00=;
	b=YsWu2AtFcA4UpV4chxH6DpyrPXCdMUKVNf3P7Ikj8begXkc0vAGmA00fUuoFGoTTzCb/Bh
	sbv5UjFdNws+2JQnmAYckaTuC252+L/IwcTvhw5kWFZGhIv/Ec49LtnLpZhpsSmPFP+i1F
	dz4hEqKzVFPDujDnGnwBt+FF2e4lBJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-auyhZHKTOPil8LMwIZVnQg-1; Fri, 16 Apr 2021 18:08:04 -0400
X-MC-Unique: auyhZHKTOPil8LMwIZVnQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1803D1898297;
	Fri, 16 Apr 2021 22:08:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDA315947F;
	Fri, 16 Apr 2021 22:07:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F5001806D16;
	Fri, 16 Apr 2021 22:07:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GM6pXj010969 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 18:06:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 290972123526; Fri, 16 Apr 2021 22:06:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 201482123528
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21C9185A5BB
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:45 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
	[209.85.219.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-153-Sb3gjdlZOem215I1MfvRtg-1; Fri, 16 Apr 2021 18:06:41 -0400
X-MC-Unique: Sb3gjdlZOem215I1MfvRtg-1
Received: by mail-qv1-f53.google.com with SMTP id h15so4400050qvu.4;
	Fri, 16 Apr 2021 15:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
	bh=5dEer/ScS348Ta3IIzvxNKGHxZsJi4C+9EcorIShKM0=;
	b=avnZK+dhaQhPrhwsUjypkBAJyBNvZC3pklbziIJyoRT8va4Kp/8Iw+T/58I7kpPgDL
	uCJdF5u44rW+2RUiAoRfd3c6y/konXcOajJ9PvaK6eTzLmkWrqWynNajwySLwVLmprxQ
	Z+e+LbT2iCsQ0KLEW4n7M9WNYVDuxT/YOSkiTq+d7oGsXpF1QeOWDHdxJ6t8MjJgx5+n
	u3lCbFcYOYtact8baTHlSYcyd+nmAF1/PhAXAFR1LSMpbytX0ceZefE3cfv3fB1FbiJQ
	8HEL7eaPB3oP1SnrTdKEDdwybczihhaCdb+jYNN/d98285Ul3Tib0wdhBaAdVgGKtu3w
	624g==
X-Gm-Message-State: AOAM533tQptTxjuN0QYvwFMeH6/NArIQT2BBSAz1ABcQXW2O/L5ZBifC
	E6fNK46ct7EZ51BWUb4DK7ev0mlvY8cFSg==
X-Google-Smtp-Source: ABdhPJwAD0B61FY0UKoYI7aZDzQ/jj3rFrz2wC2REHwr118+lfy9HJi6828NPN0YBM+uyBKehKvZAQ==
X-Received: by 2002:a0c:e286:: with SMTP id r6mr10668696qvl.26.1618610799177; 
	Fri, 16 Apr 2021 15:06:39 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	c27sm5098619qko.71.2021.04.16.15.06.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 15:06:38 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 18:06:33 -0400
Message-Id: <20210416220637.41111-1-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

v2 -> v3:
- Added Reviewed-by tags to BLK_STS_DO_NOT_RETRY patch.
- Eliminated __nvme_end_req() and added code comment to
  nvme_failup_req() in FAILUP handling patch.

Chao Leng (1):
  nvme: allow local retry for requests with REQ_FAILFAST_TRANSPORT set

Mike Snitzer (3):
  nvme: return BLK_STS_DO_NOT_RETRY if the DNR bit is set
  nvme: introduce FAILUP handling for REQ_FAILFAST_TRANSPORT
  nvme: decouple basic ANA log page re-read support from native
    multipathing

 drivers/nvme/host/core.c      | 42 +++++++++++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c | 16 +++++++++++-----
 drivers/nvme/host/nvme.h      |  4 ++++
 include/linux/blk_types.h     |  8 ++++++++
 4 files changed, 62 insertions(+), 8 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

