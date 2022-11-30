Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42060C352A1
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 13:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669815082;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kZ3pCuIQ3P/S/PPOZOk3BbdUG93C/repFzDv60KnZzQ=;
	b=VoIwvkqm7AUGt6WaiTsXYi/+CZgfEnaKOMYjdNXgqIMovdMG9RxVbLDjESoDNhiix6f3IP
	2nzxtXFs/yMSgSOsF777fczZEGOxuiyG2sWW0p/Uhj1ckPzToTlApfkDkmB2/b8MLkbbAx
	jP4f9CkCV2oEDBClazh0YHRtJyribmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-Ra1fxeWePcG2dmV4B3amqw-1; Wed, 30 Nov 2022 08:31:18 -0500
X-MC-Unique: Ra1fxeWePcG2dmV4B3amqw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56D20886073;
	Wed, 30 Nov 2022 13:31:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AE9B4A9254;
	Wed, 30 Nov 2022 13:31:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 885D819465A8;
	Wed, 30 Nov 2022 13:31:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 99CEA19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 12:58:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 878C62166B3A; Wed, 30 Nov 2022 12:58:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 803D92166B26
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 12:58:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632B138035A8
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 12:58:08 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-wEuVumX8OxuFuuy2PVQ-hw-1; Wed, 30 Nov 2022 07:58:06 -0500
X-MC-Unique: wEuVumX8OxuFuuy2PVQ-hw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 76BDC61A02;
 Wed, 30 Nov 2022 12:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45663C433D6;
 Wed, 30 Nov 2022 12:58:04 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Date: Wed, 30 Nov 2022 07:58:02 -0500
Message-Id: <20221130125802.28606-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] Patch "dm integrity: clear the journal on suspend" has
 been added to the 6.0-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm integrity: clear the journal on suspend

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-clear-the-journal-on-suspend.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e2db1c738c2945f7e1f867459a32db110527dc48
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Nov 15 12:51:50 2022 -0500

    dm integrity: clear the journal on suspend
    
    [ Upstream commit 984bf2cc531e778e49298fdf6730e0396166aa21 ]
    
    There was a problem that a user burned a dm-integrity image on CDROM
    and could not activate it because it had a non-empty journal.
    
    Fix this problem by flushing the journal (done by the previous commit)
    and clearing the journal (done by this commit). Once the journal is
    cleared, dm-integrity won't attempt to replay it on the next
    activation.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index f26a6cd09e0c..e97e9f97456d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -263,6 +263,7 @@ struct dm_integrity_c {
 
 	struct completion crypto_backoff;
 
+	bool wrote_to_journal;
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
@@ -2375,6 +2376,8 @@ static void integrity_commit(struct work_struct *w)
 	if (!commit_sections)
 		goto release_flush_bios;
 
+	ic->wrote_to_journal = true;
+
 	i = commit_start;
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
@@ -3100,6 +3103,14 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
+		if (ic->wrote_to_journal) {
+			init_journal(ic, ic->free_section,
+				     ic->journal_sections - ic->free_section, ic->commit_seq);
+			if (ic->free_section) {
+				init_journal(ic, 0, ic->free_section,
+					     next_commit_seq(ic->commit_seq));
+			}
+		}
 	}
 
 	if (ic->mode == 'B') {
@@ -3127,6 +3138,8 @@ static void dm_integrity_resume(struct dm_target *ti)
 
 	DEBUG_print("resume\n");
 
+	ic->wrote_to_journal = false;
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

