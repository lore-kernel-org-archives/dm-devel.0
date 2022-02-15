Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE367C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-vCXCCM3dM9ymE_S8YrZIDw-1; Tue, 15 Feb 2022 03:04:18 -0500
X-MC-Unique: vCXCCM3dM9ymE_S8YrZIDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9567C1006ABD;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 759D362D7F;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CE9C4A700;
	Tue, 15 Feb 2022 08:04:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1v8gO004750 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 097FB40D1B9D; Tue, 15 Feb 2022 01:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04CFA40D1B98
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E114E1066558
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:07 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-hlVPAh15OYqcGM-hxKwI7w-3; Mon, 14 Feb 2022 20:57:06 -0500
X-MC-Unique: hlVPAh15OYqcGM-hxKwI7w-3
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:50 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:50 +0000
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
Date: Mon, 14 Feb 2022 17:55:45 -0800
Message-Id: <1644890154-64915-9-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc486b2e-0c4b-42c7-dbe7-08d9f0266e9e
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2771BEC0CF4E3EFFBC004F06BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QCWO2F/w7eHbPOL0e0e9xQNZ3K7Xw38kdf5QuAOps+fk4Qcyo4C93c+aP8pDzbFZqheTj3ekgZGi/KEmlKhO2hsT4HRpBrVAuDZtGAA/7+AhyggclMFAiPWcNsA85irQz1bxTwY4PAmsNiAwaQ7U5Spvdh/RaA08wsakr0eXNmjSl0CdZH2L7u52GJYQ+dB8pnl1cXqlAAk5se8p/5iZHmzeUUX1/TPuhcLcqUzRk2Eeo16YhX3yIkbFJ99sKMhYD2+1kDbpuUZct0ntXKZAy7BcLIGijpcXw0Y6emoKi4BJDB5WcD0wrbuEmvkgfGgyFwom4EhwUeuFZTyP1kHt35Ik673k2CMg80JKoPspYnxTcI2o5Xik5vtOOMqx/eT9W/9H8SZvl2hIT0dF3Wq5m0q+k7tNOi24kWszEVv9suEW8przc+tNA6lbAigv+gB8vbkfrg7QqsER7o9iPLvqpJTmdX2gUoNzdjHT6tCUiyLZQAvPLNgteDYd1Dzkg4eTX70lexMX35irUPEM2RmPi0t2FAljly1zKbkzhvyAl36WulZgHESjauZzgep/bb5v/rCPUyHKd8bgsMfHtFUXthTtzyD9BWd4ajwAsRRZbgQU05R+VhaLX38K/km+TYJ0bayJRFx9pzwfXH1M8z9nUyxmTz21Ial9TeG9T4gHHsfvkQSskZ4H6FJ81jCQZ9P6/CoG+ox2E6Dwdcz2v2DYxiJtDjHnbDQrDqcOOvtT8h4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OcTsoEukQ+WkoN81aeNCUVTtA/p+y9SYnPvIhqVkCOJ9JSD22yIhnJ75M5XE?=
	=?us-ascii?Q?n1Q4ZkQbaUON6f4JhZ5u52/RF/0lL9DGkR2VdAFmwZ7gbTKvT7PynwlXP0Sj?=
	=?us-ascii?Q?vYMWATYITfIVvjjwBQs+QxLhR0zB8XQ/iq78eCj4TYCPdttxNVqr8S4J5Krt?=
	=?us-ascii?Q?L9Zxsj0cXdrtrvCIcr46hltG7mlz+KPHoF2zHRCFoLDMr52n6gbLaF8wzJ3K?=
	=?us-ascii?Q?2InTyLh+JIhF+HH28Pr1pKUvCFwooMpQxcfalNpV/gPowcgYE5jmr9mk2nE5?=
	=?us-ascii?Q?ilzdTc0KFh5COYqtoWV0rBnOlNbOtrOJEIlV6QM8D8TU0UZpUZxmQkC2jd9P?=
	=?us-ascii?Q?AfL2IeaLgjV3AwyMjvD25DjleeiAC/CxM2g8KGW+4ExcNLMEgvFVVMPEZ+KC?=
	=?us-ascii?Q?KhLpNU+/05zcGqmMhuSBLgb19vIqEsQy0QxKp2TbqB++U5FpQErjW6q9oyU2?=
	=?us-ascii?Q?zv7iIanbMDFBDUQguUWX/ERXS6lfk4MdXNjfnyEAnALVBHhsbd7tCOzo0glj?=
	=?us-ascii?Q?vGfxQwyoZSX+Ew6rI9vupdC29l8bA9ElFFLxb5sHOO9THvvx19MUzgby6HnC?=
	=?us-ascii?Q?qIUsGJy1ZnNJI3RBMcN6PBJRbfNGmTh/+ltPTrQW6cF8qTl1ij7i8BC4oaW+?=
	=?us-ascii?Q?DzDJA8X0vlfP+HYOpo6xn3OkZiY+4PIxo/oIHsoYIRzTm+vJZEFeGEggF6U+?=
	=?us-ascii?Q?Kk/XMD84YTzQpLJ4J15NuhHdGqLejgr9F5ZkpNv8A6SPmDEv7N4/KEL9RmR3?=
	=?us-ascii?Q?sssQ4cKyyiaKsJYrcZd8QPNzgiJiMCafib0OQuI44eC93V+uqVglogDPRyVd?=
	=?us-ascii?Q?3l3RvfAHjE0PC3S03f9pYHQlxYaZnn8JotaFCD8vcaXmerI1CF+4qnd+nOaY?=
	=?us-ascii?Q?BYf0BkKZIJTr6od28EU8QMVMLVZXRrPY40XOYX+x0AzMYstmE9zTyUyiIsWO?=
	=?us-ascii?Q?YV/6U3z/A9F7+0CYe14WCbQyYTQ5H8+BosKseJCVFyjSuSeGI06TnWDyaT8S?=
	=?us-ascii?Q?TedbubTINWAXQ1EGqIomyQ2nL5wpZMvI5SpBiWo3yr0/onds5rh//9fIpiu6?=
	=?us-ascii?Q?8vRLvF7QXRtLJdIBF79KfPw+Oj3lqe6saxXgSYx2y630EiT3ll0KLFi2kYMc?=
	=?us-ascii?Q?yod2o2L7hp48sEXqisDoBVWeoVbGUmPlZM/f6wnG2WesR4A2DK+GGlhqbBMY?=
	=?us-ascii?Q?S01mGc0wkRazG72SFuP5RjTwFEdqJ+jaRTlMx2gSARnvcG9cxJeRhIsIYZHz?=
	=?us-ascii?Q?vXQ6oe5jmGF9GGtRSsxTT6gW+VKjtZT/xpVMYw0cA7jrD6Fo/BtEPgR61ueP?=
	=?us-ascii?Q?qnDevb8DlIdYexCFURi6YX5aVdQTCijIT2SeKV0D8NgIgbyKIebVF5Ig89LV?=
	=?us-ascii?Q?KC8/fSMejiS3bwajXrLzv0dNXTJGsSx8oLVGFcaolZRNbGi6+JhZpsBIBqY4?=
	=?us-ascii?Q?lFyBkAdQ3bpSCr9Rvk+7T2K68fUaVC9ryHb7xWFpB8NMG/yYbxGTVNoUtaxQ?=
	=?us-ascii?Q?qVHbF5DIgAwlsnIoFv7dGrWtY3/i7VolntJhqo5JtSAi38QA2b9HhMJjY63j?=
	=?us-ascii?Q?sfbOhvCrzqV5bsjbSeml63n/PoRUV1knUfBzS+nz/JcBuzxJoW2O4wAS2s9D?=
	=?us-ascii?Q?37807mfgId4FgCldTVMHQ74=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc486b2e-0c4b-42c7-dbe7-08d9f0266e9e
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:50.7151 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDKERJZpmV9cVwhCSBeq6+6IG4Ar72+JGr5GCs+hxdBhDvlX4ABHT2cnopQws+WWqunLrTbVc5vaE8NzrOjsrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2771
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
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 10/13] md: use time_is_before_eq_jiffies()
	instead of open coding it
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
 drivers/md/dm-writecache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5630b47..125bb5d
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -16,6 +16,7 @@
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "dm-io-tracker.h"
 
 #define DM_MSG_PREFIX "writecache"
@@ -1971,8 +1972,8 @@ static void writecache_writeback(struct work_struct *work)
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
-		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
+		time_is_before_eq_jiffies(container_of(wc->lru.prev, struct wc_entry, lru)->age
+		  + wc->max_age - wc->max_age / MAX_AGE_DIV)) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

