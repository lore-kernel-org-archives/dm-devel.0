Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F179C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-0p747XlVOraJBK7pHCv-5A-1; Fri, 11 Feb 2022 01:08:30 -0500
X-MC-Unique: 0p747XlVOraJBK7pHCv-5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DB17814251;
	Fri, 11 Feb 2022 06:08:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51CE11038AD5;
	Fri, 11 Feb 2022 06:08:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D5744A707;
	Fri, 11 Feb 2022 06:08:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2WpIw031675 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:32:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFCE940885B9; Fri, 11 Feb 2022 02:32:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB20A40885B5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFD7A800B29
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:51 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2130.outbound.protection.outlook.com [40.107.215.130])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-267-hBP4FC_GMouy0mMf-SKQ7A-1; Thu, 10 Feb 2022 21:32:47 -0500
X-MC-Unique: hBP4FC_GMouy0mMf-SKQ7A-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PS1PR0601MB3705.apcprd06.prod.outlook.com (2603:1096:300:80::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 11 Feb 2022 02:32:42 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:32:42 +0000
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
Date: Thu, 10 Feb 2022 18:30:33 -0800
Message-Id: <1644546640-23283-11-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22c30a67-df4e-474b-1402-08d9ed06c74b
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3705:EE_
X-Microsoft-Antispam-PRVS: <PS1PR0601MB37052B4353CB4B49C0147A56BD309@PS1PR0601MB3705.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: xtNha4o4kxbbrNfFe7wfuqRCh3dUaMbzGNVcM1pOyR1Ba9j+igCFK5RNDPEDQhqmeAZHtUncJLkvOilM4zuyfKw2ygJ8Rk+7F/6WWneaoX33RAZUOTmBEoN7gU/psJapDQYaFEFUx4TIr/Sb8MiEaEA/1c+5DEj2VrK9Yq6epeFoKRUTzo/IxRDPW7jq1l4TFO6W3xaWOzrhpfRhtfv9zz09Ps1m6mo09DtHvTGkJVuLaNRFVfact1zdKKyiTlaHHKaIuxKxTxKYOzwwjGfRwSxSq9LbnuFWQlHzY++fQH0/3A9Jp//T1l47+BFpD4BHolz4kbmuZQ0fUvlXn8r0TrfIWK8XNFBJq35R/4MIfVpW3UFsVaQSo3pLNu0A22hjoUKuCKrP+URcqtkXw/dX4MynAtOk1Ux4B/FE6tfoqd7st7rneCelFFtx3oIUH8GViSicF5K7Gjw2N31QU3LSzgHguH1re+wL4BL8UQdYXn7x/Ep3Svd+NeRbZJ6GGOVnLnG4GmxQfaaVRS0rwFfQEoFLQYGTHyRNR9LiSpMNKYdjTP5GOVT3FCdRTGnus1p8evxG49bMC/BxOX4i2vLZsil1atJq5iUGUULcUBGhBe++jVw+7l6ni6yRdUKMLGiC623zIMxI1Iatqj2WjYDm9OSX/zyqep8uXe0H9nNLR3vuHT3cVrOk3d36dJYsPiuiO8BfFOQqJwMcaYlsDIfzOPAR9NtUPkiWgkRsIiFD7m036gHipCO6xrm80rDK/ZT/
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(186003)(2906002)(7416002)(66946007)(316002)(36756003)(2616005)(107886003)(26005)(921005)(7406005)(110136005)(5660300002)(83380400001)(6486002)(6512007)(6506007)(66556008)(86362001)(6666004)(508600001)(4326008)(52116002)(8676002)(8936002)(66476007)(38100700002)(38350700002)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pjaWTw4CSxN8GS9UnFX7sA3l+GWwXMpUq/KEesRwKL/GoHXIOjBizWdywU2i?=
	=?us-ascii?Q?g5ozpuQuAfq6Ma2m3azzfAG4n+rBWIHHUCrMNlgbBIi4cFezPOuMlMm7StBT?=
	=?us-ascii?Q?vGbQ4xDR9W04WLXbdFu65s179EveD5um6ffW6Tw11e+MosB1LLEadPsLcaA4?=
	=?us-ascii?Q?1NkxRLkA6HDxqNYEgFzn8Hy3t16Fkx8Es6y1hLk4+l+CQHERU5eAkpaFqvRp?=
	=?us-ascii?Q?Ptupdmt5qsjoxg11zvP2048fHPqvG7EngtIO/8I2xC3DU4shQY7HmjbO1beV?=
	=?us-ascii?Q?bG/9A+eGma864Q4br1ZKC3w7FUWXtWH3hBs82f3Sbu28B/0efjlgYJkNxaeV?=
	=?us-ascii?Q?idYJIKox+0dtnNtTNIjPh8a4Wo7SqnosOZbb1unI5kJfUpg+oNvOv4lLEGqE?=
	=?us-ascii?Q?jQMUuvz+IdztIGFoRaju5Rjo4IIZfYKdZ7bSAulf95n7dWjhA/zoWTaQ2wVp?=
	=?us-ascii?Q?jdjrZ354MmURz8ySDEzgYlCwg1OPGNPRsPLXsei4+k2PX2ToU+QtL2rTg5w0?=
	=?us-ascii?Q?gfnEls+wcSnkVFeJjYP3FZWFev4wrIn/jP31cLj1FIC5htyPJwnst0oSKc9D?=
	=?us-ascii?Q?ZZSixxWF3QhYpWMKsdIGQYnRpGLRS8BUnibB7OQ4KCv6cjFXOgugR4gao31M?=
	=?us-ascii?Q?PGZpn3w5jTexCHxvguyzc68rsdEw2lxURxIctGHR7We5LkSwXSWU9bgznzfV?=
	=?us-ascii?Q?/VO174WxxGYr/C/oLhzcCuh3MX2we2SV+KgkCq8nXo16jIAavT38z1icxBOB?=
	=?us-ascii?Q?fBpAq3FmfF9wz0Y+Sw/E7aAPWokjeCTQcvFaOy8TCEuwgiRJh8XLLv7ootST?=
	=?us-ascii?Q?u2hicKODZZTxC6h+9pEW+7NkKSe4QRWjJeTqWteAF6zHzpcufum9aeKxbtUg?=
	=?us-ascii?Q?H2s5jPbPqlzwdgrLezCzbdgHs5h+o2bFe17M+v4CdZyof1T6TpbzQruW5L7Q?=
	=?us-ascii?Q?9r0AggtqIuU/NBivDidqK+TKNyql33WcIga/TvBA57x2Ia2JWTTQtnMzJmvg?=
	=?us-ascii?Q?23gIhw2wu2TJTYzFvShjKIQPXENdwKlxM4u3HHnttdjU+bIySaSYsYaCRAXb?=
	=?us-ascii?Q?GX06/LNA4dCPL0A+01JT2RuBwR77V6uCGygcRPC00s2ooTcV7xXWN6TwbwpI?=
	=?us-ascii?Q?d9HMd8eKYq/3eQWMefDxsb9sNuOC4JSL6WvQY7cmsbivRpHpYSUweDhDr+FQ?=
	=?us-ascii?Q?K5aOBgZtPwwttP08+muDswpOB8Wdkb8/7/pe7ZT6dKilYvZWaLGwjCpF8nxZ?=
	=?us-ascii?Q?uObl0XpQgrVGl8pV2t0W7vjR9xL2EZLWSBiKoHL8tgPoduCvizuWxxPxxeMn?=
	=?us-ascii?Q?eYFAgul1/wweR7scvTUBRR4UkeKhaFphYXcXwjRPvByGSmDKqfiOB9SVluuK?=
	=?us-ascii?Q?RWDbKliEzkTr4W7a6Ke3qTYjrLhsrrdcBC5OKjFpI6LzwrVyqijvc8DHe5HV?=
	=?us-ascii?Q?X6zWze1fyFnfk0k8Vx4I/acFDIuFPt31QFIs5dzefZgYi07IU9BRFyXG+7fJ?=
	=?us-ascii?Q?bM2MiNKB//O0FSLkEsgQDKv1Oh+Tt4rin8XGjcXMoBnoZViFFUsO/qEDB7YC?=
	=?us-ascii?Q?LBYDqMoWLXcCNaF4G7r649xf471DAe95bx9OHdmo3Zs0dYqqq4KaWyDCXI4l?=
	=?us-ascii?Q?m3bcmxIaxaonDqM3EvgVrjY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c30a67-df4e-474b-1402-08d9ed06c74b
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:32:42.1464 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xdyf1Z3lDKOyxrOoZ86n1eQZmt4qPNjV9K2+wx3x+3JYTq7UQ2ub4KQHKR/GkbvOQn9kNhZLzU4kryauyQi1QQ==
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
Subject: [dm-devel] [PATCH V2 10/13] media: stv0299: use
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
 drivers/media/dvb-frontends/stv0299.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 421395e..867ae04
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -183,7 +183,7 @@ static int stv0299_wait_diseqc_fifo (struct stv0299_state* state, int timeout)
 	dprintk ("%s\n", __func__);
 
 	while (stv0299_readreg(state, 0x0a) & 1) {
-		if (jiffies - start > timeout) {
+		if (time_is_before_jiffies(start + timeout)) {
 			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
@@ -200,7 +200,7 @@ static int stv0299_wait_diseqc_idle (struct stv0299_state* state, int timeout)
 	dprintk ("%s\n", __func__);
 
 	while ((stv0299_readreg(state, 0x0a) & 3) != 2 ) {
-		if (jiffies - start > timeout) {
+		if (time_is_before_jiffies(start + timeout)) {
 			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

