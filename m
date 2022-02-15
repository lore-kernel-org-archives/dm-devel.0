Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A779C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-5zLy1NIqOASHuCtfbfdcCg-1; Tue, 15 Feb 2022 03:04:08 -0500
X-MC-Unique: 5zLy1NIqOASHuCtfbfdcCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6126E814245;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42E985445B;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1269A1806D2C;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1uTuZ004674 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:56:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 51001492D52; Tue, 15 Feb 2022 01:56:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BCF1492D1F
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33588811E78
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:29 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2116.outbound.protection.outlook.com [40.107.215.116])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-368-NXkRC-hTN9WhwgxO-GTSgQ-2; Mon, 14 Feb 2022 20:56:25 -0500
X-MC-Unique: NXkRC-hTN9WhwgxO-GTSgQ-2
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PS1PR06MB2742.apcprd06.prod.outlook.com (2603:1096:803:44::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Tue, 15 Feb 2022 01:56:19 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:19 +0000
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
Date: Mon, 14 Feb 2022 17:55:38 -0800
Message-Id: <1644890154-64915-2-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb48ae59-c9b7-4af7-8709-08d9f0265c03
X-MS-TrafficTypeDiagnostic: PS1PR06MB2742:EE_
X-Microsoft-Antispam-PRVS: <PS1PR06MB27423EC36C6F9582DAF639D1BD349@PS1PR06MB2742.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ehW9dcRQCl7K0OMhzYVyylPcjX6nmo4VnlZxjXHT/Hbn7cG/CjXh2qgz1JMDO7YB3r12scgWD2Bdr92pIAh42huOKciVe14TRT1jHAM7qzCJoA/wFKQaaK5lqsvkXJTOIFWhuiCSX8FigPl7Kehj9sLOnbeeBcpPY6zUwiKLs0xATy3fyWIa+1ZRBDrrkW0ePTHr/xppkjVcdb8J6oXrut22PlWGvH9hg//n0oLDMiR6H2qNe8nyXrrOZLQWWk8OC0CN+koj3CS0wCox/DACsxYBPIOyO4SYFN45QMHIASPy9o46ynzISosljwFHLGi8TTS6ZzCphElgic+aV7rMe+HWU5EeoAhKYrxuBBlwpEfOuzaDlr3atqzQEPKf7C3XBeJDNqkESpsHbXjmSY8ccp1Khac9mwM4QxJ5PMKYvRuExwa0mZVP6C6r28k+tKe1oBueGivJHpXDb0/1KElGF1QOumDv2hRZYQ1LDzHNSYulOAOFwhpt9r0N8qi+/YIyR2Ni2FcYcn+fVeYn6lQvY2bRiYdYuauWaSsk9Qelr3P+gPi1Q80ySgUi9uOuPaCMN725/O+Fx+A/Swct/igciicCB2rTc9lsL6nNysWADFTQlGZjrhRHh1eZkZPx2S9ZliVj3ZwP1fVDXV3/6n8FAd5PvSH4rPKO16xYSyNy3G8x50qsh5QHz/UYtBxSYxpmjQ1kHor1irQW4lI+j1T0kvr5EBO8w/HWg7flFW7lVeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(7406005)(66476007)(66556008)(6512007)(6506007)(6666004)(110136005)(8936002)(66946007)(508600001)(52116002)(6486002)(8676002)(316002)(86362001)(4326008)(36756003)(921005)(83380400001)(107886003)(26005)(5660300002)(7416002)(38350700002)(186003)(2616005)(2906002)(38100700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3S7zj+RBCohZ7GKUMLGIIoYe0d8605t5V57WjF7+5w8/WSiyKZSLbPBIHus?=
	=?us-ascii?Q?aRVX1K74LqbDqCEJrGGcVmakino4+ECanyPXwF5eQrINE4uehvMyV+FJbG6I?=
	=?us-ascii?Q?yUdIkz9QOd1PrU2bUKf8KGiJF9pVB5s+IZxriRzyfkeDufC4StTtp8IQres6?=
	=?us-ascii?Q?savaBhbOKzdhK64Lbv6TP7g+r/SSThIDN11w3cOgx+O9v/RaPHOCUuQsrvjy?=
	=?us-ascii?Q?aiJgxJvi51Ex0BwIuVRfkVjPMfpg+HbsH30T0qzcgIjmZziBETOhr59mciqL?=
	=?us-ascii?Q?dtjugoPVj2luJSrbSN4uThUdLJtxVTpovm+6NHaU7PeDG2bbtnjUtqcl0Nna?=
	=?us-ascii?Q?PytWGUz4kZQ2gv3tddmoKACWnRqEXyYqznENhIyeDPASw6pRUXt/fyayZ//l?=
	=?us-ascii?Q?yRLC1b/5Py74FMgy8uZErYunte7FqsJmF+Lh7FAVbm8GnU4JtJ1hgyvkOnMr?=
	=?us-ascii?Q?hyU32Fk+hxocwrQ3aH/arLboiITlGeeYtWDKCvHeqFgXFyDKFCkRhd4jb6j2?=
	=?us-ascii?Q?4Oy+ZljnPAcEHMoTvRaw9HTOff77umac9Rq4XjnuzBta9lbMuCRbP+42WPR6?=
	=?us-ascii?Q?1ivCrJsDk/QYfVOOjDyEVFeJYpZJkdD9Lcrusc87UDcutoSxolL9HuaClr6I?=
	=?us-ascii?Q?1sMQIPhzHsyz2p5KjAbWUj+FDNLvmzXU9W8aamD0rKzGwG/T/tcxCSM2lXiK?=
	=?us-ascii?Q?bs/F+0AoTlkrqw7U2phqGfzet5eU4qiNWsglBOhFFCOjos5gGT1O8yW4ru3w?=
	=?us-ascii?Q?dpxhLx0bbp0dfDnKM+373j7xdU2tGbrJi9FMwp+B8EAFPmG6jW3KY23OR9+J?=
	=?us-ascii?Q?7t0YPkVhmPeeBbsFZGyOLPSJfF4Gk4WrGk4xdHWlmfEC/EIklvkNT4vXAto3?=
	=?us-ascii?Q?YFJw8LZgMEz4m7gNTmuyMp0lUySKog99xDUJ73dYKbSmJjKebtQpwQBatG3e?=
	=?us-ascii?Q?vIpMs63Y2qcVLmwBIVFTZP6BGlyl24YskItviO7/0eFd5G28cQRrK3SDHy27?=
	=?us-ascii?Q?TmNxBbiDr+pNQYimRo6mWH3HqnCqXWeYJCeRICNnCJ3WVEXFd/cxlNpjEqvb?=
	=?us-ascii?Q?K2IWhdjNb+hEYw/rvV7uXQAbBGUuR0aUnz9Rz621K4dWtqHRWENKKaL9U8fB?=
	=?us-ascii?Q?esX9T+oJVWZXA26j1ZhMt8JHt8XMhuriGIfWpX2WLM/vYAaqX8n3BXWQ+Z6m?=
	=?us-ascii?Q?hCnpG0JWpSWvo9byfGlut8MSJMORQ3aICn8OxC7+5Db8JmgLfz1T2WqQsUHh?=
	=?us-ascii?Q?KwstSFOeKrm+pWD4GSTHz8JOcy+l1dIbSEb0PcAylN+Uwsv7spBOhhFTMM+3?=
	=?us-ascii?Q?JNSKlIIRhMpt9npGDIFB2VZh5tELPLIsVW8mC5Aigy4R9LOm/sjlKbzccvEz?=
	=?us-ascii?Q?yVfK8Vcg6a/wF8pv2Dy93pz5yQvBM91dcCmmqbRzYshkR4pMtPRZ0z5ZFi1f?=
	=?us-ascii?Q?KGkSO1H6HIRLjTUv+CTF5E2BG25NI8JYMmt9CniFVJfpfHRZDz2ldFjaVYU/?=
	=?us-ascii?Q?cYAeYnA6UwsRVF/R9ZxLrFRsOEzWRKh2o/qd2SZrQbCYsZ3brOeWJmDW8F/2?=
	=?us-ascii?Q?eq6o2YgMFyXc6+4HJIP7xe7nUNXbWuQdJncP0C+TOyIXp8XUf9n+ME84NM8v?=
	=?us-ascii?Q?dHH30FU76winpYAxatJhhH8=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb48ae59-c9b7-4af7-8709-08d9f0265c03
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:19.5294 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM6S87sQg7cP78QKhQf2JR+tZXuodYcczaGXperdxW2+QNWMAMXRGKpMD+CVex5j8J/w7BJXOtbIkzGfqsHx8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR06MB2742
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
Subject: [dm-devel] [PATCH V3 1/13] block: xen: use
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

