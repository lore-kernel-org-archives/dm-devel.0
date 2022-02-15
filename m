Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAAEC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:03:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-5Q3lxMqpMVWdJDvRYfhhxA-1; Tue, 15 Feb 2022 03:03:50 -0500
X-MC-Unique: 5Q3lxMqpMVWdJDvRYfhhxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF3591808326;
	Tue, 15 Feb 2022 08:03:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E85A62D7F;
	Tue, 15 Feb 2022 08:03:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9ACE14A7C9;
	Tue, 15 Feb 2022 08:03:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1uXv2004688 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:56:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75E1441136E7; Tue, 15 Feb 2022 01:56:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70F6941136E0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56FA41C05AEA
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:33 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-161-uNx_Q9ArMgWAO6cSp7Njeg-1; Mon, 14 Feb 2022 20:56:29 -0500
X-MC-Unique: uNx_Q9ArMgWAO6cSp7Njeg-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2767.apcprd06.prod.outlook.com (2603:1096:404:3b::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:24 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:24 +0000
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
Date: Mon, 14 Feb 2022 17:55:39 -0800
Message-Id: <1644890154-64915-3-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a592c175-08d4-4018-d460-08d9f0265ea3
X-MS-TrafficTypeDiagnostic: TY2PR06MB2767:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2767351B13A2B13D4B513FE3BD349@TY2PR06MB2767.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: zX2WoqF7MNdOKgvoqDvJhcCDh4FqMCBpHKSG0rNS5d0U+wfBxtQaDuQvl2Hiu1iAu8sUtj8UvfwKNAoaVBhkUUPMnrPHGdx8PIsfUNqxJkdGO2IYtGZ3L9XZR3h+FYFlcEtpceVk+KByzXWpiJEelUxepRgviV9UwUT/4vru1LDbp0ILVrDonHfeNbxbVAhM8fbVAC2dUK8uA7YBRTTwT59hS13MUTqvpLY2pW3POiM1hhiBYw02MCO3skFt18GK3vmcCCnskhLws6ioMXilv5GBRXiKF9UPI5XdDIBCaT97lAH5gWduNHdfSfyv/GjybSM/qWGyZ2UbMxeWa99WZtZtIKcMudJcOQr6CXdrwS1hWyANXWFLp0/qMVsoTLFGLrCrAsQ6MhLMd75+FvkTvparPFv15z3TiPWQxIXK/xrUdOtUkjlUhHLdfrFhCrVtUKDeUzTEjJII8xoKcwM7qehlR9ET+kpyMcJqR8IxsizFZaYJgxYcclNcJBJIxeLnmG7g5Ax0p36SIfhDft9AIiXlLSRJzES8LSdltQfuYBE5vvIojX99YZCoyiGJpy7Ns1xd6O22/7N8R4n6dS3Ny+LYr3hSUt/DPh9XiapEDBdUhCx0jkinrkQAKEO2vWCHgU2txvTdZ2KkoUQl5eQzIlXQMiuNZ+4kL7K0iyRBYEJ/yYL+08Te02m/HJSTM+0JJUBuI10lhiJCpSwMIfCvoMmjL0Etsf9zIQ+E5TPGeaU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(7406005)(7416002)(110136005)(107886003)(921005)(316002)(26005)(186003)(2906002)(52116002)(5660300002)(8936002)(6506007)(2616005)(6512007)(6666004)(4326008)(508600001)(86362001)(83380400001)(36756003)(66476007)(66556008)(66946007)(6486002)(8676002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wpw5/l7FKXOSWvAniOTgrmDA7O0YmEK3cu9ebJT2n7gDSmUwwYsI9grkdQj+?=
	=?us-ascii?Q?vtwlJvrlPqOtYPeYGTA+EiC+m+Y4RSpIEMp6AyL0pRiH4c2RYUCUXVN73oQ7?=
	=?us-ascii?Q?BDWpKO/0+k4xYHfQ8GIXoylYLO++eVRpGrr1RE2bomQMplb1O4zPF8gfqNx/?=
	=?us-ascii?Q?qIwQ9XwA/rRmzmCplmTLnn14JqeC+rb8yS92pYyIcMV7LBmHYoRYV3Iz3E4i?=
	=?us-ascii?Q?M56X6HOyPvTj0EpQXlPrEc+vwpMWEzDyfBRvPaTuauaPzrY5xsi/ngsidFd8?=
	=?us-ascii?Q?i43p+utDVYBqBjpcGRJ5meXl4f3gh5lghVJdN0ma1ZdOx1nLI1fPrU4+81S9?=
	=?us-ascii?Q?QVVhEmquiYxU1pmm172XWG6WkSs02rcFzvD+7/63vC5CQnk0o4osGxdQwHpb?=
	=?us-ascii?Q?uU0HZ/uRFcI2BWjeFONl9/6DBpRupYo/XCJWFRraAh/+PvVvBIecIbfnA57L?=
	=?us-ascii?Q?Z7X57AkkIl/sFasRRHDkV6+QeWNXLFGqx5fHWUgQqu3NzccKJiSbPfnhk/cs?=
	=?us-ascii?Q?dYDCKT4IC59H9UylRXsaBmS8NPeboXKbcPzKevy4gONKgSy8Wp2+mqp2jwAh?=
	=?us-ascii?Q?pRFHdrGOqLdJxYHyk6C07BJiF/8QWU5TU0+5CV291WlEe6lwPaQm86FMl//s?=
	=?us-ascii?Q?FRKnocqxAyr3xh5d+bOp4yYMSmbEC0RYppm2hANCkLXhmuwB5Rgz3CHOSN+Z?=
	=?us-ascii?Q?I1NXRPXtb+UOspRKqZLAZcDbeXW1Br7nfk0z+KzFKYaLgLeDOW4bHY60D0j4?=
	=?us-ascii?Q?IuERPVqvGXWQy5rSYbU6p4QALOu2uHMpLNF/9u/syhN3cYZVM+nlmfU1zn89?=
	=?us-ascii?Q?XR9I60V1a1aUWhwIFPkRglJxrcWLsnEOC39bZlJXEVkQxhDzVeeDOUns01V7?=
	=?us-ascii?Q?zI64pmtancpCjbT7L952oHi7i4JXQx0hrWmH+XyWos3JhVNIyzVuUjBVJcy/?=
	=?us-ascii?Q?rakcshLNC1FdvSl5VU2/ZsM5V1GuLY7I7J0UCvYb2pz02m27vlba7eJD2xCm?=
	=?us-ascii?Q?M5vjCe7a0eLkRYfS7n2nP42BB9kWUkSWxTpN1zCBLL2aWBFliraNvEK9fm94?=
	=?us-ascii?Q?NPbMW4veEOKufI9SR/tU8VB/xAV8NBOIGw9gkLMci83S4kgayd5zRGxfJt4N?=
	=?us-ascii?Q?e8WlpLoE2ggE7Tr/dY2Y6waUUavn9GfpuyX1yYu3FuNjot1lmewLCQ+uuBBB?=
	=?us-ascii?Q?bBHVBag0ugRmL+XtIF/DVfuylRwz9zB/9kqJd7/fkp60VPvZhjd85Sof+i5Z?=
	=?us-ascii?Q?aDTOOXU8q47n0KZALH5ywnl3DHe4Serv7jV6yROXugz4il7Q8doUMfSpZbRl?=
	=?us-ascii?Q?C2HHjm3nRe5fLB26e/cN46qJFC/LZvFC7qWE0l4yPbdoY4D6xzY5NP6E24BC?=
	=?us-ascii?Q?YEnXUSsOv3hnOAe9iWTkfoUhNCp5dDbcfLjw5lyOR5zZwRN3kh0lIkbUznE2?=
	=?us-ascii?Q?UxaoNmMhJIy7EhMQ0gsSM2ovIdhr5v1bJSAW8C0JigSUtY7nd4PV5+0NcdBS?=
	=?us-ascii?Q?qEFfUtS59ee6kAkDO1QKbSLBidp5a5WtH3dCc1HGuY0AeqiuDjsWK2Q/Lf59?=
	=?us-ascii?Q?aOPLIl07l/mAqmbPG5Ei8xxLZ9svR1ldKDWn2wraTtw4kMDh04jkKI4u+ao7?=
	=?us-ascii?Q?B0f2RuwH/p/cqJ4BlqIDWHU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a592c175-08d4-4018-d460-08d9f0265ea3
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:23.9354 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Edh6wThjQcu9bBPcnAQQNuMw2s0Y/99k5LlcNHPrjrGpOlLqbeF1aegTWK9AI/RhKFCCkax1Oz7ajkvWdmyf1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2767
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
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 2/13] clk: mvebu: use
	time_is_before_eq_jiffies() instead of open coding it
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
 drivers/clk/mvebu/armada-37xx-periph.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mvebu/armada-37xx-periph.c b/drivers/clk/mvebu/armada-37xx-periph.c
index 32ac6b6..14d73f8
--- a/drivers/clk/mvebu/armada-37xx-periph.c
+++ b/drivers/clk/mvebu/armada-37xx-periph.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 
 #define TBG_SEL		0x0
 #define DIV_SEL0	0x4
@@ -541,7 +542,7 @@ static void clk_pm_cpu_set_rate_wa(struct clk_pm_cpu *pm_cpu,
 	 * We are going to L0 with rate >= 1GHz. Check whether we have been at
 	 * L1 for long enough time. If not, go to L1 for 20ms.
 	 */
-	if (pm_cpu->l1_expiration && jiffies >= pm_cpu->l1_expiration)
+	if (pm_cpu->l1_expiration && time_is_before_eq_jiffies(pm_cpu->l1_expiration))
 		goto invalidate_l1_exp;
 
 	regmap_update_bits(base, ARMADA_37XX_NB_CPU_LOAD,
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

