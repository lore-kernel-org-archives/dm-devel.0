Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADD4C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532845;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TtLjjpvQ/HSRD5TGe+RLYGcRg+d5E6wpkJzHmYVIjks=;
	b=NKglslHWSsva4rKuqzShWnRielu/nrHYlBwenRS3+NwjzNut3VHyQ8WU80fh3WyRt9nqvA
	PV0iFyPMUbsdFo2D6006lrqtYv7oiDMYjn8Jpp98t1Vx40iaRtozfbU3V+LQqF25FjaL2Z
	hkcOBdYLMvUL5u0PHWchLTlcY8nnSRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-kU9gUEHgMHqi8it73sJlkQ-1; Thu, 10 Feb 2022 17:40:42 -0500
X-MC-Unique: kU9gUEHgMHqi8it73sJlkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4E4464140;
	Thu, 10 Feb 2022 22:40:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A88024E2DD;
	Thu, 10 Feb 2022 22:40:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 825F01809CB9;
	Thu, 10 Feb 2022 22:40:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMchKB014802 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A076492D51; Thu, 10 Feb 2022 22:38:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1671A492D47
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F266B1C04B55
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:42 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-499-ibUtmLasOMayNuCDnrQJjA-1; Thu, 10 Feb 2022 17:38:41 -0500
X-MC-Unique: ibUtmLasOMayNuCDnrQJjA-1
Received: by mail-qk1-f200.google.com with SMTP id
	bl5-20020a05620a1a8500b005088d061be4so4539042qkb.21
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=zWCBM8YnYusetp0OPiRYym7xOF2Me0YViFrrQcnA0W4=;
	b=PfCOpsDFVN+nU7M0at2K5h7I74JnngmQ1fZGHL8Y0PgbitFdEqaKUC+ni4W7CasqEy
	G9qEDgSknhjzLD4YLoeGzdGSSDYn3xMN/YVi70FgGiwGWPI7uUrzn0Ln6Td4IjKkJoHG
	2geFqqAcAC1VD3mjaO1M0Lqoc+gLrRBG7c1P0a1T4kQLfFFsRmoB4FEWaPvMnsOF7wXp
	HoV2UHF/0p4Fo4z4NIG4PDmLS7OGos7/xwxo7SDJNeZt5JqgjeiTshE9vimFylv5apmm
	+kVtuAkyrNfGpvNgd2WmYr9R2VstzpkghVmGePLyHKfV4OIrOEWHozny0XdtdZ+Ikz8g
	kqzg==
X-Gm-Message-State: AOAM5305yFH7YgGqRy8gA6bectc1Dtp+BQ7r6nJIwLRs23MJ19gSm3L2
	rvd8XKJ/nuX7Hm5Ql+szkQ8jf5aNVhlPQljzVUh06sIrQAMgN/Zq2xgkOk+tAMLqKHEgCovrzhb
	8TyiBLDB/qkg6dl+qKnOZacA9fYqKbAUM8h+lvrMNAKQd1Jsud4ETyJwYmYp0Yvuu8g==
X-Received: by 2002:a05:620a:8cd:: with SMTP id
	z13mr4860476qkz.487.1644532721076; 
	Thu, 10 Feb 2022 14:38:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRAUZfBBxSBcOHqSs0cu835y/n502phOPI93DcwbFy1t2ge6HipGrPT3511ZI+QNnRn+BDmg==
X-Received: by 2002:a05:620a:8cd:: with SMTP id
	z13mr4860468qkz.487.1644532720833; 
	Thu, 10 Feb 2022 14:38:40 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	w3sm11965918qta.13.2022.02.10.14.38.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:40 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:23 -0500
Message-Id: <20220210223832.99412-6-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 05/14] dm: remove impossible BUG_ON in
	__send_empty_flush
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

The flush_bio in question was just initialized to be empty, so there
is no way bio_has_data() will retrun true.  So remove stale BUG_ON().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cc014e56252e..1985fc3f2a95 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1255,7 +1255,6 @@ static int __send_empty_flush(struct clone_info *ci)
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
 
-	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

