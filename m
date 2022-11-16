Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C60C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 03:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668568702;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y0ICBHrmE2E56YnB/z0crMtbLC41+D7GLp/XkWLET5c=;
	b=ShTCdeVLbSs4xRVW/zGfjsgX7iQ9qWgArBr90MDNvsOiULfuAUjFK0JkG+w9xwBQpuXol8
	a/V/TyARGLNZM14oEPyOxQr+u21isFyrIYp4i32O1jhJrl+wLBwP8tvjmkTyz2ooAdb44o
	1ns3+Li+rKy33NYbdnx971Ewqstq1VY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-lX1TCNQbM7SbCoFCvRh4mw-1; Tue, 15 Nov 2022 22:18:21 -0500
X-MC-Unique: lX1TCNQbM7SbCoFCvRh4mw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34A685A5A6;
	Wed, 16 Nov 2022 03:18:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FD1A4A9257;
	Wed, 16 Nov 2022 03:18:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1268C19465A0;
	Wed, 16 Nov 2022 03:18:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86BF91946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 03:18:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54748C1E88E; Wed, 16 Nov 2022 03:18:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D1E4C19145
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 03:18:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 300F23C02189
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 03:18:17 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Dh1hz97LNr67hXL0rpK5xw-1; Tue, 15 Nov 2022 22:18:15 -0500
X-MC-Unique: Dh1hz97LNr67hXL0rpK5xw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 0339BB81BA7;
 Wed, 16 Nov 2022 03:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDEEC433C1;
 Wed, 16 Nov 2022 03:18:12 +0000 (UTC)
Date: Tue, 15 Nov 2022 19:18:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y3RWcm8pWma84RUs@sol.localdomain>
References: <20221114042944.1009870-1-hch@lst.de>
 <20221114042944.1009870-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221114042944.1009870-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-internal.h        | 12 ++++++++++++
>  include/linux/blk-crypto-profile.h | 12 ------------
>  2 files changed, 12 insertions(+), 12 deletions(-)

With the include of blk-crypto-internal.h in blk-crypto-profile.c added, feel
free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

