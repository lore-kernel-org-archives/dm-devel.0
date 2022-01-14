Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A74BC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 22:56:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-8p-Q6iAfNBCtD5bVFXmXQg-1; Fri, 14 Jan 2022 17:56:03 -0500
X-MC-Unique: 8p-Q6iAfNBCtD5bVFXmXQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AD3781CCB4;
	Fri, 14 Jan 2022 22:55:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6F785ED46;
	Fri, 14 Jan 2022 22:55:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29AE54BB7C;
	Fri, 14 Jan 2022 22:55:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20EMts8d006412 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 Jan 2022 17:55:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4FC12141DEE4; Fri, 14 Jan 2022 22:55:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4AE141DEE1
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 22:55:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31FB0800B36
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 22:55:54 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-232-0EEME6JnMe2QXIW48w6ocg-1; Fri, 14 Jan 2022 17:55:52 -0500
X-MC-Unique: 0EEME6JnMe2QXIW48w6ocg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id F104CCE23D5;
	Fri, 14 Jan 2022 22:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9F8C36AE7;
	Fri, 14 Jan 2022 22:49:44 +0000 (UTC)
Date: Fri, 14 Jan 2022 14:49:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Israel Rukshin <israelr@nvidia.com>
Message-ID: <YeH+Bv9KlceWbm05@sol.localdomain>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
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
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Israel,

On Thu, Jan 13, 2022 at 08:09:00PM +0200, Israel Rukshin wrote:
> Hi,
> 
> I am working to add support for inline encryption/decryption
> at storage protocols like nvmf over RDMA. The HW that I am
> working with is ConnecX-6 Dx, which supports inline crypto
> and can send the data on the fabric at the same time.
> 
> This patchset is based on v5.16-rc4 with Eric Biggers patches
> of the HW wrapped keys.
> It can be retrieved from branch "wip-wrapped-keys" at
> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
> 
> I tested this patch with modified nvme-rdma as the block device
> and created a DM crypt on top of it. I got performance enhancement
> compared to SW crypto. I tested the HW wrapped inline mode with
> the HW and the standard mode with a fallback algorithm.
> 
> Israel Rukshin (1):
>   dm crypt: Add inline encryption support
> 
>  block/blk-crypto.c    |   3 +
>  drivers/md/dm-crypt.c | 202 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 180 insertions(+), 25 deletions(-)

I appreciate the interest in my patchset that adds support for hardware-wrapped
inline encryption keys
(https://lore.kernel.org/linux-block/20211116033240.39001-1-ebiggers@kernel.org).
So far I've received very little feedback on it.

One of the challenges I've been having is that I still have no platform on which
I can actually test hardware-wrapped keys with the upstream kernel.  The feature
cannot be accepted upstream until there is a way to test it.  It's almost
working on the SM8350 SoC, but I am waiting for Qualcomm to fix some things.

It sounds like you've implemented a block device driver that exposes support for
hardware-wrapped keys.  Can you please post that driver?

Can you also elaborate on how wrapped keys work in your case?  In particular,
are they compatible with the whole design which I've documented in detail in my
patchset?  That would include implementing the ->import_key, ->generate_key,
->prepare_key, and ->derive_sw_secret operations.  All the different parts are
important.  If something needs to be optional, that's something I can consider
incorporating into the design, but it would restrict the use cases.

Also, will your driver only support wrapped keys, or will it support standard
keys too?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

