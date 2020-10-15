Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47D4C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1060D20848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1060D20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-OF3eJ2adOHijzm5AdTmp2Q-1; Fri, 16 Oct 2020 06:20:48 -0400
X-MC-Unique: OF3eJ2adOHijzm5AdTmp2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 779FB186DD32;
	Fri, 16 Oct 2020 10:20:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE5E6716C;
	Fri, 16 Oct 2020 10:20:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 339F744A61;
	Fri, 16 Oct 2020 10:20:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09FLkh2E001464 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Oct 2020 17:46:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A2581067DA2; Thu, 15 Oct 2020 21:46:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4653B1067CDE
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 21:46:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0953A102F1E0
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 21:46:41 +0000 (UTC)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
	[209.85.219.74]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-188-yfg3hzDVOliAI7-seP2GCQ-1; Thu, 15 Oct 2020 17:46:38 -0400
X-MC-Unique: yfg3hzDVOliAI7-seP2GCQ-1
Received: by mail-qv1-f74.google.com with SMTP id ec4so288922qvb.21
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 14:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
	:to:cc;
	bh=uzsgrDVDbNo3+n6dFdimxZArMaCeWbOw2YwQOWztNSM=;
	b=EOh/FTkmWe7z6jDOfHIfIHMZgFyMFI6qvbPONkr7of9AsOaxCZ16k5loNJYhupH0Wn
	62ZGtMd/KvthEv+wq135FyY9hnWXqR8g4Ckqe+MZ6d9er04uS7EEot5AFU4zY7+9W0Ho
	JNmfN/+QLCW5JxaqoI39NyZlXL1XZ5vF8oHl2W+Om0Y6yLw1wZS40fg+nbkNlHd7Wa/I
	VK06M8iqIb0VkyuIxUJgCNXuM/geVpAKPEoORIGjleiO1Pin6NGEWP4TfEUWUawNtLKc
	nu9hVRCt7gcpvfww93UPfdHsAJMFjvlPxMaVm+cZJmzCr+GLxassFmjkbQLeU4Rtvqo9
	/COw==
X-Gm-Message-State: AOAM532wFURuHyZ+3oHon7qHCXu4CkYZUiKkD6OfW0KULiAK5ag/JjCc
	6BZfUWqgTeaZ/BuegJ5GYfKrTFjJdtA=
X-Google-Smtp-Source: ABdhPJwLbfh++KCbzPsp2mTaTGcm34JYSxlvF9jqR4gBntK5n7lNk83rZbBSf8MfpDEu8jjFtOqheno9XAw=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:ad4:46a8:: with SMTP id
	br8mr852724qvb.24.1602798398042; 
	Thu, 15 Oct 2020 14:46:38 -0700 (PDT)
Date: Thu, 15 Oct 2020 21:46:28 +0000
Message-Id: <20201015214632.41951-1-satyat@google.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Oct 2020 06:18:44 -0400
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v2 0/4] add support for inline encryption to
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

Patch 2 introduces a private field to struct blk_keyslot_manager that
owners of the struct can use for any purpose. The struct
blk_keyslot_manager has been embedded within other structures directly
(like in struct ufs_hba in drivers/scsi/ufs/ufshcd.h), but we don't
want to do that with struct mapped_device. So, the device mapper patches
later in this series use the private field to hold a pointer to the
associated struct mapped_device, since we can't use container_of() anymore.

Patch 3 introduces the changes for inline encryption support for the device
mapper. A DM device only exposes the intersection of the crypto
capabilities of its underlying devices. This is so that in case a bio with
an encryption context is eventually mapped to an underlying device that
doesn't support that encryption context, the blk-crypto-fallback's cipher
tfms are allocated ahead of time by the call to blk_crypto_start_using_key.

Each DM target can now also specify that it "may_passthrough_inline_crypto"
to opt-in to supporting passing through the underlying inline encryption
capabilities.  This flag is needed because it doesn't make much semantic
sense for certain targets like dm-crypt to expose the underlying inline
encryption capabilities to the upper layers. Again, the DM exposes inline
encryption capabilities of the underlying devices only if all of them
opt-in to passing through inline encryption support.

A DM device's keyslot manager is set up whenever a new table is swapped in.
This patch only allows the keyslot manager's capabilities to *expand*
because of table changes. Any attempts to load a new table that would cause
crypto capabilities to be dropped are rejected. The crypto capabilities of
a new table are also verified when the table is loaded (and the load is
rejected if crypto capabilities will be dropped because of the new table),
but the keyslot manager for the DM device is only modified when the table
is actually swapped in.

This patch also only exposes the intersection of the underlying
device's capabilities, which has the effect of causing en/decryption of a
bio to fall back to the kernel crypto API (if the fallback is enabled)
whenever any of the underlying devices doesn't support the encryption
context of the bio - it might be possible to make the bio only fall back to
the kernel crypto API if the bio's target underlying device doesn't support
the bio's encryption context, but the use case may be uncommon enough in
the first place not to warrant worrying about it right now.

Patch 4 makes some DM targets opt-in to passing through inline encryption
support. It does not (yet) try to enable this option with dm-raid, since
users can "hot add" disks to a raid device, which makes this not completely
straightforward (we'll need to ensure that any "hot added" disks must have
a superset of the inline encryption capabilities of the rest of the disks
in the raid device, due to the way Patch 2 of this series works).

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
   This patch now relies on just directly setting up the keyslot manager
   in the request queue, since each DM device is tied to only 1 queue.

Satya Tangirala (4):
  block: keyslot-manager: Introduce passthrough keyslot manager
  block: add private field to struct keyslot_manager
  dm: add support for passing through inline crypto support
  dm: enable may_passthrough_inline_crypto on some targets

 block/blk-crypto.c              |   1 +
 block/keyslot-manager.c         | 130 +++++++++++++++++++
 drivers/md/dm-flakey.c          |   1 +
 drivers/md/dm-ioctl.c           |   8 ++
 drivers/md/dm-linear.c          |   1 +
 drivers/md/dm.c                 | 217 +++++++++++++++++++++++++++++++-
 drivers/md/dm.h                 |  19 +++
 include/linux/device-mapper.h   |   6 +
 include/linux/keyslot-manager.h |  22 ++++
 9 files changed, 404 insertions(+), 1 deletion(-)

-- 
2.29.0.rc1.297.gfa9743e501-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

