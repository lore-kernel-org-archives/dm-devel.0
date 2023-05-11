Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F62C7EE22
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683820696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VyOEY17z+KmxUGVlPXM41ch5Khc22jf8eJxbp+8w0tE=;
	b=RpU6eTiLhEJ1Lc/UrIOkwYb0CjCym4JxtFSB2z2Ks5BzWjHnrfsyx7JE4P1Fjw9cA+qE5o
	rz0Xa8fJpgPMuqqkeTxud5gTTPduwbIDe7Ev5725WN2w+1ULOQoa81XBqA3WDZtmzkeKWo
	qdjrcPMopTrJhjqdioQDj2hodYmpgHY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-kWDPewPzMGOzos6pXAUewg-1; Thu, 11 May 2023 11:58:12 -0400
X-MC-Unique: kWDPewPzMGOzos6pXAUewg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D003B3813F4B;
	Thu, 11 May 2023 15:58:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04EDE2027179;
	Thu, 11 May 2023 15:58:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D87F19451D9;
	Thu, 11 May 2023 15:58:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEF0719451C7
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C59564078907; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE2A24078906
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F4693C02182
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-FAIaS2CIMxCs_Lpd9vN-EQ-1; Thu, 11 May 2023 11:58:01 -0400
X-MC-Unique: FAIaS2CIMxCs_Lpd9vN-EQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 44EDB64F65;
 Thu, 11 May 2023 15:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BBFC433EF;
 Thu, 11 May 2023 15:52:56 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	akailash@google.com
Date: Thu, 11 May 2023 11:52:55 -0400
Message-Id: <20230511155255.575001-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] Patch "dm verity: skip redundant verity_handle_err() on
 I/O errors" has been added to the 4.19-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm verity: skip redundant verity_handle_err() on I/O errors

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-skip-redundant-verity_handle_err-on-i-o-er.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a1f9c2619550df502a352b6381051bf6d76774b6
Author: Akilesh Kailash <akailash@google.com>
Date:   Mon Sep 13 09:26:42 2021 +0000

    dm verity: skip redundant verity_handle_err() on I/O errors
    
    [ Upstream commit 2c0468e054c0adb660ac055fc396622ec7235df9 ]
    
    Without FEC, dm-verity won't call verity_handle_err() when I/O fails,
    but with FEC enabled, it currently does even if an I/O error has
    occurred.
    
    If there is an I/O error and FEC correction fails, return the error
    instead of calling verity_handle_err() again.
    
    Suggested-by: Sami Tolvanen <samitolvanen@google.com>
    Signed-off-by: Akilesh Kailash <akailash@google.com>
    Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Stable-dep-of: e8c5d45f82ce ("dm verity: fix error handling for check_at_most_once on FEC")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 36945030520a9..08a135f7ef431 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -471,6 +471,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct bvec_iter start;
 	unsigned b;
 	struct crypto_wait wait;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
@@ -525,9 +526,17 @@ static int verity_verify_io(struct dm_verity_io *io)
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					   cur_block, NULL, &start) == 0)
 			continue;
-		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					   cur_block))
-			return -EIO;
+		else {
+			if (bio->bi_status) {
+				/*
+				 * Error correction failed; Just return error
+				 */
+				return -EIO;
+			}
+			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
+					      cur_block))
+				return -EIO;
+		}
 	}
 
 	return 0;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

