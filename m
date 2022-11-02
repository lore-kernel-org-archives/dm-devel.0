Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09901C4167D
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lrWziMullgx8Ci2im3k1qGdwWepaNu/l0MCjI0onm4Q=;
	b=RO1EdZ2yUqMjffx8pXaKtnOfC58K4Uc29v95uGneq/iHaebAAKza9aAVUJwRKoJJ/zGuFW
	gZc5bJFZ1sjRD5ufZBjXILZBGAK8S8mrKFwnh2VHMgtcpMPdDlTPuI5PE7XXX0ACk8PzSU
	RAEolqQJtPQGuttM+GyYce77QiVyw7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-YxlFGv_HMD2c9-VcVW-kqQ-1; Thu, 03 Nov 2022 03:57:23 -0400
X-MC-Unique: YxlFGv_HMD2c9-VcVW-kqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14F6A1875060;
	Thu,  3 Nov 2022 07:57:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 033BE40C83EC;
	Thu,  3 Nov 2022 07:57:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC55B1946A76;
	Thu,  3 Nov 2022 07:57:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88F391946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 16:15:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53E6F492B09; Wed,  2 Nov 2022 16:15:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48F5E492B32
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 16:15:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C17D80600A
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 16:15:04 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-HeSPZKgsPaKsWJgxhXEpCQ-1; Wed, 02 Nov 2022 12:14:58 -0400
X-MC-Unique: HeSPZKgsPaKsWJgxhXEpCQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 20CD0B82386;
 Wed,  2 Nov 2022 16:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530F3C433C1;
 Wed,  2 Nov 2022 16:14:55 +0000 (UTC)
Date: Wed, 2 Nov 2022 10:14:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Y2KXfNZzwPZBJRTW@kbusch-mbp.dhcp.thefacebook.com>
References: <Y2Hf08vIKBkl5tu0@sol.localdomain>
 <Y2KEH6OZ0MDf5cSh@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <Y2KEH6OZ0MDf5cSh@kbusch-mbp.dhcp.thefacebook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] Regression: wrong DIO alignment check with dm-crypt
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitrii Tcvetkov <me@demsh.org>, Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 02, 2022 at 08:52:15AM -0600, Keith Busch wrote:
> [Cc'ing Dmitrii, who also reported the same issue]
> 
> On Tue, Nov 01, 2022 at 08:11:15PM -0700, Eric Biggers wrote:
> > Hi,
> > 
> > I happened to notice the following QEMU bug report:
> > 
> > https://gitlab.com/qemu-project/qemu/-/issues/1290
> > 
> > I believe it's a regression from the following kernel commit:
> > 
> >     commit b1a000d3b8ec582da64bb644be633e5a0beffcbf
> >     Author: Keith Busch <kbusch@kernel.org>
> >     Date:   Fri Jun 10 12:58:29 2022 -0700
> > 
> >         block: relax direct io memory alignment
> > 
> > The bug is that if a dm-crypt device is set up with a crypto sector size (and
> > thus also a logical_block_size) of 4096, then the block layer now lets through
> > direct I/O requests to dm-crypt when the user buffer has only 512-byte
> > alignment, instead of the 4096-bytes expected by dm-crypt in that case.  This is
> > because the dma_alignment of the device-mapper device is only 511 bytes.
> > 
> > This has two effects in this case:
> > 
> >     - The error code for DIO with a misaligned buffer is now EIO, instead of
> >       EINVAL as expected and documented.  This is because the I/O reaches
> >       dm-crypt instead of being rejected by the block layer.
> > 
> >     - STATX_DIOALIGN reports 512 bytes for stx_dio_mem_align, instead of the
> >       correct value of 4096.  (Technically not a regression since STATX_DIOALIGN
> >       is new in v6.1, but still a bug.)
> > 
> > Any thoughts on what the correct fix is here?  Maybe the device-mapper layer
> > needs to set dma_alignment correctly?  Or maybe the block layer needs to set it
> > to 'logical_block_size - 1' by default?
> 
> I think the quick fix is to have the device mapper override the default
> queue stacking limits to align the dma mask to logical block size.

This is what I'm coming up with. Only compile tested (still setting up
an enviroment to actually run it).

---
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..9334e58a4c9f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -43,6 +43,7 @@
 #include <linux/device-mapper.h>
 
 #include "dm-audit.h"
+#include "dm-core.h"
 
 #define DM_MSG_PREFIX "crypt"
 
@@ -3615,7 +3616,9 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
+	struct mapped_device *md = dm_table_get_md(ti->table);
 	struct crypt_config *cc = ti->private;
+	struct request_queue *q = md->queue;
 
 	/*
 	 * Unfortunate constraint that is required to avoid the potential
@@ -3630,6 +3633,8 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+
+	blk_queue_dma_alignment(q, limits->logical_block_size - 1);
 }
 
 static struct target_type crypt_target = {
--

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

