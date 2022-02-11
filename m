Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC27C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-OT9UPZn6MTK8yBusP40WRw-1; Fri, 11 Feb 2022 01:08:29 -0500
X-MC-Unique: OT9UPZn6MTK8yBusP40WRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5C1A101F00F;
	Fri, 11 Feb 2022 06:08:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7B02610F4;
	Fri, 11 Feb 2022 06:08:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83BF61806D2B;
	Fri, 11 Feb 2022 06:08:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2WfVD031663 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:32:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64C8C401E9F; Fri, 11 Feb 2022 02:32:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60560401474
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 478978032EB
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:41 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2090.outbound.protection.outlook.com [40.107.255.90])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-314-9-587Dl5OyiaeQtb0Borwg-1; Thu, 10 Feb 2022 21:32:37 -0500
X-MC-Unique: 9-587Dl5OyiaeQtb0Borwg-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2895.apcprd06.prod.outlook.com (2603:1096:404:31::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:32:33 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:32:33 +0000
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
Date: Thu, 10 Feb 2022 18:30:32 -0800
Message-Id: <1644546640-23283-10-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35545403-9cfb-4fdc-3fc0-08d9ed06c1f0
X-MS-TrafficTypeDiagnostic: TY2PR06MB2895:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2895E2E05F1120726288BFDCBD309@TY2PR06MB2895.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /syyc21+a3wCMBduHjjEZXphPVqYJ5p1/XojM3IKXP2n2wOF88FCk+axsSaSjzQu5euDJ/910sMON3XxFgzdvGNFSzJmvVNaVyxCFH87g2Zx3g7fZzKolbIa2Qf4v+NnaAhstPPGxNeKx+oCcqDLr1EmEWVZHSjAZxDn2j+zYE2VThN45BuJ11BOD3SI5DfavEJ8mO/wqzSIHeONhxZsXwKT5N2EeKjejdLpqmH39b+4msBOxJRWmpWQfmj168630vLfpPwWl1IcP87OWfhJlOJ9nF/2WjiZ9useg6hjRoXnDuFXY2QJHx5W/hnJnkBo1KR/YoLspn8ycO3L6E07598prptEnsZGU2J4ROEhdfJlRCNqNNrHwZCPu3+msPYi78QGIn/qroKsB9v2ZGSZipgjR2u2lVNyL9jpKVYH/h81s1OJWYtzwJQt078AZy+KG81QnwPqQKZzpJ2X/lNWtMklGIRCIvmjkW1cI1N3lADH2FByTsZBYssmEFJhIRPuNcFrOkSypFVC/srlQvi9q4o/n8aieWP4CdrHkGLroz37ZL0/2NQbkMm0wZQA3s7NoJcCElfSQg5NdmyQ/O/Nz5rwba8gjUJhjnMaa0/UI4sWTzp4RckpqFQiodDUVD/QM87bMwJvwFvlh2WyXdPq2b3a+tDN0IGXBAed0+tal1a5ypZxjJX0/84wP7kdj2KCQk1apHZyVnLcBSIzOcp6h1eJJshDQTLeOyjWQAS8Wa7gy/+g8F9f7ifgNPQ3kCte
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(316002)(110136005)(86362001)(6486002)(38350700002)(6506007)(26005)(186003)(2616005)(6512007)(5660300002)(8676002)(4744005)(7406005)(508600001)(36756003)(4326008)(8936002)(83380400001)(107886003)(921005)(52116002)(66556008)(66476007)(7416002)(66946007)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6LZ5k4ZdbVAaRXz3OQZIHKFg/WeYI3JTBc0emq7qjkfMJK3D7aE3ya+Z6tnf?=
	=?us-ascii?Q?hYyHNf9imAKQBo6+yaVfZ6vGQdMqT5dVB15ayZ0IqGbO+/D9CfPG5Z0lQotT?=
	=?us-ascii?Q?z/58+OXEhhohl4bzdo5zlTGFltOUGGhHnx86p+T773hnHW/arhP5m6U4GDbZ?=
	=?us-ascii?Q?ltsUkIBFjP1yAVYrDokULtmdaQEiuQ1F+okHG4dtENf+9uCwhm/o0uipxBb4?=
	=?us-ascii?Q?bHpoWgfpNI1GyCa527LuxoVruNTtT6739CTA0Z7++GpyqN+E/B3aL+WXZrGh?=
	=?us-ascii?Q?Cp7ViC/18kuakFZdAZfF3RFg/EOwWkQZjJtBRGYqkbZtIeJJwqEjivQWX3Zp?=
	=?us-ascii?Q?CLmmC9upyaiU9MaLBfPjAZOKsqW92iTKX7cWvPBxwcLrtlPw0GAjV8ZBvqAm?=
	=?us-ascii?Q?AzYMu275Aig7wWaPUKSi4pgOiebj+w2ac/K2CGS1oqTEd++3EX1BeuXkLsHt?=
	=?us-ascii?Q?/UQeoRRZuMSqNl8DikxVGmnG2hdC9oWj18rAiPKWt/UYT1BM6b5ptEKCf9Ne?=
	=?us-ascii?Q?4vIwru9a4iofqsCvtbJmaQw2fF30mlABfCNCOq29ZN2CFnm2a5qcCSG0FBeq?=
	=?us-ascii?Q?tPPdUhDG/MGdmUboYhnZjWNf2rHypUcnmdRIZ35nz23IUvzEecgz2rrDC/V0?=
	=?us-ascii?Q?rAY+UFIqIlzB23gFCgj43CoW/91w8PZmb6D8AC+qd2pMfi1mYU4yLyoV3KGL?=
	=?us-ascii?Q?3AwlTgXplrTrOIfrhbSreBuZY2/TAGJ478mTbEQQ0ybzgQi/eJUc2xuOjmzM?=
	=?us-ascii?Q?OsOSGGvDuilFoJwrG8/tJgPOGIW2ebAGYgG+0+1X5I0sOTDdy+2QMYUu+uGC?=
	=?us-ascii?Q?TYFQCoHZAuBQB68Q6eCqHX4KIPWy+loVQFlVOaxaV3naJv3XcLy/OY+m92Lk?=
	=?us-ascii?Q?DzxSUwz6EEtcUYIMn35KeqA4uOnppXxzGVj9Cdci/bl8T0fAJHC8XFfecI04?=
	=?us-ascii?Q?pX+L3YGSMA2w0cdw8CShirsHbc+fGGs0/0KwACjfa0HrZlaIeziGqPUV74mi?=
	=?us-ascii?Q?WJlnXtsM4EFYMiVELBl17c/xm1aPuOrG/pvNyQvcAcG9V8vINCwe8S/ePjzi?=
	=?us-ascii?Q?KzicIiC4AYdS9eliedPxsb9io9V4SFETUL9nR/M93iEVGawZ7aezA+MmrUnM?=
	=?us-ascii?Q?uMWM4eEDMijHvfEKEuL32NCMz7qAm8+1m5LHLIDwALA35S5Yy+jRQo/YEY7o?=
	=?us-ascii?Q?sc/1RTRz0CDjs8D78RfJCqq0Ah+9xHfGfW70IwOJrEBWJHkQojskFc+NAc9r?=
	=?us-ascii?Q?wvr4bETYhnjjd2kpVA0jy+4t66TbQlAetCv8pDrljjwxAEDDBdjJgOHM7x/r?=
	=?us-ascii?Q?jvhwYJ43P/MVkCQ7jokjV+cvcuQDZcYnMCCx9qt9SP+Q/jXL7IJzFvLS0MLX?=
	=?us-ascii?Q?nusiAg+AuGVTP5PtL9SYJOriYFv2AAs/rEJnCtiyxWJUdnaCvU4kCAS2jgDq?=
	=?us-ascii?Q?AWZX2sGc75lZ9Y+l1nmCANRMQrSg6X7dBlBC+5id80Yf/UQIGjd+LkKHiwEQ?=
	=?us-ascii?Q?qpacT7w77TjoL4//eT3Nkkk8lXX7yRt5a0JgN1LOnp1hrayYfP9sCRn0OvCJ?=
	=?us-ascii?Q?/gRVV3aK+lrqRcgJwW2hFhSQucmLGX47pW2IahbtLp8oDQ5C0DY/GY1nGl2w?=
	=?us-ascii?Q?qlheW/aQz1YbuqyBGwCHDZE=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35545403-9cfb-4fdc-3fc0-08d9ed06c1f0
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:32:33.1470 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVEDRXjkHcVBveXA8LcBcEgx0EK2+lRNap1RgZbICtzB7qCPM4wfM0+HMyKZlgP2NMC4+l4/JaD/4qaIh19kOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2895
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
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 9/13] media: si21xx: use
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

