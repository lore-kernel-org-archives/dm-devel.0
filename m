Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AAAC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 22 Jun 2022 06:47:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608--fe5FxsCN3KNA7FetuS0Vw-1; Wed, 22 Jun 2022 02:46:11 -0400
X-MC-Unique: -fe5FxsCN3KNA7FetuS0Vw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC08E1C06EDE;
	Wed, 22 Jun 2022 06:46:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F014640E80E0;
	Wed, 22 Jun 2022 06:46:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05EED1947057;
	Wed, 22 Jun 2022 06:46:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 714E81947041
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Jun 2022 11:32:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F491141510D; Tue, 21 Jun 2022 11:32:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B4F9141510C
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 11:32:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4762A3C1014A
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 11:32:53 +0000 (UTC)
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-s9QzS46DPVCQ3_ebpKgRlg-1; Tue, 21 Jun 2022 07:32:51 -0400
X-MC-Unique: s9QzS46DPVCQ3_ebpKgRlg-1
X-QQ-mid: bizesmtp74t1655811164tal19zhj
Received: from ubuntu.localdomain ( [106.117.99.68])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Tue, 21 Jun 2022 19:32:37 +0800 (CST)
X-QQ-SSF: 0100000000700040B000B00A0000000
X-QQ-FEAT: ZHWZeLXy+8d2xuswuyUwRi0lS84veAPfD6Hezb0MfVUM+ugSTumRnET3T1Yk3
 EYFF/an33BSniNIqs89pyDNLXWfNAWQ+jqYXe4IW2NpwK3FcYWvKX+hgfO8o5PXAN/l0N/j
 vMXHKqblTjZfRCpcJwCHfoQJXxECYVT7qmrrWErWN6FXEby5stq1LXGTYZskBvlw7at8KiF
 Lf53+44eAqHJSk74ag1cm2pZPObUfeLb1y4gVPIWomiBMqZE5Sd2iUOpO3YhuS8eO3q8khH
 SazdqzbI/I+HO19KBZr+pAwAi+WpOr1TKfQFxR4fhaopp57+vOlHh3gLuEMlTDdYz+ffMP1
 0aSgsfJvjphvdyw/uu4Fvf/wXejmA==
X-QQ-GoodBg: 0
From: Jiang Jian <jiangjian@cdjrlc.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Tue, 21 Jun 2022 19:32:34 +0800
Message-Id: <20220621113234.99140-1-jiangjian@cdjrlc.com>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 22 Jun 2022 06:46:06 +0000
Subject: [dm-devel] [PATCH] dm raid: drop unexpected word "the" in the
 comments
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
Cc: Jiang Jian <jiangjian@cdjrlc.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

there is an unexpected word "the" in the comments that need to be dropped

file: drivers/md/dm-raid.c
line: 1370
 /* Userspace passes new data_offset after having extended the data image LV */

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9526ccbedafb..a438efc70e87 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1367,7 +1367,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			}
 			rs->md.bitmap_info.daemon_sleep = value;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_DATA_OFFSET))) {
-			/* Userspace passes new data_offset after having extended the the data image LV */
+			/* Userspace passes new data_offset after having extended the data image LV */
 			if (test_and_set_bit(__CTR_FLAG_DATA_OFFSET, &rs->ctr_flags)) {
 				rs->ti->error = "Only one data_offset argument pair allowed";
 				return -EINVAL;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

