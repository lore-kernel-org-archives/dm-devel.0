Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58D6C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:45:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C12622D74
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C12622D74
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-ZVJnkU9ePBCBKdoZyGYggA-1; Thu, 10 Dec 2020 09:44:56 -0500
X-MC-Unique: ZVJnkU9ePBCBKdoZyGYggA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68B7D107ACE6;
	Thu, 10 Dec 2020 14:44:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AB7310021AA;
	Thu, 10 Dec 2020 14:44:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1CB504EA6C;
	Thu, 10 Dec 2020 14:44:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B9M4VxL004733 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 17:04:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 807649D471; Wed,  9 Dec 2020 22:04:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79D2A9D468
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 22:04:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC0E0858284
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 22:04:20 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-194-mt03JtMNPf--xWgvgBI1Ow-1; Wed, 09 Dec 2020 17:04:09 -0500
X-MC-Unique: mt03JtMNPf--xWgvgBI1Ow-1
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0B9M2tLv006941
	for <dm-devel@redhat.com>; Wed, 9 Dec 2020 14:04:08 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net with ESMTP id 35arhddteu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT)
	for <dm-devel@redhat.com>; Wed, 09 Dec 2020 14:04:08 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
	mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.1979.3; Wed, 9 Dec 2020 13:58:45 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
	id 9C5F362E51F1; Wed,  9 Dec 2020 13:58:22 -0800 (PST)
From: Song Liu <songliubraving@fb.com>
To: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dm-devel@redhat.com>
Date: Wed, 9 Dec 2020 13:58:14 -0800
Message-ID: <20201209215814.2623617-1-songliubraving@fb.com>
X-FB-Internal: Safe
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-09_18:2020-12-09,
	2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
	clxscore=1011
	adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=822
	priorityscore=1501 lowpriorityscore=0 impostorscore=0 bulkscore=0
	spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
	scancount=1
	engine=8.12.0-2009150000 definitions=main-2012090151
X-FB-Internal: deliver
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B9M4VxL004733
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Dec 2020 09:44:21 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	Xiao Ni <xni@redhat.com>, Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: [dm-devel] [PATCH] Revert "dm raid: remove unnecessary discard
	limits for raid10"
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This reverts commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28.

Matthew Ruffell reported data corruption in raid10 due to the changes
in discard handling [1]. Revert these changes before we find a proper fix.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/dm-raid.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9c1f7c4de65b3..dc8568ab96f24 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3728,6 +3728,17 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	blk_limits_io_min(limits, chunk_size_bytes);
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
+
+	/*
+	 * RAID10 personality requires bio splitting,
+	 * RAID0/1/4/5/6 don't and process large discard bios properly.
+	 */
+	if (rs_is_raid10(rs)) {
+		limits->discard_granularity = max(chunk_size_bytes,
+						  limits->discard_granularity);
+		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
+							   limits->max_discard_sectors);
+	}
 }
 
 static void raid_postsuspend(struct dm_target *ti)
-- 
2.24.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

