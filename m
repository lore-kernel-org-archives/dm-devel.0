Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A3CC433E6
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:10:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C887864E2E
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C887864E2E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-yj4RLV8hPyaLy_yaZJHEHg-1; Mon, 01 Feb 2021 00:10:46 -0500
X-MC-Unique: yj4RLV8hPyaLy_yaZJHEHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBE0E61180;
	Mon,  1 Feb 2021 05:10:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D4E65DA35;
	Mon,  1 Feb 2021 05:10:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D9D964EBC6;
	Mon,  1 Feb 2021 05:10:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1115AY4d015670 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 00:10:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 28D042026D12; Mon,  1 Feb 2021 05:10:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 233F52026D13
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 419E4101A531
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:31 +0000 (UTC)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
	[209.85.210.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-174--3thO15HPZig2a51pLX9vA-1; Mon, 01 Feb 2021 00:10:29 -0500
X-MC-Unique: -3thO15HPZig2a51pLX9vA-1
Received: by mail-pf1-f201.google.com with SMTP id z10so215415pfa.1
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 21:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
	:to:cc;
	bh=5ZoMmUaGdgNrxvzHYeMz2EcFPXbySR8ZrCc4GJHr60Q=;
	b=AOUbAwYDzlzT1lN7YFwVmqZHukTIeq+n82S1fOSAnCU6vTtrgC538xXfU0/92PEiU4
	G9bgpUq5c+ZFtyquoP5KkWWvEGRLnndaDOnJxNBmx51/FKeLrpcK7u4xdzph5C+CPox3
	v22Pf62byWG46PbUKlROoHbOmzmCVpv184c6Y09S+NC8UY48YLZO+cDMfjuFNDlycXDk
	pvouFuSdNIgnfFdfejlKOortSOq9LHnMe/6HwuCadCnOJywbRCBvLcHoPKCjLWD3TO5e
	GiWPmWkil+y+wpysQDTUPYqNGCSJmKK23UblNMXPqLzqOA9E3Oyvl9zQdGRgEQ0t9aRF
	0TjA==
X-Gm-Message-State: AOAM5311Dvju7eGBA+Ql97nerchq8VUV9KWED0QZbxbPrh9ahKcuHqid
	2opW/lbvGZG4KlBy/0xTuxzBhqnr360=
X-Google-Smtp-Source: ABdhPJx7kmsVH9WtDT4ayliJVLV/lqAyWP654IizECuvbo2azm7D5+QBqPGedxCBE8YFh0HDRNKdzQUMhKM=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a05:6a00:86:b029:1c1:99a1:fe2b with
	SMTP id
	c6-20020a056a000086b02901c199a1fe2bmr15065660pfj.29.1612156227897;
	Sun, 31 Jan 2021 21:10:27 -0800 (PST)
Date: Mon,  1 Feb 2021 05:10:14 +0000
Message-Id: <20210201051019.1174983-1-satyat@google.com>
Mime-Version: 1.0
From: Satya Tangirala <satyat@google.com>
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v4 0/5] add support for inline encryption to
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch series adds support for inline encryption to the device mapper.

Patch 1 introduces the "passthrough" keyslot manager.

The regular keyslot manager is designed for inline encryption hardware that
have only a small fixed number of keyslots. A DM device itself does not
actually have only a small fixed number of keyslots - it doesn't actually
have any keyslots in the first place, and programming an encryption context
into a DM device doesn't make much semantic sense. It is possible for a DM
device to set up a keyslot manager with some "sufficiently large" number of
keyslots in its request queue, so that upper layers can use the inline
encryption capabilities of the DM device's underlying devices, but the
memory being allocated for the DM device's keyslots is a waste since they
won't actually be used by the DM device.

The passthrough keyslot manager solves this issue - when the block layer
sees that a request queue has a passthrough keyslot manager, it doesn't
attempt to program any encryption context into the keyslot manager. The
passthrough keyslot manager only allows the device to expose its inline
encryption capabilities, and a way for upper layers to evict keys if
necessary.

There also exist inline encryption hardware that can handle encryption
contexts directly, and allow users to pass them a data request along with
the encryption context (as opposed to inline encryption hardware that
require users to first program a keyslot with an encryption context, and
then require the users to pass the keyslot index with the data request).
Such devices can also make use of the passthrough keyslot manager.

Patch 2 introduces some keyslot manager functions useful for the device
mapper.

Patch 3 introduces the changes for inline encryption support for the device
mapper. A DM device only exposes the intersection of the crypto
capabilities of its underlying devices. This is so that in case a bio with
an encryption context is eventually mapped to an underlying device that
doesn't support that encryption context, the blk-crypto-fallback's cipher
tfms are allocated ahead of time by the call to blk_crypto_start_using_key.

Each DM target can now also specify the "DM_TARGET_PASSES_CRYPTO" flag in
the target type features to opt-in to supporting passing through the
underlying inline encryption capabilities.  This flag is needed because it
doesn't make much semantic sense for certain targets like dm-crypt to
expose the underlying inline encryption capabilities to the upper layers.
Again, the DM exposes inline encryption capabilities of the underlying
devices only if all of them opt-in to passing through inline encryption
support.

A keyslot manager is created for a table when it is loaded. However, the
mapped device's exposed capabilities *only* updated once the table is
swapped in (until the new table is swapped in, the mapped device continues
to expose the old table's crypto capabilities).

This patch only allows the keyslot manager's capabilities to *expand*
because of table changes. Any attempt to load a new table that doesn't
support a crypto capability that the old table did is rejected.

This patch also only exposes the intersection of the underlying device's
capabilities, which has the effect of causing en/decryption of a bio to
fall back to the kernel crypto API (if the fallback is enabled) whenever
any of the underlying devices doesn't support the encryption context of the
bio - it might be possible to make the bio only fall back to the kernel
crypto API if the bio's target underlying device doesn't support the bio's
encryption context, but the use case may be uncommon enough in the first
place not to warrant worrying about it right now.

Patch 4 makes DM evict a key from all its underlying devices when asked to
evict a key.

Patch 5 makes some DM targets opt-in to passing through inline encryption
support. It does not (yet) try to enable this option with dm-raid, since
users can "hot add" disks to a raid device, which makes this not completely
straightforward (we'll need to ensure that any "hot added" disks must have
a superset of the inline encryption capabilities of the rest of the disks
in the raid device, due to the way Patch 2 of this series works).

Changes v3 => v4:
 - Allocate the memory for the ksm of the mapped device in
   dm_table_complete(), and install the ksm in the md queue in __bind()
   (as suggested by Mike). Also drop patch 5 from v3 since it's no longer
   needed.
 - Some cleanups

Changes v2 => v3:
 - Split up the main DM patch into 4 separate patches
 - Removed the priv variable added to struct keyslot manager in v2
 - Use a flag in target type features for opting-in to inline encryption
   support, instead of using "may_passthrough_inline_crypto"
 - cleanups, improve docs and restructure code

Changes v1 => v2:
 - Introduce private field to struct blk_keyslot_manager
 - Allow the DM keyslot manager to expand its crypto capabilities if the
   table is changed.
 - Make DM reject table changes that would otherwise cause crypto
   capabilities to be dropped.
 - Allocate the DM device's keyslot manager only when at least one crypto
   capability is supported (since a NULL value for q->ksm represents "no
   crypto support" anyway).
 - Remove the struct blk_keyslot_manager field from struct mapped_device.
   This patch now relies on just directly setting up the keyslot manager in
   the request queue, since each DM device is tied to only 1 queue.

Satya Tangirala (5):
  block: keyslot-manager: Introduce passthrough keyslot manager
  block: keyslot-manager: Introduce functions for device mapper support
  dm: add support for passing through inline crypto support
  dm: support key eviction from keyslot managers of underlying devices
  dm: set DM_TARGET_PASSES_CRYPTO feature for some targets

 block/blk-crypto.c              |   1 +
 block/keyslot-manager.c         | 146 ++++++++++++++++++++++
 drivers/md/dm-core.h            |   5 +
 drivers/md/dm-flakey.c          |   4 +-
 drivers/md/dm-linear.c          |   5 +-
 drivers/md/dm-table.c           | 210 ++++++++++++++++++++++++++++++++
 drivers/md/dm.c                 |  18 ++-
 include/linux/device-mapper.h   |  11 ++
 include/linux/keyslot-manager.h |  11 ++
 9 files changed, 407 insertions(+), 4 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

