Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FACC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Fvhc-wlYOGyEFFvrYTes3w-1; Fri, 11 Feb 2022 01:08:24 -0500
X-MC-Unique: Fvhc-wlYOGyEFFvrYTes3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E937B835BD8;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAA4E46991;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A230F1806D1D;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2VLRB031534 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:31:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 46B18140242B; Fri, 11 Feb 2022 02:31:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C6D6142B966
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 239523C01DB8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:21 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2110.outbound.protection.outlook.com [40.107.255.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-57-exRp3nKlP9qTwwKaXH0VtA-1; Thu, 10 Feb 2022 21:31:17 -0500
X-MC-Unique: exRp3nKlP9qTwwKaXH0VtA-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PU1PR06MB2326.apcprd06.prod.outlook.com (2603:1096:803:39::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:31:12 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:31:12 +0000
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
Date: Thu, 10 Feb 2022 18:30:24 -0800
Message-Id: <1644546640-23283-2-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4453172d-1062-40a4-51ed-08d9ed0691c8
X-MS-TrafficTypeDiagnostic: PU1PR06MB2326:EE_
X-Microsoft-Antispam-PRVS: <PU1PR06MB2326541D928E240EFB1B6D23BD309@PU1PR06MB2326.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: eP6YOw4R3jawIEQSMCI45OGmHyly8vyYqkhdazwPrzt/6mtGuIm71LmjFaxy3UVdqYDII6o/y/paR4ORUrg8wMyGV160gfTUQz9n5XwUATSstX5nu22RuE2sZxAZB23/YiAyCv1OX+HuegZUDD5lOEVEc6CekrE4Mal29dnB95X5fbrQGJzYk+XIKdNtt96nwEhHDxQjy4pj7d3pE5VaX9eMSCBhCBEC9iCFkRuzLfGtk9gZnwXMRJlKor3LLtrfA7CBwianCeTo+bpELFXyvu9LJCw03dF7F50eEcA3DuXkoWw9dTLPwjG7mJqa+r9u5D9eBQZBUce22QKwLgyhPcuGXa2kshtC5V81ojRl8eyt0yUNosYZ42KOeUp6toEG3uLD+4nhVSuloqdJKU1VCcpABn0f+LE8zMftaja2FIfzdD27fEwVQxdpD24upmy6rqVLvEi1/2cnacV7YSVU3Igmo40bsXSHClkLZTCPsdZ962221FDY+1pc9yTSlYoahyWqjc/mm81tDPEWnMhlXTZ2KNVr/4IjVUkk4ij26KtXBJmtGzwp4zB4wl2rxr/xyLgmDzs2mW/16icoCVHomtTT7manT7c5fGBM35UA3KKs6k/BugqXbMBiBWWGdWFybPoeG3iZNsOqhVoWWxweotu2czABYRfNcH9FwTUX/zuSKqjfnbW7lQXTJZET+ole3DBOvRqdwg90WVQaBtLlGExMPrX6cUf7lH669g2bGWAQP1QdDWoZoiSLsJ379vAG
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6486002)(316002)(508600001)(110136005)(2616005)(52116002)(86362001)(6506007)(6666004)(6512007)(186003)(26005)(2906002)(36756003)(66476007)(66556008)(66946007)(921005)(8936002)(7416002)(5660300002)(7406005)(4326008)(83380400001)(38350700002)(38100700002)(8676002)(107886003)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MPOxFWmB5E2Pt/1C2XrNteRXkmz8Srv8O1WeQjdRIJU6rqpIOUQ5pVdAGRBz?=
	=?us-ascii?Q?ikiVLOKIG/bsksxsxLXa93yDiSqxXJ2QAMm2lSXohTG0XKgY/DT/HRrbdMgo?=
	=?us-ascii?Q?3eW5tUsoS9yKaWiHtelJ11se6jPYZyL4GXtGZ/ugyMCK1H6QXVu2q0n2VqSO?=
	=?us-ascii?Q?mOZudoKGdD8HPLpn+yYFL9B0KRLO9T1629z1rr1KDv7WgxJ6KwKZwzwjOwON?=
	=?us-ascii?Q?hz7QhC9lX8MBPJT+NuaMNgfnykBSYwV8efbX/Bq35XKgjEF1NVac34OxTqiX?=
	=?us-ascii?Q?Et2rMv4di+3kp4C7gIfqwRyqUNPWmQY/F2Qf+GG0d9b+4nLSI3F5YDGaxm38?=
	=?us-ascii?Q?SoZ9PQPJVtzh4lfpYCmtW4asY08kGCWIfiycxT84k09lt66SDqSkN3qFXLDo?=
	=?us-ascii?Q?OLlE5VAMR/cUTOiaIBxkyDiB04apQLL2J+bs6nSHqSs3E+hE8/hnt6oQy9GF?=
	=?us-ascii?Q?vrq2/c8fCDGdiqhQ8tODcW7iAdemra8ZS8E8p30MBjxIgVyr69Yx3pXWnZ7e?=
	=?us-ascii?Q?fDBd/whApX0RA2ofv7R6KVppKQgAImbyWTvoxOmKWDJzp1faafR1ZSyg+FQV?=
	=?us-ascii?Q?aI14/F/RcFzsXxwReGbuabevcgnUx7A7870drwtY0Qowhe3N1+6nXXW4PJOI?=
	=?us-ascii?Q?3iV4TXCAxYKQMy8ypCBgG/8iIsrrsc4qmyUOwo/fVu7dWfEcZ5DwizXeUPbg?=
	=?us-ascii?Q?hpBgQhVBphZVFQP28m5PyvpOpMuYXHs4XSfHi/t+iOQGs/7TdHpP8HYqHZc9?=
	=?us-ascii?Q?kiXAni7iCPY1MLg10Ha4GiSPKGdXL2p7ZOaX6l80MS1XPfOgYK4ApWhaWeZi?=
	=?us-ascii?Q?GJQ4GVKoB4uqy6J1VWsms/N3WIkvggzBvltoJbr+Xebdd70O3qtnsPlv9ENg?=
	=?us-ascii?Q?2/yQmwATPR/bh0wZsQAU11hDUXMgp5LRSoywVb/BDS8nia7h8QO3eYdsSbjW?=
	=?us-ascii?Q?JbBYtM8noZ1Q5XN1v9RnqTrwpAFnU2XAUijG9nx/8azvOmvwa2BtPXSK7Q1/?=
	=?us-ascii?Q?ZKuZHK6JcKwyiniw2OJEui2JJY0Wu4zPKIiqAiKMIQC3moJ4Ok1Xr4jjWRG3?=
	=?us-ascii?Q?G7EXbtrYmuGeGEzqwuGJ6Nej6cVYhZ8dvWsZOXE868HGx8RsYhoWqrbJ+1zy?=
	=?us-ascii?Q?qLz196fvBbkdQVFRWhndvp0Kg1VSNyw4gVhiu4yxQpSitvzq52E/s/KMwVCu?=
	=?us-ascii?Q?NOKVo79n30LFTdpH2eJ805D0pTTozL0F9+Rt4+//vJ44EYaYM1zZ+nQ2e30H?=
	=?us-ascii?Q?a86+v45oyfeLMHTk7eSjCo/tqN8/8QgzuA4j+xs6n6M7174uNYKy5WsyX3P0?=
	=?us-ascii?Q?FpzTXFrtjB4U6n7igbXkB9xRWwUHrAq81srR2wg2cijXRnOvILrhmauYP5Y8?=
	=?us-ascii?Q?qG9jdZlfh2SnIjEt7MJMugDhvCYFQNG+lHWY7a3RgCI3MOvEb4NVujgMkG1U?=
	=?us-ascii?Q?jCLwOGiDKQqodG5FlLPNgrh5De+m5iJ28Qmzop2+kX5ID2mg7VNVs8sBvz22?=
	=?us-ascii?Q?9JrioWKIYj6I3fLCdLGvXugW6XB8fYTeviA+/f3V30Gu+/IsVQP83eIvKFHY?=
	=?us-ascii?Q?M5YoGHYg60uf5f8oGOUHibrx427WqgVH/KWJehbpv/NF2OxBzaHu2DUpQ8Cu?=
	=?us-ascii?Q?Trvr9xfXwhLiC3Xf0CZXHIM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4453172d-1062-40a4-51ed-08d9ed0691c8
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:31:12.3078 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/uacg7VVuyGzwc6yT/Jpc+2vpb5IQkWzzzmvRWJ3i/mySH8q4yB1L+ZwI8D+kW90tZHy4eG/bm1/t4R1NkkIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2326
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
Subject: [dm-devel] [PATCH V2 1/13] block: xen: use
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 drivers/block/xen-blkback/blkback.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index d1e2646..aecc1f4
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -42,6 +42,7 @@
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/bitmap.h>
+#include <linux/jiffies.h>
 
 #include <xen/events.h>
 #include <xen/page.h>
@@ -134,8 +135,8 @@ module_param(log_stats, int, 0644);
 
 static inline bool persistent_gnt_timeout(struct persistent_gnt *persistent_gnt)
 {
-	return pgrant_timeout && (jiffies - persistent_gnt->last_used >=
-			HZ * pgrant_timeout);
+	return pgrant_timeout && time_is_before_eq_jiffies(
+			persistent_gnt->last_used + HZ * pgrant_timeout);
 }
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

