Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C899C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-GcJgOwVQOd-zplHunHB8TA-1; Fri, 11 Feb 2022 01:08:25 -0500
X-MC-Unique: GcJgOwVQOd-zplHunHB8TA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1171190A7AA;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A652D5E275;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 812794A706;
	Fri, 11 Feb 2022 06:08:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2Vfut031554 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:31:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A69140885B9; Fri, 11 Feb 2022 02:31:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25AA840885B5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A977811E76
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:31:41 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2108.outbound.protection.outlook.com [40.107.255.108])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-549-0F6kERQzOV6BZmBD_d0mFg-1; Thu, 10 Feb 2022 21:31:37 -0500
X-MC-Unique: 0F6kERQzOV6BZmBD_d0mFg-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2895.apcprd06.prod.outlook.com (2603:1096:404:31::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:31:32 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:31:32 +0000
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
Date: Thu, 10 Feb 2022 18:30:26 -0800
Message-Id: <1644546640-23283-4-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe8ac258-883d-4bb5-0ed5-08d9ed069dbb
X-MS-TrafficTypeDiagnostic: TY2PR06MB2895:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2895D78B3ED8D2EFC148E95FBD309@TY2PR06MB2895.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: zo/R/bhk4YPH5LccKiv+TX+wqX7W7/D25syY6RvkcP1xlIoeF4bHvdEVY7ZVn5LEZhd6FFobafjLvqiGAlNDktxB9/L8f6gQJMQFWwlhH9VXNBZQ7s2DIBDExQkvb7SUY5X8oqPNGlH85qRmigyEWfKVGchpeoKXRGww4S4OyxcTAZwwgRnO+JA7xLmQFWA2HqA2SDtwO39P1InflK0McUXYyFFDjZ7RdjgOvNkMfsqdQZ8Da/Bd8CJDtH+xS09saVOq2GB1R0mtTJ0Y/0JHhZkYgLCpRhPyZXVE7zhPT66CBo0xJrkWHwQCVqsgqnKnDMATM7pBHAedgfouT073upYp8bgoH7dUhk+QfSQKnKmgOTuiPY93JBWZXfSUIDr0p/+Lk28y5Lai+DpaHk7nLhGaJywUbTOC+zsLVOfbZXiYhqNnMvlON1uxhYNAYTGvPLlsf5PSNx018TCNjmhjzMCLC2VBLlzcVN/rKseRQ4ATIoICfFWkrI06dywiFPOiBQ9v12so6RcQZyKiKcGalse59lXl6sdjDKc+NHaQhDeNlnRfxXa4xcj5x+v0Z0MZ1fO7Ao07sQHLiZcvUSomnUnxhSb5ibkcDZmkLgZ1n39ySrpzCVjAmA0ni1wEH3AN+Vy8mo6uL89U4TU/84HGXZ0SwiTX1vE67/TCM/eROcUAiEpTzApJLqfXFwXmQNzd4fw4z3U0jlxiMNC186Zd69djOYJZZmpv7dBNR3sz3SWI1aBpyvqRsWawxpL0wVuA
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(316002)(110136005)(86362001)(6486002)(38350700002)(6506007)(6666004)(26005)(186003)(2616005)(6512007)(5660300002)(8676002)(4744005)(7406005)(508600001)(36756003)(4326008)(8936002)(83380400001)(107886003)(921005)(52116002)(66556008)(66476007)(7416002)(66946007)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e/bIM8AuiT9udRoKnStelhbmCbuYE+e2WZTAJGisC5tRuT29x7b+a0DWP4bv?=
	=?us-ascii?Q?YNwl3iAlOCwnfti139KrGxzw4sreNnnL0mT5q+1lDX2HmmzHaW2wGv/K8ldU?=
	=?us-ascii?Q?eNic8Z55b/irrrUobHNcyFrEqMAPskhq+YJgx9PUkvBlM/r/RlYzjYaRDZQE?=
	=?us-ascii?Q?WwM5j/75QHJTu/UfSfn61Erq2ymiyAl7DAxUjNASs96TpUVjGynmM3POjclA?=
	=?us-ascii?Q?fDZDIMm6ueczPiQlBuUXaxDenwladTdwRKQsDEHe0Uhm5Rp+DPDDmbqxPuO2?=
	=?us-ascii?Q?UUqkBOvBEXqmjdRcAcezDkOYB55xcDFEENEPy2v+zCuJGPf2EIjZLl175ie+?=
	=?us-ascii?Q?uRQdzaBCP3tHfXAE3hjcF9F2rAFoX+alnmmliArjm/C62U/IEVPzsmN40ziV?=
	=?us-ascii?Q?ZAFuLbYqLuS6iNRMoVfztTpkysd8eUBNRwjKvAuznPytDtyIzZvfiRD4pceY?=
	=?us-ascii?Q?tnPH4rTEggnH/OwJJjHhUcOl+Sot3nw881tNEGuP4E08cDYbDdaJ1aj2xMHI?=
	=?us-ascii?Q?6sx1/3DiBInsR68NAI4DSE8LYLeKZ1sorcpBqH9jyF4+8nGhBA0sE7cluNDd?=
	=?us-ascii?Q?Wto8qMDdkJ5KScuN50r+aSJbob75H4wz3S6IJP7oEERyLHWYNygaS3PFKF6F?=
	=?us-ascii?Q?S9RJAGy5/n6GO56G7jpUXdX8NdTOoCTjsfH7IAXfFSXvxgACjDNByF8aPCyU?=
	=?us-ascii?Q?Q+9xFJzYpIS7tiQohPQId38tFWr3FShtbVfp06axt1Q2lp8r38fCeOt5pkO+?=
	=?us-ascii?Q?TFxs/Foyd8C7kIdi9xbgkzoc9Wo4mxrCyPDf03iCDgtpUPPg5wf/9t7UlHXH?=
	=?us-ascii?Q?aNwVb3RSaZqvpvMmfrA+giyGVTTDbREgcKjSQCoNoDtme1o1mbOfuaqV4veO?=
	=?us-ascii?Q?2P1QPYLOfunhfg+F7HfcWQHVL5Py7CVMmFIvoe0iVFKScI6BMLbcJbKza/qb?=
	=?us-ascii?Q?RWQz7tIE1DpTnxoIB+CaMEQJNgWuJNYpW/mbkYSxY1L8UqwUsBkptqQz3m0o?=
	=?us-ascii?Q?NdLh8YrzS1H4onbN8Pc+HZSwLjBns2vblomcw2Ux+7kDf24jtvn238CWythc?=
	=?us-ascii?Q?mJgTNh+VRF2J3C7Rk+Oiwu12rMuIH6bZUJOL0lmKs0n3vvRMmSbH+jMwIFUN?=
	=?us-ascii?Q?MMsNrZOr3SZIPyRry3k4xtIlFQsqHVg3hGtnM3vitS2J3mEDDvniGut+4Hm+?=
	=?us-ascii?Q?nDVaUOUmUGMo4/Ut7uYjooWHXyy3VlAO/xqEj+DJ3UNv3WIMwFKFiux9MteB?=
	=?us-ascii?Q?UNvMvc+0ylsVT5bJ9cIU8vL7JdQni3fU5T3dNNMaR0DWizPZ7uXoC8MG/dE4?=
	=?us-ascii?Q?pad+RnUI8StFM3uftnhqN+WzD0cFnMcIPmCQNH1YhcP15+Y9BiPAuaqDhsDm?=
	=?us-ascii?Q?aibuilsasq3xsDmuQMyfvdqnAyx1D0e8jw3p9/dP0ht4dovmlxCd5Xr6xYPW?=
	=?us-ascii?Q?W/8s/DQwX1Xhr5Dk7yncPNsEOPhOgAsh+FcTOV8RsfipLe8I5/hVQk18+Lks?=
	=?us-ascii?Q?jIkuAsZ9XOa9IlO1oLqnY5WTPZr3kRSQWaIDT2lp/paOfP/Bu/q5NE/qyfrj?=
	=?us-ascii?Q?s+uu34nWNAT5cxP7I2SPtkDtrj592myGYuA12vkr/x6NrrLK0+WH4ip9tSJk?=
	=?us-ascii?Q?ggSi3sULiaAT6wd4HiO7Uvw=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8ac258-883d-4bb5-0ed5-08d9ed069dbb
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:31:32.4316 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/oH9WScPdLif6Pl7r7BCJBGenT1qn0YKCRUYBNcVPrn3O6oBRxTzJbBkRtJgninQGAvI9WToS7m73nvAX5qyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2895
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
Subject: [dm-devel] [PATCH V2 3/13] gpu: drm: i915: use
	time_is_after_jiffies() instead of jiffies judgment
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Wang Qing <wangqing@vivo.com>

It is better use time_xxx() directly instead of jiffies judgment
for understanding.

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

