Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E395FC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-YBmYcAePM7evrK7ljATWVA-1; Tue, 15 Feb 2022 03:04:08 -0500
X-MC-Unique: YBmYcAePM7evrK7ljATWVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A858802926;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39D7E5E488;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BE301806D1D;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1ue6o004716 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:56:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A9E31492D1F; Tue, 15 Feb 2022 01:56:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A55B5492D52
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DB463811F27
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:40 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-447-bEH6yy8lOAi_I_TS7ZU3wQ-1; Mon, 14 Feb 2022 20:56:36 -0500
X-MC-Unique: bEH6yy8lOAi_I_TS7ZU3wQ-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2767.apcprd06.prod.outlook.com (2603:1096:404:3b::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:32 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:32 +0000
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
Date: Mon, 14 Feb 2022 17:55:41 -0800
Message-Id: <1644890154-64915-5-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38200d9f-f936-4add-fa38-08d9f02663ce
X-MS-TrafficTypeDiagnostic: TY2PR06MB2767:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB27678FA9AA8B49BF44E6AB2FBD349@TY2PR06MB2767.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: cg3mXU7BWZZX2gpu1DeSE9r1QeOTrZaWzbXV9fQQE3vaPQlXUz3BZdNXCkoNksIl5vTozGlD8Gj2+CmYAyyXcHBYd8DkT+7NUb8oRLO6thvDkhbgh/Zan/ZryZuskYi6YuoW2Xg6E07AtVQeDCBgWb+ww6qIvZWQBROk0933tOHA1JmERHyCVNXKNb0jDvi4Q5w4tnCVyPKRlGCgk8s0QxAjKXQiddkYA3DYJrkl6r9okpDj2hTbHzOaWy8ffqc4QzasHEg0uZLmKx38zGpStlJDuhSZmgAZ+VdJ8F+5z0yomWBck5miPzz1dRg9xwU/glpv8RyzUm+CGYvGru6JDqgGIDDuK0U2ksW6ksyZy43wGFShyqB0b763MsZSezAZCHd7Rwf/P6fw37zHvbJtoy6h+AfRG0DvrYr3NzpO4/4tbzm4qDcGCqz75/DDY91ixbS7h0ctOVe9p6V2QGfVlDtj4yx3XjpJb89RC9MOU3cbZZlmfUWSe3DLCrPJkn1hhx98B/GAZgxRQ7xJ2MfRS5X5F2xgaej7wHfIPceFe3cOH4o60C1EHA9ufsBD3mUXPrTWUEkZ2+ZooDdsp3hgHZtcdkKLftlHQIkbX8hE/ydLDomCujLgAUp2+n/aNCp0Pca0D940P4Vqf7ar5TCxzK7kVa5GFk71uHEADgNSZst1KZscU5sy/EFZxx8HFszIlVlvJ63hsLI1Q1vM0SY2ObLLjx4JmVGqtW/WyJ8aKGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(7406005)(7416002)(4744005)(110136005)(107886003)(921005)(316002)(26005)(186003)(2906002)(52116002)(5660300002)(8936002)(6506007)(2616005)(6512007)(6666004)(4326008)(508600001)(86362001)(83380400001)(36756003)(66476007)(66556008)(66946007)(6486002)(8676002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Omh3Yx//sPFK4LbBNvrYl+g310Vjw96sOgDDxTpNoa0z94woUqmxXw2cXufq?=
	=?us-ascii?Q?YNW7NMqgImOnL3vjUfqr6wpZDac3CV3wLwjaPy3Bk4jpxnSHj/Ze0A8E1BUc?=
	=?us-ascii?Q?B6WaNlIFq5bgHa4HMpZyWStgPVNUk2UrbhtoQK2COJvvgyNe9TgD/TEQLAI+?=
	=?us-ascii?Q?mMMeyPGfvEn5TpW2Jc5B+/Q2IZuFhn13i4b4wkuOqipgIQF9tHwZz7j/QJ61?=
	=?us-ascii?Q?UTy1AC+bUFMCEARaW74LGLBrwRi4e+tuEMUvXapESmMJMYF52sRM4GcYD7rb?=
	=?us-ascii?Q?yfPPB0mq7/U86MVeRRGosvIDrjJtnV7hJCvBROHD3Qy8G7meUeaAH9TWj3PX?=
	=?us-ascii?Q?MB2LYhLRLS16qwCQug6wcPoun4ncnj7OBrtGUexCIBHWs39JqPBtZbR3JSbe?=
	=?us-ascii?Q?xNbgAaU0breJ0U0/5w0lkwQdSNKk/7WIECo8y77rGpbW3fdZknljz2fKPeBU?=
	=?us-ascii?Q?QufXnf9jYQ2NneVmG38FJB2dutp0oZeu8ACPSOI0PFdrBmTdVBdx+8YITHTG?=
	=?us-ascii?Q?pCdoIbhid8isjuftnY+mHO26uQL+AKj1kLZvqdDyFg5VzRApqTquQlmyZ8LT?=
	=?us-ascii?Q?TAehL2LALTzBiT2P5WpiW18Twgf2Eiw21Z4Gy9+q964mgwLWROZnF3GO2sS2?=
	=?us-ascii?Q?l+NKe24FoIJH1CGx0gRTS5SvMI+Y4PAviPHGqtKKghOdmbfXv9jTM6cAS2c6?=
	=?us-ascii?Q?t2MuiUq8F4eyF28XPcD9B0xL2/KdIwj7W0ahQrYZtI65KaMG7ZooIwqt/g8i?=
	=?us-ascii?Q?NEJJfHSlg7D5w2M3SblxHwfJLnmfVlWhHkELudfxlvYBRcqQs3d/N2lUYXQO?=
	=?us-ascii?Q?ZTZmo5FF317novBRHUNtyq4ep9b99OiFHaEA4GbpOfZQis4wCffpAtWlJiWT?=
	=?us-ascii?Q?XRgr5ILc7gdXgFMMNfA4jpbOzCtYmoecMUvm/M1TPKjSA/05W+QT6o1vHxeU?=
	=?us-ascii?Q?RFlptPShqGCHgsJx1WldLuR24YaIUKATHlDLo8F9s3ZGV8ybTzc9ndwJRWiz?=
	=?us-ascii?Q?+6ys0W8Iih//fZuWTsxkWbH6aJV7l+AZEU7iQ59f9LN5a5IPpYQ0cFWgAOzn?=
	=?us-ascii?Q?HHeOeLdoDSFMU+Qu1H6YFESId0q3UZ7KqkNPCdnUpZSNXGGw07zWZJp1jttm?=
	=?us-ascii?Q?x0UkcrFtyjbsZw/riF31hpKd0xKJfpETcOjnpVg1IQEGeAXL0ujwfdjvyhyI?=
	=?us-ascii?Q?nFt/anRfOq4/+RD2/jEzHjMny5Kmc8/SHHhsntELHDsQJ7I0Mb/+gSZzJLyo?=
	=?us-ascii?Q?9A+UwWnf3AstXAY+AQKzCapssWAXB2YKKEWLhjGvFlUA8nAI/Zz9AwKZ5onz?=
	=?us-ascii?Q?0em5NDe+992CkefbFXJgiRgENNhu4tp/yOhsuA+6mVCbQYNq3Ptp7Ze/B2Z3?=
	=?us-ascii?Q?nDzAk2zeeQ73B8FrK/UwtMOV2GsV/oFeyiexqJ9pXXuFsAc18VNRk5sULrpT?=
	=?us-ascii?Q?O47d3nZXttoggk0mmnY/di0oBJe7PYYuESPHYw6d+K8F/mB5F6hlBVp4/BnV?=
	=?us-ascii?Q?0yicqMVQ7S3Cq4F1fEdvDrmJ2EJqJ3Jco8qszuSJsuw92mJY9Y9m7unOtP3S?=
	=?us-ascii?Q?XaTVf2jge8xu0I3IA2luGsyvOEBuDnx1q823S3Ar2TdxFtrsOZ5vraCBI5xE?=
	=?us-ascii?Q?wva1BjD8btIX4jqpW32gXnY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38200d9f-f936-4add-fa38-08d9f02663ce
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:32.5443 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIn5iwj1EgCSFXWVwDmfDj2iBmBLasb9+7fAuSjo2wPX/x7UYTBLiuJ5wl+rG5+uSU+IidQrC2kqnHPKNtXtwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2767
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
Subject: [dm-devel] [PATCH V3 4/13] gpu: drm: radeon: use
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

