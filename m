Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396FDC433E9
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:01:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AFAA64DDF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:01:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AFAA64DDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-6Fo4tIE1MFSthQv6XQ4DpA-1; Thu, 11 Feb 2021 18:01:47 -0500
X-MC-Unique: 6Fo4tIE1MFSthQv6XQ4DpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B016080402C;
	Thu, 11 Feb 2021 23:01:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 913215D9C2;
	Thu, 11 Feb 2021 23:01:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 628F458074;
	Thu, 11 Feb 2021 23:01:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BN1egi005380 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 18:01:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 79795103417; Thu, 11 Feb 2021 23:01:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73882103413
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:01:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DD92811760
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:01:37 +0000 (UTC)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
	[209.85.215.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-205-dY-oxhCFN_KmOwG9afhXCg-1; Thu, 11 Feb 2021 18:01:35 -0500
X-MC-Unique: dY-oxhCFN_KmOwG9afhXCg-1
Received: by mail-pg1-f174.google.com with SMTP id z68so303046pgz.0
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 15:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=S2PQQ0wZ9rKvtqHbEKRPCYDXrvuY1Je3Fig5GLurKUw=;
	b=uE/VLzybyE5LAL/OlXB7G8z22hZUjU5GY6SkUpEcvq3msteRfR/p+lp3wrmUb+EzB0
	1BqDbyWCIs59Hy3Qbd8xFCEqde2GbNeA1Y92E7pp52D4KL+bCvIStV+LBQAe9jfNMSyW
	5qVP8Vp3l1FUXUwhitnEI1GciD9bky64tVZb6Wi5jcj9+HUPolVagFWcJncv2nJ84Lq8
	q1143RsyVPY/BORiG5dc3jB174lJufSQ/cAkZj9jmONPabMuO4LFifyKTvlsZAejhdiE
	h/44yW+LKjFjonrAi7qOQMvkjEvyOH1ZFwQeKGGkuud9sRy9Nlykolvc5NU75KSBYj0O
	JGZA==
X-Gm-Message-State: AOAM531JAmD/pwaFy1c80ubglJGnJ2u0THoyHIKKF7ZGkpJHhNnbM9ZA
	m4vVQoI0Wz5ggvZRlqxW8UVM5Q==
X-Google-Smtp-Source: ABdhPJxxt2xRxHf1nl56GLsI9CGVrWK+YuqrhhMftY3Qk6dliUbXQXwSskF02sPLv66MVCa9bJve5g==
X-Received: by 2002:a65:62cd:: with SMTP id m13mr405393pgv.108.1613084494210; 
	Thu, 11 Feb 2021 15:01:34 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com.
	[34.82.60.139]) by smtp.gmail.com with ESMTPSA id
	h15sm6776584pfo.84.2021.02.11.15.01.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 11 Feb 2021 15:01:33 -0800 (PST)
Date: Thu, 11 Feb 2021 23:01:30 +0000
From: Satya Tangirala <satyat@google.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YCW3SlbDFNn+Xyac@google.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210210193327.GA8226@redhat.com>
	<c681d976-f1bd-482c-8ead-b099986b70e5@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <c681d976-f1bd-482c-8ead-b099986b70e5@kernel.dk>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 0/5] add support for inline encryption to
	device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Feb 10, 2021 at 12:59:59PM -0700, Jens Axboe wrote:
> On 2/10/21 12:33 PM, Mike Snitzer wrote:
> > On Mon, Feb 01 2021 at 12:10am -0500,
> > Satya Tangirala <satyat@google.com> wrote:
> > 
> >> This patch series adds support for inline encryption to the device mapper.
> >>
> >> Patch 1 introduces the "passthrough" keyslot manager.
> >>
> >> The regular keyslot manager is designed for inline encryption hardware that
> >> have only a small fixed number of keyslots. A DM device itself does not
> >> actually have only a small fixed number of keyslots - it doesn't actually
> >> have any keyslots in the first place, and programming an encryption context
> >> into a DM device doesn't make much semantic sense. It is possible for a DM
> >> device to set up a keyslot manager with some "sufficiently large" number of
> >> keyslots in its request queue, so that upper layers can use the inline
> >> encryption capabilities of the DM device's underlying devices, but the
> >> memory being allocated for the DM device's keyslots is a waste since they
> >> won't actually be used by the DM device.
> >>
> >> The passthrough keyslot manager solves this issue - when the block layer
> >> sees that a request queue has a passthrough keyslot manager, it doesn't
> >> attempt to program any encryption context into the keyslot manager. The
> >> passthrough keyslot manager only allows the device to expose its inline
> >> encryption capabilities, and a way for upper layers to evict keys if
> >> necessary.
> >>
> >> There also exist inline encryption hardware that can handle encryption
> >> contexts directly, and allow users to pass them a data request along with
> >> the encryption context (as opposed to inline encryption hardware that
> >> require users to first program a keyslot with an encryption context, and
> >> then require the users to pass the keyslot index with the data request).
> >> Such devices can also make use of the passthrough keyslot manager.
> >>
> >> Patch 2 introduces some keyslot manager functions useful for the device
> >> mapper.
> >>
> >> Patch 3 introduces the changes for inline encryption support for the device
> >> mapper. A DM device only exposes the intersection of the crypto
> >> capabilities of its underlying devices. This is so that in case a bio with
> >> an encryption context is eventually mapped to an underlying device that
> >> doesn't support that encryption context, the blk-crypto-fallback's cipher
> >> tfms are allocated ahead of time by the call to blk_crypto_start_using_key.
> >>
> >> Each DM target can now also specify the "DM_TARGET_PASSES_CRYPTO" flag in
> >> the target type features to opt-in to supporting passing through the
> >> underlying inline encryption capabilities.  This flag is needed because it
> >> doesn't make much semantic sense for certain targets like dm-crypt to
> >> expose the underlying inline encryption capabilities to the upper layers.
> >> Again, the DM exposes inline encryption capabilities of the underlying
> >> devices only if all of them opt-in to passing through inline encryption
> >> support.
> >>
> >> A keyslot manager is created for a table when it is loaded. However, the
> >> mapped device's exposed capabilities *only* updated once the table is
> >> swapped in (until the new table is swapped in, the mapped device continues
> >> to expose the old table's crypto capabilities).
> >>
> >> This patch only allows the keyslot manager's capabilities to *expand*
> >> because of table changes. Any attempt to load a new table that doesn't
> >> support a crypto capability that the old table did is rejected.
> >>
> >> This patch also only exposes the intersection of the underlying device's
> >> capabilities, which has the effect of causing en/decryption of a bio to
> >> fall back to the kernel crypto API (if the fallback is enabled) whenever
> >> any of the underlying devices doesn't support the encryption context of the
> >> bio - it might be possible to make the bio only fall back to the kernel
> >> crypto API if the bio's target underlying device doesn't support the bio's
> >> encryption context, but the use case may be uncommon enough in the first
> >> place not to warrant worrying about it right now.
> >>
> >> Patch 4 makes DM evict a key from all its underlying devices when asked to
> >> evict a key.
> >>
> >> Patch 5 makes some DM targets opt-in to passing through inline encryption
> >> support. It does not (yet) try to enable this option with dm-raid, since
> >> users can "hot add" disks to a raid device, which makes this not completely
> >> straightforward (we'll need to ensure that any "hot added" disks must have
> >> a superset of the inline encryption capabilities of the rest of the disks
> >> in the raid device, due to the way Patch 2 of this series works).
> >>
> >> Changes v3 => v4:
> >>  - Allocate the memory for the ksm of the mapped device in
> >>    dm_table_complete(), and install the ksm in the md queue in __bind()
> >>    (as suggested by Mike). Also drop patch 5 from v3 since it's no longer
> >>    needed.
> >>  - Some cleanups
> >>
> >> Changes v2 => v3:
> >>  - Split up the main DM patch into 4 separate patches
> >>  - Removed the priv variable added to struct keyslot manager in v2
> >>  - Use a flag in target type features for opting-in to inline encryption
> >>    support, instead of using "may_passthrough_inline_crypto"
> >>  - cleanups, improve docs and restructure code
> >>
> >> Changes v1 => v2:
> >>  - Introduce private field to struct blk_keyslot_manager
> >>  - Allow the DM keyslot manager to expand its crypto capabilities if the
> >>    table is changed.
> >>  - Make DM reject table changes that would otherwise cause crypto
> >>    capabilities to be dropped.
> >>  - Allocate the DM device's keyslot manager only when at least one crypto
> >>    capability is supported (since a NULL value for q->ksm represents "no
> >>    crypto support" anyway).
> >>  - Remove the struct blk_keyslot_manager field from struct mapped_device.
> >>    This patch now relies on just directly setting up the keyslot manager in
> >>    the request queue, since each DM device is tied to only 1 queue.
> >>
> >> Satya Tangirala (5):
> >>   block: keyslot-manager: Introduce passthrough keyslot manager
> >>   block: keyslot-manager: Introduce functions for device mapper support
> >>   dm: add support for passing through inline crypto support
> >>   dm: support key eviction from keyslot managers of underlying devices
> >>   dm: set DM_TARGET_PASSES_CRYPTO feature for some targets
> >>
> >>  block/blk-crypto.c              |   1 +
> >>  block/keyslot-manager.c         | 146 ++++++++++++++++++++++
> >>  drivers/md/dm-core.h            |   5 +
> >>  drivers/md/dm-flakey.c          |   4 +-
> >>  drivers/md/dm-linear.c          |   5 +-
> >>  drivers/md/dm-table.c           | 210 ++++++++++++++++++++++++++++++++
> >>  drivers/md/dm.c                 |  18 ++-
> >>  include/linux/device-mapper.h   |  11 ++
> >>  include/linux/keyslot-manager.h |  11 ++
> >>  9 files changed, 407 insertions(+), 4 deletions(-)
> >>
> >> -- 
> >> 2.30.0.365.g02bc693789-goog
> >>
> > 
> > This set looks good to me now.
> > 
> > To avoid DM needing another rebase on block: Jens (and others), would
> > you like to review patches 1 and 2 (and reply with your Reviewed-by) so
> > I could pickup the DM required keyslot-manager changes along with
> > patches 3-5?
> 
> You can add my acked-by to 1+2 and queue it up.
> 
I resent the series (as v5) while addressing the comments Eric had on
Patch 3 (the changes were only to comments, so no functional
changes). I also added the acked/reviewed-bys.
> -- 
> Jens Axboe
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

