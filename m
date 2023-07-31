Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 634BEEB64DD
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jul 2023 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690769152;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OOExKRe0r103SWGoIx0JoWtZ3BCTbaGpppXpVNKyzU8=;
	b=F8lagTWFo1tBWGB9Dccr7Lb2XPmVr8ST+bjBB70H4WfCAX7XiRFeLcqi/7oZo8FdvDc6TE
	yAK9nU9F1/WUEqsPVmb45EGimSBLkuJdw8Xt5zmPh3d8cp5nft9CxlZeF5x0BmEHyS2seU
	DHYe5OSDMXzE0g2NI6uK0t9Gvv44o9k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-CDi5RW9qMsat0SJ4fHp33w-1; Sun, 30 Jul 2023 22:05:48 -0400
X-MC-Unique: CDi5RW9qMsat0SJ4fHp33w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEDF4895684;
	Mon, 31 Jul 2023 02:05:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B828E2166B25;
	Mon, 31 Jul 2023 02:05:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F4201946588;
	Mon, 31 Jul 2023 02:05:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69B851946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 31 Jul 2023 02:05:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47CFA207B33B; Mon, 31 Jul 2023 02:05:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F914207B33A
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:05:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D4398910EF
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:05:45 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-nBv-Z62QOJ-L44vKAVicBQ-1; Sun, 30 Jul 2023 22:05:43 -0400
X-MC-Unique: nBv-Z62QOJ-L44vKAVicBQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5F27560E0B;
 Mon, 31 Jul 2023 02:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44081C433C8;
 Mon, 31 Jul 2023 02:05:41 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Date: Sun, 30 Jul 2023 22:05:39 -0400
Message-Id: <20230731020539.3806814-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] Patch "dm raid: clean up four equivalent goto tags in
 raid_ctr()" has been added to the 5.15-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm raid: clean up four equivalent goto tags in raid_ctr()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-clean-up-four-equivalent-goto-tags-in-raid_c.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 74d177c0d3f85791a134a8ffb212cc33211446e0
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Sat Jul 8 17:21:52 2023 +0800

    dm raid: clean up four equivalent goto tags in raid_ctr()
    
    [ Upstream commit e74c874eabe2e9173a8fbdad616cd89c70eb8ffd ]
    
    There are four equivalent goto tags in raid_ctr(), clean them up to
    use just one.
    
    There is no functional change and this is preparation to fix
    raid_ctr()'s unprotected md_stop().
    
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Stable-dep-of: 7d5fff8982a2 ("dm raid: protect md_stop() with 'reconfig_mutex'")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index d3ac3b894bdf5..6d4e287350a33 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3258,8 +3258,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	r = md_start(&rs->md);
 	if (r) {
 		ti->error = "Failed to start raid array";
-		mddev_unlock(&rs->md);
-		goto bad_md_start;
+		goto bad_unlock;
 	}
 
 	/* If raid4/5/6 journal mode explicitly requested (only possible with journal dev) -> set it */
@@ -3267,8 +3266,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
 		if (r) {
 			ti->error = "Failed to set raid4/5/6 journal mode";
-			mddev_unlock(&rs->md);
-			goto bad_journal_mode_set;
+			goto bad_unlock;
 		}
 	}
 
@@ -3278,19 +3276,15 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Try to adjust the raid4/5/6 stripe cache size to the stripe size */
 	if (rs_is_raid456(rs)) {
 		r = rs_set_raid456_stripe_cache(rs);
-		if (r) {
-			mddev_unlock(&rs->md);
-			goto bad_stripe_cache;
-		}
+		if (r)
+			goto bad_unlock;
 	}
 
 	/* Now do an early reshape check */
 	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		r = rs_check_reshape(rs);
-		if (r) {
-			mddev_unlock(&rs->md);
-			goto bad_check_reshape;
-		}
+		if (r)
+			goto bad_unlock;
 
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
@@ -3299,8 +3293,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = rs->md.pers->check_reshape(&rs->md);
 			if (r) {
 				ti->error = "Reshape check failed";
-				mddev_unlock(&rs->md);
-				goto bad_check_reshape;
+				goto bad_unlock;
 			}
 		}
 	}
@@ -3311,10 +3304,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mddev_unlock(&rs->md);
 	return 0;
 
-bad_md_start:
-bad_journal_mode_set:
-bad_stripe_cache:
-bad_check_reshape:
+bad_unlock:
+	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
 bad:
 	raid_set_free(rs);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

