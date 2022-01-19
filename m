Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AD0C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jan 2022 05:18:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-U_uKTckjMb6g6pa6X-FkWw-1; Wed, 19 Jan 2022 00:18:52 -0500
X-MC-Unique: U_uKTckjMb6g6pa6X-FkWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01AFC814246;
	Wed, 19 Jan 2022 05:18:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EE8578C2A;
	Wed, 19 Jan 2022 05:18:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CFE364BB7C;
	Wed, 19 Jan 2022 05:18:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20J5IZ1q031233 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 Jan 2022 00:18:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 45D3776C4; Wed, 19 Jan 2022 05:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 417F8740A
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 05:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35EFD811E76
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 05:18:32 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-g0wtdouNOUuT2uUDhb62pQ-1; Wed, 19 Jan 2022 00:18:30 -0500
X-MC-Unique: g0wtdouNOUuT2uUDhb62pQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nA3MZ-003qbP-0c; Wed, 19 Jan 2022 05:18:27 +0000
Date: Tue, 18 Jan 2022 21:18:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <YeefInTrcsQRZVwY@infradead.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeH4yhy1FFGooOrR@sol.localdomain>
	<139878d0-d1bb-02d9-30c2-9334ffb5b3b3@gmail.com>
	<YecXNYm63BL50hFL@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <YecXNYm63BL50hFL@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	dm-devel <dm-devel@redhat.com>, Nitzan Carmi <nitzanc@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 18, 2022 at 11:38:29AM -0800, Eric Biggers wrote:
> I doubt that people would find Android's dm-default-key to be acceptable, given
> that it's a layering violation, and a similar approach was rejected in the past
> (https://lore.kernel.org/dm-devel/20170614234040.4326-1-mhalcrow@google.com/T/#u).
> dm-default-key's purpose is filesystem metadata encryption; it encrypts all
> blocks that aren't already part of an encrypted file's contents.  It differs
> from dm-crypt + fscrypt together (which the upstream kernel already supports) in
> that file contents aren't encrypted twice; this was a non-negotiable performance
> requirement.  Obviously, this required a new flag in struct bio to indicate
> which bios are reading/writing from an encrypted file's contents.  I doubt the
> block layer people would find that to be acceptable.

Well, it was rejected because it pokes a hole into dm-crypt.  In a
purely inline crypto world a way to assign a key context if there is
none before is a little different, especially if it requires a different
setup than an unconditional encryption for the device.  It would also
not even require a flag.

> 
> In principle, the filesystem is the right place to implement metadata encryption
> in this way.  This would also allow the kernel to enforce (via the key
> hierarchy) that fscrypt keys are never weaker than the metadata encryption key.

Yes.  Especially in the inline crypto world it would seem just as
trivial to assign a default key in the file system itself.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

