Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BD2C433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43E39206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43E39206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=126.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-ouRTPJPpPLKCymr5DQ_n6w-1; Mon, 04 Jan 2021 14:04:07 -0500
X-MC-Unique: ouRTPJPpPLKCymr5DQ_n6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC596801B19;
	Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C77E327C55;
	Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9730E1809CB8;
	Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BS3S0mB011421 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Dec 2020 22:28:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42E4E2166B28; Mon, 28 Dec 2020 03:28:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D96F2166B27
	for <dm-devel@redhat.com>; Mon, 28 Dec 2020 03:27:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1043D858EEC
	for <dm-devel@redhat.com>; Mon, 28 Dec 2020 03:27:58 +0000 (UTC)
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-335-zL6_jefuPDK-D_BhCKS_Fw-1; Sun, 27 Dec 2020 22:27:55 -0500
X-MC-Unique: zL6_jefuPDK-D_BhCKS_Fw-1
Received: from localhost.localdomain (unknown [36.112.86.14])
	by smtp2 (Coremail) with SMTP id DMmowAB3fqonSelfE1NwKg--.26949S2;
	Mon, 28 Dec 2020 10:55:35 +0800 (CST)
From: Defang Bo <bodefang@126.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Date: Mon, 28 Dec 2020 10:55:23 +0800
Message-Id: <1609124123-232214-1-git-send-email-bodefang@126.com>
X-CM-TRANSID: DMmowAB3fqonSelfE1NwKg--.26949S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr4DXFW7CF43tF1DKrW7Arb_yoWfArc_Cw
	1Svry7Gr48Gr1j9rW5Ar48ZF9rKws5uF1kZF1Ikw1fArykZry3Ar4jgr12qr1Duw42kF15
	ur9xG3yrArnFkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUfHUPUUUUU==
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbiaQcJ11pEBDLf1AAAsT
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: linux-kernel@vger.kernel.org, Defang Bo <bodefang@126.com>
Subject: [dm-devel] [PATCH] dm snap : add sanity checks to snapshot_ctr
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Similar to commit<70de2cbda8a5>("dm thin: add sanity checks
to thin-pool and external snapshot creation"),there should be a check
for argc and argv to prevent Null pointer dereferencing when the dm_get_device
invoked twice on the same device path with differnt mode.

Signed-off-by: Defang Bo <bodefang@126.com>
---
 drivers/md/dm-snap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4668b2c..dccce8b 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1258,6 +1258,13 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	as.argc = argc;
 	as.argv = argv;
+
+	if (!strcmp(argv[0], argv[1])) {
+		ti->error = "Error setting metadata or data device";
+		r = -EINVAL;
+		goto bad;
+	}
+
 	dm_consume_args(&as, 4);
 	r = parse_snapshot_features(&as, s, ti);
 	if (r)
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

