Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABDAC77B7C
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683820703;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fdnE7u8RXlFkZk8XzzqkPHpZXy3Ns8/88gdvAohoaIw=;
	b=GOHYzkbeqgMD5+ErzTwrdORQHGlLDKNqkagGfo3H2SWGrnIl2adqHFAbu2ierxgiM3aw1K
	ZyY9fHEiPW/rw3Kg67ihateSHO+7c7xW+/dvup/H2UwHJdIGH78XkYa0PS8NuNuAN102BU
	+EXrveYtdjryeHUabTZM7cAZ7lpuTOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-TQmgIZaSO_yhWbRMhxYhKw-1; Thu, 11 May 2023 11:58:18 -0400
X-MC-Unique: TQmgIZaSO_yhWbRMhxYhKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF78C899688;
	Thu, 11 May 2023 15:58:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0DB04078906;
	Thu, 11 May 2023 15:58:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7AD019451D1;
	Thu, 11 May 2023 15:58:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D465019451D1
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9257492B07; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B10BE492C3F
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93F5A185A78B
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-phPBM0MJOaCM2mwMqNSH-Q-1; Thu, 11 May 2023 11:58:01 -0400
X-MC-Unique: phPBM0MJOaCM2mwMqNSH-Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D2AC264F61;
 Thu, 11 May 2023 15:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABCC433D2;
 Thu, 11 May 2023 15:52:42 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	akailash@google.com
Date: Thu, 11 May 2023 11:52:41 -0400
Message-Id: <20230511155241.574554-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] Patch "dm verity: skip redundant verity_handle_err() on
 I/O errors" has been added to the 5.4-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm verity: skip redundant verity_handle_err() on I/O errors

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-skip-redundant-verity_handle_err-on-i-o-er.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2c62be506cff39c7694a6cd3b0bb781c04d6e461
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
index 9dcdf34b7e32d..aad0018cc7b2d 100644
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

