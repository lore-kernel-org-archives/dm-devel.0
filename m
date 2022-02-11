Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55334C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-jS57HfUgPWiCmG2P204A9Q-1; Fri, 11 Feb 2022 01:08:25 -0500
X-MC-Unique: jS57HfUgPWiCmG2P204A9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CE88190A7A0;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DCCE7AB42;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3720D4A700;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2XDvu031716 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:33:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 24520C202C5; Fri, 11 Feb 2022 02:33:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2DF7C1D38B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:33:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D59421C04B4A
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:33:12 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2132.outbound.protection.outlook.com [40.107.215.132])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-287-oteKDIaNPke9jmaYOrT4Ng-1; Thu, 10 Feb 2022 21:33:08 -0500
X-MC-Unique: oteKDIaNPke9jmaYOrT4Ng-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PS1PR0601MB3705.apcprd06.prod.outlook.com (2603:1096:300:80::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 11 Feb 2022 02:33:02 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:33:01 +0000
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
Date: Thu, 10 Feb 2022 18:30:35 -0800
Message-Id: <1644546640-23283-13-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0c82371-8017-4197-5f91-08d9ed06d2ea
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3705:EE_
X-Microsoft-Antispam-PRVS: <PS1PR0601MB3705AF49C75AC16BA5099910BD309@PS1PR0601MB3705.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 11djht2qCnSHMekgjn3yfBRNtKoR0UKGRdDeekosS2A4AcFGfSf+QKEcjVSnzr3ieJMEzCCnbyUD7zK7fd2IcVdw0r4yjmIqyF2yGbTm+2HU4IlFNRVNlCKKDzRlZ/6cCVK37j2tZ0Mw55gBsf2CFgFEpdmKeIS+UijpaMSkOLATA7oqL0OIuuQVDg+p4PfEZaN8rqN1A2VQH7ttB9uBIX1QuI7bQLdAdVou+oIweYykJdmldP2YkkYJJxj8P9cFqoqSruo+mu2cJaEx0HEeAHnMIiO2tAhoUJQM5465VSFPX8O0eoMKKQuNpCyjC5sIljeXf0enq7aKAT6lbhSVB1nreAIimblP2EiIuFzqnnsURNqftyYJxzUPDBLAM5kenQUdKj5zUvGSpqhgiqLrHx0MtWB28l6sbzxD52d6iHp3EM1j3KM6T98sYHvMbFX0oOZRroNIYvYKkVQ41UTrURd+fIF69cftcJiBCa2U4TxXtre2edAL7Xf3Dmr5zRlq2lbuFtffgfkBkv4YbzE+Nqlwg36WM7ihe6PospLDzLIrL25Z3iXeEQz10a3Ko6R89PJzcS7JGG0eOGV1u+wijPYeha6073Gp7Mecq2MK1wX4vfIblPMSue9oHRzEojZpvmBbZx2B/+DhzfB+rH1xuC5F63LNPO4aD5udzwWf2fz6s/XwP8QuzB/cxV7XJrrd/BRaTaXaCA5ozq8eLq5y1gtQUD2ZTAdcWp005htUYf8JtG4kn7FB4qp40LfQrBdB
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(186003)(2906002)(7416002)(66946007)(316002)(36756003)(2616005)(107886003)(26005)(921005)(7406005)(110136005)(5660300002)(83380400001)(6486002)(6512007)(6506007)(66556008)(86362001)(6666004)(508600001)(4326008)(52116002)(8676002)(8936002)(66476007)(38100700002)(38350700002)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j9fyLt2pN3iVlwuQgYSDuidhHBuXIqGYNxxdAxZxiLqMohOtaeQ4vcG95cj4?=
	=?us-ascii?Q?8tk23Bxd/fSNFy190paiTPbZL3vhMrekLNGVOImi/gPBk1Nmv9rA5EhMuCUP?=
	=?us-ascii?Q?je1dnQHm49etj4mp/Q/gankTIjbTVaB62MwksFHWLaiLP/pNgQUEJYyr5WoC?=
	=?us-ascii?Q?OMjBLuNNTc/mwvq11hwxOagLktLUfBsWIWzyh5eGr+/IobCHbnsPjJejsNRY?=
	=?us-ascii?Q?xZbJUywMZtmYConMfnjZ+w0HCd+Uft3dek8DObgX88vbFk1wnhyvfwk1AQ0x?=
	=?us-ascii?Q?uYuIbot6Bkxx33EGOf8p83qlCg8m0YznvJsThw3o3CGJHmiM7vv+uNLaMtlw?=
	=?us-ascii?Q?usupnjPdxbrdZXbzikVs312ML/TVP6s8qMU8b7DtjE4EqVhixvtN+ZGxIVJK?=
	=?us-ascii?Q?0KzoC8C8bktQol0RNWc818k8cAcO6wruT8ZEgZ5R8Zk+qy7bmpcdGi2FCbsW?=
	=?us-ascii?Q?s9je5QH/Yn6UCHJ1c5oG9uCwsy+NTWu5Iw/UyZUrFlveovYFyzZXsXIA3K0a?=
	=?us-ascii?Q?lxExdE3NfIXWcMgetjHAtg6j5PT2NZFgeIC/RUQaNnV4o6HVpSewEuPC0pwr?=
	=?us-ascii?Q?VgHexVgfvMw/FLOaoG/R+lKAproLn+ODDh3D1pBjq0e/gCJuBSWILxeHKahW?=
	=?us-ascii?Q?q5Jna0NBrGCp5GZ3+qrGLpGy0UCXiQUqxoi+EHYPhuY3AxYxPhR2nUlPIuXb?=
	=?us-ascii?Q?5yFuSIUekF7EchRUNEHzaK1T0eBkIkvdkOvtJRFx2/1YcA2uasFAjbzVvBHV?=
	=?us-ascii?Q?MSxF+3SACPq6sNMNgm0Cu/UH7JxUz0TCBh/SZUBT49E+7Yes8YWgFBDj205N?=
	=?us-ascii?Q?Mp+TOTxnEq/Sf/nEQPhey2gV08XSH5+37sUQo71qI16kkeOSHoUiZxZ92IR9?=
	=?us-ascii?Q?glj+z7pMxkcYjul7sFNTksL8yoKrvPERGBvpUgaRElg5qmlK2bUKO5diNCLj?=
	=?us-ascii?Q?HaewpMmmXkY5Xf7TmEQOZhAwT9/T8KrKjxzBmUpDkyo6N8Z1iijvF6S1rU5X?=
	=?us-ascii?Q?6doyYzqhqNcMQnhkv2bK27LTFrUXktrhC0ABsnJ2xZiRnWgbrFzsoblnlebD?=
	=?us-ascii?Q?rKoVD9/mufSXio0kFwHGCy8kihdYplrZdv8XCNgYMdqVkTbSILPM7+QT3feE?=
	=?us-ascii?Q?lAeO4y6o3g4K8R1jUgNrg7f0pe8o2xN5oqw+wTJXj75JdqPzbeufTeyw0YPi?=
	=?us-ascii?Q?kDFmcPQZ1YQ7aAOv9e8x37tsOHwwDeqz/N9s/rpyqto+GyGqVjh3w1KMwrgK?=
	=?us-ascii?Q?NEt2SLFP5Eb6KdYskenPL0wzNkd0yLDMz0yCNIPoDpJ44z4P2APDeA5Xzgh4?=
	=?us-ascii?Q?s7Db7ETALugxj5MA9fTSin7gcOkwlJDzxeravTfwq7laIXqNF+Mt4IEi94Rs?=
	=?us-ascii?Q?RGtman4w0dQhnGfzetD8P4kt0GstkLSxXwmeezCGkmK2tBRHEqN5Olrimr/P?=
	=?us-ascii?Q?jb5MSFNcL+dHhWKg0Cibf6vl5j1o3ZmE4CzOI6/xz2kBgG/W9YnAIg4sBXRE?=
	=?us-ascii?Q?jmYw42Kp2ugl7V2ivgeqwjtyl43EwCq3BBYSKg9FL55TxqFMyCAs/U+7bVtm?=
	=?us-ascii?Q?/7PCgwOqunni2VGWvO06JdDBSksstiVDmNMy9W3uYmtPM6SGbTApPcjW+bem?=
	=?us-ascii?Q?Uq3uRUmeM0yZNeBmyxrTv8k=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c82371-8017-4197-5f91-08d9ed06d2ea
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:33:01.6141 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDxsZ8OVzzcn3EziFmxkt3V6wB/ovplKbr+7kX4+3TE38TD3TwdWdWogUoybm0UyyF1ke3SnrbndMi04Mm7HgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR0601MB3705
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 12/13] media: wl128x: use
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

