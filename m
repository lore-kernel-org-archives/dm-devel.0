Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A892C7EE32
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AAeaccJXBbKtujMm+YQLItIKj91bDhg18YYXNSOxRb0=;
	b=hAuxG1/twPmtVkAEZk7fStVEjAbrXsj2sP8LSNARtpZbRwfxR2+jTQXD9y6RZhT1EpvqnC
	xVjoZNfevyLMwax4bB3iy+MX0voasuQhuKkmSNwF4UyKbebI3l8B3C9USGyO2h85j+EdpE
	jD8Wg/dj+/qRLhpXq82vDNeK5YM5nEo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-9t4AdpUgNnuYJZruePLOxg-1; Tue, 30 May 2023 16:54:45 -0400
X-MC-Unique: 9t4AdpUgNnuYJZruePLOxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7CF338294C5;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C60A7C154D1;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CD8F194E111;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB8CC1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB9CD40C6CCC; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C41CB40C6EC4
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4CDD3C13517
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-1nmPtkV3MxqPOSuoUmCNYQ-1; Tue, 30 May 2023 16:40:55 -0400
X-MC-Unique: 1nmPtkV3MxqPOSuoUmCNYQ-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.west.internal (Postfix) with ESMTP id E6A0D3200906;
 Tue, 30 May 2023 16:31:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Tue, 30 May 2023 16:31:34 -0400
X-ME-Sender: <xms:JV12ZKw_sleDe0CYhkOy1rfxDsKjpyELd-fxjymHbgcgq5lekwsKZA>
 <xme:JV12ZGTAn57_8e1GFIsXL0ysKh0FpixwJKQ-TddPSbdxYp9ycPOiTVwaNOrltt2ad
 ug8Bk31vxxSZPs>
X-ME-Received: <xmr:JV12ZMUabxwRmIasWNcUfFJi1r8ayOF9Gz99yU6V6s-nhGY0G9ciErqgnlwdmTNxI5uZ2MoKV6c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffogggtgfesthekredtredtjeenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhephfeggfeiiedtieejgedutdekgfet
 geehheegteekvefhfefgudehtdevleegueegnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:JV12ZAjQ2rV9YCzr3z2bw2d41_MyNZJp_kvJGEi-trj6PoDKHYaXqQ>
 <xmx:JV12ZMCHtfgQyZp2PZhX45i91mJDIhD_ys-ao3poTncETHRblZjImQ>
 <xmx:JV12ZBLpJyOl-upuH58Tw1NYpbK7gxAD5Bx9jCgXSTOlNIObWkK6QA>
 <xmx:JV12ZKAryiWCZk5crUODpJpFTwj0sB-WzC-8b4F9y9v0UR85ql4CiA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:31:32 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:00 -0400
Message-Id: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 00/16] Diskseq support in loop, device-mapper,
 and blkback
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This work aims to allow userspace to create and destroy block devices
in a race-free way, and to allow them to be exposed to other Xen VMs via
blkback without races.

Changes since v1:

- Several device-mapper fixes added.
- The diskseq is now a separate Xenstore node, rather than being part of
  physical-device.
- Potentially backwards-incompatible changes to device-mapper now
  require userspace opt-in.
- The code has been tested: I have a block script written in C that uses
  these changes to successfully boot a Xen VM.
- The core block layer is almost completely untouched.  Instead of
  exposing a block device inode directly to userspace, device-mapper
  ioctls that create a block device now return that device's diskseq.
  Userspace can then use that diskseq to safely open the device.
  Furthermore, ioctls that operate on an existing device-mapper device
  now accept a diskseq parameter, which can be used to prevent races.

There are a few changes that make device-mapper's table validation
stricter.  Two of them are clear-cut fixes for memory safety bugs: one
prevents a misaligned pointer dereference in the kernel, and the other
prevents pointer arithmetic overflow that could cause the kernel to
dereference a userspace pointer, especially on 32-bit systems.  One
fixes a double-fetch bug that happens to be harmless right now, but
would make distribution backports of subsequent patches unsafe.  The
remaining fixes prevent totally nonsensical tables from being accepted.
This includes parameter strings that overlap the subsequent target spec,
and target specs that overlap the 'struct dm_ioctl' or each other.  I
doubt there is any userspace extant that generates such tables.

Finally, one patch forbids device-mapper devices to be named ".", "..",
or "control".  Since device-mapper devices are often accessed via
/dev/mapper/NAME, such names would likely greatly confuse userspace.  I
consider this to be an extension of the existing check that prohibits
device mapper names or UUIDs from containing '/'.

Demi Marie Obenour (16):
  device-mapper: Check that target specs are sufficiently aligned
  device-mapper: Avoid pointer arithmetic overflow
  device-mapper: do not allow targets to overlap 'struct dm_ioctl'
  device-mapper: Better error message for too-short target spec
  device-mapper: Target parameters must not overlap next target spec
  device-mapper: Avoid double-fetch of version
  device-mapper: Allow userspace to opt-in to strict parameter checks
  device-mapper: Allow userspace to provide expected diskseq
  device-mapper: Allow userspace to suppress uevent generation
  device-mapper: Refuse to create device named "control"
  device-mapper: "." and ".." are not valid symlink names
  device-mapper: inform caller about already-existing device
  xen-blkback: Implement diskseq checks
  block, loop: Increment diskseq when releasing a loop device
  xen-blkback: Minor cleanups
  xen-blkback: Inform userspace that device has been opened

 block/genhd.c                       |   1 +
 drivers/block/loop.c                |   6 +
 drivers/block/xen-blkback/blkback.c |   8 +-
 drivers/block/xen-blkback/xenbus.c  | 147 ++++++++--
 drivers/md/dm-core.h                |   2 +
 drivers/md/dm-ioctl.c               | 432 ++++++++++++++++++++++------
 drivers/md/dm.c                     |   5 +-
 include/linux/device-mapper.h       |   2 +-
 include/uapi/linux/dm-ioctl.h       |  67 ++++-
 9 files changed, 551 insertions(+), 119 deletions(-)

-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

