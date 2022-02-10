Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C863AC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:07:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-TKw67g95MmuYmwNAPY8Zeg-1; Fri, 11 Feb 2022 01:07:54 -0500
X-MC-Unique: TKw67g95MmuYmwNAPY8Zeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4B181F019;
	Fri, 11 Feb 2022 06:07:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA9327A22C;
	Fri, 11 Feb 2022 06:07:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 098BE1809CB8;
	Fri, 11 Feb 2022 06:07:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21A8VuQe002778 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 03:31:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1B3F140240C; Thu, 10 Feb 2022 08:31:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD050142B966
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 08:31:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A491C3C01DB0
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 08:31:56 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2115.outbound.protection.outlook.com [40.107.255.115])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-196-5lk0PCuHNFG4tiSEzADXNA-1; Thu, 10 Feb 2022 03:31:53 -0500
X-MC-Unique: 5lk0PCuHNFG4tiSEzADXNA-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PSAPR06MB4005.apcprd06.prod.outlook.com (2603:1096:301:3a::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Thu, 10 Feb 2022 08:31:50 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.011;
	Thu, 10 Feb 2022 08:31:50 +0000
From: Qing Wang <wangqing@vivo.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2022 00:31:37 -0800
Message-Id: <1644481897-14862-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: SG2PR06CA0123.apcprd06.prod.outlook.com
	(2603:1096:1:1d::25) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56401447-81e9-4372-2365-08d9ec6fc852
X-MS-TrafficTypeDiagnostic: PSAPR06MB4005:EE_
X-Microsoft-Antispam-PRVS: <PSAPR06MB4005B03398696A436D766E26BD2F9@PSAPR06MB4005.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 41mzeBTVMosngCND81i40R/k7Z3JwLYmXuhelSRHgET4XaRF7p3SEzVuaAel0Dtzg6wJEp1tOwrRXaLQeXpRG0IpGmfP/zxsc5Et+KvINlnTgWja8RhwLoKAU9tbE3DWCkGLsxrO0lIN8c1VbVOKIYNR/TbGy3bJH5LoG1YDV44SuexDAyzsQCo6uCdEo4jq8jcN9TtPMhxP+QygOTbwBkQIU2f7MjUD0onpnHywBXWqG4dokUVZ9A8RlNOknLrPzyaVWerwthD1Gdl6xKxy6X5LxEnyOJFmcPd2dcDxvDj1aRtFocC2mAwW/eyhbBboctuQMvDUscogofNrqWVHF19G5SpqONCns+P/XG7oSePRGI5j2mKxITMqL83O7sKppb2qCpwSqzrGBiw+Dv0oKo06QCFKDb1QpTTm5CSOEB3AjNIDCepEDnt5EZ5kcmCdfik7VdJsaFNm186AUgKgalDx66jdwiLoRdgFhW068Z9HPGXfSErNI4XVqb0yTTeXFKZQiujm2jaP6L/NQsb/687CowZ6h7/SUkK+pR1fMXYEBAONrfn8JOZPo7fEu4SQSq79Ddla/DaBUNX4sAVX2v3zwbrnKv7IVgBiGX50SE/NneL59TDgQ67UAKimoGJKmsZJzhhB0r2r5A5GQcWMcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(36756003)(508600001)(86362001)(316002)(6486002)(110136005)(186003)(2616005)(66476007)(26005)(83380400001)(107886003)(38350700002)(66556008)(52116002)(8936002)(38100700002)(6666004)(6512007)(6506007)(2906002)(8676002)(5660300002)(66946007)(4326008)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: yKYBhp2Vp2kNDCcSLmPBOpAyfWSZueit588xShKP2bGuLrCwlNnrr8Yiln4uO7PxqQ9vWsmiMC887QKDw+Uud8dlTEuwIHOb62w/zYD+HqVxNhyis79XSA6a3KIVGi35Q7Jwpv97Z5wqYziq5EHB59qvakEKnhOqucCX7TC37BTo741dWUDl+xZogZAY+ZTpGZnD4tOgdPGtaPb1WtKrCVp2szov7ALABiP741OmvOCCQCvLdvwTfHK1XG0pNcpZ30lac0igIDmVt7CdP6IJSHmn7dt6eHdbZ69Y21YDq7UhgbcMzDx0gy4hoYks+8KxcZRgtYrK1OCv8CWmmieoCG2Ep6aTwMD0e4z3pQyYpFIz2ZyvU6zZ326F6U7blC4NeLRjDFJ1mmBuU3CQicPel+tYdwC/JeZL5X0E1TEac4IfF2VYU7ipZFlIRIJgPpde
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56401447-81e9-4372-2365-08d9ec6fc852
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:31:49.9736 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmQigH0SGOH8ukl/buZSBMo5RCfbvFrq3LnCE7XzPatpTGwjTLmhhcaVJVVi6pp6kvgxDMa3TYNqW/3X9bhUnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4005
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH] md: use time_after_eq() instead of jiffies
	judgment
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Wang Qing <wangqing@vivo.com>

It is better to use time_xxx() directly instead of jiffies judgment
for understanding.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/md/dm-writecache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5630b47..125bb5d
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -16,6 +16,7 @@
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "dm-io-tracker.h"
 
 #define DM_MSG_PREFIX "writecache"
@@ -1971,8 +1972,8 @@ static void writecache_writeback(struct work_struct *work)
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
-		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
+		time_after_eq(jiffies, container_of(wc->lru.prev, struct wc_entry, lru)->age +
+		 wc->max_age - wc->max_age / MAX_AGE_DIV)) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

