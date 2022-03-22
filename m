Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C15C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 19:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647978581;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5uiA1blzfIhe1XAa79x3REGTr0H5hxSwmyHYELjOzX4=;
	b=c+odmNMfbjv9CYecQ9vP/E7oG0+EIifZTvWN2PodjNLPhbFMh3cU7We52pczNV4k+8FRq0
	ABynuw7Podw5A4GDIwDNcxRmXa2FLrDifsiU0+AK7I59MXTHOTssQxJrcwrByZbIjZXEIV
	orLvWQ9F4nbewCfHnBoZfOK2tG+hlyw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-PoV50vs0MjyawYW0nSvQOg-1; Tue, 22 Mar 2022 15:49:39 -0400
X-MC-Unique: PoV50vs0MjyawYW0nSvQOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01389802C16;
	Tue, 22 Mar 2022 19:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF7F940D2822;
	Tue, 22 Mar 2022 19:49:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 342F11940358;
	Tue, 22 Mar 2022 19:49:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74A321949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 19:49:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57C6A1121330; Tue, 22 Mar 2022 19:49:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 539F8112132C
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02AB7866DF4
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:49:31 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-V5Tn3HrzPQWLDeJYis566w-1; Tue, 22 Mar 2022 15:49:29 -0400
X-MC-Unique: V5Tn3HrzPQWLDeJYis566w-1
Received: by mail-qv1-f71.google.com with SMTP id
 o1-20020a0c9001000000b00440e415a3a2so12213432qvo.13
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
 bh=Ra70WqR4k9WaEnGzMfMHq7N8Yl2YrFMOg3wm/QlzybE=;
 b=PhPfRrj1VTj2izlg6WA0nbZRbed8cqHmcIBCkm/CwwUQgXtZmYIbZcmZebdCIOWmLu
 pYlS9ZdXHT/WzoGoYNiaeh2cnFmxG5akSSUda2UC+pM4igjXRzhe0nFGBo9hZuMD23N0
 7Tgy+eizxZ07do+wqsqzsXGYZj7DaCR+v+RXyHqon8vmx8SsrpZ+z5cjG/hA/5Zo8H/L
 qKGsyhRVdvRtJCfXbjZeN9mMWL+gThYqm++6cqbmdTKA/kw82sFSwQVgvW1WNcckngMJ
 4w3dzMeoeHkVWoIrgGZL7qCcGIXjZZBE46Xlc+aouptVGeoE862w/aNLc5dylGVwAtjo
 6BxA==
X-Gm-Message-State: AOAM532KZ385fCK7y9CVx2SJIUdrKPPZUCJDNZMfHglkhBrBPIozBrKD
 /BKoAVh7NFdgeUpEzJjKFTr1my0H8l8ej744sfolaa5RDG6XuuotZN9C/gYaSkBB9ETB3Bni9E8
 JO5MtZHt25ZTqSA==
X-Received: by 2002:ac8:5c45:0:b0:2e1:9144:2849 with SMTP id
 j5-20020ac85c45000000b002e191442849mr21355798qtj.510.1647978568659; 
 Tue, 22 Mar 2022 12:49:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuAUFri4nvEvVZF2RbL13ATvmIkasPUTw6SWWeNMQNB5h7Rc+g8WP6K964HYpvWyTYncWNsg==
X-Received: by 2002:ac8:5c45:0:b0:2e1:9144:2849 with SMTP id
 j5-20020ac85c45000000b002e191442849mr21355785qtj.510.1647978568427; 
 Tue, 22 Mar 2022 12:49:28 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 x20-20020ac85f14000000b002e1ee1c56c3sm13518520qta.76.2022.03.22.12.49.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 12:49:28 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Tue, 22 Mar 2022 15:49:24 -0400
Message-Id: <20220322194927.42778-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 0/3] block/dm: use BIOSET_PERCPU_CACHE from
 bio_alloc_clone
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

I ran with your suggestion and DM now sees a ~7% improvement in hipri
bio polling with io_uring (using dm-linear on null_blk, IOPS went from
900K to 966K).

I'd appreciate it if you could pick up the first patch for 5.19.
I'll rebase dm's 5.19 branch on block once it lands.

(FYI, this series builds on linux-dm.git's "dm-5.18" branch, and the
commits in this series are available in linux-dm.git's "dm-5.19"
branch).

Thanks,
Mike

Mike Snitzer (3):
  block: allow BIOSET_PERCPU_CACHE use from bio_alloc_clone
  dm: enable BIOSET_PERCPU_CACHE for dm_io bioset
  dm: conditionally enable BIOSET_PERCPU_CACHE for bio-based dm_io bioset

 block/bio.c           | 56 ++++++++++++++++++++++++++++++++-------------------
 block/blk.h           |  7 -------
 drivers/md/dm-table.c | 11 +++++++---
 drivers/md/dm.c       | 10 ++++-----
 drivers/md/dm.h       |  4 ++--
 include/linux/bio.h   |  7 +++++++
 6 files changed, 57 insertions(+), 38 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

