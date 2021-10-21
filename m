Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB08EC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 06:25:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1503E610D2
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 06:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1503E610D2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=baidu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-xYLZezfnNaWkUJWb_LJ-1Q-1; Fri, 22 Oct 2021 02:25:44 -0400
X-MC-Unique: xYLZezfnNaWkUJWb_LJ-1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8440B1006AA3;
	Fri, 22 Oct 2021 06:25:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3195F60657;
	Fri, 22 Oct 2021 06:25:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABE014A703;
	Fri, 22 Oct 2021 06:25:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19L8tGcQ031305 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 04:55:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C1EE400F3E5; Thu, 21 Oct 2021 08:55:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3883C40D1B9F
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 08:55:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4102B866DF9
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 08:55:15 +0000 (UTC)
Received: from baidu.com (mx24.baidu.com [111.206.215.185]) by
	relay.mimecast.com with ESMTP id us-mta-485-jFdv7KCXOymdBHGE1S7sDg-1;
	Thu, 21 Oct 2021 04:55:11 -0400
X-MC-Unique: jFdv7KCXOymdBHGE1S7sDg-1
Received: from BJHW-Mail-Ex12.internal.baidu.com (unknown [10.127.64.35])
	by Forcepoint Email with ESMTPS id 7B66FF519D69360D465D;
	Thu, 21 Oct 2021 16:39:04 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
	BJHW-Mail-Ex12.internal.baidu.com (10.127.64.35) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.14; Thu, 21 Oct 2021 16:39:04 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
	BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.14; Thu, 21 Oct 2021 16:39:03 +0800
From: Cai Huoqing <caihuoqing@baidu.com>
To: <caihuoqing@baidu.com>
Date: Thu, 21 Oct 2021 16:39:01 +0800
Message-ID: <20211021083902.1918-1-caihuoqing@baidu.com>
MIME-Version: 1.0
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-MAIL-EX04.internal.baidu.com (10.127.64.14) To
	BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex12_2021-10-21 16:39:04:526
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
X-Mailman-Approved-At: Fri, 22 Oct 2021 02:25:38 -0400
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm crypt: Make use of the helper macro
	kthread_run()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/md/dm-crypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1ee3da2bfd0b..d4ae31558826 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3363,14 +3363,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	spin_lock_init(&cc->write_thread_lock);
 	cc->write_tree = RB_ROOT;
 
-	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write/%s", devname);
+	cc->write_thread = kthread_run(dmcrypt_write, cc, "dmcrypt_write/%s", devname);
 	if (IS_ERR(cc->write_thread)) {
 		ret = PTR_ERR(cc->write_thread);
 		cc->write_thread = NULL;
 		ti->error = "Couldn't spawn write thread";
 		goto bad;
 	}
-	wake_up_process(cc->write_thread);
 
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

