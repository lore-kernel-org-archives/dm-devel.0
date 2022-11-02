Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E913EC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667359088;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=blI+pHLL6ActM7+lxmjgYx6aRafprrCeWuJM0Wye/c4=;
	b=TsTLqedVxyLf/pPIlxbUucYZQ3sZcWC07UXUTBVbVfYNDW329Ly36fBubIe5upvguAKih1
	PlLeJyP/KpEwZXdm54bQkHLYfcpD5o/imSEtH8zEYyUuXPzaNGox3oMC04ca1lIZyu12uT
	4xjRMDzShyY1lyys7hjhRqLet29Zxmo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-hAWLBmQBMUaTiGvV2D0MaQ-1; Tue, 01 Nov 2022 23:18:07 -0400
X-MC-Unique: hAWLBmQBMUaTiGvV2D0MaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A458E101A54E;
	Wed,  2 Nov 2022 03:18:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B14A0207B344;
	Wed,  2 Nov 2022 03:18:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F0731946597;
	Wed,  2 Nov 2022 03:18:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CAD711946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 03:18:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E85F422A9; Wed,  2 Nov 2022 03:18:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7656F4EA5C
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 03:18:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A1A185A794
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 03:18:02 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-pJF1XJmlO9K_HJYHGTABaA-1; Tue, 01 Nov 2022 23:18:00 -0400
X-MC-Unique: pJF1XJmlO9K_HJYHGTABaA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7640D617BC;
 Wed,  2 Nov 2022 03:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E88C433C1;
 Wed,  2 Nov 2022 03:11:16 +0000 (UTC)
Date: Tue, 1 Nov 2022 20:11:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>
Message-ID: <Y2Hf08vIKBkl5tu0@sol.localdomain>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] Regression: wrong DIO alignment check with dm-crypt
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
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I happened to notice the following QEMU bug report:

https://gitlab.com/qemu-project/qemu/-/issues/1290

I believe it's a regression from the following kernel commit:

    commit b1a000d3b8ec582da64bb644be633e5a0beffcbf
    Author: Keith Busch <kbusch@kernel.org>
    Date:   Fri Jun 10 12:58:29 2022 -0700

        block: relax direct io memory alignment

The bug is that if a dm-crypt device is set up with a crypto sector size (and
thus also a logical_block_size) of 4096, then the block layer now lets through
direct I/O requests to dm-crypt when the user buffer has only 512-byte
alignment, instead of the 4096-bytes expected by dm-crypt in that case.  This is
because the dma_alignment of the device-mapper device is only 511 bytes.

This has two effects in this case:

    - The error code for DIO with a misaligned buffer is now EIO, instead of
      EINVAL as expected and documented.  This is because the I/O reaches
      dm-crypt instead of being rejected by the block layer.

    - STATX_DIOALIGN reports 512 bytes for stx_dio_mem_align, instead of the
      correct value of 4096.  (Technically not a regression since STATX_DIOALIGN
      is new in v6.1, but still a bug.)

Any thoughts on what the correct fix is here?  Maybe the device-mapper layer
needs to set dma_alignment correctly?  Or maybe the block layer needs to set it
to 'logical_block_size - 1' by default?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

