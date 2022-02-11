Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9A8C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:08:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-kb-qSv4pOvaUApetZ0L0SQ-1; Fri, 11 Feb 2022 01:08:24 -0500
X-MC-Unique: kb-qSv4pOvaUApetZ0L0SQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81A50835BD3;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6774B519D4;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 42D811806D03;
	Fri, 11 Feb 2022 06:08:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B2WO1b031606 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 21:32:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 87E99401E9F; Fri, 11 Feb 2022 02:32:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83964401474
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69A2010726BD
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 02:32:24 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
	(mail-psaapc01on2114.outbound.protection.outlook.com [40.107.255.114])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-609-1E0udtDCPEyHYszgkv79Cw-1; Thu, 10 Feb 2022 21:32:20 -0500
X-MC-Unique: 1E0udtDCPEyHYszgkv79Cw-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TY2PR06MB2895.apcprd06.prod.outlook.com (2603:1096:404:31::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17;
	Fri, 11 Feb 2022 02:32:16 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Fri, 11 Feb 2022 02:32:16 +0000
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
Date: Thu, 10 Feb 2022 18:30:30 -0800
Message-Id: <1644546640-23283-8-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
	(2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
	(2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c225f979-e148-4ff3-3fd8-08d9ed06b7c7
X-MS-TrafficTypeDiagnostic: TY2PR06MB2895:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2895C5F8FAFF3D4794E09867BD309@TY2PR06MB2895.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: m+gLbLKDEUYtgg6JicjuPldNAEFxgWIHOT7l4DraoaJD6b+FautiuJXjyJSIJnH9mYKXvyu+2+URwZPVEfb6vN8+fn9tAy71Bc6uiykTfGDuBzTJ0l31SRC+FVmdiStKMGJYItgGxPmMwTWHdRigJlEQoVRSLJuD30YI6EKeosSlg41s5Kt5+03KD7jrPgSU3x7wAPsWx2YEd/ZdeGmDJ/OLPQLtxL8uga4F9oRJ7n3tpd//z6MSNbn23dygd7SK7z3LlOncANQB6BnnEUVhGionjOcYHC4Nhn8HHB+W6tbkLI4Q05+WXhY50Y0g7T5HuZXT1fyRKJntJX/D4xljmO/35XkBLb/WJBBPbxv7L3EZnoRv9+8E35V8fYjSclLpy6GSkmLgJ8ir76dIcz/sUwNkaMN9tpYehhuArKCh4gVArqP3Smg1izn6tNo5NTlWUYi/qAzjzgIFvMjPsJ3e7ZSGINZTq0N6+lCasmPqxtkC0vRYksTQ2uEcMAnIbZXmw7yYZN4HBTUF0uEnL0gsxQ4Tzd8JyQJ4FIbFYPxcMvQmyl2FuO1ptziccMi6fHR60ceVv0K8ymdF//fb6QGhDiy8jTmgesQpIpqHc4JTHlU/akv9pM+JhtXT19Z0WXfOZw9WpkAiVYMrdpno3VHXamMW1f69DbuTOQPcSiZ/3PgeoMJJMLuXbfdTShntVbvmMMa+xpVviUqPZhaWNt1eJEZBS0PqcJgxpQCriKRPTUI16z8JpnXpHbscDnhs/j+X
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(316002)(110136005)(86362001)(6486002)(38350700002)(6506007)(6666004)(26005)(186003)(2616005)(6512007)(5660300002)(8676002)(4744005)(7406005)(508600001)(36756003)(4326008)(8936002)(83380400001)(107886003)(921005)(52116002)(66556008)(66476007)(7416002)(66946007)(21314003);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9wJunXdafueXwS1HARm+UcDn9TyGyU9g1s76Lc6rMQJXbcwOgVcd4d8/HcxT?=
	=?us-ascii?Q?/JVc9sR2wmCQDk7kOA/mKbLUkeUOddf5rVUcUlE81Fv0wxXIT/Foo0drXfj+?=
	=?us-ascii?Q?okhp/LpdHRtg8IoqR4a+utA8A2LjYTwIuv7AbnnWNUrU8otcHM7DGUU9VSun?=
	=?us-ascii?Q?OSybiJa3wl1QmPNWxBCuY2vE2cmkGuA0Q4Zf5+zvew3XxpH70pcN8epb8+0u?=
	=?us-ascii?Q?ImsWg9Oqzv2/l08hbRK/SmE7K1E24tWVo5yhjebtkN21zBsxvKLlMmB+C4ov?=
	=?us-ascii?Q?9nUrCkwx9PIFlhzkbupJowU/DIOD8DxWCKA0/KETzZwpjNbyEjM6wg+YM7pT?=
	=?us-ascii?Q?rdWeH00wh1eGD1QCe7DP62Zc/DJtjFbqK3ju6fnUqwQ1BnOxn1NkonkH6g+k?=
	=?us-ascii?Q?KniDGW8HavDExlKV8oAaYwtrAw46pWP7CvGHKyYBpWTT5gJ9/RE29rHNGOd6?=
	=?us-ascii?Q?B9AQ8MQjkKQERY/XYUlyh3yqxjkbRufTz7z91kZP0q86H8EWsTSsh4R+ZTuq?=
	=?us-ascii?Q?+yHiaVNfLspSHxhR0EWCFKLGIYl4M2JplniPFyvSPEi3QTirWUWSqYYREEQE?=
	=?us-ascii?Q?LjiqcDoiNITz3jlQwQlmSPydYl7ccGl83oE6Z0Eirrz6B/ATOyWW94XFPNsV?=
	=?us-ascii?Q?VgWX4dJGhPeO/JQk6pnp555xDOGPQrD0uY08eAhh6Ju5Z8WqooBsJjgT4oqN?=
	=?us-ascii?Q?5RZhZSvX25ug7mnGiUxQL2KyoqbhaQebsti/5bLobYl+OcTL9sqiwDjw6iuy?=
	=?us-ascii?Q?P6BUxvccPC0iGVdT3jw3PE9gRhPTa6KnGY6yfOlxsxxe9PygYsDF9e6rtm49?=
	=?us-ascii?Q?so87P6FdbsNze0VvxckqfXEWA+Km1EVuau5FEM8VKuYSVLQTAaM5SqcT1+d7?=
	=?us-ascii?Q?rFt94cSWAzina+8dneb4FTT0XXac6ZRpPNt0U0TiYMmFOKXHj/qK5WaajsgW?=
	=?us-ascii?Q?9HEdcqH3ohQuClPT9k3pyKXFclQKUl+agejOMUufnLU/JTyZSEwqu6GZE4xM?=
	=?us-ascii?Q?jV9Xwi0mzMxE638PMfIjXZ4G+e1ppd+XgjsE+xFzydGg0/izIekIrmw/3lkg?=
	=?us-ascii?Q?2f2wddwU+aNCmewhKVuem5MZXhJ58qlw/+/KSHUkYxX+hcbndPj8RwjEpCxH?=
	=?us-ascii?Q?3zNGYha5VItjAxNc3GpULxjllMJGsUBTwU09b5y3Cp7XMo5yLQLGGhEQaIvv?=
	=?us-ascii?Q?USJjyQwZpKIAdJJvMHTd2bIqXVXmZM0YCWI7QDNXmoUmkKLGAedlMXGRFXvj?=
	=?us-ascii?Q?6k0uhycKg8Jw7bFZIaSdmnspMP7eNc4aicCu5clLStuHtyXzADfNCCWPEG3b?=
	=?us-ascii?Q?RtKH3AlvaqAQ8s7IWGl3GBBNbWJZlS5hWSi4S/biIU6SmytICG0QmyNIMJSW?=
	=?us-ascii?Q?s7bwcIpGqdyqvqgPOsbMxYzIBO1nLzXz1p02X9262Ika9zVbdLuvjsMNM5K3?=
	=?us-ascii?Q?jVEuF1JfIpMDN+gtBk236EAU4YWC4VY7bSUXWp2CElVRoET4QKsQhYhZn7jn?=
	=?us-ascii?Q?D5YjklnY7XuekOlL9KeVHQz41Mmjvry8JHCbPYuu4iovExU+MBp07l6cqIgc?=
	=?us-ascii?Q?dSvYJ/x6mvC111Frfk+SyjIJWYQpkZbOABnMpwjOyNUN+M5/hW3N1tvWHEGO?=
	=?us-ascii?Q?ejej4/MAyunSQ9wmcy2LGEE=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c225f979-e148-4ff3-3fd8-08d9ed06b7c7
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 02:32:16.0854 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4YxRg1ecI7HlnxWT425FXY4UjVoKm196uJwuFAtIX1YYiOd8+uoj7+n6d7o5Qgax39lGdeRzbAoVI+SjmIuNQ==
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
Subject: [dm-devel] [PATCH V2 7/13] md: use time_is_before_jiffies(()
	instead of jiffies judgment
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

It is better to use time_xxx() directly instead of jiffies judgment
for understanding.

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

