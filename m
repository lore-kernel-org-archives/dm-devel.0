Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B114C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 19:47:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-YbC-TGaGMbiHqGdaOmlkxw-1; Tue, 18 Jan 2022 14:47:42 -0500
X-MC-Unique: YbC-TGaGMbiHqGdaOmlkxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2ACF1091DA0;
	Tue, 18 Jan 2022 19:47:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98BD4100E113;
	Tue, 18 Jan 2022 19:47:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4C4B4CA93;
	Tue, 18 Jan 2022 19:47:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IJlT61022335 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 14:47:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F994492D41; Tue, 18 Jan 2022 19:47:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C094492D40
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 19:47:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 811F6381D585
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 19:47:29 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-332-gLjEb8OYO4urPxJFsbOtAA-1; Tue, 18 Jan 2022 14:47:27 -0500
X-MC-Unique: gLjEb8OYO4urPxJFsbOtAA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 49F2CB8159B;
	Tue, 18 Jan 2022 19:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8251C340E0;
	Tue, 18 Jan 2022 19:38:30 +0000 (UTC)
Date: Tue, 18 Jan 2022 11:38:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YecXNYm63BL50hFL@sol.localdomain>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeH4yhy1FFGooOrR@sol.localdomain>
	<139878d0-d1bb-02d9-30c2-9334ffb5b3b3@gmail.com>
MIME-Version: 1.0
In-Reply-To: <139878d0-d1bb-02d9-30c2-9334ffb5b3b3@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jan 15, 2022 at 10:22:26AM +0100, Milan Broz wrote:
> > Note that in the Android Common Kernels, there is already a dm target called
> > "dm-default-key" which uses dm-crypt compatible syntax but uses blk-crypto
> > (inline encryption) rather than the crypto API:
> > https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/md/dm-default-key.c
> 
> Any plans to submit this to mainline? Or it is just too controversial?
> 
> > 
> > It differs slightly from what is being proposed here in that dm-default-key's
> > purpose is to implement filesystem "metadata encryption", so it has logic to
> > skip encrypting blocks that have their encryption controlled at the filesystem
> > level due to being part of an encrypted file's contents.  I expect that logic
> > would be unacceptable upstream, as it's a layering violation.  (The long-term
> > plan is to handle metadata encryption entirely at the filesystem level instead.)
> 
> Well, I wish that we have strong authenticated encryption in filesystem even for
> metadata, where it fits better in the fist place....
> But fscrypt is still not here (or am I mistaken?)
> 

I doubt that people would find Android's dm-default-key to be acceptable, given
that it's a layering violation, and a similar approach was rejected in the past
(https://lore.kernel.org/dm-devel/20170614234040.4326-1-mhalcrow@google.com/T/#u).
dm-default-key's purpose is filesystem metadata encryption; it encrypts all
blocks that aren't already part of an encrypted file's contents.  It differs
from dm-crypt + fscrypt together (which the upstream kernel already supports) in
that file contents aren't encrypted twice; this was a non-negotiable performance
requirement.  Obviously, this required a new flag in struct bio to indicate
which bios are reading/writing from an encrypted file's contents.  I doubt the
block layer people would find that to be acceptable.

In principle, the filesystem is the right place to implement metadata encryption
in this way.  This would also allow the kernel to enforce (via the key
hierarchy) that fscrypt keys are never weaker than the metadata encryption key.
Satya Tangirala previously implemented a proof of concept of this for f2fs
(https://lore.kernel.org/linux-f2fs-devel/20201217150435.1505269-1-satyat@google.com/T/#u).
Unfortunately, Satya has left Google and no one is currently working on this.
But it is still the long-term plan.

Authenticated encryption is certainly desirable, but not really feasible to
retrofit into filesystems that overwrite data in-place.  (Yes, dm-integrity
exists, but its performance impact is too much for the vast majority of users.)
Even f2fs isn't entirely log-structured; it often overwrites blocks in-place.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

