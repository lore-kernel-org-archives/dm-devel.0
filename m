Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69879C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:05:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-UZYUplKANmOftqQ6zaMolA-1; Wed, 02 Mar 2022 10:05:30 -0500
X-MC-Unique: UZYUplKANmOftqQ6zaMolA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93062835DE5;
	Wed,  2 Mar 2022 15:05:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ECC87DE20;
	Wed,  2 Mar 2022 15:05:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDC0546FA8;
	Wed,  2 Mar 2022 15:05:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 222EuhYN004788 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Mar 2022 09:56:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C3DB9140240A; Wed,  2 Mar 2022 14:56:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0419140EBFE
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 14:56:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A37321C0514E
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 14:56:43 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-JCojUvzROeiLV_Z1pl3ZrQ-1; Wed, 02 Mar 2022 09:56:42 -0500
X-MC-Unique: JCojUvzROeiLV_Z1pl3ZrQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 9CAC9B81FF0;
	Wed,  2 Mar 2022 14:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA49C004E1;
	Wed,  2 Mar 2022 14:56:38 +0000 (UTC)
Date: Wed, 2 Mar 2022 15:56:36 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <Yh+FpKuoyj3G16lK@kroah.com>
References: <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
	<Yh0y75aegqS4jIP7@silpixa00400314>
	<Yh1aLfy/oBawCJIg@gondor.apana.org.au>
	<CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
	<Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
	<Yh9ZvLHuztwQCu0d@silpixa00400314>
MIME-Version: 1.0
In-Reply-To: <Yh9ZvLHuztwQCu0d@silpixa00400314>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Dave Chinner <david@fromorbit.com>,
	Linux-Kernal <linux-kernel@vger.kernel.org>, qat-linux@intel.com,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 02, 2022 at 11:49:16AM +0000, Giovanni Cabiddu wrote:
> Hi Greg,
> 
> On Wed, Mar 02, 2022 at 11:29:00AM +0100, Greg KH wrote:
> > On Tue, Mar 01, 2022 at 04:11:13PM +1200, Herbert Xu wrote:
> > > On Mon, Feb 28, 2022 at 05:12:20PM -0800, Linus Torvalds wrote:
> > > > 
> > > > It sounds like it was incidental and almost accidental that it fixed
> > > > that thing, and nobody realized it should perhaps be also moved to
> > > > stable.
> > > 
> > > Yes this was incidental.  The patch in question fixes an issue in
> > > OOM situations where drivers that must allocate memory on each
> > > request may lead to dead-lock so it's not really targeted at qat.
> > 
> > Ok, so what commits should I backport to kernels older than 5.10 to
> > resolve this?
> Is it possible to wait for a set that resolves the problem rather than
> backporting the patches that disables the use-case?

It's already disabled in newer kernels, so we should do so for older
ones to prevent problems and the delay in getting those potential fixes
merged some day in the future.

> I have a patchset that fixes the actual issue and we are doing an
> internal review before submission to the mailing list.
> I should be able to send a V1 out between today and tomorrow.
> 
> If not, then these are the patches that should be backported:
>     7bcb2c99f8ed crypto: algapi - use common mechanism for inheriting flags
>     2eb27c11937e crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
>     fbb6cda44190 crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
>     b8aa7dc5c753 crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>     cd74693870fb dm crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
> Herbert, correct me if I'm wrong here.

These need to be manually backported as they do not apply cleanly.  Can
you provide such a set?  Or should I just disable a specific driver here
instead which would be easier overall?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

