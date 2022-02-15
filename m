Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9549C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-XM6aAq6dPfqyIw1cZi77xA-1; Tue, 15 Feb 2022 03:04:14 -0500
X-MC-Unique: XM6aAq6dPfqyIw1cZi77xA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF200814253;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 938114F877;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BF9B4A7C8;
	Tue, 15 Feb 2022 08:04:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1v5IO004743 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:57:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F13F85361C0; Tue, 15 Feb 2022 01:57:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC9B15361DB
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41B8811E76
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:57:04 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-9a26Y5v5OE6ROBxmtqV6eQ-1; Mon, 14 Feb 2022 20:57:00 -0500
X-MC-Unique: 9a26Y5v5OE6ROBxmtqV6eQ-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2771.apcprd06.prod.outlook.com (2603:1096:203:58::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:46 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:46 +0000
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
Date: Mon, 14 Feb 2022 17:55:44 -0800
Message-Id: <1644890154-64915-8-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d1b7eae-3c35-4b24-eef9-08d9f0266c1f
X-MS-TrafficTypeDiagnostic: HK0PR06MB2771:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB27714B8A27E9EFD13292E88DBD349@HK0PR06MB2771.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 9umtK72So+HOJMJynAoNcqIKtzt8h6WC+lj/eowtVzatDO2oyReLR1Hix0xDIsU1sFqF08DqIOfCCqfX6TYO4B3mpvaup1hC46JJFx7mM21PlNybWqUqYku9K2XyJmoQjd2+PaInkHvTl5BJUjCLTf77VbgxqiPdzsfnrpyN4+pUnROQ3V/DR1va09Qz5Udej5Ct63iAYR366Y6MMHb2wU9wKxwJaWfPiwQ4eDfWYA/Py64voQLBmWR7TxKvinU+SBH5oU3qfU3ergN1fyyBzwHGEIp3Zhd2PyS+7hT+HF0zDr66ZHtCy7Klv1phAXTXN5DuNWStGnQltaYmRdZ84SXzz5vvXEj99opE/TUT9jAMRIUnE6Md9FuirbNy3KeL8ka5j6w33zm7BoXy3GwVrZFH4Nztx8Ij+WqNx5GsSt23DRol9ZOqORxF9Lz3gNgPBS2YDgNByZPluY6PNruGWIdsn3xR+jNGKC6z7ejBJ2qrGa80YEow7mhl/fk2zCoop7k5H04SCo6VJuHeA+0N/lOTzyukEgzbpm7fsiXDXd4Mu1ov/oet7kRltQbK3J4OFOa+xGDQJcXa5JKOByCMO7NvwGOXCRQZNfFYcgVpndi1WXBsiBFoe27CW1IQNY0P4yLb8F+HIT4xcJHIpaNus30HBx6JlUZuUgZOd6s1CJil7+rizoC0dY5iJ+n3L8P1rwbiPDncS9Hwf6HVNWVM80aceDzpruN06ZP3YjSfl58=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(8936002)(83380400001)(26005)(186003)(6486002)(508600001)(107886003)(5660300002)(4744005)(2906002)(7416002)(7406005)(921005)(110136005)(316002)(66476007)(8676002)(36756003)(66946007)(4326008)(66556008)(6506007)(6512007)(52116002)(86362001)(2616005)(38100700002)(38350700002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qr7w/D3OwuPzFuWkRZasFmrqocTl0pOHW++Bqrc3lcdxzjB/q5XVEUCRe37w?=
	=?us-ascii?Q?QNTIS3R0DZxIHiV7QJYqRq/olod9AdUGZqlbJDMEQPXgTMevhNZgsfhLGtH5?=
	=?us-ascii?Q?5UX6Rtsi9GYDecsPwJ/Eq1x47R+NF9mGL5Do1u5hxR+lBofLxh18b6lGX/2k?=
	=?us-ascii?Q?9YpRWMsTRBO0ynv+np15xuEQDx9Eym4+wpeWXaSASsEkR83/JgZsuvBrHcpW?=
	=?us-ascii?Q?Z6BH2D9kbP2c0qYB+thkeW5lIEkpGngkDvGwFvdkqXHivG/yJ+B2KwKy9PEh?=
	=?us-ascii?Q?se9nYvuiwfyMbzWMehmXw8AO88Hw4/9HIu2VXPH+QTPkIwa5zd8HCCAVJISd?=
	=?us-ascii?Q?5AIf6rzDhTEEs8aoaCA14d3av9OU8NKf+LQiYch7a6woHKswUxirMKaS34lf?=
	=?us-ascii?Q?bmEDlzeaWgxcQjQB0CMgKLmbo29rgQGgm9WE4QN+XynqS/Z969xr7N7cUQZt?=
	=?us-ascii?Q?MMcJayibm1zG2M/5DOqAImRri1aftADciPBPd38xdMI7Hfku5Cvnp91sGgtk?=
	=?us-ascii?Q?odHzdjh1Gjt6ZZiLe9G7Z746TAK2BR0wQnrH3m98yADwQzSP/p7oELzgQoEr?=
	=?us-ascii?Q?8mOX+J6TmZd++8iwRltk+BMYLU2tWqix7L5UL7WgR0PCzNf+FjpRdBWNsRmt?=
	=?us-ascii?Q?C31TM3KTZGVh3tRxYEd8lzKaqLZJLDGUeDV12Ft7bbYjsEvziaZBhFT4unsd?=
	=?us-ascii?Q?Qw4C4jPFWhZ5w2CJDVZsLVy84/DYgZFwpF8+qt1ie2LRSaHdexsbzB98Qx9m?=
	=?us-ascii?Q?QGuaPf+kLWyB0MUOjW5LiljKqo0+hRGHju+MDINcJ4rVefJq8XnV6kEh5wn7?=
	=?us-ascii?Q?RW4Pm7tYery9HWxsevbGRh4OxnnL9NoGKl/f95nxJGoWehOHoB9RTNjmBH12?=
	=?us-ascii?Q?IQyR9OzTTCHZPqaZbR0Er7aOj532vq4JfzPp1jfkYLYI9briowSGCuV5j+el?=
	=?us-ascii?Q?FBwkxfa3suvijWLh0QUv9R/fQKQWrkgoixd1TMTRyk+jq4W9i64iDprtKbWa?=
	=?us-ascii?Q?UGZ/9XIfuLj7c5DDylnQ93wr0+FPUDgn08Dk83cwX1J9vfHj3ncxVxX1jMI0?=
	=?us-ascii?Q?FNcc/MCoGaAlMRcKkRUahXVj0MjB92/RwUR9wLaU+VaznKomzy6ZQk/AwdFz?=
	=?us-ascii?Q?aCGndkgjgvUlWohre4GDNAPDg+F5tOoYqtOMjaSALxhrXQ0HWloTfIFl8vRL?=
	=?us-ascii?Q?cid3sQWtxr9GNtbaIeLa/NX+o+jYO6VuKLtbYvz+TgUvIRoFPiFzz7xgXWsL?=
	=?us-ascii?Q?bFhdk7V9yhXCZayLZ3PoPYK/srI+WHEC5x0RVEWfHF4cuvARhnxxm0TZiAoF?=
	=?us-ascii?Q?Ej1180RLRoZb7LiEg0dKOFyJqrgBTv05ApySLW9FiUFB6Fva98r7+qPhBZNA?=
	=?us-ascii?Q?2gpgQvtbo6chMBrNPSsjeyQ2nuzhlU+MeBi3ysnv7ptrcH1VXkWE0jGdLCV4?=
	=?us-ascii?Q?fyupduk9WGDZU4cN/hfitMbDRYeYs8fbSUojPgCwLd2SjlzpC4VdibE1Az9u?=
	=?us-ascii?Q?tiVhd3n4aZtddVZYLr/0Sjc4hrTNcvAimoc+hmrwoYVlKi1F8pdUllIJo5KF?=
	=?us-ascii?Q?5dHWkfSMacLeAxl5nhEOurkudAMyOUD6A7pKp9VERvIsXv6sMloX+sx5mHuu?=
	=?us-ascii?Q?7ZDVQNaDA48h3I/V+WoZY3A=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1b7eae-3c35-4b24-eef9-08d9f0266c1f
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:46.5435 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuQkkncIquAWowsVFvIAcUne9uogjwEjTI2rzMIdX/1OvIIRW1Yo0U53H2jqSYhEesX6mA/XB5q98w+hWzCkuQ==
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
Subject: [dm-devel] [PATCH V3 7/13] md: use time_is_before_jiffies(()
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
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f4234d6..dced764
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -161,7 +161,7 @@ static void throttle_work_start(struct throttle *t)
 
 static void throttle_work_update(struct throttle *t)
 {
-	if (!t->throttle_applied && jiffies > t->threshold) {
+	if (!t->throttle_applied && time_is_before_jiffies(t->threshold)) {
 		down_write(&t->lock);
 		t->throttle_applied = true;
 	}
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

