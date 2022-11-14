Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B439C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 14 Nov 2022 05:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668403649;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VXcD1dwa36sFZktXF57zDFgL/lAB5KEvyJKUqK02sME=;
	b=V3w+S2b2rynh/9iiQcZr9iLNQt66Z7CW2ArcLn16ZFxJjtCsrMj8tD5vnsXFer74c/zdiP
	ayKJ/tCSJ45bVnVhyo63/APljo0Ac/FhEAoX7fC4u/pqvQocIboXWGZTy6qgEFW4Dh3/Wr
	WKBJlZNbhkYhM44epgP5DsWwPKf5t7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-q3eYP0LtMlaqtLFV7MQXWg-1; Mon, 14 Nov 2022 00:27:25 -0500
X-MC-Unique: q3eYP0LtMlaqtLFV7MQXWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B45968027FE;
	Mon, 14 Nov 2022 05:27:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A11B92166B2F;
	Mon, 14 Nov 2022 05:27:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D41B1946589;
	Mon, 14 Nov 2022 05:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A3BF1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Nov 2022 05:27:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E64849BB61; Mon, 14 Nov 2022 05:27:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5728849BB60
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 05:27:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC268027FE
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 05:27:21 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-9RFlVIkePay0JFieU5AthQ-1; Mon, 14 Nov 2022 00:27:19 -0500
X-MC-Unique: 9RFlVIkePay0JFieU5AthQ-1
Received: from [2001:4bb8:191:2606:c70:4a89:bc61:2] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1ouR6Q-00FvTJ-RA; Mon, 14 Nov 2022 04:29:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 14 Nov 2022 05:29:41 +0100
Message-Id: <20221114042944.1009870-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] pass a struct block_device to the blk-crypto interfaces
 v3
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
Cc: linux-block@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, linux-fscrypt@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this series switches the blk-crypto interfaces to take block_device
arguments instead of request_queues, and with that finishes off the
project to hide struct request_queue from file systems.

Changes since v2:
 - update a few comments
 - fix a whitespace error
 - remove now unused forward declarations
 - fix spelling errors an not precise enough wording in commit messages
 - move a few more declarations around inside or between headers

Changes since v1:
 - keep using request_queue in the Documentation for driver interfaces
 - rename to blk_crypto_cfg_supported to
   blk_crypto_config_supported_natively and move it to blk-crypto.[ch]
 - mark __blk_crypto_cfg_supported private

Diffstat:
 Documentation/block/inline-encryption.rst |   12 ++++-----
 block/blk-crypto-internal.h               |   12 +++++++++
 block/blk-crypto.c                        |   37 +++++++++++++++++-------------
 drivers/md/dm-table.c                     |    2 -
 fs/crypto/inline_crypt.c                  |   14 ++++-------
 include/linux/blk-crypto-profile.h        |   12 ---------
 include/linux/blk-crypto.h                |   13 ++++------
 7 files changed, 52 insertions(+), 50 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

