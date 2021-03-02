Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A586C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05A9864F30
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05A9864F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614711978;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nao2s2PKKMTEvU4czJoZgtlAnv5eda6MPF5TzPvQUnU=;
	b=Vew7IEkMuw+OkVjOX0rD8EHxHotiJ8/us7bESGJYKjE5WBJgcL6kQS+uvt/5lJr3VNmAbE
	CBAdHkAas7bfso04bnAEcqZn5b3wyNR9WtWCuuIOWAp6dIXt2f0xWP2CNmfCdaiQMN62b7
	6KasKRnyKAQiES4y70IHmEpbMVilXLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-yDLZWq8QMyWoupdTN3jbaw-1; Tue, 02 Mar 2021 14:06:15 -0500
X-MC-Unique: yDLZWq8QMyWoupdTN3jbaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02947835E36;
	Tue,  2 Mar 2021 19:06:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D836960BFA;
	Tue,  2 Mar 2021 19:06:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB1721809C8F;
	Tue,  2 Mar 2021 19:06:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122J604q011087 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 14:06:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61A5E18400; Tue,  2 Mar 2021 19:06:00 +0000 (UTC)
Received: from leontynka.twibright.com (ovpn-116-252.ams2.redhat.com
	[10.36.116.252])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D517262465;
	Tue,  2 Mar 2021 19:05:58 +0000 (UTC)
Received: from debian-a64.vm ([192.168.208.2])
	by leontynka.twibright.com with smtp (Exim 4.92)
	(envelope-from <mpatocka@redhat.com>)
	id 1lHALE-0003kL-Fd; Tue, 02 Mar 2021 20:05:57 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation);
	Tue, 02 Mar 2021 20:05:55 +0100
Message-Id: <20210302190555.201228400@debian-a64.vm>
User-Agent: quilt/0.65
Date: Tue, 02 Mar 2021 20:05:17 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>, Mike Snitzer <msnitzer@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
	caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, hch@lst.de
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
Subject: [dm-devel] [PATCH 4/4] dm: support I/O polling
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
Content-Disposition: inline; filename=dm-poll.patch
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
cookie.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
@@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
 		}
 	}
 
+	if (ci.poll_cookie != BLK_QC_T_NONE) {
+		while (atomic_read(&ci.io->io_count) > 1 &&
+		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
+	}
+
 	/* drop the extra reference count */
 	dec_pending(ci.io, errno_to_blk_status(error));
 }

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

