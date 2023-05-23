Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792FDC77B75
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684880718;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fhpMkKEODKPkkKtOuj7VwxPgDK2KbAjj6kgJBsarW0w=;
	b=Y9itmlsar/y13LU0qOC9pQZY7s91hn3VisSIpXmqpsCB2Hg4YfY2wnAmWoOetPdN4OpBnV
	qX0qCKVMtblBo/+4PQA+wV/WEKF4tdPAi+wiD7lkcOCfFvwvrs5FPHGrxqtgrIgONX8djC
	YIRIQJ7auO/QBTKoZRdl7+MUZcGgUgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-yJXK70w2O6CyK9i7xH3roA-1; Tue, 23 May 2023 18:25:15 -0400
X-MC-Unique: yJXK70w2O6CyK9i7xH3roA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BBF2800B2A;
	Tue, 23 May 2023 22:25:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB8B940C6CD8;
	Tue, 23 May 2023 22:25:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A819419465A8;
	Tue, 23 May 2023 22:25:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C3B819465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 22:25:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C1671121314; Tue, 23 May 2023 22:25:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 541701121320
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:25:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25B18101A53A
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:25:10 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-rcLSyLRlPGGvaB_upUkodQ-1; Tue, 23 May 2023 18:25:03 -0400
X-MC-Unique: rcLSyLRlPGGvaB_upUkodQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 09E4761BE9;
 Tue, 23 May 2023 22:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F6CC433EF;
 Tue, 23 May 2023 22:25:02 +0000 (UTC)
Date: Tue, 23 May 2023 22:25:01 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: corwin <corwin@redhat.com>
Message-ID: <20230523222501.GD888341@google.com>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523214539.226387-3-corwin@redhat.com>
 <20230523220618.GA888341@google.com>
 <0d3d1835-d945-9fa2-f3b7-6a60aae3d1df@redhat.com>
MIME-Version: 1.0
In-Reply-To: <0d3d1835-d945-9fa2-f3b7-6a60aae3d1df@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 02/39] Add the MurmurHash3 fast hashing
 algorithm.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23, 2023 at 06:13:08PM -0400, corwin wrote:
> On 5/23/23 6:06 PM, Eric Biggers wrote:
> > On Tue, May 23, 2023 at 05:45:02PM -0400, J. corwin Coburn wrote:
> > > MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
> > > written by Austin Appleby and placed in the public domain. This version has
> > > been modified to produce the same result on both big endian and little
> > > endian processors, making it suitable for use in portable persistent data.
> > > 
> > > Signed-off-by: J. corwin Coburn <corwin@redhat.com>
> > > ---
> > >   drivers/md/dm-vdo/murmurhash3.c | 175 ++++++++++++++++++++++++++++++++
> > >   drivers/md/dm-vdo/murmurhash3.h |  15 +++
> > >   2 files changed, 190 insertions(+)
> > >   create mode 100644 drivers/md/dm-vdo/murmurhash3.c
> > >   create mode 100644 drivers/md/dm-vdo/murmurhash3.h
> > 
> > Do we really need yet another hash algorithm?
> > 
> > xxHash is another very fast non-cryptographic hash algorithm that is already
> > available in the kernel (lib/xxhash.c).
> > 
> > - Eric
> 
> The main reason why vdo uses Murmur3 and not xxHash is that vdo has been in
> deployment since 2013, and, if I am reading correctly, xxHash did not have a
> 128 bit variant until 2019.

Why do you need a 128-bit non-cryptographic hash algorithm?  What problem are
you trying to solve?

> 
> It would certainly be possible to switch vdo to xxHash, but it would be
> problematic for existing users.
> 

Well, this commit doesn't mention that the choice was forced for compatibility
reasons.

It sounds like the on-disk format (and presumably the UAPI, too?) for dm-vdo was
already set in stone before it was ever sent out for review.

That takes away some motivation to bother reviewing it, since many review
comments will be met with "we won't change this"...

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

