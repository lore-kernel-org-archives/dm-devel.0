Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A7E1C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684883197;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nVQl3t0WcxZsaIENMjPKcN44DEVIOpnzEm0p6PYjlJE=;
	b=atrHCHyzFDmNvjeMycqG/1Yu2oR3X3zzgsEDlNIJS9bIUxD+MGjJvTYOSFYfzQDdec0FqE
	HUA/fKht4agwXWhvcS70n9l+EguIttOWodFoes7NyfCxDF29m+Zny8nU5veIebsxIW6Yhw
	ygs9Ir6zTUgSBQMc/sRu6IiZTFETVnw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Z2JNnnCHNE-L2_6efXrYaw-1; Tue, 23 May 2023 19:06:34 -0400
X-MC-Unique: Z2JNnnCHNE-L2_6efXrYaw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2769B185A7A7;
	Tue, 23 May 2023 23:06:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BE561121315;
	Tue, 23 May 2023 23:06:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B69A419465A8;
	Tue, 23 May 2023 23:06:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB84219465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 23:06:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8E501121315; Tue, 23 May 2023 23:06:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D18121121314
 for <dm-devel@redhat.com>; Tue, 23 May 2023 23:06:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B74A58039A4
 for <dm-devel@redhat.com>; Tue, 23 May 2023 23:06:29 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-_z7QWynaPHyMjOqrEOdptw-1; Tue, 23 May 2023 19:06:27 -0400
X-MC-Unique: _z7QWynaPHyMjOqrEOdptw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EB4DC631F8;
 Tue, 23 May 2023 23:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFF2C433EF;
 Tue, 23 May 2023 23:06:26 +0000 (UTC)
Date: Tue, 23 May 2023 23:06:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: corwin <corwin@redhat.com>
Message-ID: <20230523230624.GF888341@google.com>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523214539.226387-3-corwin@redhat.com>
 <20230523220618.GA888341@google.com>
 <0d3d1835-d945-9fa2-f3b7-6a60aae3d1df@redhat.com>
 <20230523222501.GD888341@google.com>
MIME-Version: 1.0
In-Reply-To: <20230523222501.GD888341@google.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23, 2023 at 10:25:01PM +0000, Eric Biggers wrote:
> On Tue, May 23, 2023 at 06:13:08PM -0400, corwin wrote:
> > On 5/23/23 6:06 PM, Eric Biggers wrote:
> > > On Tue, May 23, 2023 at 05:45:02PM -0400, J. corwin Coburn wrote:
> > > > MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
> > > > written by Austin Appleby and placed in the public domain. This version has
> > > > been modified to produce the same result on both big endian and little
> > > > endian processors, making it suitable for use in portable persistent data.
> > > > 
> > > > Signed-off-by: J. corwin Coburn <corwin@redhat.com>
> > > > ---
> > > >   drivers/md/dm-vdo/murmurhash3.c | 175 ++++++++++++++++++++++++++++++++
> > > >   drivers/md/dm-vdo/murmurhash3.h |  15 +++
> > > >   2 files changed, 190 insertions(+)
> > > >   create mode 100644 drivers/md/dm-vdo/murmurhash3.c
> > > >   create mode 100644 drivers/md/dm-vdo/murmurhash3.h
> > > 
> > > Do we really need yet another hash algorithm?
> > > 
> > > xxHash is another very fast non-cryptographic hash algorithm that is already
> > > available in the kernel (lib/xxhash.c).
> > > 
> > > - Eric
> > 
> > The main reason why vdo uses Murmur3 and not xxHash is that vdo has been in
> > deployment since 2013, and, if I am reading correctly, xxHash did not have a
> > 128 bit variant until 2019.
> 
> Why do you need a 128-bit non-cryptographic hash algorithm?  What problem are
> you trying to solve?

To elaborate a bit: the reason this seems strange to me is that when people say
they need a 128-bit (or larger) non-cryptographic hash function, usually they
are either mistaken and 64-bit would suffice, or they actually need a
cryptographic hash function.

In this case, the hash function seems to be used for data deduplication.  This
is unusual, since data deduplication normally requires a cryptographic hash
algorithm.

I see that this is touched on by the following paragraph in vdo-design.rst
(though it incorrectly calls the hash an "identifier for the block"):

    Each block of data is hashed to produce a 16-byte block name which serves as
    an identifier for the block. An index record consists of this block name
    paired with the presumed location of that data on the underlying storage.
    However, it is not possible to guarantee that the index is accurate. Most
    often, this occurs because it is too costly to update the index when a block
    is over-written or discarded. Doing so would require either storing the
    block name along with the blocks, which is difficult to do efficiently in
    block-based storage, or reading and rehashing each block before overwriting
    it. Inaccuracy can also result from a hash collision where two different
    blocks have the same name. In practice, this is extremely unlikely, but
    because vdo does not use a cryptographic hash, a malicious workload can be
    constructed. Because of these inaccuracies, vdo treats the locations in the
    index as hints, and reads each indicated block to verify that it is indeed a
    duplicate before sharing the existing block with a new one.

So, dm-vdo handles hash collisions by reading back and verifying that the data
matches before allowing deduplication.

That solves the security problem.  However, it does seem strange, and it's more
complex than the usual solution of just using a cryptographic hash.  Note that
cryptographic hashing is very fast on modern CPUs with modern algorithms.

So, some more details about the rationale for designing the data deduplication
in this (IMO unusual) way should be included.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

