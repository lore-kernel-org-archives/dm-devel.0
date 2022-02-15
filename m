Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B17AC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-oj1lhEbyP_eJ7uk2VMDu2g-1; Tue, 15 Feb 2022 03:04:14 -0500
X-MC-Unique: oj1lhEbyP_eJ7uk2VMDu2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B66C80D690;
	Tue, 15 Feb 2022 08:04:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49713163D2;
	Tue, 15 Feb 2022 08:04:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2169D1806D2B;
	Tue, 15 Feb 2022 08:04:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1vKdZ004796 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D2F42166B44; Tue, 15 Feb 2022 01:57:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 182492166B2F
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F41DE1066558
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:19 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-E3_9z-5bM1K143LexYxdNg-6; Mon, 14 Feb 2022 20:57:16 -0500
X-MC-Unique: E3_9z-5bM1K143LexYxdNg-6
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:57:03 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:57:03 +0000
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
Date: Mon, 14 Feb 2022 17:55:48 -0800
Message-Id: <1644890154-64915-12-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94ca7f55-53b8-4f22-77cf-08d9f0267652
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB27712D4B9B1228657612CF57BD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: gV2oF/OyYcAeAm3Z/ywQFp3c16XzzbH9iWeVLunxe43SBoP/9cDeHIVvXGFrbl5hyT9qw6wb9GTJ6p5LeyeWYmqPnQ+zLWuflUnNBv/4424U5jg8T2xxqcp3mrhNcxfd5rSpzqaY5Rwscvfb7eRHwch0DpK4wozaZKYqm1tfbD1/cTBHKDs8NZc/gzC7jnJi5YZxQm7mKEt5RAJ2M10E3RvuIyL6lSM3Bwi63xsUUDEngg/cGCX1112Lwk7k5Vk+2lKkOvaciLuNfaJ57e7k+cODf4I5nNvNxiTmdkYhJdLAysmjrFWn4x+O8FBAROaqqp8fqBUejYXCCBnptKwCGAcZR388X3FAsnFHHe/cw2KEIpXslrwP8qh8CuZpTLHgUlciy34lsTQi2m0TnDsMk0jK2KIJBnQg3kDfSxCREokOLWlxOdIXiVAvutyCDogNTbIwdGt446x1kbCGnTcrogKXrfQViqpN5Ief7SdhqhqZBdhfbYbBYYSnTwxkxtJjclRfbzitHpDb0C2X0LDRAdj3A4txuQsihLT+6GNsoGo7MRWPYWL2HjeaBlvNZyEJZTs2hLtAk/eidy5JhCNzkY6bRXc9mncdXZvsEHGDveox7yFQsA6kYpufdfd+XjY4h1P4lnFV5NMwyheCnCR7MU0SpXaXedHQ/3mOCz1lAPLxWCJe3eemodj6x2LfWgBVE83pigXnP9rl7jw4RDj09gdbIliXFMdn78bn4cSQGQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6666004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(4744005)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5MercmGQ9TFzLOeFladCcko3hYvfU5SNs9NOw2+9D7L7k6I0GqVFlOmmJrgq?=
	=?us-ascii?Q?OeLdEejvjAOM9iQNatT/3Ul4EuLFDAPSGEGNRCMPPrbEl4ZtSEEoHvJbGX5d?=
	=?us-ascii?Q?4dTVyLK8fWRpfESUPAtM58keC90j3x+tJ2ovvZIiKR5QcrYiY29J7XsB5V8E?=
	=?us-ascii?Q?ZYyWDoR6BSamZKMmp74V6WqjUm89eqmJN/MT8fqzl0VEay4ItxpbpKUYVgbB?=
	=?us-ascii?Q?2VaNG71bB7BXNzAYY0BhbOCLRcveSC/amCp6DN1Gbs+UQMFhkIpAXWMlLbgP?=
	=?us-ascii?Q?Nk9tgcELRWyuDHqkgy9+H87IqJEHslRUN2X+ykP5NCXvdiicVpNc0g1WzKr1?=
	=?us-ascii?Q?wb7aQa0wTxlgA7XXtLnUzXC/cvi5QObIx2NN81Lh4076pRBm27AQ36bCVJiV?=
	=?us-ascii?Q?EibGe3I+zx6XShezN9vLMRRmOo2XkI3MyNNEFaCQXsKI52aMDLDrttscU3W5?=
	=?us-ascii?Q?p3pquY0GGWfsV06wkhjI9vDvg/nvoQrwoOzmO5XwcUTdsYt/3E20HX58CZzz?=
	=?us-ascii?Q?rWuwk1uEEr5CXT9S5ZM/O8C8N5EQaHYbZM1IXB86S/bBsDYYXNZr0oiUrZAQ?=
	=?us-ascii?Q?5bebvLKa9VJZf1N4UwRQxuJjq5MPuFrmTrzLNEtJ8COwCAzQ93RearXg9xIg?=
	=?us-ascii?Q?j+Ksnmj3xxmMUHmyHg61nmPV7gKHTV+nHhDL+3Ge+BHgJZMUg8FURTmo6npM?=
	=?us-ascii?Q?6VOHlgLBAF2XX1bWMzYV4XUsPjduRipv2yauRp8ApM/4M17R4/YWTQCbs533?=
	=?us-ascii?Q?6caxhl3xrflEJOa1dDdmMIPjvbOuDSrG2DT5rHM9NoTFwsHOJKa4TQVTFtpj?=
	=?us-ascii?Q?nwqNZR3GomhjHPAMmZpj1gGjPUBwCTpuxnd8oeCQt+mhv3FEhsNQWfIPN8IU?=
	=?us-ascii?Q?FWYFIrMyd9FhJJ+c52wEBfgsoOT/HQH9txgCtUP/T4baq2+70aKIsGDyq2+9?=
	=?us-ascii?Q?TfjP/8yrkQAEVeBRoKBHJPIAxDlpeC/B6x6v1g0AMqqZrnxFDPGMNkHYhwMc?=
	=?us-ascii?Q?XeNCxwg4xaC0p3D5nwY8NxydR4y6kXO0EagMa8nVy4q2GYx+R/GzaKPmjaA7?=
	=?us-ascii?Q?xd7I1lSBfjWrizETDcezgnUZT55SgJ+ZSmBtmU50cjPtGaaDmZCfSpj9GFmW?=
	=?us-ascii?Q?ypBWARMZI2UK5YsR7rB6TA72Pu0ubN1pllG1W6A0dGIdCowHCfGiEDvTda2I?=
	=?us-ascii?Q?1WFBQ2eSLYPAvYIuQfV2cnb4ku6eSk2aKAOoXkfHjr88hr7V6Tvuzla1adIv?=
	=?us-ascii?Q?J46sXCKnmkHbKiRx4x14JcR/684RrDlQwWJeq1M9H6hBEOnKVyaFWmV/51fX?=
	=?us-ascii?Q?OZYD4yognVtd+e4sqC2zDpeEioWawPl2tmkIL5uWsTBovrH7tcKzBks8R48M?=
	=?us-ascii?Q?DLgqOBJcZyHCUEI+1LWR7tIOeI5OmmZBTJwVxZqeSZAB+tYnoE43YwlcTLiM?=
	=?us-ascii?Q?R7TDbKvO7nZGR/aj5Ejyx/8DwDADM26HxVjaFK9Wgfq426C9nVyLStuq5H4c?=
	=?us-ascii?Q?+fKQf0vzM9+tFxvxV+f4e7CDzWq5E/7qBCFRAZ7M2UPOC1BMH8mZ4s0rHAzw?=
	=?us-ascii?Q?gWw4undedslAcO+oTr172k07AGApDuAhaJO03dt4Ha8Je/C8zSuCZFWJvLw6?=
	=?us-ascii?Q?R1okkSX3eJUUoB7jqtLR7B4=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ca7f55-53b8-4f22-77cf-08d9f0267652
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:57:03.6675 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFEuzil0urqptxkdME+hbidqRFKNvjpaAGKOrzHhgbeiM5Ro7os/lGC86t2nJ/h1Bal4xr+JCTkBo3sNx60XYg==
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
Subject: [dm-devel] [PATCH V3 11/13] media: tda8083: use
	time_is_after_jiffies() instead of open coding it
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 drivers/media/dvb-frontends/tda8083.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 5be11fd..49c4fe1
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -162,7 +162,7 @@ static void tda8083_wait_diseqc_fifo (struct tda8083_state* state, int timeout)
 {
 	unsigned long start = jiffies;
 
-	while (jiffies - start < timeout &&
+	while (time_is_after_jiffies(start + timeout) &&
 	       !(tda8083_readreg(state, 0x02) & 0x80))
 	{
 		msleep(50);
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

