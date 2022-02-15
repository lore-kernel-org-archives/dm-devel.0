Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2658BC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-7X6PSm41OmCWLKh3V1Csbg-1; Tue, 15 Feb 2022 03:04:19 -0500
X-MC-Unique: 7X6PSm41OmCWLKh3V1Csbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D1EE1853026;
	Tue, 15 Feb 2022 08:04:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE13455F6C;
	Tue, 15 Feb 2022 08:04:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C46051806D2D;
	Tue, 15 Feb 2022 08:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vPH4004813 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E03081121314; Tue, 15 Feb 2022 01:57:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D975D112132C
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85CBC3811F25
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:21 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-GCbMa_INNdOMDoujyxBJEQ-7; Mon, 14 Feb 2022 20:57:18 -0500
X-MC-Unique: GCbMa_INNdOMDoujyxBJEQ-7
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:57:08 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:57:08 +0000
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
Date: Mon, 14 Feb 2022 17:55:49 -0800
Message-Id: <1644890154-64915-13-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6296c2c9-2fb7-4819-0f42-08d9f026793f
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2771C677E22165241E79FC93BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qSjKbwTeUefY/5XfnMzQWYZgsd45DfT8L6x6Klg3SnsN1cieMmLcMaWkL4xYkeLO7W0x3iSqkVTk5khQ2XrDoAAw8tIwQj1hQw+hbkc3oYFQ4tumhkZQd20Muyvh6xRWy71DAfkr+z9tRqzGPAX3rF5qXLAn88hJsTu4F8Bg+Qh03pBatNcKD8zWhWr9QwKenkblxg0RpG/uaAUmMQ11DFqY+kGPyqMtYOMukqt90XCYThQuO3Xlxp1diCO8QcJo48PgjQ7kikry7VEjKOY4/iCwju6LBew5PGHh94abvrpIUzzp+YFRF5oRp0RtMGbGgLfV7+UlQb8VfFcqVQTJia033kQXr05fh+CPxnR5gK94KnqKLTeGpsu7ufOt7PhhmsFk7FfarnTNcsCj/vAXINrDiYimDTJskKjYzRXfh33EDNBJytnv9HhHBRYqBbjtWFH2EPsovF3jQhBPDESxoyIgZeKryIw28JtKEn1Awzbh/URMnC8gRsTWtU+hoUP5o+l/J8pxs7PuNJr3SzJYbdSpOUkAP5m0PtnZCCk0OHzsBKRSODbvATPDmunC0Ifo4Sk54bRPDpnABrdVAb4nzBJK0Ixb8wKZ48KHS41d1KOhwfsmXz7tY+kkaRwmxL0F0IDUmC5RPAPHhSjkAv754GZSGxzHtnLNyYYw8aa7fl8GgJ+Cw62svRUVFvCxRlutSV6/WgbN4U8n88eE+glQ4vZ46yFh/3TRmid7v8lAlUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fEdToDFzbgvbvN7qWxtjGGi+QazY9e97o1YF7YbhRPDsHggHUFqbf9v2tSy0?=
	=?us-ascii?Q?d2ZGrpigbm0f2NJZv8hrs3xIIpSq4defvWJ5m/jKqSluy1qRFLyf7WZTkxgK?=
	=?us-ascii?Q?1kpJZhJnVAUOJVC7cOdGF9BQMpwylJk30xJO/cotOM8z12sJo/6htGgZI1M7?=
	=?us-ascii?Q?KnoNAbBPqNEk+1m4aMhLXaSya/i7/2kmoBEGkNzTZS6S0Ym2eOBZ46y/VIgq?=
	=?us-ascii?Q?OZ6WH8Xeazc/ug7gipHmHIw0lIeYV9zTTkFvxH9vnsWcTynmBPHGYIBVEQLl?=
	=?us-ascii?Q?chPR+ez21rlfD0QIGSpc25+HUDb+4Rky2UiwNGKSf4y0uNtoH1IfZkYyHif5?=
	=?us-ascii?Q?NPOnTjBiCqRVloVgsnF/ZkgW7j/yuMq6miQCEYA0UBao568Egiyy/fXuc9ST?=
	=?us-ascii?Q?ntu4Y5NmqZNWysp2NOMtiHWhPEehR5lREWlPqauiZgMHQIbmEklbZ9IOIJE3?=
	=?us-ascii?Q?HRxcH6eeGLAfGs3kM/m1aSPfsGuz/AXgQboEJDiGHCOstX2n2arLJWEdZk47?=
	=?us-ascii?Q?gOnHXIbgdlrNtvBuT273N5GMnbqaaRXX0gc6U5AGxf8zJA0uN/5/8MWQHV8U?=
	=?us-ascii?Q?+1EHaF6ChDy0SLN9BHn6jYH/Q5Ot6TFZf2/6uq0U/yCPTKbXfsGpnRp2xud0?=
	=?us-ascii?Q?cpPWBuXs+xagybrMbZQlBAqa22pozi0oJvIrUuRHOsd8rLk2Zy9T5ttMSC/W?=
	=?us-ascii?Q?Rp0I7cgA4siVVzFd9nIOXR/tb/njBnQ2rzOdRXY5Aoy3dzKMOwBf6ujAMKFV?=
	=?us-ascii?Q?0tWb/sjiMR4uAi2bN0nNFbrc5lZbQ8bGCMdRsBFMKZwfHRYPOfGzbFlkKVNH?=
	=?us-ascii?Q?vkH0559fck0kRQQA2oQCOwnqyc8Y9T/ewAv/hiRyWaZO2lP1V0OmZhdUUPIi?=
	=?us-ascii?Q?/HAj6gT9WrA693LTWyVwjLanMYeh+bgmd0Drgi0TN4AZIQGq49skb0f+H0CD?=
	=?us-ascii?Q?1ugVpJJZY6si8TRkwuPXYNHmvZjZuhsKNyRJwROZvt3ud9qpA3bnBOyqOcYW?=
	=?us-ascii?Q?wPsABG5MyRt4I57cYHU1e9bfnPRtzuAvxlsaKuD1Y0kOSvnBdadn3Qsq3ILw?=
	=?us-ascii?Q?lCYZOGZJnb6jSo65CdWTJYpwWkP3B9ayXxd7f2DO1IQq7wxSHAw5vZoiAZb1?=
	=?us-ascii?Q?4fEwE76LG45UYaHqpzE4WRLqe2fvhZTMOrphwU+KfHetNBnkE6e+MQ3qB+Qz?=
	=?us-ascii?Q?293af7kMgOSEgXpViCWBwzmmJYm8m3OKjAzQ2M0HE2AhRaIV6oy8xqbSY2+a?=
	=?us-ascii?Q?0oKHPKZ2IBuRkelqeyOnG3OlGWOxmoXRp1ojFTcLt3h+emJbIrH9Q19pl/qu?=
	=?us-ascii?Q?ymHx/B+sp3By1upwlc9MNyBIvXKA0qjk7a502R6ECmjbIYZ6us9G/PQU2YLb?=
	=?us-ascii?Q?mTDgMdHNEUqHoOUzIvn0JZZZN0SSIxhAvSlkT8v8tjlKNccNa6aRohJcLcuY?=
	=?us-ascii?Q?aumtCEyaQczqIH49OyUXAJAT55x+uxs93P1DNwvHkbkJlxdnPzVC4gKMJA4y?=
	=?us-ascii?Q?xCSNkacsN0noFqG9IlNI+4r2irT5eoICIQjMNyG5gIzNBNCurke5DNW9gtbG?=
	=?us-ascii?Q?nDlx7B/sSQVeii6pRBkbjgOEm6YnyedmWaIVRw/C/kAZWr1wpBpBkIxAg1KR?=
	=?us-ascii?Q?mK45CnaeHOrIaYoivIWnXNY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6296c2c9-2fb7-4819-0f42-08d9f026793f
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:57:08.5734 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZUQJ3DpGBlABktVULOZhxTm+OFwKEbGKvDe4gjCg8LI6oJ6aIWEVBqVVBcDqxwPhShvhFs7+tS0SH5zdQOGTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2771
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 12/13] media: wl128x: use
	time_is_before_jiffies() instead of open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/media/radio/wl128x/fmdrv_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 6142484d..a599d08
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -23,6 +23,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/nospec.h>
+#include <linux/jiffies.h>
 
 #include "fmdrv.h"
 #include "fmdrv_v4l2.h"
@@ -342,7 +343,7 @@ static void send_tasklet(struct tasklet_struct *t)
 		return;
 
 	/* Check, is there any timeout happened to last transmitted packet */
-	if ((jiffies - fmdev->last_tx_jiffies) > FM_DRV_TX_TIMEOUT) {
+	if (time_is_before_jiffies(fmdev->last_tx_jiffies + FM_DRV_TX_TIMEOUT)) {
 		fmerr("TX timeout occurred\n");
 		atomic_set(&fmdev->tx_cnt, 1);
 	}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

