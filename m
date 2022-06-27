Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BCBC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 27 Jun 2022 15:35:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-lbzS7Gk0NjuKry-1Js3ysg-1; Mon, 27 Jun 2022 11:35:40 -0400
X-MC-Unique: lbzS7Gk0NjuKry-1Js3ysg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8E2A803524;
	Mon, 27 Jun 2022 15:35:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EC4C400F8FD;
	Mon, 27 Jun 2022 15:35:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F33C51947040;
	Mon, 27 Jun 2022 15:35:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB6F319466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 15:35:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC75C2026D07; Mon, 27 Jun 2022 15:35:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7DE32026D64
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 15:35:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B30F185A79C
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 15:35:35 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-V_4mYhlKPk-xv-CrW_07qw-1; Mon, 27 Jun 2022 11:35:33 -0400
X-MC-Unique: V_4mYhlKPk-xv-CrW_07qw-1
Received: by mail-pj1-f49.google.com with SMTP id
 g16-20020a17090a7d1000b001ea9f820449so12831369pjl.5
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 08:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=vmKgQCYz9ljvAqKv2sf4fN2XVnda5eEsA6eDXq1Jn9A=;
 b=xK9eGtsA0StHvwUp3p/yYGI4eHfDWdNrkwDmiHDYzEmThNakVQSVVU3jTLX92jXq4c
 7du2eMjhiSvRW6PjRr++93J0k+rbB1sTCGwcf6fosiSddtMAIjiOKY4wgMwco1i6V7JY
 yWcj6O0zJ2X2Xjh8AiPvEh7lYMZi70IIjb5hS+/JKTCqYxPBO4RA+R8a5eSb4+92pAB8
 Kn45LK1sk1FZxi69TXXte/sj4ktdAXNp2fIz2vqOaV5Voo/S7WAZHz+eBCm/SbqjbO6V
 DyBbPqKbbb3qyjyN52j+OjdRGE7jlk7HSChx2ROmKvlfmwXxlhevE0zXdbJQyIS8jC91
 Md2Q==
X-Gm-Message-State: AJIora//C8HyCSgTHWgfYzfcz52WLUIQ12T6XsmQB41i42O3K3ro7q1r
 X3zxnbjr3LQZRz89NpKB+iO9Bw==
X-Google-Smtp-Source: AGRyM1vIdp0c04oi73uLU1/CuVw4BfaF9QRUrOsc5qutr3rZUo0Fobl/R5V8WqKskPFzunuzPjhv3g==
X-Received: by 2002:a17:902:6b42:b0:15d:3603:6873 with SMTP id
 g2-20020a1709026b4200b0015d36036873mr1083plt.30.1656344132540; 
 Mon, 27 Jun 2022 08:35:32 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:f31c:687c:3a61:62c5])
 by smtp.gmail.com with UTF8SMTPSA id
 jh2-20020a170903328200b00161478027f5sm7363141plb.150.2022.06.27.08.35.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 27 Jun 2022 08:35:32 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 27 Jun 2022 08:35:23 -0700
Message-Id: <20220627153526.3750341-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v7 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As of now LoadPin restricts loading of kernel files to a single pinned
filesystem, typically the rootfs. This works for many systems, however it
can result in a bloated rootfs (and OTA updates) on platforms where
multiple boards with different hardware configurations use the same rootfs
image. Especially when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a given board.
Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
at runtime. As an example a DLC package could contain firmware for a
peripheral that is not present on all boards. DLCs use dm-verity [2] to
verify the integrity of the DLC content.

This series extends LoadPin to allow loading of kernel files from trusted
dm-verity devices. LoadPin maintains a list of root digests of verity
devices it considers trusted. Userspace can populate this list through an
ioctl on the new LoadPin securityfs entry 'dm-verity'. The ioctl receives
a file descriptor of a file with verity digests as parameter. Verity reads
the digests from this file after confirming that the file is located on the
pinned root. The digest file must contain one digest per line. The list of
trusted digests can only be set up once, which is typically done at boot
time.

When a kernel file is read LoadPin first checks (as usual) whether the file
is located on the pinned root, if so the file can be loaded. Otherwise, if
the verity extension is enabled, LoadPin determines whether the file is
located on a verity backed device and whether the root digest of that
device is in the list of trusted digests. The file can be loaded if the
verity device has a trusted root digest.

[1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
[2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html

Changes in v7:
- rebased on v5.19-rc4

Changes in v6:
- added missing dependency on CONFIG_SECURITY_LOADPIN to
  CONFIG_SECURITY_LOADPIN_VERITY
- s/loadpin_trusted_verity_root_digests/dm_verity_loadpin_trusted_root_digests/
- s/trusted_root_digest/dm_verity_loadpin_trusted_root_digest/
- removed unnecessary symbol exports

Changes in v5:
- changed dm_verity_loadpin_is_sb_trusted() to
  dm_verity_loadpin_is_bdev_trusted()
- deleted bad semicolon in declaration of stub for
  dm_verity_loadpin_is_bdev_trusted()
- bumped verity version number to 1.8.1
- added 'Acked-by' tags from Kees

Changes in v4:
- a trusted verity device must have a single target of
  type 'verity'
- changed struct trusted_root_digest to have an unsized
  u8 array instead of a pointer
- use shared list of verity digests, deleted
  dm_verity_loadpin_set_trusted_root_digests()
- use newline as separator in digest file instead of comma
- after reading an invalid/corrupt digest file deny further attempts
  of setting up the list of digests
- added comment to read_trusted_verity_root_digests() explaining that
  an invalid digests entry invalidates the entire list of digests
- minor refactoring of verity related code in LoadPin

Changes in v3:
- added securityfs for LoadPin (currently only populated when
  CONFIG_SECURITY_LOADPIN_VERITY=y)
- added uapi include for LoadPin
- changed the interface for setting up the list of trusted
  digests from sysctl to ioctl on securityfs entry
- added stub for loadpin_is_fs_trusted() to be used
  CONFIG_SECURITY_LOADPIN_VERITY is not select
- depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
- updated Kconfig help
- minor changes in read_trusted_verity_root_digests()
- updated commit message

Changes in v2:
- userspace now passes the path of the file with the verity digests
  via systcl, instead of the digests themselves
- renamed sysctl file to 'trusted_verity_root_digests_path'
- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
- updated Kconfig doc
- updated commit message

Matthias Kaehlcke (3):
  dm: Add verity helpers for LoadPin
  LoadPin: Enable loading from trusted dm-verity devices
  dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional
    compilation

 drivers/md/Makefile               |   1 +
 drivers/md/dm-verity-loadpin.c    |  74 +++++++++++++
 drivers/md/dm-verity-target.c     |  33 +++++-
 drivers/md/dm-verity.h            |   4 +
 include/linux/dm-verity-loadpin.h |  27 +++++
 include/uapi/linux/loadpin.h      |  22 ++++
 security/loadpin/Kconfig          |  16 +++
 security/loadpin/loadpin.c        | 167 +++++++++++++++++++++++++++++-
 8 files changed, 342 insertions(+), 2 deletions(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h
 create mode 100644 include/uapi/linux/loadpin.h

-- 
2.37.0.rc0.161.g10f37bed90-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

