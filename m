Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FA5C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-tYrm62S4Mfm_nLgNMaVcsQ-1; Fri, 11 Feb 2022 01:07:54 -0500
X-MC-Unique: tYrm62S4Mfm_nLgNMaVcsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4258835BC3;
	Fri, 11 Feb 2022 06:07:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F4475E24E;
	Fri, 11 Feb 2022 06:07:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 099494CA9B;
	Fri, 11 Feb 2022 06:07:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21A8VXqC002742 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 03:31:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8365440CFD74; Thu, 10 Feb 2022 08:31:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E97A40CFD45
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 08:31:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63CD510088A8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 08:31:33 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2136.outbound.protection.outlook.com [40.107.255.136])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-578--2cyEL5wM0qwlz3Ud0r9Fw-1; Thu, 10 Feb 2022 03:31:31 -0500
X-MC-Unique: -2cyEL5wM0qwlz3Ud0r9Fw-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PSAPR06MB4005.apcprd06.prod.outlook.com (2603:1096:301:3a::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Thu, 10 Feb 2022 08:31:27 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.011;
	Thu, 10 Feb 2022 08:31:26 +0000
From: Qing Wang <wangqing@vivo.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2022 00:31:14 -0800
Message-Id: <1644481874-14812-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: SG2PR06CA0131.apcprd06.prod.outlook.com
	(2603:1096:1:1d::33) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5f46a05-62e7-4c28-d48f-08d9ec6fba7d
X-MS-TrafficTypeDiagnostic: PSAPR06MB4005:EE_
X-Microsoft-Antispam-PRVS: <PSAPR06MB400546727DF61FEDA1DAE74BBD2F9@PSAPR06MB4005.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: U4bAOwGPVzRncR25sOpRb7nmyofZJ2XT7ToGKXUXrGvKeFi4rulJDMQHzi477p+/qPZR/tkn92idTuEe06CO9c0eu7+MinvElkMrdiaTqio6PX42xDysYTo/QUQEO8tGhjaTrH9KNEO44cntfleGAPtOgGTUyCUQh8YzE81XrC/0FqkfMLqJ/nu3O8Cmx2aFSkZdvNht+Q2ursKqTrcb5RaKpKpOtf2hvQZbzIWCcXn+qHYjsOt3hqf6S40T4YilEBidinG32slyadSw6qSA8s5Mo9NRa36eQfBMRSzCds1iLeWQ9LmW/j/oOprntsA9ShFaX5Vw3jhJetBdCkM3oYYOvn4XTkU5r3pK4oUZz5Te5uMIaa/IUK7PvGiptNuUMV2KIpyS+h94+LexCyLfUiElfAabV8OeQrK8bX6ZKxwd6J5fa+ShGWaUN7Yf6+eLRU6g/9NuzHyFe/Z4NQTo1Y+x0ggIjIvKQzHfosVe+KG6+qbaKdur6I9n8okpQztVO61bukGW8AqXD6tawFSBTinr68+pnQlro0ag+voKOP6pMicGQfc1iMJAxPSkjg///M4l0xHUr1Bmc8w/w8ITY3B+kCPOhF8BmQFptwxep1LpTRJle1FXwqn2+oM6pjmh4xip+oYu6IlwxQsQpactdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(36756003)(508600001)(86362001)(316002)(6486002)(110136005)(186003)(2616005)(66476007)(26005)(83380400001)(107886003)(38350700002)(66556008)(52116002)(8936002)(38100700002)(6666004)(6512007)(6506007)(2906002)(8676002)(4744005)(5660300002)(66946007)(4326008)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: nqXdLOSssjdbWTEU3E/02CK6u+ogOgyehvk87xnGJFJPM26AUptxSBm1Q93Aiyoy7U0qttp8VyMwNIkwj6NMPyRoYzOtX/jo0l17Vo10c6CoA1YApTaZYKzAIDaDi/kDyZBBd4jrUygtIuRgLQOLko5TBorRBKZS3YZ0ED1FA4QlK3Gic9e6v3H8mz+lQ7yubLbrKMrUk9OJ5Re6pNpcurstXAx5ImdPy/F6+DMZ1e385v4Aq8FTFTQhU0imryXlz8OFJ0lBmbPFvqXOYqmNfF+hyOgkvUZjOEE3RzDd5AcutaGKY4v2C6TpNMh/vgKDNHHv/m+SdaDt0J+AtqTxtLVc6WGMb3Hej5qcFtXnLDhTfJsOIeTNDDRtLT1T6N6aNA3tKcTi9QkEPoq5qF5Dp9HfA4QgtpiuPZvTIsF25nmU3wTWDWWpsib0fZJxMjiO
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f46a05-62e7-4c28-d48f-08d9ec6fba7d
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:31:26.8344 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wWhOFB6T7a5UNykUA/3oMEzCZq5pl98sf+ogzE1/ZyCokqKYoi4Lofn0dO2fZfrCtmkQ/3616ADAtgJGv6B87A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4005
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f4234d6..dced764
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -161,7 +161,7 @@ static void throttle_work_start(struct throttle *t)
 
 static void throttle_work_update(struct throttle *t)
 {
-	if (!t->throttle_applied && jiffies > t->threshold) {
+	if (!t->throttle_applied && time_after(jiffies, t->threshold)) {
 		down_write(&t->lock);
 		t->throttle_applied = true;
 	}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

