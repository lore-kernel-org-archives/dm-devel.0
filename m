Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49043C388F7
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5CFA12080A
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CFA12080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-dfpyXKRTMpOkT1uBaHykig-1; Tue, 10 Nov 2020 02:55:31 -0500
X-MC-Unique: dfpyXKRTMpOkT1uBaHykig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD13310866A3;
	Tue, 10 Nov 2020 07:55:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DF962C604;
	Tue, 10 Nov 2020 07:55:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 65A96180BA96;
	Tue, 10 Nov 2020 07:55:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AA6uBbu018767 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Nov 2020 01:56:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D29A12157F5D; Tue, 10 Nov 2020 06:56:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDAF22166BDD
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 06:56:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B342B90E424
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 06:56:09 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-595-JWp5PuSMPiuOTAH7TSzQuw-1;
	Tue, 10 Nov 2020 01:56:03 -0500
X-MC-Unique: JWp5PuSMPiuOTAH7TSzQuw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R781e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UEqxTzN_1604991358
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEqxTzN_1604991358) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 10 Nov 2020 14:55:59 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Tue, 10 Nov 2020 14:55:58 +0800
Message-Id: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com
Subject: [dm-devel] [PATCH] dm: add support for DM_TARGET_NOWAIT for various
	targets
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is one prep patch for supporting iopoll for dm device.

The direct IO routine will set REQ_NOWAIT flag for REQ_HIPRI IO (that
is, IO will do iopoll) in bio_set_polled(). Then in the IO submission
routine, the ability of handling REQ_NOWAIT of the block device will
be checked for REQ_HIPRI IO in submit_bio_checks(). -EOPNOTSUPP will
be returned if the block device doesn't support REQ_NOWAIT.

DM lacks support for REQ_NOWAIT until commit 6abc49468eea ("dm: add
support for REQ_NOWAIT and enable it for linear target"). Since then,
dm targets that support REQ_NOWAIT should advertise DM_TARGET_NOWAIT
feature.

This patch adds support for DM_TARGET_NOWAIT for those dm targets, the
.map() algorithm of which just involves sector recalculation.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
Hi Mike,

I could split these boilerplate code that each dm target have one
seperate patch if you think that would be better.

---
 drivers/md/dm-stripe.c   | 2 +-
 drivers/md/dm-switch.c   | 1 +
 drivers/md/dm-unstripe.c | 1 +
 drivers/md/dm-zero.c     | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 151d022b032d..df359d33cda8 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -496,7 +496,7 @@ static void stripe_io_hints(struct dm_target *ti,
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 6, 0},
-	.features = DM_TARGET_PASSES_INTEGRITY,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index bff4c7fa1cd2..262e2b0fd975 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -550,6 +550,7 @@ static int switch_iterate_devices(struct dm_target *ti,
 static struct target_type switch_target = {
 	.name = "switch",
 	.version = {1, 1, 0},
+	.features = DM_TARGET_NOWAIT,
 	.module = THIS_MODULE,
 	.ctr = switch_ctr,
 	.dtr = switch_dtr,
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index e673dacf6418..7357c1bd5863 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -178,6 +178,7 @@ static void unstripe_io_hints(struct dm_target *ti,
 static struct target_type unstripe_target = {
 	.name = "unstriped",
 	.version = {1, 1, 0},
+	.features = DM_TARGET_NOWAIT,
 	.module = THIS_MODULE,
 	.ctr = unstripe_ctr,
 	.dtr = unstripe_dtr,
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index b65ca8dcfbdc..faa1dbffc8b4 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -59,6 +59,7 @@ static int zero_map(struct dm_target *ti, struct bio *bio)
 static struct target_type zero_target = {
 	.name   = "zero",
 	.version = {1, 1, 0},
+	.features = DM_TARGET_NOWAIT,
 	.module = THIS_MODULE,
 	.ctr    = zero_ctr,
 	.map    = zero_map,
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

