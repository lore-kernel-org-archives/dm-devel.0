Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B779C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:13:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-CWAuoKzxPamj2QqtyX--CA-1; Fri, 11 Feb 2022 01:13:16 -0500
X-MC-Unique: CWAuoKzxPamj2QqtyX--CA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 673EE190A7A3;
	Fri, 11 Feb 2022 06:13:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 485E455F78;
	Fri, 11 Feb 2022 06:13:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EFA8E1806D2B;
	Fri, 11 Feb 2022 06:13:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2XIkO031722 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:33:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9825D40885B9; Fri, 11 Feb 2022 02:33:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 936D040885B5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:33:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7761A28EA700
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:33:18 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2092.outbound.protection.outlook.com [40.107.215.92])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-353-731ep-J0M6O2YxGbIf8qsA-1; Thu, 10 Feb 2022 21:33:16 -0500
X-MC-Unique: 731ep-J0M6O2YxGbIf8qsA-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PS1PR0601MB3705.apcprd06.prod.outlook.com (2603:1096:300:80::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 11 Feb 2022 02:33:11 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:33:10 +0000
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
Date: Thu, 10 Feb 2022 18:30:36 -0800
Message-Id: <1644546640-23283-14-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ecfda2a-ef55-44e3-464c-08d9ed06d858
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3705:EE_
X-Microsoft-Antispam-PRVS: <PS1PR0601MB37053AFD614E2C1FEAFBD6BABD309@PS1PR0601MB3705.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: gET8Awy8O3rfEJ2KEFZxWC/slmqXyDgtNj99XlkJW1GWzk84hR/TRK5gKO+GMjL72JwFI6j44TQUDhyT7fJawFzngVXOjZNW+FCCe3vSeBoo9xJOKgQxhSWjwsNyPnsN5QtAphPEQowiinJNUfJGXO4YlIGTyoyPK47tqB7e1ELN/au+VZg2KiVmmdlujxOKh/svgY0Btkt3E1EU9XAaEB/fDl1iFeRBWsyOehLabAOAzB+QTpaJiwz7tTdFl1zm2hEOus6Fm0fQfZvqk7e0K3FB0ES4SOOasvK/MidWtWFzOusgZm2g8OODEW2qChgbIg2e82TJhCANYnYxOzi8e9bEKklSRDc45QifSPZODJHCPBiccXPEwJBMtlg27FzB4C/7N9kSCGDwpu8iJx+Azt+wOrawMWlEco+uFtBmgGZCXWpereILX4Rc2jc7V2AGuLNNTs+gOjMB0zGeJEI9X4q4Qq2u181f0/uja1Bfc4bWCt2sagAz/YMuFQU0PyrnOEIrjC+Dip5zndrETRa7qjBq9QY0yRNQrCZX/j8PyOMfxzDS+WLZNHCFxbFearaLwLx0F0UZUycs9wkTmVmTzZPKD3zwVN6eFYLH3eo+zHNWxp5IEa8sxVkNxTP5j1EaArvagxtVMxLVnAleAObs8ibPNXRtibSSfBbfbrNrXK+43VI5q+1mUQsllCh8Oyviqwm46moiYKGuo49/PM7F2RgyY1Echn1GhCN32kJi9/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(186003)(2906002)(7416002)(66946007)(316002)(36756003)(2616005)(107886003)(26005)(921005)(7406005)(110136005)(5660300002)(83380400001)(6486002)(6512007)(6506007)(66556008)(86362001)(6666004)(508600001)(4326008)(52116002)(8676002)(8936002)(66476007)(38100700002)(38350700002)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?anxVmQzQteJnVybznqZkGfIiz7nVC4C/C1I0BoUPZOiTIogrlkXJQfPjamKT?=
	=?us-ascii?Q?oJ/GBiaYBt42qmKppqJRYlI6K8e8oDSseJKFoNBR04iv6/fm+Lx7GWQvRPd2?=
	=?us-ascii?Q?oa1twpXDMI4qvuvmPwZAkhoKDxF0B174B/eCGvcrZb7MuG3t4wRSryhy++4e?=
	=?us-ascii?Q?x1neH6Wqoj90ulCVvy5lZyrMXkQgTs3QUhg3tOd5nh+d/+3M0Ry0g23wvfNp?=
	=?us-ascii?Q?XjL+GSbFdHDYkdh8FY8WD+0jdtn5kt+zr6DoklFBlihTRmOPDsmAV5lF7ysL?=
	=?us-ascii?Q?7Ot3qkCxkgN6pm8DFreYAQqEpBVcHa9nG/CgeRF7kuwCG4Qp5zSCWpkvAilj?=
	=?us-ascii?Q?+BRyPmamsXHVBCD8KgKSCNvrjxsPNqNfqIOuYlhdCcma00ieIvNk0ZZrkVhg?=
	=?us-ascii?Q?1i6VM7n+qZA599hn/GshE8jQdY3SQ476lJakG6ATJeBo8ph1RCyYfr5vtgx+?=
	=?us-ascii?Q?DuYyutc5Cl7ZbdkYiK0/YjkgOrS6Q91fRSA9ffUTob6enZ3DAwORawFIBL5t?=
	=?us-ascii?Q?CEOPBiHPL4rCujB6wstavCGEUdUniEda70+r8aqtK5YaTkpMa3f/VGGjqYhO?=
	=?us-ascii?Q?RqXiFumiP4zSdqZJULVM5uUUXbVs3ezbCsUaJioSKn0ebUP3bUDyGqPscVKs?=
	=?us-ascii?Q?6SPTJAgp3JhddiZzHFnHbyYlEKO+tPqeIOtQpu/N+JJP+mSJK2CfocrN5A9C?=
	=?us-ascii?Q?H7W35Ydlo5Y7iBCSUa+YM5eGX2PovUV/g5+TJbrVyS1O1VS11FZgsI1ooqiN?=
	=?us-ascii?Q?eY5fqBMZ3IgzHqvBoueLUSCZpUWkoulRF40IN9THC9O2FL4yTz7kJmH6u8DB?=
	=?us-ascii?Q?p4ueZ8ZPfFfUfaser2NE4V2AvtLieom2/4HHb/esIgPzqSNcHy1SMH6Yqu9T?=
	=?us-ascii?Q?ij/kDCVsMQa5ahFGZJicU5qFtwtSDpUMyNkPvUbdMMZkzihwrke1FXD0O1CL?=
	=?us-ascii?Q?LYKOaHRAOc6DGdNZYRTpoNLq047VAMxzRkOHIUUoE5Jq3J9kmtbV+Kk4CVcR?=
	=?us-ascii?Q?/3gPFKfERJ7n2uREHPAqYxq3sjDcxmdPW44xPZKbTq3uE4N4/Z49lO1lzrOE?=
	=?us-ascii?Q?v2a8odAA5+otNk+qAlk0ccQsoMkk3BcwFDNFk7QlIT1UoIrbNhOG3VtEm7hl?=
	=?us-ascii?Q?zI39hCe8/Ebnw4vX6HLRt3KMgLqyCGknQn29QpQgZ/ARx6BCJ19zTEqGeH1F?=
	=?us-ascii?Q?5ocRmCkZMyI8Ke+F6qMylorIcRz6b7721btXextPwLRRMozloFGWmLc5aIb+?=
	=?us-ascii?Q?tMEY/1vMG+D9DmH+eZtYThlQbHn4BQKkZma7/miULWcqc63kQT+hLwhUnj7j?=
	=?us-ascii?Q?v6zcGFy4bbaInAjgb6eoy+3rBMdrA2zJ4VFYdL0zd3z3WxD2sJLfKF35kjEq?=
	=?us-ascii?Q?7wHXFUNq+jRihuVEe2vuTsqTtBwuCDKQW7XklkcaKQ9CZSWh9mt3h7a/jtOu?=
	=?us-ascii?Q?Kg3nYMr0455m7f3VUWVteWlS9A0gtaublibFTjEYc3sGv+xoITeJoQ7Uw+Kw?=
	=?us-ascii?Q?2lWQAREqiQ9wixIO7ywDetYMx7LpB1JoZnJb4gGVHx2QqQPp3bPkXezFKtUq?=
	=?us-ascii?Q?x8GzjbGPH9PpYHBeIIpgbkb8mAtjfKBVfNE8KrxHotMy2YXr+er6qy9SCFw8?=
	=?us-ascii?Q?zXNvEoji+nBbytiph8ID4VM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ecfda2a-ef55-44e3-464c-08d9ed06d858
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:33:10.8323 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8mJtO29nBoysTeez6egaCcwz1EVAAOfzUIKKBW62z5C2FaTL3wFUrZi2JsNpYWrBJ5be6JEHEfDI/DMXA3DLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR0601MB3705
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
Subject: [dm-devel] [PATCH V2 13/13] media: vivid: use
	time_is_after_jiffies() instead of jiffies judgment
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

It is better to use time_xxx() directly instead of jiffies judgment
for understanding.

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

