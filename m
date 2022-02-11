Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23681C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-47Xg1C94OU6XOtaeTafLuA-1; Fri, 11 Feb 2022 01:08:20 -0500
X-MC-Unique: 47Xg1C94OU6XOtaeTafLuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B81C190A7A2;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30F564EC7E;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AEFA4A7C9;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2VZkb031545 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:31:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5EE002027EB4; Fri, 11 Feb 2022 02:31:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 588442026609
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC758002BF
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:28 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2096.outbound.protection.outlook.com [40.107.255.96])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-202-w7jfmSx1PYqdETn-vS6YkQ-1; Thu, 10 Feb 2022 21:31:26 -0500
X-MC-Unique: w7jfmSx1PYqdETn-vS6YkQ-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PU1PR06MB2326.apcprd06.prod.outlook.com (2603:1096:803:39::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:31:21 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:31:21 +0000
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
Date: Thu, 10 Feb 2022 18:30:25 -0800
Message-Id: <1644546640-23283-3-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54f17a6e-fe93-4639-c032-08d9ed06975e
X-MS-TrafficTypeDiagnostic: PU1PR06MB2326:EE_
X-Microsoft-Antispam-PRVS: <PU1PR06MB2326C71B3F3396DFE0CCDDF3BD309@PU1PR06MB2326.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Yqxj2iWIIuzZawtwdzqczDFvGCSFSic0MRN2Sf1CAFjg9Tkt8fxgnGTFe2HJnFX4Kar1GtowNhQRjpm9IFr+M5umWukIXzV2k/j6QtDDF7kU7lJUv8//Cpt/c2yjdw4yf/vh+Re/22Ux4aPtLuI+xsbDPxpx28E7ARpvvqcAxjc9VitMYrYAo2FVa5Y/eUOxzdeTEX+S1AndOk8GsUp06siDV9HGqWYtrnfP8VMQw7WWGV9hrG2U2RybmaDP4i2XZHImaMKzeJtQjqQLkJo4Qyykh9Jly5Lqi5BTSxSkVTSoOy2eBSTWnUnFJdKX3HcsqrsqhEPsZR4Lv3KW6OSUYCe0rl4jeUXzBVO3Gl1zbo7QieZEHMRBZvUu/xbcmuk4ouGKiwzDHumQ6zlSA3VEefE6trY+JiaxCcbwnizpgC1axElAFEldePYE1u2fPqawiNDlT/DZCJENGsUovimfHdB3ywzX5lF8qz1S7MWTEz1xleNSAsvzWvcNJXehKZnHMW+DBJrOg+friLegy1el0p0vXIxJvCIwam4AS5ye5G8DnAccCyhqKoT0XbQdEzw8YHZBslBXHHOltVgW6B1vd4E0ZqusU0FqcS6MbV0MhvCD9ehMRqUDzjKdS5Cjuaajj9rY2zNqgb/VV3dVFYwxqEKy/R0YJOtJcbUV1ffvQ7e7xmpYoIftASyuoTo4JrsDKkISBVnfWP3fVQ4aO0fsr2aBpJwvQZn7SjJWpSzlRhLa07VmpmWgVOa9XKLTlA4z
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6486002)(316002)(508600001)(110136005)(2616005)(52116002)(86362001)(6506007)(6512007)(186003)(26005)(2906002)(36756003)(66476007)(66556008)(66946007)(921005)(8936002)(7416002)(5660300002)(7406005)(4326008)(83380400001)(38350700002)(38100700002)(8676002)(107886003)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EPj7tTLWJhAnjd+8vEpnCLOQzaZHf/ldw+3lsmz1AF3Fva5OW0s7lere35Sn?=
	=?us-ascii?Q?ZMOgw1FMLE5Lmxu3jCbRZbbJWvm6bA49IC0Ovbb1OnlJemmQEr+bFacWNMWD?=
	=?us-ascii?Q?Va3OFIhZQIgjVgjJP/xRUdJLicQN0Mad9GjQRURhZGer5+ZPJXczWo+GeZ3s?=
	=?us-ascii?Q?iUaxQ1lmWlVIMDwGXFWEJfTQvI5ZRZP6ksty6+l0ydTzHE/Zr5Ggfo6H4TeU?=
	=?us-ascii?Q?RudUrJWvaoWYorQ71h6GZyx4YhM3NkBcnGwNhOKSgLI54p5j8EnWgzwV29OB?=
	=?us-ascii?Q?5JDjTsKgqajNKzAYLL8/WaYNLa85oINkIIbbdSChUrisTDXbSbeeGzqd9AMb?=
	=?us-ascii?Q?AxIigRA4CGawimMxNgmX76GCDoIOu1GLX6cyyjPI0kCEc8H7yISe/3mB9U0T?=
	=?us-ascii?Q?AGIJOi3KDOTYR8F7XeXALtdUF+1Pwv4+buqIsQC0L1LvEJfXA3q3ephs6As/?=
	=?us-ascii?Q?nmXP0Vm4ioAiBdQN/Nm73ROW0FPNtqepqzKVMb+db8UlRdNXm6Mv8q5znjAB?=
	=?us-ascii?Q?3cL+r40iGl+q35H3ZrpAveydnySB8bAV7ZWijgDP3qKEdyXP+OxQfR2a++B9?=
	=?us-ascii?Q?80W27Fr7BNRt0ZrPuXFUU3uOBvUXbCtWndZFS2auUVeyzXgiv65vmQ7d+Hol?=
	=?us-ascii?Q?4aU8Qq69SojHQ7meBT7o9JgGPb9Du9A3WIjUYVyMhwaIAl4KWabe2yyon2mY?=
	=?us-ascii?Q?tNBAX3SOVeXENRyJQv+006yfnkyPYgLVdxuNhZFNnM97/wgjvnsKX6kBDitc?=
	=?us-ascii?Q?HiqMec+w/FWSAn5K9llVLbM5m0rTS8l3GfeBDr4x0/1setC8ZVVOkqYWWrAl?=
	=?us-ascii?Q?/BINkH+wfO55iawUDQRJqglD7czL79mfImS6Dxd8jdxVr9C3iHWnLwo3JQVC?=
	=?us-ascii?Q?bxloKb3tUGsTv8YG92ci7pOF9FaFcpBfmC9OniqngUtf4/dKwrO5Bt7jOevh?=
	=?us-ascii?Q?hrVGmcpemlNks4EyFVo2HPxZLSnDi+7BekXwLQRIEvOVKvSXmuR1KWMi1FLs?=
	=?us-ascii?Q?+yOy7bZe+a9oNsOrw55+F86vlxipIoWUUdjoFQ+RhY1Rg7uGyRKhCe4aOXLz?=
	=?us-ascii?Q?8+G0wWvrjLvjMbapL/Y4CqNqmo2S1R+3UegGhAfetpqpNYEbqtlhrvGSGOY+?=
	=?us-ascii?Q?v7gLGmLIcMHVuGouCr7Ti8nFTx71A9QYDVqSWVgUI0y6t4Qmg9cH1k3IZRpt?=
	=?us-ascii?Q?SNFo857/WQHjaYBzjshbRuYnioTsySGjBF3jSlet1fKrE+gTvQ5KdEyGjwd5?=
	=?us-ascii?Q?AwA9+rvBBNQwBoRWAb68ln7pXoBTzaLU/YkFW+me5Claj0MDAwaHGZMd5Pcf?=
	=?us-ascii?Q?XVY6X195ZHQQWfVCME+ehx7djb890wXfiQstqNpRKrhztkgupPjeda0N1V/A?=
	=?us-ascii?Q?/hT/Ga8c1dx0hOS865ftnA4dYvKEGZodAB+z90jH/LCPw9yXfgqZswjRJs3t?=
	=?us-ascii?Q?4NHPpjm/8i69Y16vaOdhED4xQVLHhQkMDAS2C0V3pW5no3mjneytO8Fz4IR/?=
	=?us-ascii?Q?rR3jLp9AwYZe863eMYhzZfpgbi3Qqb/r/shW1JWWhLcC1huJq4bFD53+8BYb?=
	=?us-ascii?Q?0v34Aukej253CX40zwnXz6PJO7EXeWVIBJJxNvFrZZt0u0mguAxCR6uSdjGT?=
	=?us-ascii?Q?LktZppNmqcNY60VH/nfFwUA=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f17a6e-fe93-4639-c032-08d9ed06975e
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:31:21.7447 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5ShcZbiCtmLryyUEfbOWjk1acGLL5W9vqCQ+h3lPfIcXbBklSckOaIfy/WuPiY3vyh30C7ya9v6MlU7BMzfeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2326
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 2/13] clk: mvebu: use
	time_is_before_eq_jiffies() instead of jiffies judgment
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

It is better use time_xxx() directly instead of jiffies judgment
for understanding.

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

