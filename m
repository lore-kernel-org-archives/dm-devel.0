Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CADC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-eRc4a_pDO4C8AIvW9bMIuQ-1; Tue, 15 Feb 2022 03:04:11 -0500
X-MC-Unique: eRc4a_pDO4C8AIvW9bMIuQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99A721091DA4;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A6FE62D73;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5331D4BB7C;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vCdA004768 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AD67C5361DB; Tue, 15 Feb 2022 01:57:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A86175361C0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FC1385A5A8
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:12 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-yQhGtChSMkq_JRVN_Zm_gQ-4; Mon, 14 Feb 2022 20:57:08 -0500
X-MC-Unique: yQhGtChSMkq_JRVN_Zm_gQ-4
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:57 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:56 +0000
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
Date: Mon, 14 Feb 2022 17:55:46 -0800
Message-Id: <1644890154-64915-10-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eca22f0-7a4d-40e8-7914-08d9f026712e
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB277188E6101087AF9235D086BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Zcr4PVFb8yBmpl3ocaDvIF+2MN9J/vXB/CtUB6IOeyqRFToL+6Sv+aHpZnulkJjDqw8mT4QFXz2MZMt7vlO6lHXcEmTgPHn9mR0fIIkozVUMaNaKsgCsrWlDjBt6pvZHIefPbwWFVRRJkc6LnkoyDC337SyEZTrP7bXKuIRY3CJ6obcoC/cHd/Uopx+nVj3hBbKZblY7J/7/0rNV9xJvXHezWiv4IX8ov+WjqLzVAfU7jQi4tjRXAaQ4t7YyQ81aOdePBvy+Pgn/pNIrPP/j2FB6sDwffbv6JjEIYUVDWVU7YL7pfoLwlm5Uwq5/fev9FkauDwN4F7vInplEthZlAMGTbhMbwHLdkdoqdI93rPB40eB60pGo8oI6rgtky92Co9cEt0cbPNbHo1fl4ivKSQmIdEWuEwCh4wDE3DSiZvVkQHcxBo7JcFo0v1LzY/xsTlgX7QZkIvYrUHXDDR0XN4wY68zGamgkeCFI0abyV5157K/wtIoqdCFvjtJx6a2fvH9puGR/jDzOpl9qzV6EbZY/WkxCe7xi9hfZNZizMAViGwUtSp1+z/6PA/+MOoKriv0b1K9aiZnEVS9YDsNZDidZO3ws0YJLrQxQ+7QtE0xmnQA8e8W5juxb88RAUHAaxTok9ZxLfxiYEnhaTEvPA1F2Vo4azT7EGHwWl5YX52Bxn4oD60zEC3ycTaqC+2/Mzy6GdTgMGt+hgHM/JiuQ9Y6juTsuM10f5oRJugatg+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(4744005)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kvvvXYfY3SAz0fQ9bdPKkWwlseYrmsnnNXiKA6wvTFgdPbGpEpATtSEhOssr?=
	=?us-ascii?Q?QlRASukWmlcLYqBRGOFNNNK4w/V+ngXI1xag6H8zRzDxQrPUrjZ9W6MnNg3q?=
	=?us-ascii?Q?pFbtJcXzspJsA2abO+qTZMQG9SIQW0qn8Ne0SD4UM0x4ciWf2bDZSFwbdfXh?=
	=?us-ascii?Q?cs2PTH+5miWioUgV/xyqs7Va1FhtjT7sCq3cjKOipQ08RJ6TbapWnsAAj5uE?=
	=?us-ascii?Q?2EILgNocOgNkv35E06TC8KMCPyTlALhakB65xvyMqnR14gZVJzbxNIG4/xRS?=
	=?us-ascii?Q?/zGEBY9t9C0lBRHliJTokvqbnXNa6SCePt3wzejdqotwYiNwXk+cTLluVXPl?=
	=?us-ascii?Q?OQr+4QI1bofV9PVUDcKe+6QLCPcvEi3L6oxhi7R6/aij6Wbz2nz/1hGmW5Mp?=
	=?us-ascii?Q?kOfk3BDjRmjvLpQUMAbX/dhXwcTmFTyAAWvvEjJTjhnY8IbXYUBymb+8no7f?=
	=?us-ascii?Q?JEJcv4RMScCJ6KDoy6IbO+DobeBeACuMVXQ3uDH1ugN0C76r3DtFfUfaCG7U?=
	=?us-ascii?Q?3ECBaxjx+3VNKEU62+7QK3EdpuQOX8xVM2YRf4A4tCa5QlZm0vEETiRN+aTM?=
	=?us-ascii?Q?Ssp6Hsyq99dcLxRo2VCewp1/29iGwgIpdLgI+Rlx/wlBj0byLtp8SQKf6pcg?=
	=?us-ascii?Q?2GIVADcrpKH4bP2miyD45/KFg4Own0OY/iGh9aPKp0XR2dXACaMcnhs3UoTD?=
	=?us-ascii?Q?CcRDW8SW2bfEpr6M1T04LSPUf5qIq0k6GMaaKZDiwq/U9Moyl0Y2Uq1Uk/Ei?=
	=?us-ascii?Q?GhLUImQMqvU4whOPH9rj+4D+ZCdCdxOjm0X6wsEhLhM/+J2nPDlr3NPp7bRV?=
	=?us-ascii?Q?2FcTbVjYmn15s7Bdn6GKP8ZhOCuQ9/BdGCsGtImuNuCrmnYeFvi20PNhXwmV?=
	=?us-ascii?Q?3nPQ/ArLuuFuSsY0AlMRmHrw5unISCLDGfOJecHNr3pBv3qyFr8Mx2SbH42d?=
	=?us-ascii?Q?eYfEiFjZpmp9FzOhh8HdTPy0US5tt4Y9HtDxjy2G1TK9N6sUgfdZ2q21bsoo?=
	=?us-ascii?Q?RKseRe/BukyoibNAP0jclUFoSmIarhuBnp1HIlVvM9JkJgsCmEV7ZXG/3E7v?=
	=?us-ascii?Q?QFzkPKoLQl+U+I5cWR1wJ2tN4cNoGxQIPGUE2srDyezmTx3XYlrtexurw4I0?=
	=?us-ascii?Q?yVE2ZL8JRpVqjRSa0qlARtkcrySi6QURVfSAPvJY4LpYng4OHsUH1P95gkDb?=
	=?us-ascii?Q?6/9uS4aZPGpgppkcSf7myWhFfbF/pHMXDp8Y/yTBWHhXfem09LowM6/ZP4kO?=
	=?us-ascii?Q?8JgRLFh9QPaoiM8eDMnaC9Ep5D/MEAIwx509TTWswmx+UUjQZD025Z5LMpuK?=
	=?us-ascii?Q?ksVCJGc+j4tBioHZJjt6cGWAF3M5WQn7bstF4eoGWO/8AvzKWQbavaFYCn19?=
	=?us-ascii?Q?le+LZWVf47LShfnlJcMUI7Eiow7kqEaC4kSb9A1zT4TQE6C+qH90Ol421q5I?=
	=?us-ascii?Q?Q3NLK7IQm3biXnc7UCJNPhOn72OYI1wFGJTw2Zg3rc66lQ87OTURCmAUKlRd?=
	=?us-ascii?Q?BKwzuH9yL3ux6fS7DyC5O3m5ynichBH7gd/GsGSi9v8mbYYHiX3DfzZMjGxl?=
	=?us-ascii?Q?FN3nTH+szzB7dkCduacK0SzjkGcNqxQ6/VK40kSSGXROCwAM5PxX/JSqx+L1?=
	=?us-ascii?Q?BIqCa9hQvYDnHEU6b9AXadA=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eca22f0-7a4d-40e8-7914-08d9f026712e
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:55.0742 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdL8lKhc7PkTAFDvkPlXyy4TydiXOxyB804HOKylwE/yyvZufo6UIyoDiyPNIrvNv8DSmBi8AE5pkUsS+m8X6g==
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
Subject: [dm-devel] [PATCH V3 9/13] media: si21xx: use
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
 drivers/media/dvb-frontends/si21xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 001b235..1c6cf76
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -336,7 +336,7 @@ static int si21xx_wait_diseqc_idle(struct si21xx_state *state, int timeout)
 	dprintk("%s\n", __func__);
 
 	while ((si21_readreg(state, LNB_CTRL_REG_1) & 0x8) == 8) {
-		if (jiffies - start > timeout) {
+		if (time_is_before_jiffies(start + timeout)) {
 			dprintk("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

