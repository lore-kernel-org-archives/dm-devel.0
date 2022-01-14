Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A24C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 22:27:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-E4vMqSWlOhq-SJSAs2KryA-1; Fri, 14 Jan 2022 17:27:41 -0500
X-MC-Unique: E4vMqSWlOhq-SJSAs2KryA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E860196E6C0;
	Fri, 14 Jan 2022 22:27:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BECB04E2AB;
	Fri, 14 Jan 2022 22:27:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BA1F44BB7C;
	Fri, 14 Jan 2022 22:27:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20EMRU4U004127 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 Jan 2022 17:27:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 583F82166B1A; Fri, 14 Jan 2022 22:27:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51E0F2166B2D
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 22:27:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61730811E76
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 22:27:26 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-290-zBUV79AYOp6YZbvvXFWzmA-1; Fri, 14 Jan 2022 17:27:24 -0500
X-MC-Unique: zBUV79AYOp6YZbvvXFWzmA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 38C186203D;
	Fri, 14 Jan 2022 22:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749C6C36AE7;
	Fri, 14 Jan 2022 22:27:23 +0000 (UTC)
Date: Fri, 14 Jan 2022 14:27:22 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YeH4yhy1FFGooOrR@sol.localdomain>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
MIME-Version: 1.0
In-Reply-To: <9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	dm-devel <dm-devel@redhat.com>, Nitzan Carmi <nitzanc@nvidia.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 14, 2022 at 09:51:20PM +0100, Milan Broz wrote:
> On 13/01/2022 19:09, Israel Rukshin wrote:
> > Hi,
> > 
> > I am working to add support for inline encryption/decryption
> > at storage protocols like nvmf over RDMA. The HW that I am
> > working with is ConnecX-6 Dx, which supports inline crypto
> > and can send the data on the fabric at the same time.
> 
> This idea comes from time to time, and it makes dm-crypt bloated,
> and mainly it moves responsibility for encryption to block layer
> crypto.
> It adds two completely different sector encryption paths there.
> 
> Also, see my comments here (for similar patches)
> https://lore.kernel.org/dm-devel/c94d425a-bca4-8a8b-47bf-451239d29ebd@gmail.com/
> 
> I think dm-crypt should stay as SW crypto only (using kernel crypto API,
> so HW acceleration is done through crypto drivers there).
> 
> A cleaner solution is to write a much simpler new dm-crypt-inline target,
> which will implement only inline encryption.
> (And userspace can decide which target to use.)
> Code should be just an extension to the dm-linear target, most
> of dm-crypt complexity is not needed here.
> 
> Also, please think about configuration - how do you want to configure it?
> 
> Just my opinion, it is, of course, up to DM maintainer if he takes such patches.
> 

IMO, adding inline encryption support to dm-crypt would be fine.  Normally,
blk-crypto is just an alternate implementation of encryption/decryption.  I'm
not sure that a separate dm target is warranted just because of a different
implementation, as opposed to different *behavior*.  (Support for wrapped keys
does complicate things a bit, as they do change behavior.)  But, I'd also be
fine with a separate dm target if the dm maintainers prefer that route.

Note that in the Android Common Kernels, there is already a dm target called
"dm-default-key" which uses dm-crypt compatible syntax but uses blk-crypto
(inline encryption) rather than the crypto API:
https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/md/dm-default-key.c

It differs slightly from what is being proposed here in that dm-default-key's
purpose is to implement filesystem "metadata encryption", so it has logic to
skip encrypting blocks that have their encryption controlled at the filesystem
level due to being part of an encrypted file's contents.  I expect that logic
would be unacceptable upstream, as it's a layering violation.  (The long-term
plan is to handle metadata encryption entirely at the filesystem level instead.)

But with that potentially-controversial logic removed, it would basically be
dm-inline-crypt already, so it would be a good starting point.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

