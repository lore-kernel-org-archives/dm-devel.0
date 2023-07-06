Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9121BC001E0
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971632;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=k3VOHZ72X8nWczS/1hdpGWRUh89ZsVpRmGVStiJdiic=;
	b=ejla8EsUPMgPqczPJiQtSt1aCzZ068yFKgCd8UxrMokfGoV/pNPYs+PbF0dajwdKq0Rgvr
	O0noCVMrlt/4rojJjVOqwdQsOZwna5Um+VvIl2fNrk7ycaVwbVVKR5dHOwpgBPwp00YMMZ
	64k8LooStum2wnDqjn6FdtaWm42vIMY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-lG1prpNOMbqay3p9uFPN-Q-1; Mon, 10 Jul 2023 02:47:09 -0400
X-MC-Unique: lG1prpNOMbqay3p9uFPN-Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1713887111;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA4B2492B03;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9797019451D1;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C77ED1946588
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Jul 2023 09:30:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EFCB2166B26; Thu,  6 Jul 2023 09:30:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65C672166B25
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 09:30:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 458FD185A78F
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 09:30:51 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com
 (mail-tyzapc01on2102.outbound.protection.outlook.com [40.107.117.102]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-5mIEcOFTM4ezYohpwYCwaw-1; Thu, 06 Jul 2023 05:30:49 -0400
X-MC-Unique: 5mIEcOFTM4ezYohpwYCwaw-1
Received: from TY0PR06MB5706.apcprd06.prod.outlook.com (2603:1096:400:272::6)
 by TY0PR06MB5077.apcprd06.prod.outlook.com (2603:1096:400:1bb::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 09:30:44 +0000
Received: from TY0PR06MB5706.apcprd06.prod.outlook.com
 ([fe80::d6ff:1295:38d7:a019]) by TY0PR06MB5706.apcprd06.prod.outlook.com
 ([fe80::d6ff:1295:38d7:a019%7]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 09:30:44 +0000
From: Zehao Zhang <zhangzehao@vivo.com>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Thu,  6 Jul 2023 17:30:35 +0800
Message-ID: <20230706093035.35685-1-zhangzehao@vivo.com>
X-ClientProxiedBy: SG2PR01CA0123.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::27) To TY0PR06MB5706.apcprd06.prod.outlook.com
 (2603:1096:400:272::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY0PR06MB5706:EE_|TY0PR06MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 225a0f14-5230-4701-8ca6-08db7e03ac7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kN7+gGkk7zj8VDOt8SXXuZRaB5/gKkaHwXU07Q0T4ATDzM0GvAJZKcpRDiu+EbmPjmMojjY6Myia516X8Ct/HvPSKxjt2IRiaSybA78rfDIE5tPVx0QMjWavzW1U02wkQ07Uty0DDIR6wxhW+HF4BLE6VUuVfaYIGfP5wS7nZmA9Uif9BxR8El1QRUtwksHlgRQrwAksrXKb9EAOV1o6/v4y3Z5tvFx4fV7j/BXTQ07km0XuouT1djyUXOtWfXPh7h7EBt4PrVBc9tXUk1IJWTI3zxn/3F2iS9jjD11FBD5b0jeW7TVIUX84gaL9a224pFPKAOzOTsYIeAUGUA3FkHTRR3E6KM0FEUu9CNuhYuFhZ0MzPL23m8d72qtTEXI2LL/o3aUvgJQAvv79KDnUVvWE7JuLYnCSQAost8mb8Dlo6DA0nzEhlq9yqOlp8R1d+zmETbfGzi+kHEjqtHf9zBF05f/14KbeBXbCj0lltmDebsCPxYSYUP6eTcZOiwBL03GjnSaMathUOCT/DgtJ9s/ChD+cb2U/Pnd5sfjzx18kGMXuaLSLRN42YXV+AH4/s/6tytqpMKarGvMi/ZnwM+JIq12ZyyNHrSKqznYvTRUX6miaJCYR+LqhvhfWIj4P
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:TY0PR06MB5706.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199021)(6506007)(41300700001)(38100700002)(6666004)(52116002)(83380400001)(1076003)(2616005)(107886003)(38350700002)(186003)(6512007)(86362001)(6486002)(316002)(478600001)(36756003)(66946007)(66476007)(4326008)(8936002)(66556008)(8676002)(2906002)(26005)(5660300002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/jh1mCth6K+7jgrMz8x+vkZJ5fJzVIDasiNVdcVlPPgMmdi7Z8uXqBEYL4iP?=
 =?us-ascii?Q?EwpDUL9Ff3U+9BCEAAmhmqeO5w9nTNWK4RDt0sEoByFDBPC+j3tvlVyIzvPz?=
 =?us-ascii?Q?X0ZVwStoT5e1tQtBW66gC335uhAJehIwrIofvoYHzX1isNoqbYwZ+Cy/hf0l?=
 =?us-ascii?Q?pWFFiWwmwO1vYhgw5paZEXPe2OsuF0kHC0eXwqMMcp6dqr8yd15dJgZWViMS?=
 =?us-ascii?Q?X4xcb+7st1eAdmMVJ0aNG1cGhvQw236u5XfP3tDF4pOFLeHPULoRxmgMInX4?=
 =?us-ascii?Q?hNWidYnhU8NJbGluXUDpRgzDTKkqX4xhQ1ZY9I8N4456flbdLD/eRCV+GKSC?=
 =?us-ascii?Q?hvHBPtGez5g1uTVNkXVZQpD5tKn4MjbRYbY94/rOrzBesMr1+D/5V2mEc9/W?=
 =?us-ascii?Q?2J1EKEleIxUWKMIKMptBhu/ncjBAm5hTj8xbUVYRwNJwHnRtoeEPKL6upN3b?=
 =?us-ascii?Q?Ic6C39ygTUCT6EL8cIbqygZDoi5fdzmB82/8W6hZd1PXVKkT7IKYCFoNFhmC?=
 =?us-ascii?Q?aE5OXc2B+rhUBKRyC4x4ONv73EPwCrPYznO2jV3j5IYendow3QG7XjNx4xMq?=
 =?us-ascii?Q?YCinC03XU6id98Zgz8Inij4lAFk10tJoxv95Lp7Ijs1ICDWHvGjNGDxW8+L5?=
 =?us-ascii?Q?ZjJrEuEd+71CrdkgGD6+r9orUrc8JTJp2v7ruWMNzOLi1pdQXhDgO8zcBG0P?=
 =?us-ascii?Q?AqVloipYlJtlchJ42NIEZF1oWpmjImXdQ3nc0Bf9/uXKhTZzelZH+MfMhAEi?=
 =?us-ascii?Q?5VSmy/YU43bjregkqhrr3rOO81B+2ajAbFWBy4sgAiQztXeBser7fZFK+vZP?=
 =?us-ascii?Q?mKE1t83qekLIh3LUDtkZXs6tAbMhosZCj7uVPYFJIc2lL6N9iIBQVz0T7YBP?=
 =?us-ascii?Q?zB7IcIBrx6c25JskUQq3i23NSub26MF2dqRAnbjfxrLlWmt/xbNDZ9pKhcaV?=
 =?us-ascii?Q?H30ELyan7W5A1vdj/UPuX/eqk0TsZcN2B3rLDo0S9jteK4RtWcbod0P+F1w/?=
 =?us-ascii?Q?futxEF25iCmLSJ/M8HRFJN6f2zybQXcwobhT0cylkvhhBV3N2O6GbQkGp2gz?=
 =?us-ascii?Q?N1foDKC9FALGMn6VJM4qHraprlB7r1A1tHxkhFPaHqXNeieiBSjc8hxXVShv?=
 =?us-ascii?Q?H7GXrDgNJY3ozNRUNZYddtfP+1w4ay6SlC5KrJfMJ6qwNT3w2NIRr59Bt5Ou?=
 =?us-ascii?Q?ZnsXv3IKkL6/UZBQxMz5cktm815jwfyu8NsVmcOZXTrtCJHF70v8meXlc3Ld?=
 =?us-ascii?Q?eNWi43h2LcHuowXEXjrDAuHutjSI0yWPjC+jSOFRGBqDTwrf8y4B3lbEFM/y?=
 =?us-ascii?Q?3zwEV2xnJibKtmty3qtvNrA1PvRbm+FAAKvCxqcBZMekIr4Pg6CKabfqd91g?=
 =?us-ascii?Q?HEdTb9YeeH03olanAl9AFU7aTYqixZtPJ0k3ZhhfK6pk11YHgwSolFukqz58?=
 =?us-ascii?Q?voBdVH0G2v3wdvr9XiJEQfdcQ69C78YqN3nKuB4yjagDTnXtRWdoQ3ZNvXPL?=
 =?us-ascii?Q?Ii1LXzwDawERlzFGgXRtPgZ/tYhRil+McUCI53bsg+yRBA+MChwPw3uKrBz8?=
 =?us-ascii?Q?9U2GzK3cJZcj0EpkVkOrMgDDVoF8c4g8pwysH1VM?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225a0f14-5230-4701-8ca6-08db7e03ac7d
X-MS-Exchange-CrossTenant-AuthSource: TY0PR06MB5706.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 09:30:44.8871 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlwDgWbKaP0968di9jvD9w6OXRBSmaHsb4yk/jV0thpKkmw52RB1raF35ef35K7mslrAb7X3XMjXb58SxCIokg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5077
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: [dm-devel] [PATCH] dm: Convert to use time_after_eq macro
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Zehao Zhang <zhangzehao@vivo.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: vivo.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use time_after_eq macro instead of opening it for readability.

Signed-off-by: Zehao Zhang <zhangzehao@vivo.com>
---
 drivers/md/dm-writecache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 074cb785eafc..0527d328b6f4 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -16,6 +16,7 @@
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "dm-io-tracker.h"
 
 #define DM_MSG_PREFIX "writecache"
@@ -1994,8 +1995,9 @@ static void writecache_writeback(struct work_struct *work)
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
-		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
+		(time_after_eq(jiffies,
+			container_of(wc->lru.prev, struct wc_entry, lru)->age +
+			(wc->max_age - wc->max_age / MAX_AGE_DIV))))) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
-- 
2.35.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

