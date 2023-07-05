Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F95EB64DA
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jul 2023 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688592818;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NgEy9jOhm/XClNxWxjihrCRnGaAuXbLDLeQafBXH20k=;
	b=EN127NfmhKo/tf2tAzlI3Pn+4Wyg0j4LCACo50H3NXAPzgaEpwnMc579rjAdMx8zs5kcCX
	eOl/yeRGGDTxiIcg0QVfA53pVpECEJy+cOoCEUZdGdyUIsDHrLt3PFkPyFm9mZABAIylIM
	3M4cFAliTu28DU3DtqjjFaDlH5pSg/c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-dj3Rb1XONt-NdbNWuI-iEA-1; Wed, 05 Jul 2023 17:33:35 -0400
X-MC-Unique: dj3Rb1XONt-NdbNWuI-iEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3187E101A54E;
	Wed,  5 Jul 2023 21:33:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5B69140E952;
	Wed,  5 Jul 2023 21:33:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D20F1946589;
	Wed,  5 Jul 2023 21:33:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1EA5B1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 21:33:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F20A840C206F; Wed,  5 Jul 2023 21:33:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA64040C2063
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 21:33:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE7FD104458F
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 21:33:30 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-jV5N8KsvOjiWvdAR6bv5Wg-1; Wed, 05 Jul 2023 17:33:29 -0400
X-MC-Unique: jV5N8KsvOjiWvdAR6bv5Wg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 88E0B6144C;
 Wed,  5 Jul 2023 21:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0B9C433C8;
 Wed,  5 Jul 2023 21:33:27 +0000 (UTC)
Date: Wed, 5 Jul 2023 14:33:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20230705213326.GC866@sol.localdomain>
References: <20230610061139.212085-1-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230610061139.212085-1-ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] blk-crypto: use dynamic lock class for
 blk_crypto_profile::lock
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
 Bart Van Assche <bvanassche@acm.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 09, 2023 at 11:11:39PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When a device-mapper device is passing through the inline encryption
> support of an underlying device, calls to blk_crypto_evict_key() take
> the blk_crypto_profile::lock of the device-mapper device, then take the
> blk_crypto_profile::lock of the underlying device (nested).  This isn't
> a real deadlock, but it causes a lockdep report because there is only
> one lock class for all instances of this lock.
> 
> Lockdep subclasses don't really work here because the hierarchy of block
> devices is dynamic and could have more than 2 levels.
> 
> Instead, register a dynamic lock class for each blk_crypto_profile, and
> associate that with the lock.

Jens, can you apply this?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

