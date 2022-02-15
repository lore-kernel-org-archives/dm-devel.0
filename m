Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4658CC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149--DRPAi2rMNyYQxXixNjdZg-1; Tue, 15 Feb 2022 03:04:08 -0500
X-MC-Unique: -DRPAi2rMNyYQxXixNjdZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60906802927;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4184B163D2;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17A071806D2D;
	Tue, 15 Feb 2022 08:04:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F1ucVj004705 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 20:56:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97A212166B44; Tue, 15 Feb 2022 01:56:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92D9C2166B2F
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71F531066559
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 01:56:35 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-161-ef5Dwn4DO6aG0iaOR4Qgmg-2; Mon, 14 Feb 2022 20:56:31 -0500
X-MC-Unique: ef5Dwn4DO6aG0iaOR4Qgmg-2
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2767.apcprd06.prod.outlook.com (2603:1096:404:3b::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Tue, 15 Feb 2022 01:56:28 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 01:56:28 +0000
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
Date: Mon, 14 Feb 2022 17:55:40 -0800
Message-Id: <1644890154-64915-4-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
	(2603:1096:202:2e::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 350c5fef-b405-474c-85dd-08d9f0266127
X-MS-TrafficTypeDiagnostic: TY2PR06MB2767:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2767CEA2486227939D0AC07EBD349@TY2PR06MB2767.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ePSXhaPcXg4FCtC68F2lY8InSV29A9B0X7537mP4RBGWHZP5mXN708htS4S4u7wWqKMhSwagUCUhji/QcJ2mvFsxZEm/2pLfUvwFb8b3AKZJwlXAh5UPQIPL2fZ75nO1NxEBaQPqlmFXvngc53/CfB5o2pm5rl/xMvTVxPLK+4v8e1IdOnVmEDaD9lxdw43v9MBTu5b4oIS3prUue4WUwqwiNF2zoGo3VejapXFNxDPt1X2HQ/utN7+aRFJVz+nB4rI0dWys6BfO/JaT1uGVYDyhTnWC2tvI36H6NHU2Bjf3f7uFgEdaN8ZWcCqSKu0cAcksL8QDeDVlJU56i6Vz/LLqL6610jEIqsYwVYEXzM1EnKIKAnNx16JNoMsww0xBAhRwG2WO0VgNvPJXJ3CP/J4hndR7/WaSNYQUEdFQeNcDEYei3vFdEDuGW4BexNCsa8KPsUJ7o2ngxEcsVrCGxWgVBCLvsi8y3dVhDHO1ODvi9QJa9mFK5+MHgQHCdDcIL/vbNt9ALSS5CzoEHTArCcTnblAdRCEPkvWRlqj1w+QKxCgvMAEZWBoi8ygkPtETPoFbvNS9JGh/VIJZ2EoZaDSclGDFQS3MHmQp2Eon9Z0xRk34KkBfCwASiyyW68/uxjLyAQf4iZbxEXn+kjM9eOeeHiWTe7BrqPLtmjIxOQwUty26WwAfZPp5oloO94IY5HdO4tUsdbkpSy22+M7sLvlSq0k2Dtr/kq+JTu1sfL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(7406005)(7416002)(4744005)(110136005)(107886003)(921005)(316002)(26005)(186003)(2906002)(52116002)(5660300002)(8936002)(6506007)(2616005)(6512007)(6666004)(4326008)(508600001)(86362001)(83380400001)(36756003)(66476007)(66556008)(66946007)(6486002)(8676002);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BaK9tJZZgUm1KrBqZG1H+LXOYbJWVBMNHl3eqdFRkRBZtvWoWGVDQB0LHTcP?=
	=?us-ascii?Q?/vO4YjfcTYv3yBzT2DhJeOwVLJgtU4HkOV2NEL/GCzB0igWhnmNvADiBz0al?=
	=?us-ascii?Q?kPjYnD+4hZ24hQuDjTdPyTFq3th9Ch1WqMz3FJLrZadNlkX8etXdTDiN6ydK?=
	=?us-ascii?Q?cw81cetwlw9rCF8fTPY9YrJi5LjBCyeimc54nI0jauWuwKTZEo3MTt9AbVPw?=
	=?us-ascii?Q?aoWcy9tsE3NbknUJQlqIIZYSWTuY4Sk+jx8gzxO0oeSBaSfYyxADwBgOrbux?=
	=?us-ascii?Q?dyHB7XAk1zd1zdYkZFsRIA7MNwr75/e3d2iFUeOas4BgWLYmXAweKGVSjN+K?=
	=?us-ascii?Q?A3M41pRDd+77FeILsbxw0302PEYLs5Q2ibxkOHjivAV+ZyHyF09Jo908tKOg?=
	=?us-ascii?Q?w+CDMLH8kUAM1UYezrQ96nOZEzVvAOMcN+KhPKJ29ZVtK8bcPvCf5uFEuksb?=
	=?us-ascii?Q?2UH8jNDqHrLwg9EUh6IqYtY2ZXgFrssd20XQ1yvgRXVTHdDU6T+ngVtSUe6r?=
	=?us-ascii?Q?E54na1IRaVDQNv3xwFWr5ngEifny/G5xmH1oWMMLcdj2lguw3K35VVgVMYVf?=
	=?us-ascii?Q?84rU3ynyEU8ufYKi4OMdO7++HKAFXDa5VInWyMwkTpqchRJ/DeVZqObrZKPa?=
	=?us-ascii?Q?acUGADNZUJirsyY0QKVjUADNRxQgW0/3JhW7xahw0e8A5kLcS7DyZiO2kusn?=
	=?us-ascii?Q?szrkuao7lfYlKIQ+NyD/PdPNxE8p3GKv4in62yLwoHdVo/9rk9McVyQvqNLc?=
	=?us-ascii?Q?ZpsXnHk21VIcMDHHtwmLZP/IYCiI3fDUXbYHblM869HOzRbJamnssPYRms0J?=
	=?us-ascii?Q?jtG2fBogijS6aeRcQWEAIbRN/j0NdqHHBv2tmGZRhHl2kwm3EEXd0S4JO7jO?=
	=?us-ascii?Q?sWMTTzmkCI0toHbmXePzLnW93VmXzoAwa6JnLV8JL/tdlu81OUSnHyEU2asx?=
	=?us-ascii?Q?zbEjoXfFbEVedkE+us9ZHKuw59JkU4SRspI7U7/K3+sg96M7rmWS0Jk0EFuX?=
	=?us-ascii?Q?ldmoeyEJCME2RZvWzSrDmSlcT5wzybdIFV7+PC5H8ALkc6PiXtlFNCPyMt+4?=
	=?us-ascii?Q?ayz8RAE8IbAcQxuSwOU4GNC5cKU8FdE/Xt0vfIOWDenGo2p3m5SQ6RGCvksX?=
	=?us-ascii?Q?E8H/mQs3INUt8ra38KeMjQmJT1wBT0vd6IscFqLk0M9zUpgWUkBwkfgDhARr?=
	=?us-ascii?Q?o2PKQjbUmGfN8hi1xzgVr95IKLvFcJQzx9tpoIuJ7VOIGkd0R6x8g+uVbofu?=
	=?us-ascii?Q?/msxkTcPl+dg4qIvUptQ/R/cvEOm2eoeeKM0MVvxy0rwmyB4gOJRqGMmNTDA?=
	=?us-ascii?Q?NlOMBov3RAgqCov1ij6msEh0GFA/KlkAkOUkQu0nR8EGWmbS2dvT17/Dnc+H?=
	=?us-ascii?Q?s9Kzb9urW+kTfMbNadciL4cLn/blUhsOTjxwYYW/pvZWMZRk8YldPp63Vb2j?=
	=?us-ascii?Q?z4hVNXwRcKoXOfbQoixyk1R72BMo6K3lqYlH3oFlpLeDoz7TnWm5urzYKQYA?=
	=?us-ascii?Q?gIzqw0Nw/aUihezEGE599AA5XOxFV5LRnGf2ak5hTr2CsZj4wW1xkOnEKhGz?=
	=?us-ascii?Q?DouxcTwsbYr1m3U1uhAmFvb4r7MgTuZru+1Z+YtuM5jYn02V53iiNwycDPJp?=
	=?us-ascii?Q?XRgTXEvfBh9L5Zp7AwXEXU4=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350c5fef-b405-474c-85dd-08d9f0266127
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 01:56:28.1851 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MesX6WPaJ56e7udwMc5quBO9Bo++SBp9oZSEvycwae7SZxjgXI1hb0rilNxKSpPKAc5JKBC38ib/K74jMaT0Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2767
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
Subject: [dm-devel] [PATCH V3 3/13] gpu: drm: i915: use
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
 drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c b/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c
index 9db3dcb..b289abb
--- a/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c
@@ -56,7 +56,7 @@ static bool pool_free_older_than(struct intel_gt_buffer_pool *pool, long keep)
 				node = list_entry(pos, typeof(*node), link);
 
 				age = READ_ONCE(node->age);
-				if (!age || jiffies - age < keep)
+				if (!age || time_is_after_jiffies(age + keep))
 					break;
 
 				/* Check we are the first to claim this node */
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

