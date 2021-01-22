Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1487BC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:29:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4FFA23A84
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4FFA23A84
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-kCSa1HlGMu68VcK7b5lgmg-1; Fri, 22 Jan 2021 10:29:26 -0500
X-MC-Unique: kCSa1HlGMu68VcK7b5lgmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99C1D101F7D9;
	Fri, 22 Jan 2021 15:29:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70DFE18993;
	Fri, 22 Jan 2021 15:29:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FE034E58E;
	Fri, 22 Jan 2021 15:29:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFQ9Wn028586 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:26:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BEEA3EE847; Fri, 22 Jan 2021 15:26:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7DD4EE84C
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCB05811E76
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:06 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-L0I24-yvOwyAECaizP-fdQ-1; Fri, 22 Jan 2021 10:26:02 -0500
X-MC-Unique: L0I24-yvOwyAECaizP-fdQ-1
Received: by mail-wr1-f47.google.com with SMTP id m1so4760722wrq.12
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:26:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=UgcTNWE/uk/KcXUXWdLFils+XT6RGm4GOt/51Vobw+c=;
	b=LosoNa6pXojwHIPItMmQjCyvEU/PG61y5J00VEPZd67U4Cb+kzYnrq7E3X3bk9Ij71
	EiZvhtAAO0Y+xZnYQe5Zkdurs2afjnpPVgWPjoGzXF7EW6RCDeKjU3wIlH6/sqS4XIb+
	J4Uipcg3NydNVyp6C1Fr1ad6CxOf7KTiZMBj6SxI0iqpMmjox8kn/K4oTrK/tqeRZnim
	Cu7JpAAS5I3F8MLAbBi8WnxHaOXZ0MpIlwtBwN8ut6TnMFQd6OYAlQCujxL9ZtMzs+5V
	p8b6yi55AB/ZLs78WLPujcY/3CabrU4JbvY9bF9ZnC2ZY2LcHsVCEHNHBEGb+99FTl/W
	6Smw==
X-Gm-Message-State: AOAM531IoUuQrqW1q+BSIGk/07xTniJDf78Xg2FjjYs7Qkgy9mcHX38w
	gC3oyB2dJ5+ZL0G2WEupGNTXHQ==
X-Google-Smtp-Source: ABdhPJx+pMdt5El2L1nSbohq3kgqH1hx0SoFFhdFFKLmBED8Hj0k8SGGsWHPlfsDuJ1lPpug+cqlZg==
X-Received: by 2002:a05:6000:1374:: with SMTP id
	q20mr4913106wrz.44.1611329160966; 
	Fri, 22 Jan 2021 07:26:00 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	r1sm12685159wrl.95.2021.01.22.07.25.59
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:26:00 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:25:53 +0200
Message-Id: <20210122152556.24822-2-ntsironis@arrikto.com>
In-Reply-To: <20210122152556.24822-1-ntsironis@arrikto.com>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 1/4] dm era: Verify the data block size hasn't
	changed
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

dm-era doesn't support changing the data block size of existing devices,
so check explicitly that the requested block size for a new target
matches the one stored in the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index b24e3839bb3a..52e3f63335d3 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -564,6 +564,15 @@ static int open_metadata(struct era_metadata *md)
 	}
 
 	disk = dm_block_data(sblock);
+
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk->data_block_size) != md->block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk->data_block_size), md->block_size);
+		r = -EINVAL;
+		goto bad;
+	}
+
 	r = dm_tm_open_with_sm(md->bm, SUPERBLOCK_LOCATION,
 			       disk->metadata_space_map_root,
 			       sizeof(disk->metadata_space_map_root),
@@ -575,7 +584,6 @@ static int open_metadata(struct era_metadata *md)
 
 	setup_infos(md);
 
-	md->block_size = le32_to_cpu(disk->data_block_size);
 	md->nr_blocks = le32_to_cpu(disk->nr_blocks);
 	md->current_era = le32_to_cpu(disk->current_era);
 
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

