Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EB3C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:05:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 74A0964DDA
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74A0964DDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613084714;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Hg5e/Z8ZLRkchqZ33WvWtARlFJg1BXVpD5bvLHdfgzU=;
	b=gC5nj8Cn5rvVS61w8Fncb4fafgbTZptoAPd/Doxk+/nKC9GtaXTt9qBnRKP4L1KUjLzDsw
	pYkkX7qWkrYM4n7K/JuNXC+wXUa4HGqYWWJz9dIfqVWhfNSpsuyATrGGxMc6ba8FBVVhJq
	M0d0muCQhNv0CJCIeIOrQ54GnIG+HVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-VHpxB6MOO3WqubUw7xKOfA-1; Thu, 11 Feb 2021 18:05:10 -0500
X-MC-Unique: VHpxB6MOO3WqubUw7xKOfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F7CD107ACE3;
	Thu, 11 Feb 2021 23:05:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E375A60BF1;
	Thu, 11 Feb 2021 23:05:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F7E64E58D;
	Thu, 11 Feb 2021 23:05:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BN53Qw005728 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 18:05:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 423BB5DA27; Thu, 11 Feb 2021 23:05:03 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15F105D9C2;
	Thu, 11 Feb 2021 23:05:00 +0000 (UTC)
Date: Thu, 11 Feb 2021 18:04:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Satya Tangirala <satyat@google.com>
Message-ID: <20210211230459.GA15187@redhat.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210210193327.GA8226@redhat.com>
	<c681d976-f1bd-482c-8ead-b099986b70e5@kernel.dk>
	<YCW3SlbDFNn+Xyac@google.com>
MIME-Version: 1.0
In-Reply-To: <YCW3SlbDFNn+Xyac@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 11 2021 at  6:01pm -0500,
Satya Tangirala <satyat@google.com> wrote:

> On Wed, Feb 10, 2021 at 12:59:59PM -0700, Jens Axboe wrote:
> > On 2/10/21 12:33 PM, Mike Snitzer wrote:
> > > On Mon, Feb 01 2021 at 12:10am -0500,
> > > Satya Tangirala <satyat@google.com> wrote:
> > > 
> > >> This patch series adds support for inline encryption to the device mapper.
> > >>
> > >> Patch 1 introduces the "passthrough" keyslot manager.
> > >>
> > >> The regular keyslot manager is designed for inline encryption hardware that
> > >> have only a small fixed number of keyslots. A DM device itself does not
> > >> actually have only a small fixed number of keyslots - it doesn't actually
> > >> have any keyslots in the first place, and programming an encryption context
> > >> into a DM device doesn't make much semantic sense. It is possible for a DM
> > >> device to set up a keyslot manager with some "sufficiently large" number of
> > >> keyslots in its request queue, so that upper layers can use the inline
> > >> encryption capabilities of the DM device's underlying devices, but the
> > >> memory being allocated for the DM device's keyslots is a waste since they
> > >> won't actually be used by the DM device.
> > >>
> > >> The passthrough keyslot manager solves this issue - when the block layer
> > >> sees that a request queue has a passthrough keyslot manager, it doesn't
> > >> attempt to program any encryption context into the keyslot manager. The
> > >> passthrough keyslot manager only allows the device to expose its inline
> > >> encryption capabilities, and a way for upper layers to evict keys if
> > >> necessary.
> > >>
> > >> There also exist inline encryption hardware that can handle encryption
> > >> contexts directly, and allow users to pass them a data request along with
> > >> the encryption context (as opposed to inline encryption hardware that
> > >> require users to first program a keyslot with an encryption context, and
> > >> then require the users to pass the keyslot index with the data request).
> > >> Such devices can also make use of the passthrough keyslot manager.
> > >>
> > >> Patch 2 introduces some keyslot manager functions useful for the device
> > >> mapper.
> > >>
> > >> Patch 3 introduces the changes for inline encryption support for the device
> > >> mapper. A DM device only exposes the intersection of the crypto
> > >> capabilities of its underlying devices. This is so that in case a bio with
> > >> an encryption context is eventually mapped to an underlying device that
> > >> doesn't support that encryption context, the blk-crypto-fallback's cipher
> > >> tfms are allocated ahead of time by the call to blk_crypto_start_using_key.
> > >>
> > >> Each DM target can now also specify the "DM_TARGET_PASSES_CRYPTO" flag in
> > >> the target type features to opt-in to supporting passing through the
> > >> underlying inline encryption capabilities.  This flag is needed because it
> > >> doesn't make much semantic sense for certain targets like dm-crypt to
> > >> expose the underlying inline encryption capabilities to the upper layers.
> > >> Again, the DM exposes inline encryption capabilities of the underlying
> > >> devices only if all of them opt-in to passing through inline encryption
> > >> support.
> > >>
> > >> A keyslot manager is created for a table when it is loaded. However, the
> > >> mapped device's exposed capabilities *only* updated once the table is
> > >> swapped in (until the new table is swapped in, the mapped device continues
> > >> to expose the old table's crypto capabilities).
> > >>
> > >> This patch only allows the keyslot manager's capabilities to *expand*
> > >> because of table changes. Any attempt to load a new table that doesn't
> > >> support a crypto capability that the old table did is rejected.
> > >>
> > >> This patch also only exposes the intersection of the underlying device's
> > >> capabilities, which has the effect of causing en/decryption of a bio to
> > >> fall back to the kernel crypto API (if the fallback is enabled) whenever
> > >> any of the underlying devices doesn't support the encryption context of the
> > >> bio - it might be possible to make the bio only fall back to the kernel
> > >> crypto API if the bio's target underlying device doesn't support the bio's
> > >> encryption context, but the use case may be uncommon enough in the first
> > >> place not to warrant worrying about it right now.
> > >>
> > >> Patch 4 makes DM evict a key from all its underlying devices when asked to
> > >> evict a key.
> > >>
> > >> Patch 5 makes some DM targets opt-in to passing through inline encryption
> > >> support. It does not (yet) try to enable this option with dm-raid, since
> > >> users can "hot add" disks to a raid device, which makes this not completely
> > >> straightforward (we'll need to ensure that any "hot added" disks must have
> > >> a superset of the inline encryption capabilities of the rest of the disks
> > >> in the raid device, due to the way Patch 2 of this series works).
> > >>
> > >> Changes v3 => v4:
> > >>  - Allocate the memory for the ksm of the mapped device in
> > >>    dm_table_complete(), and install the ksm in the md queue in __bind()
> > >>    (as suggested by Mike). Also drop patch 5 from v3 since it's no longer
> > >>    needed.
> > >>  - Some cleanups
> > >>
> > >> Changes v2 => v3:
> > >>  - Split up the main DM patch into 4 separate patches
> > >>  - Removed the priv variable added to struct keyslot manager in v2
> > >>  - Use a flag in target type features for opting-in to inline encryption
> > >>    support, instead of using "may_passthrough_inline_crypto"
> > >>  - cleanups, improve docs and restructure code
> > >>
> > >> Changes v1 => v2:
> > >>  - Introduce private field to struct blk_keyslot_manager
> > >>  - Allow the DM keyslot manager to expand its crypto capabilities if the
> > >>    table is changed.
> > >>  - Make DM reject table changes that would otherwise cause crypto
> > >>    capabilities to be dropped.
> > >>  - Allocate the DM device's keyslot manager only when at least one crypto
> > >>    capability is supported (since a NULL value for q->ksm represents "no
> > >>    crypto support" anyway).
> > >>  - Remove the struct blk_keyslot_manager field from struct mapped_device.
> > >>    This patch now relies on just directly setting up the keyslot manager in
> > >>    the request queue, since each DM device is tied to only 1 queue.
> > >>
> > >> Satya Tangirala (5):
> > >>   block: keyslot-manager: Introduce passthrough keyslot manager
> > >>   block: keyslot-manager: Introduce functions for device mapper support
> > >>   dm: add support for passing through inline crypto support
> > >>   dm: support key eviction from keyslot managers of underlying devices
> > >>   dm: set DM_TARGET_PASSES_CRYPTO feature for some targets
> > >>
> > >>  block/blk-crypto.c              |   1 +
> > >>  block/keyslot-manager.c         | 146 ++++++++++++++++++++++
> > >>  drivers/md/dm-core.h            |   5 +
> > >>  drivers/md/dm-flakey.c          |   4 +-
> > >>  drivers/md/dm-linear.c          |   5 +-
> > >>  drivers/md/dm-table.c           | 210 ++++++++++++++++++++++++++++++++
> > >>  drivers/md/dm.c                 |  18 ++-
> > >>  include/linux/device-mapper.h   |  11 ++
> > >>  include/linux/keyslot-manager.h |  11 ++
> > >>  9 files changed, 407 insertions(+), 4 deletions(-)
> > >>
> > >> -- 
> > >> 2.30.0.365.g02bc693789-goog
> > >>
> > > 
> > > This set looks good to me now.
> > > 
> > > To avoid DM needing another rebase on block: Jens (and others), would
> > > you like to review patches 1 and 2 (and reply with your Reviewed-by) so
> > > I could pickup the DM required keyslot-manager changes along with
> > > patches 3-5?
> > 
> > You can add my acked-by to 1+2 and queue it up.
> > 
> I resent the series (as v5) while addressing the comments Eric had on
> Patch 3 (the changes were only to comments, so no functional
> changes). I also added the acked/reviewed-bys.

I took care of Eric's comments.
And I already staged these changes in linux-next for dm-5.12, see:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.12

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

