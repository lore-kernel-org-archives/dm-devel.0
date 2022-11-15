Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75694C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 09:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668503188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ehyRwYAOLvXRc3j2BbfSFgCTtynGEPj1FWD/DUE1fN8=;
	b=afzZCr7LrNZEd3Tv2to6dkFRSM86c6Yk4ZcXtvjyixwE40X/Hpjbd/Py6iYoaufjwTk+0y
	0d4frsTuG4MJFO8Y7PvIjTwkK+Ox88jRZjDKxANFYx6rT/dc04ffuO34dqKgssqT32T0o/
	Lw9CUctlu5oz+d7ulcpb/qaSBVUUpgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-uEnaBl-uM8SoidLTpQyYFg-1; Tue, 15 Nov 2022 04:06:25 -0500
X-MC-Unique: uEnaBl-uM8SoidLTpQyYFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64928185A78B;
	Tue, 15 Nov 2022 09:06:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4142540C6EC3;
	Tue, 15 Nov 2022 09:06:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8DA41946589;
	Tue, 15 Nov 2022 09:06:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE7921946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 09:06:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 46CCF1121333; Tue, 15 Nov 2022 09:06:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F054112132E
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 09:06:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CB0029AB3E0
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 09:06:18 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-eDqjSPzBOR-N7ErhoB_QDQ-1; Tue, 15 Nov 2022 04:06:15 -0500
X-MC-Unique: eDqjSPzBOR-N7ErhoB_QDQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 6240367373; Tue, 15 Nov 2022 10:06:12 +0100 (CET)
Date: Tue, 15 Nov 2022 10:06:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20221115090612.GA22190@lst.de>
References: <20221114042944.1009870-1-hch@lst.de>
 <20221114042944.1009870-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221114042944.1009870-4-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/3] blk-crypto: move internal only
 declarations to blk-crypto-internal.h
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
Cc: Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 14, 2022 at 05:29:44AM +0100, Christoph Hellwig wrote:
>  blk_crypto_get_keyslot, blk_crypto_put_keyslot, __blk_crypto_evict_key
> and __blk_crypto_cfg_supported are only used internally by the
> blk-crypto code, so move the out of blk-crypto-profile.h, which is
> included by drivers that supply blk-crypto functionality.

The buildbot complained that blk-crypto-profile.c now needs a
blk-crypto-internal.h include, which can be done by folding this in:

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 96c511967386d..0307fb0d95d34 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -32,6 +32,7 @@
 #include <linux/wait.h>
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include "blk-crypto-internal.h"
 
 struct blk_crypto_keyslot {
 	atomic_t slot_refs;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

