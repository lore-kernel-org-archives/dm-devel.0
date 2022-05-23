Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3A2C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 21:14:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-h8kaChtwPOOblpaCp4AtYg-1; Mon, 23 May 2022 17:14:12 -0400
X-MC-Unique: h8kaChtwPOOblpaCp4AtYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6D93C19023;
	Mon, 23 May 2022 21:14:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 898127AE4;
	Mon, 23 May 2022 21:14:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 391A01947B85;
	Mon, 23 May 2022 21:14:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 21E8E1947B83
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 21:14:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 156CC7ADE; Mon, 23 May 2022 21:14:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10E767AD8
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E98C2185A79C
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:06 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-wFKDb8wgMVSVbSt1D0GuDg-1; Mon, 23 May 2022 17:14:04 -0400
X-MC-Unique: wFKDb8wgMVSVbSt1D0GuDg-1
Received: by mail-pj1-f51.google.com with SMTP id
 o13-20020a17090a9f8d00b001df3fc52ea7so335981pjp.3
 for <dm-devel@redhat.com>; Mon, 23 May 2022 14:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=qPTyGkXNBh5K/gOO6jZInJgHMCEA96LD8k/0LUFStZ4=;
 b=MQDoQxXV4kLKeFHuRLm3Iwh1hrhUwuHdF49mKr+XyEM3kixGni0fUqqXJ2k3yITqDW
 0UXjMqUpMlTgCFT8Hof57QEN22gLj2Aa0byh2hffh7hZSn5Rje/KAv/xf50WkCqPqh+O
 7AUCvg1ChP5hTVKeyAvhs5iLnlSmH9e7u4bOEuygaA37s+Ta7hlY7boF6xyLnqbz26t+
 stLf3Nn1XExbvk5eRNv4YcRzYARMEn6/XTm/skygMnwRbQHS5UaEApaqEHflNunZjiDE
 8N5BmgyJcTiwdi2c4vWGBJO6NiCu4/KITzExq5OeGZG/Lv1dGmFY0nCMJKZ2EGicS4gt
 0yaw==
X-Gm-Message-State: AOAM532D7LV6htB1Z6xoPME5eBrmcENy+PJz59Ft6FnAq8IB0wMg2zwk
 wfZIh4OYJXdcrFlpSYhvrkmBbA==
X-Google-Smtp-Source: ABdhPJxuy1BlOdM7/6/pWUeJ4rY6QYNUiWdgdqvs5v1dBxBEoVPPJiiikm8Wc0ZrXEJ58Wa1GZauSA==
X-Received: by 2002:a17:90a:f3cf:b0:1e0:2abc:9387 with SMTP id
 ha15-20020a17090af3cf00b001e02abc9387mr940221pjb.39.1653340443350; 
 Mon, 23 May 2022 14:14:03 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:d9e2:8472:9ac:8532])
 by smtp.gmail.com with UTF8SMTPSA id
 i136-20020a62878e000000b0051849bc0c23sm7795894pfe.23.2022.05.23.14.14.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 23 May 2022 14:14:02 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 23 May 2022 14:13:57 -0700
Message-Id: <20220523211400.290537-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v6 0/3] LoadPin: Enable loading from trusted
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
2.36.1.124.g0e6072fb45-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

