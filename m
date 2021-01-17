Return-Path: <SRS0=SDq8=GV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E29C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jan 2021 09:02:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B349322240
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jan 2021 09:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B349322240
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-uH3PpC51OWirBVjIfWkm1g-1; Mon, 18 Jan 2021 04:02:20 -0500
X-MC-Unique: uH3PpC51OWirBVjIfWkm1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64DBCAFA81;
	Mon, 18 Jan 2021 09:02:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90D1C5D9CD;
	Mon, 18 Jan 2021 09:02:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BFE484BB7B;
	Mon, 18 Jan 2021 09:02:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10HBoCDN013121 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 17 Jan 2021 06:50:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 86BC71111A58; Sun, 17 Jan 2021 11:50:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 820F91111A5B
	for <dm-devel@redhat.com>; Sun, 17 Jan 2021 11:50:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37AE8858EEC
	for <dm-devel@redhat.com>; Sun, 17 Jan 2021 11:50:09 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
	[209.85.216.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-WAhIvf7SMmC4Uav_x2FTDw-1; Sun, 17 Jan 2021 06:50:02 -0500
X-MC-Unique: WAhIvf7SMmC4Uav_x2FTDw-1
Received: by mail-pj1-f50.google.com with SMTP id ce17so5515189pjb.5;
	Sun, 17 Jan 2021 03:50:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
	:mime-version:content-language:content-transfer-encoding;
	bh=wjPyOsg006KMekw1viBbKY+LT22ITMgy31SMuHo+XjE=;
	b=dMBYa5Ldj3dzGtB2Wp8EUXBMkqUTdI56CM8QYV+X8b4sdQy1huj0JcgCinKRnUZ5Dl
	NuyZp26dG0eIDQOv9Wu6qRD8leYtv75i4M7PD3JtK/GKLQCGPWadGEJjNTPaCh+G4ok0
	a/z3IHKjsw0kjOs82Y60dmJ8unfq6NssH79Ou4nbtk95b+oHSr+zmYrgoUYXuQVlSJEU
	QVUROSomWrciDVd7Jbuz7a7LJE60IN18h9Foi0t1sD/G7wpwe5TAF2I4sJyeZ+RcwbeM
	V4oYmR5x86YRu08uV4sK9CLDd8wCDqG2tijypnTKcn6f994eLyrjFhxCEJs+yhAkwPAq
	pU3A==
X-Gm-Message-State: AOAM5336MuNyhlBqpmpXXSRitrYgSl3g0mmyCa90eqeD/+1OQvD9IY4S
	7P5tcF4YQ+4sJYM2UhxKieM=
X-Google-Smtp-Source: ABdhPJx5JKiQ2y/nAVCQkVouzzubmUwRiuNk6Pz4z3bB8CGruuUzIqamVZEopjPuWzYryfL7Zhvt3g==
X-Received: by 2002:a17:90b:1649:: with SMTP id
	il9mr16845778pjb.62.1610884201203; 
	Sun, 17 Jan 2021 03:50:01 -0800 (PST)
Received: from [127.0.0.1] ([14.33.99.107]) by smtp.gmail.com with ESMTPSA id
	184sm13135964pgi.92.2021.01.17.03.49.57
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 17 Jan 2021 03:50:00 -0800 (PST)
From: Jinoh Kang <jinoh.kang.kr@gmail.com>
To: dm-devel@redhat.com
Message-ID: <f271028d-182e-c665-f67b-a407a7f7674a@gmail.com>
Date: Sun, 17 Jan 2021 11:49:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Jan 2021 04:02:06 -0500
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm persistent data: fix return type of
	shadow_root
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

shadow_root() truncates 64-bit dm_block_t into 32-bit int.  This is
not an issue in practice, since dm metadata as of v5.11 can only hold at
most 4161600 blocks (255 index entries * ~16k metadata blocks).

Nevertheless, this can confuse users debugging some specific data
corruption scenarios.  Also, DM_SM_METADATA_MAX_BLOCKS may be bumped in
the future, or persistent-data may find its use in other places.

Therefore, switch the return type of shadow_root from int to dm_block_t.

Fixes: 3241b1d3e0aa ("dm: add persistent data library")
Cc: stable@vger.kernel.org
Signed-off-by: Jinoh Kang <jinoh.kang.kr@gmail.com>
---
 drivers/md/persistent-data/dm-btree-internal.h | 2 +-
 drivers/md/persistent-data/dm-btree-spine.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index 564896659dd4..fe073d92f01e 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -100,7 +100,7 @@ struct dm_block *shadow_parent(struct shadow_spine *s);
 
 int shadow_has_parent(struct shadow_spine *s);
 
-int shadow_root(struct shadow_spine *s);
+dm_block_t shadow_root(struct shadow_spine *s);
 
 /*
  * Some inlines.
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index e03cb9e48773..8a2bfbfb218b 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -235,7 +235,7 @@ int shadow_has_parent(struct shadow_spine *s)
 	return s->count >= 2;
 }
 
-int shadow_root(struct shadow_spine *s)
+dm_block_t shadow_root(struct shadow_spine *s)
 {
 	return s->root;
 }
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

