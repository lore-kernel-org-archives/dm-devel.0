Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2753BC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 27 Jun 2022 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656338168;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6seFpXLKJKz7fFooS/zmo0E6Ygri8jb3aF16U8f8GMk=;
	b=VhIBaSPToSpclka4fO685+moPcLkyseGEP1pxtX+zpayQ6GxL4BpIZGbiIZE3EvHgtO0rf
	qqZ3Fnsod7hZqKibobCR5lRLdc1wKB5R7qvIAQNd1wMe+SJxDU8p7K6EEeVkcgU1QoGsyW
	SHRfGezvMiiXnKk1lfzKlsZgGR9H+Sk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-htuwtXl6MyWyUE2nM-EqKQ-1; Mon, 27 Jun 2022 09:56:04 -0400
X-MC-Unique: htuwtXl6MyWyUE2nM-EqKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AE973817A71;
	Mon, 27 Jun 2022 13:56:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2772166B26;
	Mon, 27 Jun 2022 13:56:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 647451947040;
	Mon, 27 Jun 2022 13:56:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8CF3619466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 13:56:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C74F492CAA; Mon, 27 Jun 2022 13:56:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 651F0492CA3;
 Mon, 27 Jun 2022 13:56:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 25RDu0Av016820; Mon, 27 Jun 2022 09:56:00 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 25RDu06O016816; Mon, 27 Jun 2022 09:56:00 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 27 Jun 2022 09:56:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
In-Reply-To: <CAM23VxqOH9SeZFvfbFD2zUF_WFDUVY1Xh0ngp_1E+7n=7+7TUQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2206270954570.16147@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2206270858520.13562@file01.intranet.prod.int.rdu2.redhat.com>
 <CAM23VxqOH9SeZFvfbFD2zUF_WFDUVY1Xh0ngp_1E+7n=7+7TUQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2] dm-raid: fix out of memory accesses in dm-raid
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Marian Csontos <mcsontos@redhat.com>,
 linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
 dm-devel@redhat.com, Ming Lei <minlei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-raid allocates the array of devices with rs->raid_disks entries and
then accesses it in a loop for rs->md.raid_disks. During reshaping,
rs->md.raid_disks may be greater than rs->raid_disks, so it accesses
entries beyond the end of the array.

We fix this bug by limiting the iteration to rs->raid_disks.

The bug is triggered when running lvm test shell/lvconvert-raid.sh and the
kernel is compiled with kasan.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2022-06-27 15:44:12.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid.c	2022-06-27 15:44:12.000000000 +0200
@@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru
 	unsigned int rebuilds_per_group = 0, copies;
 	unsigned int group_size, last_group_start;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
+	for (i = 0; i < rs->raid_disks; i++)
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
 		    !rs->dev[i].rdev.sb_page)
 			rebuild_cnt++;
@@ -1047,7 +1047,7 @@ static int validate_raid_redundancy(stru
 		 *	    C	 D    D	   E	E
 		 */
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->md.raid_disks; i++) {
+			for (i = 0; i < rs->raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1073,7 +1073,7 @@ static int validate_raid_redundancy(stru
 		group_size = (rs->md.raid_disks / copies);
 		last_group_start = (rs->md.raid_disks / group_size) - 1;
 		last_group_start *= group_size;
-		for (i = 0; i < rs->md.raid_disks; i++) {
+		for (i = 0; i < rs->raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
 			if ((!rs->dev[i].rdev.sb_page ||
@@ -1588,7 +1588,7 @@ static sector_t __rdev_sectors(struct ra
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		struct md_rdev *rdev = &rs->dev[i].rdev;
 
 		if (!test_bit(Journal, &rdev->flags) &&
@@ -3766,7 +3766,7 @@ static int raid_iterate_devices(struct d
 	unsigned int i;
 	int r = 0;
 
-	for (i = 0; !r && i < rs->md.raid_disks; i++)
+	for (i = 0; !r && i < rs->raid_disks; i++)
 		if (rs->dev[i].data_dev)
 			r = fn(ti,
 				 rs->dev[i].data_dev,
@@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_de
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		/* HM FIXME: enhance journal device recovery processing */
 		if (test_bit(Journal, &r->flags))

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

