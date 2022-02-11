Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D27C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-DJ9OqhrnO6GYP26KnN1xQQ-1; Fri, 11 Feb 2022 01:08:21 -0500
X-MC-Unique: DJ9OqhrnO6GYP26KnN1xQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A000E3E745;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AA9B1038AD3;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3461D1802E34;
	Fri, 11 Feb 2022 06:08:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2WHDA031591 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:32:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3F0D31120AA8; Fri, 11 Feb 2022 02:32:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 391731120AB2
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0201B3C01DB8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:14 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2111.outbound.protection.outlook.com [40.107.255.111])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-260-4uIicU6LPYeoqTIOfEtL3w-1; Thu, 10 Feb 2022 21:32:10 -0500
X-MC-Unique: 4uIicU6LPYeoqTIOfEtL3w-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2895.apcprd06.prod.outlook.com (2603:1096:404:31::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:32:05 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:32:05 +0000
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
Date: Thu, 10 Feb 2022 18:30:29 -0800
Message-Id: <1644546640-23283-7-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d708849d-f73a-4f4d-cc35-08d9ed06b144
X-MS-TrafficTypeDiagnostic: TY2PR06MB2895:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB289554482BFAB287A31191B5BD309@TY2PR06MB2895.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Knvn+ZoyuwtwWjb9mcX7NX4jSd5sdfPjHKvVg0RXnl4B0HLfdv7nMLFc7oEB4uoAC7nhPliMSDWanEG6pMpbUMVchrTfRPtCpo+Y9i2hsRrc25VPJsQIlYgbOHynMgwohX+gOCxM98x/hcUkKTKy6Ryyhot4nSM/0df5459+EPX+x8NZu34ETQArWLJOO3DJoFyzdyDDJijXFnKF8StSK8SDk/KX6pxA24EhE4BsT7pE8nNubWPzCoKTJZ7vOov0foDGTTu6krh/sLcMo6L6nZ6nydKlrooia830KyO7n+KfO43/q8wgsu0A+JODt2HzqOlnx941h+brnfgGknRGrExAUXDCl8qIKFU0jeXg2oIM3raNNQXDgmZPJOmeMV9EhhTFBr5mgg1YOlGcDkX2Rx3CZfKwql7KkyvR7akXzIHPo3pC+7d2N4rU1kFHPBOq+rv1FrY2/QtW3a0t65ZNCOQDeECkSq5ewxwXJiYpN0ZKgFH1KLjT7ocJcx1ye2Mjkzh1io96S0XXVoxVwnFgltmxzN3tbxnfFLn3kP0Jnh9Sv4sKlzKr13KfQgEjlD66Y8FsDfp3Xp3FqQnn+hJ4WkYB0fL0fxaXSwDlsdL/R1zm5erAtH3JjL2OMueHjzOjBFj1hDM2oTVUQ3HXfriBYbSf4BBfNyfwfOv7LhlhMppZxHs0XurFN1SuOtP7wCSnfPcNMxU25l/4naC+SDZhkRhEnwSvc6XBS+HkJgo+XK7hZZGCTdgfdd8zaO/cYRS9
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(316002)(110136005)(86362001)(6486002)(38350700002)(6506007)(6666004)(26005)(186003)(2616005)(6512007)(5660300002)(8676002)(7406005)(508600001)(36756003)(4326008)(8936002)(83380400001)(107886003)(921005)(52116002)(66556008)(66476007)(7416002)(66946007)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j1JTYbUZFwE57rs9P/bZPsIXhEWUhUwZYslxJXmoBcB0DzYfbRs71yby+bz/?=
	=?us-ascii?Q?vz75e/QAd9pa2P700yMpBDdgLxzW6+5gs4C2NReUwTJLVy/jkasgGvEJEAMo?=
	=?us-ascii?Q?ANyh3VAVxDLRWeKzNgfmUh59OQ0gG7J78o38VzqvB2TASGOVv9JmA04H3jiz?=
	=?us-ascii?Q?VATIIQjKFAWUEX2zZraRVTaLYF/Kn/KwzMw+jry1qtD4Pk3NcNq3a9h8UVqa?=
	=?us-ascii?Q?zDvMEWaV6dI+Ps0UjvurBJ0po1LIa12Dn1BruvzU4WmY8X/Q2Sur9NeUloSc?=
	=?us-ascii?Q?8ccM0l5hQfo0YztFRCut2eaB6mWaG1NKEJ3KjWSsLKJU1ksTHAptEVL+jpRp?=
	=?us-ascii?Q?Qj7+D6zg0cYdt8RfQzBKDr/sxGlyKyCaHs1vK6+Z70aP5NdTA0vFxnluiB8C?=
	=?us-ascii?Q?p3N6bDN7BqbEpAAAMj+WVfPHTtIByNjhVb+oDGgc/O4OLFVaYNrrrVHz5Zi3?=
	=?us-ascii?Q?tt5ZMkj7zIUURoHN7vpQHb3Y99X2LhgNrHZ8kbkuhPnXNZAU0Ysfw/jsRKos?=
	=?us-ascii?Q?MzLH/vn9iS3+9Jk5h0q75TeX8s/kGubhwUfMgV/S2lLcpf0UpUsYHxxtYzon?=
	=?us-ascii?Q?K0oCVegi+YetZ4v7+g+GSVsGmb+KPqjx4Mr695Kr/ltQ8+JgB8Ia+dmkVLpm?=
	=?us-ascii?Q?dq1udpl1z/U8BjmWMAcnjNrypYQrJkBH0UESuwbjcCN/nGRl+164MP1mXYSC?=
	=?us-ascii?Q?fsVevoaKz+vMKE14aCjXvtA03yJ/PZTteqsLnw66sOptNlHnVKIL9l0Fdcj+?=
	=?us-ascii?Q?jDebUhmOIBpfoOIcioevcPPSiH9jWL1swvSekt6owINn4xveOlxIl0GOQ3j3?=
	=?us-ascii?Q?Yo71yZzslNQDV5uF5+Ur/j7819SU+IkaojzQ1dJJ1+bO7f2XBNBmRiFtCytM?=
	=?us-ascii?Q?viKz23TLEqe5WYTk+T5zePcV84QL1bJ2C+xqdrSkr8Yf6OoaeZBupFAwVm4x?=
	=?us-ascii?Q?cTVHHVYUMWx2PPwExu9WPAKIM7Uh190sthnfabctRky2InIzIZAhV4Mku/Kh?=
	=?us-ascii?Q?SzHGHOKpVYOThcYCUVE8Hmk0yhWYjAf4LcHs9rDTRBw7GqMQh0dP3IL9OLY7?=
	=?us-ascii?Q?BQ6HfAy+tZk9yltgjheKpwqhga1YZWgZQPYAlpDINa27srj1yAPpMJDC8MYd?=
	=?us-ascii?Q?Uo8qF+DflfHJJQHU/+hRlXiymTJBgXWKu12JEX7xCeknq1Hm2kyhmScKRHlU?=
	=?us-ascii?Q?1vQpaDbZgMU04tH6zjPWq4ENhOO27Qv/3PHBcZXW7HhJQ7IlfO7QKTINUY8e?=
	=?us-ascii?Q?dr/J825MBIGDIxE1ZIW2/lJoP+5aYqcAj4Mn9uwCazYon5CmGekCEjPpKYzI?=
	=?us-ascii?Q?/4U+1h5LnacScpbVRhSDZOhzC/nvAredJ67lub0o0a36TEg5zvNi9tugM5q0?=
	=?us-ascii?Q?F30Zr1Xo/YHair/UowF6j/fWerUeIUQhadUX7HZz3tJuCFj3rjerGRWG6qPW?=
	=?us-ascii?Q?q2OOJcB7iltVZ9HQI5GAo4/MsgPPdvQXOtXIVeT2fLFQeQwtp9m5ixLahLkT?=
	=?us-ascii?Q?IevJsLNjsAxF07GN1agDblRVNjIofefahuoICwB6CS/Vxns6d/Yqw/ibLnrt?=
	=?us-ascii?Q?Ve0p0IZq4Hz8+TRwiysYCTaru+5OfIlnMukaKBQz5hUy12PLehFXl8E6uVFv?=
	=?us-ascii?Q?uTbGOTOaM/sLAUWkpuhcXA0=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d708849d-f73a-4f4d-cc35-08d9ed06b144
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:32:05.1954 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKip6f9iqiS3IpgYMeOPaufHSDL7O8bFVrZCqIKCGXNHOnl1Y+SvZVBj97LT3qYik6/RGDYwW2+DwZ8sR60wNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2895
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 6/13] input: serio: use
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

