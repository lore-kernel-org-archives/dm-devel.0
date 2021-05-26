Return-Path: <SRS0=F9kp=KW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0FDC4707F
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:44:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7067D613CA
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7067D613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-W5WWH_ddPG6vSALFqfsNrw-1; Thu, 27 May 2021 01:44:47 -0400
X-MC-Unique: W5WWH_ddPG6vSALFqfsNrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F23AE1005D53;
	Thu, 27 May 2021 05:44:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6A7861156;
	Thu, 27 May 2021 05:44:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E6D055345;
	Thu, 27 May 2021 05:44:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14QL745v010455 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 17:07:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB025205D6AA; Wed, 26 May 2021 21:07:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6C2D2047957
	for <dm-devel@redhat.com>; Wed, 26 May 2021 21:07:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6783890DE29
	for <dm-devel@redhat.com>; Wed, 26 May 2021 21:07:01 +0000 (UTC)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
	[209.85.167.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-531-QfXaoPKePbecHhDCxfIIAw-1; Wed, 26 May 2021 17:06:42 -0400
X-MC-Unique: QfXaoPKePbecHhDCxfIIAw-1
Received: by mail-lf1-f42.google.com with SMTP id r5so4651032lfr.5;
	Wed, 26 May 2021 14:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=VLd5OXrScZXh8ykov1e7sSfF7Q/pna3Hb4gFF9BgLMI=;
	b=Tw4vbcW3K1nH7/J3qhXUF+OBHWn6DO41BF3oCSpwDM+Vpw+4Yira02AAl22TpUsJn6
	p4sJQ0+PMQihsyGkJk0iROjkNsgaAKCZtot2DGDea61T67nJG6yR9isvqSWAU6qefAnK
	lzQIYfdgVtY0Ths9uLNExHcdTAFp5bsbTT9QeLvzqakQYf8Eib2yGKcR9Q7GCIl9QMrL
	QbGepxfgOO7fWiACQNDjMxOiYR7sHislNidvsqqEdT5I/iTvbGHA7apUttB8cQttOYek
	ObzNge/AI7uzwp9Y7IssBl9t53WiBEo1/0spIMyTJKkdPXyBzHJkfr8O7Bbqhmk5LYpy
	fhFg==
X-Gm-Message-State: AOAM532iuesS1taFSuqC8AnUBW9VAEEQEoBKbp9RwjIk8xzKMWB3V7yR
	FsKFXW7Uy4OXHgtffMGO+3WQYRD7Xyg=
X-Google-Smtp-Source: ABdhPJwavZWnuA1g9gUQdiZMg2Dj80xDEzIKwCNc+3hki0pbQVZpHTRqMuKOjkCv69ZX4E4ffKaRSg==
X-Received: by 2002:a05:6512:3196:: with SMTP id
	i22mr39784lfe.492.1622063200706; 
	Wed, 26 May 2021 14:06:40 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-193.NA.cust.bahnhof.se.
	[98.128.228.193])
	by smtp.gmail.com with ESMTPSA id r10sm16900lfe.110.2021.05.26.14.06.39
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 26 May 2021 14:06:40 -0700 (PDT)
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 26 May 2021 23:06:37 +0200
Message-Id: <20210526210637.21528-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Thu, 27 May 2021 01:44:38 -0400
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [dm-devel] [PATCH] dm table: Constify static struct blk_ksm_ll_ops
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The only usage of dm_ksm_ll_ops is to make a copy of it to the ksm_ll_ops
field in the blk_keyslot_manager struct. Make it const to allow the
compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ee47a332b462..7e88e5e06922 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1244,7 +1244,7 @@ static int dm_keyslot_evict(struct blk_keyslot_manager *ksm,
 	return args.err;
 }
 
-static struct blk_ksm_ll_ops dm_ksm_ll_ops = {
+static const struct blk_ksm_ll_ops dm_ksm_ll_ops = {
 	.keyslot_evict = dm_keyslot_evict,
 };
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

