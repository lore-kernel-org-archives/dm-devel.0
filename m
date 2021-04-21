Return-Path: <SRS0=/8Iv=JS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A98C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 21:32:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1916A613D1
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 21:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1916A613D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619040778;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iCoM9xhWplLgm7vsJwwfb7AXssf4VAu+e5B/qsGlv9c=;
	b=AznZrpjzSXjTuFKFzqIbgw952UQv8xE7LvW9UXCnHssXkA0DjiG3poXgGDpJMOEyb+toUp
	B1wV/B1QxiNymGqNjb4dgPQyaUMLrbyXXtXKPalr9y/dKwtlRFlDOT3ppiSNqZZXxPvo8w
	YfLldL7+3XGjzjaiGvMj9bwP6W0WcJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-EmPDtaf0OHyG8neyVeRdoQ-1; Wed, 21 Apr 2021 17:32:55 -0400
X-MC-Unique: EmPDtaf0OHyG8neyVeRdoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84687107ACCD;
	Wed, 21 Apr 2021 21:32:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA77C10016DB;
	Wed, 21 Apr 2021 21:32:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 845BF1806D1A;
	Wed, 21 Apr 2021 21:32:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13LLWiwS010955 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Apr 2021 17:32:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D7C15610F1; Wed, 21 Apr 2021 21:32:44 +0000 (UTC)
Received: from o.ww.redhat.com (ovpn-112-42.ams2.redhat.com [10.36.112.42])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DF8160C05;
	Wed, 21 Apr 2021 21:32:37 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@redhat.com
Date: Wed, 21 Apr 2021 23:32:36 +0200
Message-Id: <0fa9291505763839c6fec97c4de448857f387aa6.1619040704.git.heinzm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zkabelac@redhat.com
Subject: [dm-devel] [PATCH] dm raid: fix inclonclusive reshape layout
	induced on fast raid4/5/6 table reload sequences
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

In case fast table reloads occur during an ongoing reshape of raid4/5/6 devices as e.g. for raid5
in lvm2 test lvconvert-raid-reshape-stripes-load-reload.sh, the target may read a superblock
in a race window with the MD resync thread causing an inconclusive reshape state
to be read in its constructor.  This causes BUG_ON() to trigger in md_run() as in
"kernel BUG at drivers/md/raid5.c:7567!".

Scenario triggering the bug:

1. the MD sync thread calls end_reshape() from raid5_sync_request() when done reshaping.
   However end_reshape() _only_ updates the reshape position to MaxSector keeping the
   changed layout configuration though, i.e. any delta disks, chunk sector or RAID
   algorithm changes.  That inconclusive configuration is stored in the superblock.

2. dm-raid constructs a mapping loading named inconsistent superblock as of step 1 before step 3 is
   able to finish resetting the reshape state completely and calls md_run() which leads to mentioned
   bug in raid5.c.

3. the MD RAID personality's finish_reshape() is called which resets the reshape information on
   chunk sectors, delta disks etc. eentirely.  This explains why the bug is rarely seen on multi-core
   machines as finish_reshape() races with the dm-raid constructor thus may update the superblock before
   it gets loaded as of step 2.

Fix identifies inconclusive superblock content in the constructor and resets it before calling md_run()
factoring out identifying checks into rs_is_layout_change() to share in existing rs_reshape_requested()
and new rs_reset_inclonclusive_reshape().  Also enhance a comment and remove an empty line.

Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1916891
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cab12b2251ba..4443e277b005 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1868,6 +1868,14 @@ static bool rs_takeover_requested(struct raid_set *rs)
 	return rs->md.new_level != rs->md.level;
 }
 
+/* True if layout is set to reshape. */
+static bool rs_is_layout_change(struct raid_set *rs, bool use_mddev)
+{
+	return (use_mddev ? rs->md.delta_disks : rs->delta_disks) ||
+	       rs->md.new_layout != rs->md.layout ||
+	       rs->md.new_chunk_sectors != rs->md.chunk_sectors;
+}
+
 /* True if @rs is requested to reshape by ctr */
 static bool rs_reshape_requested(struct raid_set *rs)
 {
@@ -1880,9 +1888,7 @@ static bool rs_reshape_requested(struct raid_set *rs)
 	if (rs_is_raid0(rs))
 		return false;
 
-	change = mddev->new_layout != mddev->layout ||
-		 mddev->new_chunk_sectors != mddev->chunk_sectors ||
-		 rs->delta_disks;
+	change = rs_is_layout_change(rs, false);
 
 	/* Historical case to support raid1 reshape without delta disks */
 	if (rs_is_raid1(rs)) {
@@ -2926,6 +2932,22 @@ static int rs_setup_reshape(struct raid_set *rs)
 	return r;
 }
 
+/*
+ * Reshape:
+ *
+ * if the md resync thread has updated superblock with max reshape position at the end of
+ * a reshape but not (yet) reset the layout configuration changes -> reset the latter.
+ */
+static void rs_reset_inconclusive_reshape(struct raid_set *rs)
+{
+	if (!rs_is_reshaping(rs) && rs_is_layout_change(rs, true)) {
+		WARN_ON(1);
+		rs_set_cur(rs);
+		rs->md.delta_disks = 0;
+		rs->md.reshape_backwards = 0;
+	}
+}
+
 /*
  * Enable/disable discard support on RAID set depending on
  * RAID level and discard properties of underlying RAID members.
@@ -3212,11 +3234,14 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
+	/* Catch any inconclusive reshape superblock content. */
+	rs_reset_inconclusive_reshape(rs);
+
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = 1;
 	rs->md.in_sync = 1;
 
-	/* Keep array frozen */
+	/* Keep array frozen until resume. */
 	set_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 
 	/* Has to be held on running the array */
@@ -3230,7 +3255,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	r = md_start(&rs->md);
-
 	if (r) {
 		ti->error = "Failed to start raid array";
 		mddev_unlock(&rs->md);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

