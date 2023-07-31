Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92658C001DC
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jul 2023 02:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690769273;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FUTEsnckRqhj+x2wuXHOpbu/2EYQKN9Ff0sEUXMFmTk=;
	b=Q/aDf0wv4Xcpc5oMAVS1+/fcvCnkMwdpvhZqG1fp/cH4sH3IpPHlQJKx0gL2FtldmFSXYR
	ljrph67D3vHSfIpYV3gIa4ddbV25zVFH4KIcp7CTTgvlAATDRsOlQXMIPq4HjCkG274rEJ
	7Sh0wrnhloVVXVhZonC1+OtqVgzUJws=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-5Nf6ajafP4ewARkH_bw96Q-1; Sun, 30 Jul 2023 22:07:50 -0400
X-MC-Unique: 5Nf6ajafP4ewARkH_bw96Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 796141C06EC6;
	Mon, 31 Jul 2023 02:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27F072166B26;
	Mon, 31 Jul 2023 02:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0762E1946588;
	Mon, 31 Jul 2023 02:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E2631946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 31 Jul 2023 02:07:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 888BA4A9004; Mon, 31 Jul 2023 02:07:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8133B401061
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:07:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61EC5857FF8
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 02:07:46 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685--idtzbSIMPCyXL4J3ym_8Q-1; Sun, 30 Jul 2023 22:07:43 -0400
X-MC-Unique: -idtzbSIMPCyXL4J3ym_8Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 95F2560E06;
 Mon, 31 Jul 2023 02:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59591C433C7;
 Mon, 31 Jul 2023 02:07:41 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Date: Sun, 30 Jul 2023 22:07:39 -0400
Message-Id: <20230731020739.3808322-1-sashal@kernel.org>
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
Subject: [dm-devel] Patch "dm raid: fix missing reconfig_mutex unlock in
 raid_ctr() error paths" has been added to the 4.14-stable tree
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

    dm raid: fix missing reconfig_mutex unlock in raid_ctr() error paths

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-missing-reconfig_mutex-unlock-in-raid_ct.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 5bd837e565b35be3c6942eb7e5062a70b7613453
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Sat Jul 8 17:21:51 2023 +0800

    dm raid: fix missing reconfig_mutex unlock in raid_ctr() error paths
    
    [ Upstream commit bae3028799dc4f1109acc4df37c8ff06f2d8f1a0 ]
    
    In the error paths 'bad_stripe_cache' and 'bad_check_reshape',
    'reconfig_mutex' is still held after raid_ctr() returns.
    
    Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 025a36ddf26ec..b818cc982e624 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3190,15 +3190,19 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Try to adjust the raid4/5/6 stripe cache size to the stripe size */
 	if (rs_is_raid456(rs)) {
 		r = rs_set_raid456_stripe_cache(rs);
-		if (r)
+		if (r) {
+			mddev_unlock(&rs->md);
 			goto bad_stripe_cache;
+		}
 	}
 
 	/* Now do an early reshape check */
 	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		r = rs_check_reshape(rs);
-		if (r)
+		if (r) {
+			mddev_unlock(&rs->md);
 			goto bad_check_reshape;
+		}
 
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
@@ -3207,6 +3211,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = rs->md.pers->check_reshape(&rs->md);
 			if (r) {
 				ti->error = "Reshape check failed";
+				mddev_unlock(&rs->md);
 				goto bad_check_reshape;
 			}
 		}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

