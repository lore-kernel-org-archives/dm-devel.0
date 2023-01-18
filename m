Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F003C38159
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674045748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9g64hqQv2v7iJMmydO79406bROuQVoMA0sxTL327mjI=;
	b=WDmEQ3DSVKUaq1MjRzdeKXkjYA9RFSnN9LzMF/bOmH8TLol7CZcfshxf2t/FVDPFDHvLPB
	Uj1YN6tPMaPsl4KUkyIF84RFcUyyF6e+QczMjPIxxC+hziEmypUVUxfysTfLiAKYEuAuDj
	ifUCoS4GlQGLtleJP1297EYfEnBfPoo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-UJlaEvcVO7q7DGQUwWZYmg-1; Wed, 18 Jan 2023 07:42:26 -0500
X-MC-Unique: UJlaEvcVO7q7DGQUwWZYmg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4C143802B86;
	Wed, 18 Jan 2023 12:42:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A4DF492B00;
	Wed, 18 Jan 2023 12:42:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F06C71946A6E;
	Wed, 18 Jan 2023 12:42:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F7ED19465B7
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 50E2B4010D46; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49D0140C6EC4
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F0911C08793
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-404-KYB-D_z7OwS-EzYz6C12AA-1; Wed, 18 Jan 2023 07:29:56 -0500
X-MC-Unique: KYB-D_z7OwS-EzYz6C12AA-1
Received: by mail-wm1-f45.google.com with SMTP id
 q10-20020a1cf30a000000b003db0edfdb74so1118390wmq.1
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 04:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=i0cw6NDurT/jWDkYJA2si2HsrHnhghGZlcvgudiyYBE=;
 b=gIMvHSyj1tV+h3diPJow4osry189TQFwWQ7BJI3vKmtI7PDw2r//pOu+t96QCEC/IH
 d45BKiZR0lM9OSLOe8/1OW319LVNYQr3J3U6Rwi6srnEJ3JmRIh/32uTlevoZw2uZp7y
 bW2v5jR7asDWIRjuNi4Jr+odXMOd27OXFiiZUh8NOqqDZk+ahyfUkcj9w4aeYnyiEy+u
 vMTjXK72FGnZbMCKR6mFoqIexlOUXlV4tNnDjDx6MFfpZ6M8y1Xaj6yEyMzE2N0/kaT3
 MZCzb+56CTm8JytHY9cfbGJ5DPS78O1aL8qP4mYBhLERgs7SWAx8fkKDld4f4/OoK4y3
 4F3A==
X-Gm-Message-State: AFqh2kq6VYV2coLcUrwFLL4CngbhTLnjMQdBV60FIyFNvUosfoB2C1+q
 XHYTca1vwmTsB3qyJa7fhJz6XA==
X-Google-Smtp-Source: AMrXdXvXEk+AGcGGcOyihfnQ0q0iO0HivoFXg/32/CPZaoJA0neqsKt0iBc4KOM/NQYP1fZlk/RFAA==
X-Received: by 2002:a05:600c:4d98:b0:3d3:5c7d:a5f3 with SMTP id
 v24-20020a05600c4d9800b003d35c7da5f3mr15190660wmp.37.1674044995399; 
 Wed, 18 Jan 2023 04:29:55 -0800 (PST)
Received: from marvin.hq.arr ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 n42-20020a05600c3baa00b003d9f14e9085sm2099344wms.17.2023.01.18.04.29.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Jan 2023 04:29:54 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@kernel.org,
	agk@redhat.com,
	dm-devel@redhat.com
Date: Wed, 18 Jan 2023 14:29:45 +0200
Message-Id: <20230118122946.20435-2-ntsironis@arrikto.com>
In-Reply-To: <20230118122946.20435-1-ntsironis@arrikto.com>
References: <20230118122946.20435-1-ntsironis@arrikto.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/2] dm era: allocate in-core writesets when
 loading metadata
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
Cc: ejt@redhat.com, ntsironis@arrikto.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Until now, the allocation of the in-core bitmaps was done in pre-resume
by metadata_resize().

In preparation for the next commit, which makes it possible for a
metadata operation, e.g. an era rollover, to run before pre-resume runs,
allocate the in-core bitmaps as part of opening the metadata.

Also, set the number of blocks of the era device in era_ctr() to the
number of blocks in the metadata.

This avoids attempting to resize the metadata every time we create a new
target instance, even if the metadata size hasn't changed.

Fixes: eec40579d8487 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index e92c1afc3677..3332bed2f412 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -788,6 +788,7 @@ static int metadata_digest_start(struct era_metadata *md, struct digest *d)
  * High level metadata interface.  Target methods should use these, and not
  * the lower level ones.
  *--------------------------------------------------------------*/
+static void metadata_close(struct era_metadata *md);
 static struct era_metadata *metadata_open(struct block_device *bdev,
 					  sector_t block_size,
 					  bool may_format)
@@ -811,6 +812,24 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 		return ERR_PTR(r);
 	}
 
+	if (md->nr_blocks == 0)
+		return md;
+
+	/* Allocate in-core writesets */
+	r = writeset_alloc(&md->writesets[0], md->nr_blocks);
+	if (r) {
+		DMERR("%s: writeset_alloc failed for writeset 0", __func__);
+		metadata_close(md);
+		return ERR_PTR(r);
+	}
+
+	r = writeset_alloc(&md->writesets[1], md->nr_blocks);
+	if (r) {
+		DMERR("%s: writeset_alloc failed for writeset 1", __func__);
+		metadata_close(md);
+		return ERR_PTR(r);
+	}
+
 	return md;
 }
 
@@ -1504,6 +1523,7 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		return PTR_ERR(md);
 	}
 	era->md = md;
+	era->nr_blocks = md->nr_blocks;
 
 	era->wq = alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM);
 	if (!era->wq) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

