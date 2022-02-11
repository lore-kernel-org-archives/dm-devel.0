Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D976C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417--6lUXBYEPr2gNLN2x2kO7Q-1; Fri, 11 Feb 2022 01:08:25 -0500
X-MC-Unique: -6lUXBYEPr2gNLN2x2kO7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BD7B3E74E;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3177B4EC80;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DE5D4A7CB;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2VoQA031566 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:31:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9673A40885B9; Fri, 11 Feb 2022 02:31:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91BAE40885B5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B96F3804093
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:50 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2138.outbound.protection.outlook.com [40.107.255.138])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-264-hO9EV-MVNV6pE8RdqgN5uA-1; Thu, 10 Feb 2022 21:31:46 -0500
X-MC-Unique: hO9EV-MVNV6pE8RdqgN5uA-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2895.apcprd06.prod.outlook.com (2603:1096:404:31::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:31:42 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:31:42 +0000
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
Date: Thu, 10 Feb 2022 18:30:27 -0800
Message-Id: <1644546640-23283-5-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f244d204-a61e-47eb-dbbd-08d9ed06a391
X-MS-TrafficTypeDiagnostic: TY2PR06MB2895:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB28958EDF79CB6C851B84A11DBD309@TY2PR06MB2895.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 0AL7Nm1Aur2OluoZbKm2LgMFQkifIuWuiUxXHFoWhejTbJvi6k7rj8KTS/+UKcv9CR6iUPtxusMwWQ9VDYT1DK7PR15v0FTc1SVkI95C09hB9SFuLjb6M1S4UkgsmpySIdvKTlLUZfrPXpfQEi+d3Zi5HImFeARlfxaw6ZbtP8r1S4ryYMT+9wxtRxyB3w9j4YBLNqF2fo+aN+8NjXnpc9f60FUBx7zHJkcg02yubgKZCNOPqb7a0Rt25ypMDhMnFft7mcoYiIsOCzkUobY1ArSYfCpYilOKauip3fpaWUA71XoEWLRfLYYDK9w8LPfJYH+wMjxKL49AYDijdiRUngiDwAeQHm4U/Mk2nm4C3W+45Jwya/+ODpDL2mdkm085UafGmml6CyzhHSUW+dpQbpdaCYtkMBb06Ws2Z7LlLEINqP0XAPmYOCESh1lNhK4aRYFtpxUnn9m87isSoEfbCdzlHYe31FB8IqXBIE8RA8H+yVj9LucjeROOGOtBEDInDsVVXBBpZGz7Ba7ky3CYT7+ZbyGl03P+Rnhihf3+QV1YAFrDt7itankMwg0CHqNksbCxov3/OCLvsa5eihosLTJxa46ddrgOFcqpWev1hqrkuSTdgxviMiQgZC8dXgNEsBEHsNbtaGRWamKKPRwK0CNRRioz1Os2q/GjsjeviqNSjV1K20Q+oxNsIvH5PZW6SOXVXjjadIvIuB8bPiLjHcT1iVxOQa0247dBZYoLHzEnbsGTUoQ31frUFkkjJ+9+
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(316002)(110136005)(86362001)(6486002)(38350700002)(6506007)(6666004)(26005)(186003)(2616005)(6512007)(5660300002)(8676002)(4744005)(7406005)(508600001)(36756003)(4326008)(8936002)(83380400001)(107886003)(921005)(52116002)(66556008)(66476007)(7416002)(66946007)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alyDAJC7lf3gI2MqaeNi7+CcCL2EWScLzyYu2wnwKVvQo03qe7/EUwYM17en?=
	=?us-ascii?Q?Gc6z682h5HDKYPbkSlQODtYI44Vgi5YWHz67E4l+dZmsBtDaGOhnIjIRXXun?=
	=?us-ascii?Q?hVPDtUpo9203hsGVhRgo5YOCAeNEZvrOjHKiFgGIt2MGuu0W33nYCv6pnIo3?=
	=?us-ascii?Q?j5jXpI1ug2i2n3PASlMneavxryupDcy5HpZfut0zMN6+vOuNqv9X29zVWeuR?=
	=?us-ascii?Q?rU2vG9iLr9EmN4BH3IpYIRM44mVB8KXJK/jCUmndt9DWqJeRQHeTRXoD36Rp?=
	=?us-ascii?Q?NpJ3xoP4OgJ8hyRoPwbDowpsvBrmXiSX1onQ9zAoJpEfxlRTRxoXzatGCkul?=
	=?us-ascii?Q?2fe+S/8BQZSB4JcTiVEhp8qMlgWQTwhJZ2zrvh5Ty355V1g7bQ2udQGSg1d4?=
	=?us-ascii?Q?Mno7oqAaARd7PmTW1FelAX3ZX/5ip3smlhfkvH1rITbND1zU0b6xIASbEMtd?=
	=?us-ascii?Q?m8pQ65+w5w7QpLZIQcnYT7htSgd8uh279+io8vrlfDq0yHikPv50LFGdsOzz?=
	=?us-ascii?Q?7ViID/4szux+Im/ZAauAi3Pide47ITa3lLDHyqNR4kTS/mH4xJZnyocbMLnP?=
	=?us-ascii?Q?kqkl7+kSNp4h/qGuN2ORtX9Bb94TT5vgtXNFS7ZhennKMFby7mAcPFBgkOEi?=
	=?us-ascii?Q?pPYbzLyR5TeIDUJiISn0TjxofHxf8zlIWEHP4EGFp0W5hVZhL3x6YIiGOupG?=
	=?us-ascii?Q?+K/mFHYO45n00Ba272yTXaoHyApJZu+OCezgm1v65MH2Krw8zsHchyaMEOgs?=
	=?us-ascii?Q?UoB1YJJ+OqSB0iLx9sD2z3mJIWvMNO1FDkzfBKrQzA2Rt/f1loLDO6HG/dGF?=
	=?us-ascii?Q?JT/i2de4NxFmDrosyeRN+0zlHUAvxT7zEcYeRvu3FwHD9pXUGvpyRALwy9tT?=
	=?us-ascii?Q?tv0dzyqMc3ULthWpjjmtYc8/LDnt5w5kbiPhpZuKHNbyN+Z8KtCXuiPPFDBW?=
	=?us-ascii?Q?FKjdcnPjhhP+nEySXZ3NGLakJ18xKdzkucdUpY5AlwISoQPHG/d8KDp5tSrc?=
	=?us-ascii?Q?kqVpjEg6+Jqu45NnMbNIrcZ19P/LfPXUst9GaHdG5BAnMbHQ/SRtnuYszKXJ?=
	=?us-ascii?Q?zDxZi9i5RIEQe5bu5oJK9IFabkHZdr5Q3rLOnOoS6yQyxNqmFdU0ucMLvoDK?=
	=?us-ascii?Q?gUZ8qQKtJ+bmSmHdUPnzf9yhZNCaHLwS4jv3y74QdB7xZOf3m95Ti9gZp7r4?=
	=?us-ascii?Q?tfpEv3v9tj6rDEJAhvYtZT6ch2SEWH5ywjsp3S3s50eHyt7ALvNmv6gPDesI?=
	=?us-ascii?Q?j+vWPdjIWsk7aJvLbtUNIYWgI2ffdIxqQbrcbO6XghZ7OCHOKN+FTSpUcGfl?=
	=?us-ascii?Q?gUkyze/iS6Df3gZ2eS+0SWv743Uc9TfuqRziT2HrT+p0O30pO/fh9ycpW46f?=
	=?us-ascii?Q?rN4YLck5HIPACTDc+gu4YceTaR2joqFh4bbiYZb44Gw4/pt0kpSRXkivGYDD?=
	=?us-ascii?Q?5h8WC1zXoYlim8ffIkaFIxR7/skdHIz9zMn2CWZjLGmnmyeOlcg9MzMi/dPO?=
	=?us-ascii?Q?jCVNrsthg69WhCkulWrHInks2951S9CEZkLN9M3wfd4hMrsEtvnU5drFK3Jf?=
	=?us-ascii?Q?ks7OIB5TD4/96E5EHhRR3pZPcv3JgR1/qPnVCFGCZRXLoLY7cnDX7gj/vRYf?=
	=?us-ascii?Q?ThFnBoM0acFG/fWtfEHAgMk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f244d204-a61e-47eb-dbbd-08d9ed06a391
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:31:42.2436 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+F6t0V4YzUrv/nbwcDfsGjFMf655h7dYH5QSRElM6mIVKFZKFoCJy+K4setluG0VnHQH0/whpKc8KVA7RVo2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2895
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 4/13] gpu: drm: radeon: use
	time_is_before_jiffies() instead of jiffies judgment
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

It is better to use time_xxx() directly instead of jiffies judgment
for understanding.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index c67b6dd..53d536a
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -25,6 +25,7 @@
 #include <linux/hwmon.h>
 #include <linux/pci.h>
 #include <linux/power_supply.h>
+#include <linux/jiffies.h>
 
 #include <drm/drm_vblank.h>
 
@@ -1899,7 +1900,7 @@ static void radeon_dynpm_idle_work_handler(struct work_struct *work)
 		 * to false since we want to wait for vbl to avoid flicker.
 		 */
 		if (rdev->pm.dynpm_planned_action != DYNPM_ACTION_NONE &&
-		    jiffies > rdev->pm.dynpm_action_timeout) {
+		    time_is_before_jiffies(rdev->pm.dynpm_action_timeout)) {
 			radeon_pm_get_dynpm_state(rdev);
 			radeon_pm_set_clocks(rdev);
 		}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

