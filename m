Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4858C77B7E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685606266;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZI6dqr/oB71ACl4s52IHdlz9jz2/V1cJYxLZzXuDOPI=;
	b=MtC1m9o5zb0skMNXx4dpHiqXVc69QZLaa+j7JY6Ec676ao9bSy6J29cJ80NoC17W6LESjU
	pgRZeeuWOzDPxUiH/sTO5PXZkVf5uufygdUsBK8vTYUWEHTTPC+KPmqSYsM8GeeXePpm/0
	zHUslOXYLDwX3wAasHftPuSPmz2g+Zg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-E_jTgVeOPfqA8A7QqrXwxw-1; Thu, 01 Jun 2023 03:57:43 -0400
X-MC-Unique: E_jTgVeOPfqA8A7QqrXwxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACEC33C02B64;
	Thu,  1 Jun 2023 07:57:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C9C82023164;
	Thu,  1 Jun 2023 07:57:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 287E0194343B;
	Thu,  1 Jun 2023 07:57:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBC8919451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:57:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5449407DEC3; Thu,  1 Jun 2023 07:57:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D9A3407DEC0
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:57:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E947185A78B
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:57:39 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-4mwYt7_tN4Of_t1ifYDJMg-1; Thu, 01 Jun 2023 03:57:37 -0400
X-MC-Unique: 4mwYt7_tN4Of_t1ifYDJMg-1
Received: from [2001:4bb8:182:6d06:35f3:1da0:1cc3:d86d] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4cjZ-002MKH-0R; Thu, 01 Jun 2023 07:28:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  1 Jun 2023 09:28:26 +0200
Message-Id: <20230601072829.1258286-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] enforce read-only state at the block layer
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
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

I've recently got a report where a file system can write to a read-only
block device, and while I've not found the root cause yet, it is very
clear that we should not prevents writes to read-only at all.

This did in fact get fixed 5 years ago, but Linus reverted it as older
lvm2 tools relying on this broken behavior.  This series tries to
restore it, although I'm still worried about thee older lvm2 tools
to be honest.  Question to the device mapper maintainers:  is the
any good way to work around that behavior in device mapper if needed
instead of leaving the core block layer and drivers exposed?

Diffstat:
 block/blk-core.c       |   20 ++++++++------------
 include/linux/blkdev.h |    1 -
 2 files changed, 8 insertions(+), 13 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

