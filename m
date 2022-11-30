Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B5FC4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795300;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s4RdacpilgUl//uKXpMKYiwGcgHB6ecDSvQdea3v5Gs=;
	b=ct+smxrYiNd/fuVpTpKH2oXUovK3ab56Pg9msSPa6Ygh9qoygMc67SSYDkAsIR2taMPQln
	+pwTuDbf2ID0GcSFSU652TGvH1+/auUiKtHppMLHS7GuMUQ38YcJqZoBLyEeViw5ThuDRq
	rVGR5V29vE2e1w1R9NVqs0fwdgJ4Ass=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-SBO5yj4VNH6kUFBFbqRNkA-1; Wed, 30 Nov 2022 03:01:39 -0500
X-MC-Unique: SBO5yj4VNH6kUFBFbqRNkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F28C801585;
	Wed, 30 Nov 2022 08:01:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 755E440C2066;
	Wed, 30 Nov 2022 08:01:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCA7119465A2;
	Wed, 30 Nov 2022 08:01:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9541219465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 07:42:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32BF3C15BB4; Wed, 30 Nov 2022 07:42:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BAEAC15BA4
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 07:42:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11FD9858F17
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 07:42:45 +0000 (UTC)
Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-u8YYw7MNMnO0QmFPKwn7Gw-1; Wed, 30 Nov 2022 02:42:43 -0500
X-MC-Unique: u8YYw7MNMnO0QmFPKwn7Gw-1
Received: from mxde.zte.com.cn (unknown [10.35.20.165])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mxct.zte.com.cn (FangMail) with ESMTPS id 4NMWGb1XvHzK84;
 Wed, 30 Nov 2022 15:36:07 +0800 (CST)
Received: from mxus.zte.com.cn (unknown [10.207.168.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mxde.zte.com.cn (FangMail) with ESMTPS id 4NMWG93h4hz4xD1k;
 Wed, 30 Nov 2022 15:35:45 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mxus.zte.com.cn (FangMail) with ESMTPS id 4NMWG33qsxzdmYkl;
 Wed, 30 Nov 2022 15:35:39 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NMWFv3J2fz5BNRf;
 Wed, 30 Nov 2022 15:35:31 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
 by mse-fl1.zte.com.cn with SMTP id 2AU7ZELP093349;
 Wed, 30 Nov 2022 15:35:14 +0800 (+08)
 (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null]) by mapi (Zmail) with MAPI id mid31;
 Wed, 30 Nov 2022 15:35:17 +0800 (CST)
Date: Wed, 30 Nov 2022 15:35:17 +0800 (CST)
X-Zmail-TransId: 2af9638707b54cb41bce
Message-ID: <202211301535171577902@zte.com.cn>
Mime-Version: 1.0
From: <zhang.songyi@zte.com.cn>
To: <agk@redhat.com>
X-MAIL: mse-fl1.zte.com.cn 2AU7ZELP093349
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.14.novalocal with ID
 638707E6.000 by FangMail milter!
X-FangMail-Envelope: 1669793767/4NMWGb1XvHzK84/638707E6.000/10.35.20.165/[10.35.20.165]/mxde.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638707E6.000/4NMWGb1XvHzK84
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
Subject: [dm-devel] =?utf-8?q?=5BPATCH_linux-next=5D_dm=3A_remove_redunda?=
 =?utf-8?q?nt_sz_variable?=
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 zhang.songyi@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: zhang songyi <zhang.songyi@zte.com.cn>

Return value from hst_status() directly instead of taking
this in another redundant variable.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 drivers/md/dm-ps-historical-service-time.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 1d82c95d323d..6c8e83ad2662 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -237,7 +237,6 @@ static void hst_destroy(struct path_selector *ps)
 static int hst_status(struct path_selector *ps, struct dm_path *path,
                     status_type_t type, char *result, unsigned int maxlen)
 {
-       unsigned int sz = 0;
        struct path_info *pi;

        if (!path) {
@@ -261,7 +260,7 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
                }
        }

-       return sz;
+       return 0;
 }

 static int hst_add_path(struct path_selector *ps, struct dm_path *path,
--
2.15.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

