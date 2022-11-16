Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E49C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 03:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668568372;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4eSnYht+CE/JG6TeBBzLx9HlyA1Eh7POe/0SxYHyBrY=;
	b=QurvSL8pwbXx5UcxXc2yKjRnATdcYHlpUfrrhU6u6bvawWsi5fQDr6fe+DUhqmfUuVuFor
	q/G/mLxMNvT8LFHV6Dzy3amdOOrsDQXVpTqSFSPQbkFFtuhbZHh6kIh+iR0Qda9b2MMT5F
	jmDXdkwdvAPVT2Qxexaf2jix5r04Byg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-SgBF13ArNxSHMn0aw9-1oQ-1; Tue, 15 Nov 2022 22:12:48 -0500
X-MC-Unique: SgBF13ArNxSHMn0aw9-1oQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE354101A52A;
	Wed, 16 Nov 2022 03:12:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDA51111E3FA;
	Wed, 16 Nov 2022 03:12:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6974919465A0;
	Wed, 16 Nov 2022 03:12:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E1571946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 03:12:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3633E6D661; Wed, 16 Nov 2022 03:12:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E8BC63A55
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 03:12:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13EC8857D1A
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 03:12:45 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-sWGhzfTONdSRDHWXOrT9sA-1; Tue, 15 Nov 2022 22:12:42 -0500
X-MC-Unique: sWGhzfTONdSRDHWXOrT9sA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 46E1F6184A;
 Wed, 16 Nov 2022 03:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCB8C433D7;
 Wed, 16 Nov 2022 03:12:40 +0000 (UTC)
Date: Tue, 15 Nov 2022 19:12:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y3RVJkcagipPquny@sol.localdomain>
References: <20221114042944.1009870-1-hch@lst.de>
 <20221114042944.1009870-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221114042944.1009870-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/3] blk-crypto: add a
 blk_crypto_config_supported_natively helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 14, 2022 at 05:29:43AM +0100, Christoph Hellwig wrote:
> Add a blk_crypto_config_supported_natively helper that wraps
> __blk_crypto_cfg_supported to retrieve the crypto_profile from the
> request queue.  With this fscrypt can stop including
> blk-crypto-profile.h and rely on the public consumer interface in
> blk-crypto.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

