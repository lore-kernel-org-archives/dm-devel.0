Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FB6C43219
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-ER3shFEBMOi2ss29gd8egQ-1; Tue, 15 Feb 2022 03:04:15 -0500
X-MC-Unique: ER3shFEBMOi2ss29gd8egQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C9781440E;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30BE64F877;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 067194A7CB;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vQqR004819 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C4015361F6; Tue, 15 Feb 2022 01:57:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86E375361C0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 699DF800B21
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:26 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-urdlLlXfNQSriIwM_Pfvjw-8; Mon, 14 Feb 2022 20:57:22 -0500
X-MC-Unique: urdlLlXfNQSriIwM_Pfvjw-8
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:57:14 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:57:13 +0000
From: Qing Wang <wangqing@vivo.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Jens Axboe <axboe@kernel.dk>, Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, 
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, xen-devel@lists.xenproject.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 14 Feb 2022 17:55:50 -0800
Message-Id: <1644890154-64915-14-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b832f5a-dcb1-4e65-5aaa-08d9f0267bfe
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2771D9FC8FCE2704409599B8BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: H/4bqIzmoJrpbSPGOKQFg3STl7pNYuYY7HyAxnoNBYmHT+1a0htC4+KZF4nwpycZ1/W4Ctxzyx/PTvG3N36pMzTrkwSMNUzF0eUxAwl/1rlecctY7zsoP2L9SvhyRdcRzpjhlch2M5M7XpQvoZMKh3HDdA2KuLfI2jIInkjIyZpJvcAv8EwliaBDXBzCoOTQcOsr+HBcV27t+G/srcgQdCQEO5z32g6Mb8n+3eBGcZXac/IEc1tk+5fX6hHvOILfg26RgtWlnK84Uae7R4C7zu50/JvXvt6dDOeuKSsyKuTnrdXUeNToguNafjyllSS1g21/q7jTp1j3dxuvHafZTl3z/6qUQJ69+xXsYaAC2JHjtZvQ25BVpldPtExoa4xHj+jLPRg/7qLfrffdM0zMxI3lFePj20ysi1vRUAQkRIGpchPE7xvv1LD9F09v0tfSMppv98XwLX7xDgXiaI0CRk6ciSNtosf/CfVu2y2Awx53M2z5rmBP3GbGRyO72dVVzSpJxNzgnmqG1fn0DJtYOJSuWiQizCnY26Js+nXAWNIJ06euzmYCW/ncuyuQjZjaha9PlxiMUg5Bh1v7N8bQ+GmH3xQRqDnVBMKYpEzlaCJIrqM0Pp2Ze9cY7qgurZBMVHLi7cz8NNRhhXhg39xgy/3fmUR1GgJImDyuMo0WJz8Kpy+aTQNRzKhxeupYM5otuAJslYIxdxixFCxsrIz/AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bK0nz8C1sAOMe2uEktKzSvPsIyfDKfV9FcSqR+eBqcWsshGvBa4WTZxU9KiE?=
	=?us-ascii?Q?3Vav+GqZW7U69B2v4SW8UW71GSYl2UGRPwB+hEPoa2P2v1HPRTk6E+yeY03a?=
	=?us-ascii?Q?Zoe51jzCRekRNgd0Zfa8LyGJpeKJ4J2ZGHEYxlUKVyHUICMKKOxn3LAcS54i?=
	=?us-ascii?Q?3JWXhM5Ir/j1SPSAB2BtSxLERl6DJc2MkRkLRNieotOIfArJ8Dg/wOBaK48R?=
	=?us-ascii?Q?acOhO5vW1kEdBIcih9bnKLFZDSo5wJmnd5lkB0ifef38Kot8n6fXzT4Ewij/?=
	=?us-ascii?Q?JQGE8ompPz3xAZBs1vqFipu7WwWzHS5n6pvKprgGGYJKuXToTGtkEt1Te7Hc?=
	=?us-ascii?Q?ihh4zgPRlEB3B1cr9nh4AHp4ZmkWsdEvMIdgyoR5JW4eEsXsUnq4GtPjRk5F?=
	=?us-ascii?Q?PPJsjU3jNOUVWrO7ZBiiY4yOoppLLknRub8sfYbIebgTdg6BgwGcfS8g13vw?=
	=?us-ascii?Q?CO2+jBzLb9uIGEU33ENOq6QjZdKzUElFbkPw6Jbk4MbPmDtn1yqVtVxQ125l?=
	=?us-ascii?Q?Yw9SdR743VUpRRldl/IRLoKC0E5j5bXfzANnIypQGtL5w7J3WvaRe8oMQ5m5?=
	=?us-ascii?Q?y13uChO8xNvh975DtaOg4HrLP5fh1jbkYVllm4TauZ0y0GnTbCOLU4J7WXTV?=
	=?us-ascii?Q?IDTyuyJW6Wg3VMD3j1XxNPFzK/3gYbttE/35o2wL+JYP3R7SPYHa+OLoX5nG?=
	=?us-ascii?Q?IZgz6347m+JC/13n7BgJ+/TfttoWX9IdRx2GAQg60lEJaTEtoXeeANjD0vip?=
	=?us-ascii?Q?ZNmtR81KhQ3WzvrJ0tyBEdTE9iqt58cX/sv/g+juJ72n8gnDYN66DdpWjI1w?=
	=?us-ascii?Q?h241ziU2Edw4OqKVceCI6yBL+p+GB8gFLCXdqya1ULuLjOsHPFA8UYofJANG?=
	=?us-ascii?Q?Kk3/NyVWwJ5nnnQQWnNxoDsTnIwX1gs8GEf/arv+/g8LqEzOjVj9m4axF1PB?=
	=?us-ascii?Q?dR0Jwr2eQkB2fT6v9YeC1G6zh6Efj50kJyhItTSTlX+ZYDjw/LIWK81p1D/Y?=
	=?us-ascii?Q?UZCRzvN30HUG6BCTdpEJjElEphkrzSIASJM0AVgMV65nnibnCJnr/d5qvNbd?=
	=?us-ascii?Q?9HiIspZG586oGk+B8kHhl0lXnB4682W3u+806BQog5YIwFTjeo6A9vExY3l2?=
	=?us-ascii?Q?+Y22bHHUZ29d1oLocAYelNLv2MGfYnYEhU55KvO3zG/tqMSwBOlTbKCLJQ5v?=
	=?us-ascii?Q?/PyrIviFHhht/Xwfy/FXURBEzA40RzTK2yMDZVZTBeLcTXeNqu6WPuUg0ZMp?=
	=?us-ascii?Q?TlrVTzO3GwXhSpDqBqfqCNxL4OWWGcVQf1sdoDTdt3bCKoH6c3Jdf3sGbDDX?=
	=?us-ascii?Q?Lwv1ovGhvyWvJa+FkrnrGMNJOGJBEywV5XyU5XmEfqyvoZRgTQeSqifwD6ik?=
	=?us-ascii?Q?hfJaCXJas1GH5OcoaI2G1QoxCcqScLz4dceDs705ftneXbQ9Zx5HgB0urOgi?=
	=?us-ascii?Q?145/5Jaf9b51bo95nqOZglW8AxsfiTJcsur99k7xj2FVC38wF4II1TAlbbiA?=
	=?us-ascii?Q?QvF1XxxLoBN5AkOGhBI9Fq21+tmTXulegOcY5MySIWm3MJ4EUGX+Rxr1vr7r?=
	=?us-ascii?Q?1wKNCzV5xjDjpzYNYlJSI3EgvGYl9cx/48GLboYyfKvjmCpzN8r0fbMuIfxg?=
	=?us-ascii?Q?JRkfz4pmTNqX4/+9vBRbhOI=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b832f5a-dcb1-4e65-5aaa-08d9f0267bfe
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:57:13.0888 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyZdUVP+2fWY+yORosp2bLfqv4Z5+NzGfn3oDk/tXxeEcEmDE7T6Y895G6GWUbvVkpnX9VDalim26j+6jFRLMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2771
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 13/13] media: vivid: use
	time_is_after_jiffies() instead of open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Wang Qing <wangqing@vivo.com>

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/media/test-drivers/vivid/vivid-kthread-cap.c   | 3 ++-
 drivers/media/test-drivers/vivid/vivid-kthread-out.c   | 3 ++-
 drivers/media/test-drivers/vivid/vivid-kthread-touch.c | 3 ++-
 drivers/media/test-drivers/vivid/vivid-sdr-cap.c       | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-cap.c b/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
index 6baa046..295f4a3
--- a/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-cap.c
@@ -18,6 +18,7 @@
 #include <linux/freezer.h>
 #include <linux/random.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
@@ -893,7 +894,7 @@ static int vivid_thread_vid_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (jiffies - cur_jiffies < wait_jiffies &&
+		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
 		       !kthread_should_stop())
 			schedule();
 	}
diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-out.c b/drivers/media/test-drivers/vivid/vivid-kthread-out.c
index b6d4316..13f737e
--- a/drivers/media/test-drivers/vivid/vivid-kthread-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-out.c
@@ -18,6 +18,7 @@
 #include <linux/freezer.h>
 #include <linux/random.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
@@ -234,7 +235,7 @@ static int vivid_thread_vid_out(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (jiffies - cur_jiffies < wait_jiffies &&
+		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
 		       !kthread_should_stop())
 			schedule();
 	}
diff --git a/drivers/media/test-drivers/vivid/vivid-kthread-touch.c b/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
index f065faae..8828243
--- a/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
+++ b/drivers/media/test-drivers/vivid/vivid-kthread-touch.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/freezer.h>
+#include <linux/jiffies.h>
 #include "vivid-core.h"
 #include "vivid-kthread-touch.h"
 #include "vivid-touch-cap.h"
@@ -134,7 +135,7 @@ static int vivid_thread_touch_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (jiffies - cur_jiffies < wait_jiffies &&
+		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
 		       !kthread_should_stop())
 			schedule();
 	}
diff --git a/drivers/media/test-drivers/vivid/vivid-sdr-cap.c b/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
index 59fd508..f82856b
--- a/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-sdr-cap.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
 #include <linux/fixp-arith.h>
+#include <linux/jiffies.h>
 
 #include "vivid-core.h"
 #include "vivid-ctrls.h"
@@ -205,7 +206,7 @@ static int vivid_thread_sdr_cap(void *data)
 			next_jiffies_since_start = jiffies_since_start;
 
 		wait_jiffies = next_jiffies_since_start - jiffies_since_start;
-		while (jiffies - cur_jiffies < wait_jiffies &&
+		while (time_is_after_jiffies(cur_jiffies + wait_jiffies) &&
 		       !kthread_should_stop())
 			schedule();
 	}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

