Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE497EB64DD
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jul 2023 02:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690769203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WxKYSEzD6qJeYZMVUO/TVyM7PvNAvbtqkGigNt5Mua8=;
	b=gDEwkJd4xGP2ATF/Oq+8zAd/uBt6BuUb2zxX2fhAWOPiNBITHmXP8dd6F0pR3zc0MA+0qj
	dZKccJdd+31TydCsrXjzyiU8f3cqP1DrgFD32kG3cTlWIqMl5ZouMyRxwSpUe3Wv8wLcdW
	hCtjW0LLQM3MSRsHjTg/qYATydMXNIw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-BPhqjZs7PvyFEt59Vue2eg-1; Sun, 30 Jul 2023 22:06:39 -0400
X-MC-Unique: BPhqjZs7PvyFEt59Vue2eg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0EE180C4F8;
	Mon, 31 Jul 2023 02:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FBBDC57964;
	Mon, 31 Jul 2023 02:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FE841946588;
	Mon, 31 Jul 2023 02:06:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C84C1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 31 Jul 2023 02:06:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B582F7845; Mon, 31 Jul 2023 02:06:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73AC4F7849
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:06:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58C973806739
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:06:36 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-FrCkdGrLPau3sfZtNWjBNg-1; Sun, 30 Jul 2023 22:06:32 -0400
X-MC-Unique: FrCkdGrLPau3sfZtNWjBNg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 14F3E60E15;
 Mon, 31 Jul 2023 02:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA07DC433C9;
 Mon, 31 Jul 2023 02:06:30 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Date: Sun, 30 Jul 2023 22:06:28 -0400
Message-Id: <20230731020628.3807419-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] Patch "dm raid: protect md_stop() with 'reconfig_mutex'"
 has been added to the 5.10-stable tree
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
Cc: Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm raid: protect md_stop() with 'reconfig_mutex'

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-protect-md_stop-with-reconfig_mutex.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c9159a4596222955ffa558a871a0cfedfb439475
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Sat Jul 8 17:21:53 2023 +0800

    dm raid: protect md_stop() with 'reconfig_mutex'
    
    [ Upstream commit 7d5fff8982a2199d49ec067818af7d84d4f95ca0 ]
    
    __md_stop_writes() and __md_stop() will modify many fields that are
    protected by 'reconfig_mutex', and all the callers will grab
    'reconfig_mutex' except for md_stop().
    
    Also, update md_stop() to make certain 'reconfig_mutex' is held using
    lockdep_assert_held().
    
    Fixes: 9d09e663d550 ("dm: raid456 basic support")
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f3a489b1b6e9a..140bdf2a6ee11 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3305,8 +3305,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
 bad_unlock:
-	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 bad:
 	raid_set_free(rs);
 
@@ -3317,7 +3317,9 @@ static void raid_dtr(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	mddev_lock_nointr(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 	raid_set_free(rs);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae0a857d6076a..6efe49f7bdf5e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6316,6 +6316,8 @@ static void __md_stop(struct mddev *mddev)
 
 void md_stop(struct mddev *mddev)
 {
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

