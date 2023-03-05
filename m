Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41F3C678D5
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 02:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677982730;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s61ZXP0b+TDAQL57Lkkd2diCa3kqw9Ish/G4t+1u2vI=;
	b=L3JVZhr1dl3Pp+qZ84xGWls4gLhNT9DmZZ4cm9sfTC3bU5GLZUyaGCA/iuj7KZuHyMvdkK
	ePBtjTlpRtDcDnK3Smd96+ugH66KuLZFfs1vRZAlNfs1jOQAzLMhhb+lj8a1wh9p+qDKY7
	C1z+E+hyP+DukJp0h+qmysicep2nm8s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478--oQqVTt8OdqI1DyyNsz3jA-1; Sat, 04 Mar 2023 21:18:49 -0500
X-MC-Unique: -oQqVTt8OdqI1DyyNsz3jA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F7D085D062;
	Sun,  5 Mar 2023 02:18:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B4FBC492C14;
	Sun,  5 Mar 2023 02:18:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E3761946594;
	Sun,  5 Mar 2023 02:18:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D88921946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 02:18:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE446492B00; Sun,  5 Mar 2023 02:18:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A764C492C3E
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 02:18:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C2B7101A52E
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 02:18:44 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-OzVqbfwvOK6r9L8yuea8gQ-1; Sat, 04 Mar 2023 21:18:41 -0500
X-MC-Unique: OzVqbfwvOK6r9L8yuea8gQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4D474B8094B;
 Sun,  5 Mar 2023 02:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF3AC433EF;
 Sun,  5 Mar 2023 02:18:38 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Date: Sat,  4 Mar 2023 21:18:36 -0500
Message-Id: <20230305021836.1702854-1-sashal@kernel.org>
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
Subject: [dm-devel] Patch "dm: improve shrinker debug names" has been added
 to the 6.2-stable tree
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: improve shrinker debug names

to the 6.2-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-improve-shrinker-debug-names.patch
and it can be found in the queue-6.2 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 532b9a20ec187359497de3abd95b061e18ce0b68
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Wed Jan 25 13:01:46 2023 -0500

    dm: improve shrinker debug names
    
    [ Upstream commit c87791bcc455a91e51ca9800faaacc21c8d67785 ]
    
    Commit e33c267ab70d ("mm: shrinkers: provide shrinkers with names")
    chose some fairly bad names for DM's shrinkers.
    
    Fixes: e33c267ab70d ("mm: shrinkers: provide shrinkers with names")
    Signed-off-by : Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bb786c39545ec..19caaf684ee34 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1833,7 +1833,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->shrinker.scan_objects = dm_bufio_shrink_scan;
 	c->shrinker.seeks = 1;
 	c->shrinker.batch = 0;
-	r = register_shrinker(&c->shrinker, "md-%s:(%u:%u)", slab_name,
+	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
 			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 	if (r)
 		goto bad;
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 0278482fac94a..c795ea7da7917 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2945,7 +2945,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	zmd->mblk_shrinker.seeks = DEFAULT_SEEKS;
 
 	/* Metadata cache shrinker */
-	ret = register_shrinker(&zmd->mblk_shrinker, "md-meta:(%u:%u)",
+	ret = register_shrinker(&zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
 				MAJOR(dev->bdev->bd_dev),
 				MINOR(dev->bdev->bd_dev));
 	if (ret) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

