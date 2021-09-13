Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MISSING_HEADERS,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CCCC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:27:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D05961004
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:27:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D05961004
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-Lt3HL6bVP06uSB9MnF0zqg-1; Mon, 13 Sep 2021 05:27:40 -0400
X-MC-Unique: Lt3HL6bVP06uSB9MnF0zqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A46E1084686;
	Mon, 13 Sep 2021 09:27:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47B631972E;
	Mon, 13 Sep 2021 09:27:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C73A1800B8B;
	Mon, 13 Sep 2021 09:27:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18D9RU92020626 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Sep 2021 05:27:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 893F3200B69F; Mon, 13 Sep 2021 09:27:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84D44200B696
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 09:27:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9492811E84
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 09:27:27 +0000 (UTC)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
	[209.85.160.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-259-64R40vwqMFyDj-GKe28SgQ-1; Mon, 13 Sep 2021 05:27:26 -0400
X-MC-Unique: 64R40vwqMFyDj-GKe28SgQ-1
Received: by mail-qt1-f201.google.com with SMTP id
	f34-20020a05622a1a2200b0029c338949c1so54862956qtb.8
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 02:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
	bh=PQ67016JCuw0wmarW+Gg6xUxvTIMgb10aFiL+BvYQI4=;
	b=qAWQzeoKd1blwzN/m4hlLwpLTBgdXszLXfWLhiTe/Qb7R8abHfO5obMkERBMRhyZVq
	5AwPVY34PzO9VH+T6+lNHibWy85xgqvj59NTIcaHSk3Sh+eLGxq4TgrTdBvF+O0JcxZp
	dxk0xccPo8l8z+hHZp4LjEkZAaebdrHxWWb/0NVzt3NovpXZdii6dtmBWHVHc5lkaMEt
	L2avVV93TvF8umX9ClaRWsgrwWWTrQ5dP8x252Lj23zTKzMRYsCf+yt5ZKa826r2Pjx0
	XF4K0e3rP6VEAKLpiolE9Ota2yE451cZXc4yCogsBJTACkCW+aw3jMpT6kykrDe2MvqK
	X2/w==
X-Gm-Message-State: AOAM533sDa1UlM2xPXbw5FZZ1B7SwAgry398FiknbbijG/K5YYwPJOoF
	O7U2V38VbLunlkNtrwyhb+rbiP5GUQAXgA==
X-Google-Smtp-Source: ABdhPJxMQ6XY9sfo57rAG/cK/FlLZ1uUwMeQq7Jr4fgisRGXbfJn0QmMjkHPRA1fD82P8E7cIRdhZ79f6/6VoA==
X-Received: from akailash.c.googlers.com
	([fda3:e722:ac3:cc00:7f:e700:c0a8:1e6])
	(user=akailash job=sendgmr) by 2002:ad4:57a7:: with SMTP id
	g7mr9762449qvx.42.1631525245649; Mon, 13 Sep 2021 02:27:25 -0700 (PDT)
Date: Mon, 13 Sep 2021 09:26:42 +0000
Message-Id: <20210913092642.3237796-1-akailash@google.com>
Mime-Version: 1.0
From: Akilesh Kailash <akailash@google.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, samitolvanen@google.com,
	akailash@google.com, kernel-team@android.com,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] dm-verity: skip verity_handle_error on I/O errors
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If there is an I/O error and FEC correction fails, return
an error instead of calling verity_handle_error().

Suggested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Akilesh Kailash <akailash@google.com>
---
This was discussed in [1] by Sami Tolvanen but was
never implemented.

[1] https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1

 drivers/md/dm-verity-target.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 22a5ac82446a..a6f7c452ee80 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -475,6 +475,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct bvec_iter start;
 	unsigned b;
 	struct crypto_wait wait;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
@@ -529,9 +530,17 @@ static int verity_verify_io(struct dm_verity_io *io)
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					   cur_block, NULL, &start) == 0)
 			continue;
-		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
+		else {
+			if (bio->bi_status) {
+				/*
+				 * Error correction failed; Just return error
+				 */
+				return -EIO;
+			}
+			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
 					   cur_block))
-			return -EIO;
+				return -EIO;
+		}
 	}
 
 	return 0;
-- 
2.33.0.309.g3052b89438-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

