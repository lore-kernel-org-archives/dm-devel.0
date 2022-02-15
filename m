Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F3CC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-PjFWWCMQPwKdyBcAfHc40A-1; Tue, 15 Feb 2022 03:04:19 -0500
X-MC-Unique: PjFWWCMQPwKdyBcAfHc40A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E473184B7E9;
	Tue, 15 Feb 2022 08:04:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B95662D73;
	Tue, 15 Feb 2022 08:04:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F8881806D1C;
	Tue, 15 Feb 2022 08:04:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vFnZ004782 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3592F492D56; Tue, 15 Feb 2022 01:57:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30D37492D52
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 177E51C04B4C
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:15 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-uH3K9He1PeSjN_nghbgmXQ-5; Mon, 14 Feb 2022 20:57:11 -0500
X-MC-Unique: uH3K9He1PeSjN_nghbgmXQ-5
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:59 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:59 +0000
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
Date: Mon, 14 Feb 2022 17:55:47 -0800
Message-Id: <1644890154-64915-11-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34b35900-c3a8-4b8c-3d01-08d9f02673c5
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2771ECC9B5E197E44E6691A1BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Z/1ZKpi0U80UNY1LFIrHjKtGH7NFlMoGYEVe7u7lBBCiRn4454SvlfYCgUjw9ICl4Grrh/m8sk+Yvb/J18L2ZrsqbCrnmVyrt0wyzY3GX2FDBbycOy39yxJx4pDHii94IQp4nKMnFsxrKXSrWBvNJYCfbf8ZAxbcgqPusg48djQCQubUul5+/5qQnUPk3P44c7Oyv76uXRMhzWQcWSukl1pKe/udgcvghS7Ux5T5qrObwE6T4XkLbW0XwbE53UQrlf/96+REHPYdER0c/v7crnxhGubS7HwzV3bIia1djM3keDiv1gY4B7KFLsPERvH+vlAkyerspKTCf/Goc18u9bpcA38hBRA/E6pwLloxidpPSzpwjSWPVOlmuiTmETxZ6tg+QGNXIWJ/hdBDglS2TL/i2CKR0lSp88r966/7Ys0LZRhARrSQJDMN5D2ow0NSSz8fIxfZmIagRTJkZXeB09XBR9a5En9uyfJaWyMoRO4XSaaAG2B8XbNl71TaWfZCewz0w1KWssjzgLrxJi7qzzUUoSE4XsplLg3/uYSGTHcz0hwSbDw6Z8Xxo/M44l1h2+vA7KjItXld/jy6Kh0YeTAwAvwCvKQMV+z318Kisqp/iUZb46TdA3A0xtdt3clpdWvG2VpZv7QFAhsdXQApVRLihg4w9b+s/7+QUfmpOEyBy6KfyY5YMMSRBIOZouwOYctgLcok8PVdtfRhmsA/PH5dGz++Geze1+5WQDhSNto=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JegvUsNVsaXfcZGlbG8Z7mFCnaU7BQ0BsQylFhFuPqaCXKuVghWUmQPSpxsm?=
	=?us-ascii?Q?CRMKukZ/tzUkTKR+dUozO3hMTTv/LuohDFWwWqvN9HR67qBmOAf7dcTzOTaS?=
	=?us-ascii?Q?OBLFRuQ2cgq7cWeP+rG+IyzSQzARrRq9VsgJmVkkHnA1pD/peagLLZSJbccz?=
	=?us-ascii?Q?xNpUn0PIZltTzqroWhcxDzUEi907QFlR0X05/ouP6QWrLsxKvqFcebqBg2yB?=
	=?us-ascii?Q?ACvaOIEdyD7SA3eh380RnwDYFICe+aGDIuTb9t66ct1JJ9AiLTKSAgr3docn?=
	=?us-ascii?Q?8UdsgrRnMgbl+m/gKQV+MAcPMrCaWql/GAqzw3Vy0yJ1qxVUeC0AT5Ee6K2Y?=
	=?us-ascii?Q?I7QaOR3pYZFSU/2Cj114eekfStRWwlqt1t+VxkEiOEdq7yyvLzfBRe4/oTXq?=
	=?us-ascii?Q?nJ5f9IvvSPuBSwb7bxYN3LJGfJg1KCPrhYZ0S1lWxFZJ+yVeBsXWb7wJ7Vx/?=
	=?us-ascii?Q?LmcWSjban4FlmShR57hVbt75C7/KqFS1nbM5/RjYsbHzrDr/GRZDxUMTgthb?=
	=?us-ascii?Q?7EGpYU7ykr58OYsBQH+ouiTUJQlWNa6YT452eIN13Ndc4S+krHAR013u5EgQ?=
	=?us-ascii?Q?eG63S4WXiMaRBCjwrrQS5iUH7rsYYQsuz/bdJARU4O5cGu2LAlsbJ0beju01?=
	=?us-ascii?Q?6ZcLgvM6dL/2kd9Y5KAG/iGQhJZtw7jx1Kdm9T3g61fzjAbqUGx6pF/yJOcx?=
	=?us-ascii?Q?psCLql7cyZddIAh/vpJgnI8VZHsvaKUsJlzLk+aOkNSjFlUKMp9layqtVv6j?=
	=?us-ascii?Q?q4hjaNr+HaCSe1uq0osa6TFtiSNcDfdwyhJwoXaPgohHYkIFSiB8OO/nfoGt?=
	=?us-ascii?Q?bX1vyOJj9q3VXXnJCCcwuhPMpI5MQkPR3sjci6vxgLIdTOhAZhuByV1bDM6v?=
	=?us-ascii?Q?kP8qzxvTthWrRL7UMbXx4zUv0zgg0F1vey1iZh08imuEvj1rpVgzAiuC7KXX?=
	=?us-ascii?Q?NTJOvlI2jQpzKa9t/42FIx6FDj3Eg2mlFZ7r/LCxd5PA98p465KlVzwmkgFF?=
	=?us-ascii?Q?6/6EYOAvMIJCxeC154EBsG3SrLUvOtcUNXRRsWNxAqqUJk0JdvnP3AW51fzE?=
	=?us-ascii?Q?O2xfumQKf+Tl0ruOsYWm0c4rtx0fW6+//PpWp7ku6mkIBPCysF/Pkzz3Wlqz?=
	=?us-ascii?Q?BHWjaUXiNSiXiXAtcWKZrkuyOf3QNPsUH9EXtIdRy9OPlaKELuVpnYUGg7J5?=
	=?us-ascii?Q?+fHY8T0KpHvdAaHOhosNcyhNkxMiXN7J6mOtKm1uWBkRWJ3EKmSJ0l7djgKf?=
	=?us-ascii?Q?IeEDbGBmBfy+irCmr6wPVCdxvKMN+aYomWsUm+fopiIpdRU/OQPPAqGty5nS?=
	=?us-ascii?Q?VyJ4vytvKLA0euM8aVgV2W9v5R48PIK+L7nCagEo8Nitnzc2tYDG5Q7PgCjc?=
	=?us-ascii?Q?2nMKGasOVGgi6Ny3jQTSX+8qD9OBLW3ElCrKpru3KV5yJ1zikAaqmw8j9m3j?=
	=?us-ascii?Q?AMPwAItRX1dM9EEbk+5ksn/1OzqaxzjL9Jh0Dqeak0n0ghhQnSa29NhZf6Kt?=
	=?us-ascii?Q?6rlq4ATiqiHJYQlDB4g/nT8f331psS6xKiiLE6IUwyRvvUfHuJt0lHBE/o4K?=
	=?us-ascii?Q?e6gcuask47AEJ8Y219txFb4sNiIpTQCy75vf573mpTyIjCBYup089lC/EKH7?=
	=?us-ascii?Q?rw3ewQFdDfehBjZc3myYxRI=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b35900-c3a8-4b8c-3d01-08d9f02673c5
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:59.3865 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JrLm+M6mSEBLFYeLGu3LqaQ+wmgbyZRt1lWiKI+vI4p/tuj4r8sAEpelBecCUckxJ7lzICMVuprAbVV8Nj7Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2771
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 10/13] media: stv0299: use
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 drivers/media/dvb-frontends/stv0299.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 421395e..867ae04
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -183,7 +183,7 @@ static int stv0299_wait_diseqc_fifo (struct stv0299_state* state, int timeout)
 	dprintk ("%s\n", __func__);
 
 	while (stv0299_readreg(state, 0x0a) & 1) {
-		if (jiffies - start > timeout) {
+		if (time_is_before_jiffies(start + timeout)) {
 			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
@@ -200,7 +200,7 @@ static int stv0299_wait_diseqc_idle (struct stv0299_state* state, int timeout)
 	dprintk ("%s\n", __func__);
 
 	while ((stv0299_readreg(state, 0x0a) & 3) != 2 ) {
-		if (jiffies - start > timeout) {
+		if (time_is_before_jiffies(start + timeout)) {
 			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

