Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1833CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-2oRrZbD9PTGCUOSQfwrWxQ-1; Tue, 15 Feb 2022 03:04:16 -0500
X-MC-Unique: 2oRrZbD9PTGCUOSQfwrWxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 734E51091DA6;
	Tue, 15 Feb 2022 08:04:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EAF05450E;
	Tue, 15 Feb 2022 08:04:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 05E4B1806D2B;
	Tue, 15 Feb 2022 08:04:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vDVS004774 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9BDE52166B4D; Tue, 15 Feb 2022 01:57:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 724552166B44
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74FBF3811F22
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:09 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-2QolVexlMP2gj7RqYv9K5Q-2; Mon, 14 Feb 2022 20:57:03 -0500
X-MC-Unique: 2QolVexlMP2gj7RqYv9K5Q-2
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:41 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:41 +0000
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
Date: Mon, 14 Feb 2022 17:55:43 -0800
Message-Id: <1644890154-64915-7-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 223ce6e0-9445-4c31-3457-08d9f02668ee
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2771C3D0F113D3DA4472A8D3BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: cDMxHup5yWOHw8mFcFUIaQfoxyQKud4jrkTMFg0CUJIXPvP58tsdTdGcIPk6yl2u0h3zsSGhDm59qTDw1/o+vkc5hLhThbG+y8cUIRSBF4zBFbj4JTj4r0Ryq8RTF6prBUlIBAsXDYTtcK5jq0oUUaPm1SJi8uVupnocTn33UXOvKQOcNF4kH31q1XkG2vl1qev+hzrXLR9VxrJ1KVh1rd4e53A/iuAR23UZU7V9qPI9XFaJ+8I/3Zeg7wG4S7HaBtJXjiIdoRnVbIMoMy51/WiMdEaMEmY7uD4/uza6Ea0bgj+01tm3mOEScGl8Qj4nEi2euZtMfeVr68/6pgY74Wngu4Vm4y/QrNGWYHZ8P8ZXklpGJF0hEYlZCdOObcyOGKGduZczot8wEs7b7100+D6I3eqzSwex303n/63KCjeGBo8d8PCPORcic8FZwyzuqi99yT2n1xmIhqxpsPIs5bQkY2792VFGr1AT+k2O5q4j8tuwROSGkQIEZEmMTqIDsLaglNeKbtpIMVI2AA9plEMwQURwJZs0INhcCkZxFja4Y5C+WmTFiW/ytBTVwCsUNLnk68k3lbn7SWYnVJH0UfiV1iq82wofwKcxaBfMJlUwycgzL8u01S7pBZlqKHK84uHHo7QLSauT8PZNX63zosBVkCBgWMZ5SUHjaeLSp/IYhJwkFLHHT+qyeuYMd07i2++Wi8wYtdMmNXcDSpmDOxinS+DDxJCgNXzlPYzTRho=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/hNMObMNqtwdyZN+b6AB7PMwEkk/ZcXye09kWae6WhE+yHoUl9Og9KQwn+um?=
	=?us-ascii?Q?p69J/+02qfDjjMtfbZTJ+7qmPm4+sfTDBW5WszpyAdBt8tpcb+/Uilh8YLb1?=
	=?us-ascii?Q?ZfDGpFwdHwEuOLZMMHgcGZJZwYeseT8iqRidtMx+YJcw1nS1EQJv8MwJt82Y?=
	=?us-ascii?Q?nE/75Ib7WEdeOtZZn7R/7qiYlPm1oSx5xarIC9FphLxn7tFlwBURQfMMSIx0?=
	=?us-ascii?Q?L6S9EtQNkPa6nSs9Vid/eUrEO4uQFTai8yf4WCRXJNwZILUaVfQyxLJDwJ0r?=
	=?us-ascii?Q?+vWUuE2h79Bnl+ikhlQmeuDhJkQAWsBENQf0BQ/Tk41kUSe8hjSccMba5dvB?=
	=?us-ascii?Q?1/LkpNf3prN+1BhNe6cYvTvplggzF+TmwaN/8Oon/RD/s8ub7mNrFw+6GWJe?=
	=?us-ascii?Q?WaIWsbnVqaXgfTJQEfY8Qe0IVDAjVlGIKaJOJ4APCeMo65VlASSMLkxkSSpA?=
	=?us-ascii?Q?9I0B09poREZyCN13zM+AGYHU20po3ZLu/E2Tzm/CiI2iLbRoW/UtvlYExXa/?=
	=?us-ascii?Q?MGFdRNNm8as0FSAhp6QV7kzpXugurT5bXRr/kJC+zoXt14EEzL1JPWbtLZzW?=
	=?us-ascii?Q?ySOjdo2jFaJKbgnSiCbn9ymIy4IIsX3EFMqJ3qxvBPu94MdW8VKse7MMcmdz?=
	=?us-ascii?Q?+0WQ3PR/xFAprd6Rs8nYHX6kbQUBt8KvFhDn4S08X8+yC1sZ3gm//xkArc6D?=
	=?us-ascii?Q?aFQL5omXkj1dogbyz8AdqtZeIOz9yS/o0+EDbikm+jrBAVRyWZf6JS13Xj6M?=
	=?us-ascii?Q?xB2zwBdyyguCeimCO+detEuLS3ueLQJm4RusdxCttplqZcd9AYkkU7MSV0S4?=
	=?us-ascii?Q?cOupaSmB9wDwIgrY0U4GTbpIwIJXSqV/iVUMdAQdY0Tm9rGhyPRiM6NnuyXt?=
	=?us-ascii?Q?cJyXSflP8+eb3/oPEmVUzyVm0j2a0YyBLTodxUudr7wQpHLF38g+mMIiJtzz?=
	=?us-ascii?Q?DQO9gPfn0zM8f3HU+S8hhXBlql2p/vb2SaQ4l0N9YLnkTRTv48gPblxKRmy2?=
	=?us-ascii?Q?bjf3cOAsYmRRAZO6lwx5TpXT7Pjf8NY3aG4f/FfmZ9cM3Lj0s7AIvH1qhYfF?=
	=?us-ascii?Q?znSwef88plc5VWdwzuPGIoASNK/cA0zF58aBA5ORjsY8/jM84VnlVibQ4XAu?=
	=?us-ascii?Q?6WZKwyrQL4acUhcBhbUdhRAWWlfQIbSgRKxANboe9zhCVgQemb0jRnYlZv+i?=
	=?us-ascii?Q?5b3v8leeD/rUZVFDVsxk8j5e/n13FPYmrlRObxpaJEY0WroB9v7tS6Uhc/O4?=
	=?us-ascii?Q?vdSoJT9f+1rEQwYaoC0Q759b5yMtht1/BDjcO0B8j2l86QZNVlnrchlGyrxA?=
	=?us-ascii?Q?bxHk4NDGk+taU67w62VNRHeZKQkeyGgQCKXnQw3trcmhXLrcBAdZKiiLbdK4?=
	=?us-ascii?Q?o59tRU+2es5UaEe6y5qn53dnlOFv2HUM1Yc6//VKm1G1GJAA+bTsbkUDdYFS?=
	=?us-ascii?Q?PLgwUyE9/Rlnmk3Jplmyw1RyEjCDLdJmNSHuC2DQBLklc26boLSZ+QqV2VgS?=
	=?us-ascii?Q?1Y6EhFeXNAFCTllsecc2Hdq3oJ3tYjL4UOwgBeFLr5Nxg41mSs3/UOc2SuDV?=
	=?us-ascii?Q?X7mWIjKLMI8Ts+RIQ9ZMkZO07PbE/RWxPj1cBpRlgvEEyi1KuVrUWrr89j1+?=
	=?us-ascii?Q?BzOD0j2m0Nov7hSAX3g5+GM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223ce6e0-9445-4c31-3457-08d9f02668ee
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:41.3563 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDMorbaPLABqnTTpOwm40CBkcz4dtMZpZlZYde5e3nsJXS1ZDx0+p2Hseebj67OCT6NIyc0pHCU7ReC2G7pQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2771
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V3 6/13] input: serio: use
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
 drivers/input/serio/ps2-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/ps2-gpio.c b/drivers/input/serio/ps2-gpio.c
index 8970b49..7834296
--- a/drivers/input/serio/ps2-gpio.c
+++ b/drivers/input/serio/ps2-gpio.c
@@ -136,7 +136,7 @@ static irqreturn_t ps2_gpio_irq_rx(struct ps2_gpio_data *drvdata)
 	if (old_jiffies == 0)
 		old_jiffies = jiffies;
 
-	if ((jiffies - old_jiffies) > usecs_to_jiffies(100)) {
+	if (time_is_before_jiffies(old_jiffies + usecs_to_jiffies(100))) {
 		dev_err(drvdata->dev,
 			"RX: timeout, probably we missed an interrupt\n");
 		goto err;
@@ -237,7 +237,7 @@ static irqreturn_t ps2_gpio_irq_tx(struct ps2_gpio_data *drvdata)
 	if (old_jiffies == 0)
 		old_jiffies = jiffies;
 
-	if ((jiffies - old_jiffies) > usecs_to_jiffies(100)) {
+	if (time_is_before_jiffies(old_jiffies + usecs_to_jiffies(100))) {
 		dev_err(drvdata->dev,
 			"TX: timeout, probably we missed an interrupt\n");
 		goto err;
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

