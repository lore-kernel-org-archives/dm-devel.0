Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED7FC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667999797;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JtRsMkq+ZupQHqXKxZaG9XN/WKKCGcdSfE/8v2zZMWg=;
	b=UNOI0KEmULHGYrJXAJ6EiJ3Y6tSvWRB28bRqTSAzGMLt1SFupFK6vjGWbTv5pH+QzXmrCY
	+chAKmRopAEBHbGRpeKimxS8CmVzvWlfsV+vhN0UE3xxxjA+jHNqxYefm4d2JAoqEsJmN1
	B37qvMvltSYH4JUgg+BshpZety5Lluk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-Pph23SeWOj6eM5MWy8nyaA-1; Wed, 09 Nov 2022 08:16:35 -0500
X-MC-Unique: Pph23SeWOj6eM5MWy8nyaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68A8C802804;
	Wed,  9 Nov 2022 13:16:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86CBA1121320;
	Wed,  9 Nov 2022 13:16:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64C8F19465B8;
	Wed,  9 Nov 2022 13:16:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 451CA1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 13:14:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 22A644B4010; Wed,  9 Nov 2022 13:14:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B5E34B400F
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 13:14:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0366B2823814
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 13:14:17 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-JBUgrYZUM3GBe_EDHQTOjw-1; Wed, 09 Nov 2022 08:14:15 -0500
X-MC-Unique: JBUgrYZUM3GBe_EDHQTOjw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 2991D68AA6; Wed,  9 Nov 2022 14:14:10 +0100 (CET)
Date: Wed, 9 Nov 2022 14:14:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20221109131409.GD32628@lst.de>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-2-hch@lst.de> <Y2lnloNN5wovDBMF@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <Y2lnloNN5wovDBMF@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/3] blk-crypto: don't use struct
 request_queue for public interfaces
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
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 07, 2022 at 12:16:22PM -0800, Eric Biggers wrote:
> On Mon, Nov 07, 2022 at 03:42:27PM +0100, Christoph Hellwig wrote:
> > diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> > index a496aaef85ba4..0e0c2fc56c428 100644
> > --- a/block/blk-crypto.c
> > +++ b/block/blk-crypto.c
> > @@ -357,17 +357,18 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
> >   * request queue it's submitted to supports inline crypto, or the
> >   * blk-crypto-fallback is enabled and supports the cfg).
> >   */
> 
> Replace "request queue" with block_device in the above comment?

Done.

> > -	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
> > +	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> > +	       				  cfg);
> >  }
> 
> There's a whitespace error here:

Fixed.

> >	/*
> >        * If the request_queue didn't support the key, then blk-crypto-fallback
> >        * may have been used, so try to evict the key from blk-crypto-fallback.
> >        */
> >	return blk_crypto_fallback_evict_key(key);
> 
> Likewise, s/request_queue/block_device/ in the above comment.

Done.

> > struct request;
> > struct request_queue;
> 
> These forward declarations are no longer needed and can be removed.

Done.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

