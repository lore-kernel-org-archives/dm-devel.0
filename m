Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562BBC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-kM9fcE8QN2aTMkEztMeHpA-1; Fri, 11 Feb 2022 01:08:28 -0500
X-MC-Unique: kM9fcE8QN2aTMkEztMeHpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FD65101F00A;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12ECE4EC82;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E00A84A7CD;
	Fri, 11 Feb 2022 06:08:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2W7Tp031577 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:32:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 321552028CE7; Fri, 11 Feb 2022 02:32:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D9D8200B429
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97D753C01DB0
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:03 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
	(mail-sgaapc01on2095.outbound.protection.outlook.com [40.107.215.95])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-15-_tOkNR5AOHqo5yJY4k7Suw-1; Thu, 10 Feb 2022 21:31:59 -0500
X-MC-Unique: _tOkNR5AOHqo5yJY4k7Suw-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by PS1PR0601MB3705.apcprd06.prod.outlook.com (2603:1096:300:80::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 11 Feb 2022 02:31:53 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:31:53 +0000
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
Date: Thu, 10 Feb 2022 18:30:28 -0800
Message-Id: <1644546640-23283-6-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d70cf59-bb08-44c9-d8b4-08d9ed06aa1d
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3705:EE_
X-Microsoft-Antispam-PRVS: <PS1PR0601MB3705F1BCDE9A160C732742B7BD309@PS1PR0601MB3705.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kfbibTSneam9oWVKH3DJ3QOmFnh1mxRPRDBXU5LWmu2QQPbyKOmkjNUUjHmIAV9oT+FH5R7EvNcx+TizTs0YPsdXg96FAf+MOM0q0XWfBFTqb0zMhLoqf+zH0Ulk7GqEFfxbhmPxPy06oS5nPVqv1VFFSrZ3TXJDYb/sMLZ94ev8c0c+G2/Bn7r8pzjjHr5LbeCTw21M8+fnytSNLajBvg7BpsMj/GMhL/MTyrqmtQ+H9+Om58JtZchdluGQ8PveT99QYc8D2BE5HnapXVgo7BUQYxDAm7tcmTe9M+1AassFREhfHKVOL5zi12RksfC29ozoSPf/hgFBDhiM7a/CMyB05W/U8tV+F+JnK9GBFHXvOImkabeBzWgZpVwm+P7AwTjPM24J/8Cdtfg4c4UBWbylIMjqzMJREciO8BV73AoM8folGHGIIXDe5CzWAbu0rhouhlltDpbkbezfUECpu7nQG5XGVu570OuqBGRlADPLib2pzOKzGJmH42lBSyPSqEcz8tpWDmg8pzXZNkLETWMR4dOj2aedfY6/LOT2IQr+knBwX26/Z7P2jyYHB3WqSpAfl8kXuw1cplmxseQRgj4Usv+EuKEY32jinmrVtUryMXjj/aiMeLu2DN5MgJwqCP6qhoIiKYR6R3hygd5Qe0NSTahaRaiqQT5DsEvMfBebkML+ADjUYtGKj5w7U6Zu5Jo+Eb7J/KzsLiZt/RESM0GoeKyXO5nOSYX7VgTCTg1l5eBX2YAyZkrE1XLl286L
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(186003)(2906002)(7416002)(66946007)(4744005)(316002)(36756003)(2616005)(107886003)(26005)(921005)(7406005)(110136005)(5660300002)(83380400001)(6486002)(6512007)(6506007)(66556008)(86362001)(6666004)(508600001)(4326008)(52116002)(8676002)(8936002)(66476007)(38100700002)(38350700002)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BBfZ+O1Kxqh21loJeQRlANfu0QekBm26HVPA7GyNiNYfAo4+Um03Vc3uJq2w?=
	=?us-ascii?Q?JJgjUFV/xR3uMWvKcFI3tTiNy/upkQ090Zy8abBi0tIs7V6ScpzGgv2UR8sj?=
	=?us-ascii?Q?YCtDKIX8nXAeGQBI191G5ARvLsxC4+Elfr3w19dfnnSZru82GZUeH3ySaveh?=
	=?us-ascii?Q?g4ZpeeVonCgHFm84185SCy+4C5pIAI7s8kLNZ4+4d/1E7ZxLt1dWtMqUu9AZ?=
	=?us-ascii?Q?fUvHd0nbVuQx3wG5XbxbFuDvtB5Uyp3riuzT29pfWHj9o++CxNUHtQj8wGnm?=
	=?us-ascii?Q?fN7vgffFbifDbWNICqUrIYx2RRljjKB6aVtnpcsvUSFdk36xOeFDjcFkX4Hg?=
	=?us-ascii?Q?W0Tfa7wAKMkt37by333t3+cq9urgxkK3Z1yqgd0f8Oii/Q8C4NhE32rcA/o+?=
	=?us-ascii?Q?IwspIUdC7W8RhDigWSnjrbbH1p7KwTVk1EZiuuB/k02l6WJI2+x6ZLYhLF+v?=
	=?us-ascii?Q?xqwFg1ZSdvdTDGQnH7XnR3Ufati+nzTrp+SNgnJdrzK5DGjOQr1INoiSkiHF?=
	=?us-ascii?Q?9qWVnKBwo3E7tOU4b5n42g2nOOzzeBJ/qapVobWALiWPzsmK9hnxzb2wq8vk?=
	=?us-ascii?Q?+53gw83z0/2QGglEllV5UBWnP77rKVB8XnAORTGcwWAhr/9jdUw33WslorzQ?=
	=?us-ascii?Q?BNL/U5+2amc2hNL0V/4MhgGDrFcQzoCZSqB871xZFrSueByvP/15adpou0MW?=
	=?us-ascii?Q?iuL+xx9xoYVHxW0CJdna2gsC8qSn+MrCQSTiV8wnDiyw379AS5u80+tnNDdc?=
	=?us-ascii?Q?wUaz0xElVWdafxDXoBduBj9f2P1RQ5cb2EmrGYZeLP8x0DYsgbc/9EH+/sPo?=
	=?us-ascii?Q?tmyFrpjAQy2O8eQskqnOFdVmIvjmfzBiFa1tO6XTX5u49+NRItYisUu88z4e?=
	=?us-ascii?Q?mUMvimxuXxD8VgL9ZaI7xnwSXrk4eaHDai0h7BXG9wJaMZ5LhgFsjjYJqm+n?=
	=?us-ascii?Q?11e6sxy0tWvxw0LYwm7xJx3lgh2jqishlwaklTMkt2EbWgn5jVgA8Qjok8SV?=
	=?us-ascii?Q?GPmEIkLb3LEHnaAqhpzz0uwH88qCk8TUnU40rz0/pC0kagWiMGGUbEHZ5pm2?=
	=?us-ascii?Q?2RIniCO1iKMlmnilOuJE+8eRhLCZaJQl26sMTUikZdcbxovBOoohFbQV/MlO?=
	=?us-ascii?Q?BJBV4mPOvBQnKyDE8kZ1t3GQ4dkohKclpgk7VlQKWnRwxV5jED6bdzjSfM5v?=
	=?us-ascii?Q?ZEX8A1xMZbbXIF/TrnoonkmQ+kfOvRUJue0PMCFoo9gCaSXN1USoaxgYPjmM?=
	=?us-ascii?Q?TLYYB3UBE1ICle3hk9qB8IkDWyhrKdws7iw2yk7wjB9rLGjxTi4igzlad+b+?=
	=?us-ascii?Q?2n4Q7ZW0d0VJ2Ztq+vQHKZCaCsxr7jEm0OiDBIxe0eqTt3Bv7m4FyMVmKWrt?=
	=?us-ascii?Q?HsORE7URlTNn6yx/R8E/yaB97QPwS9Cvmmx6f7LYEqxh8dzkgSCy8O18+xXN?=
	=?us-ascii?Q?nbdOHAhQK2vqtoTuzghVXMHztLsmHN+jvKq4WOyl0Qu9bcMYMsHmOvNNSpmf?=
	=?us-ascii?Q?T0tMrhGgQVavp6BU3RU+VZQZou95lS3L6bPIrFLiG43CbdvDLQbMm5DtN+8x?=
	=?us-ascii?Q?HCOzkPZyJsZYhuWU1gq/VtpU874+C3AAzhEvMUxqHQU0HFNNj9ksI3ISeftA?=
	=?us-ascii?Q?OrZU3fHBQYef6Wd3ZzS7Srg=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d70cf59-bb08-44c9-d8b4-08d9ed06aa1d
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:31:53.2742 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TylgQ8NLxtwkXjCtK6xwJY9XXGkueBEZNf2tBbnWictxmcg+fs+mPezSy7kFaW8Y6nxMhs/TlXtqAL4sUD76g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR0601MB3705
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: [dm-devel] [PATCH V2 5/13] hid: use time_is_after_jiffies() instead
	of jiffies judgment
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

It is better to use time_xxx() directly instead of jiffies judgment
for understanding.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index 8ccb246..15e1423
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -578,7 +578,7 @@ static void _ish_sync_fw_clock(struct ishtp_device *dev)
 	static unsigned long	prev_sync;
 	uint64_t	usec;
 
-	if (prev_sync && jiffies - prev_sync < 20 * HZ)
+	if (prev_sync && time_is_after_jiffies(prev_sync + 20 * HZ))
 		return;
 
 	prev_sync = jiffies;
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

