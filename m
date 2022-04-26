Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63D4C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:20:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-Pfh89D6uNFCQjmXYm27r3Q-1; Wed, 27 Apr 2022 08:20:38 -0400
X-MC-Unique: Pfh89D6uNFCQjmXYm27r3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23EBC3839745;
	Wed, 27 Apr 2022 12:20:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5AE4404E4B5;
	Wed, 27 Apr 2022 12:20:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A8981947042;
	Wed, 27 Apr 2022 12:20:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9166A1947BBB
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 21:31:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AC34463EEB; Tue, 26 Apr 2022 21:31:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66BA2463EE5
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 21:31:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C82E1E17FEE
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 21:31:18 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-2lpHqY-HMQi-lkpvYZ7LFg-1; Tue, 26 Apr 2022 17:31:16 -0400
X-MC-Unique: 2lpHqY-HMQi-lkpvYZ7LFg-1
Received: by mail-pl1-f178.google.com with SMTP id d15so31381770pll.10
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 14:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NmMY7ZEC2LA8ubdNrSjDuhNzkyHfOdHj22q0EtJVAhk=;
 b=FrNARUSf/qj7tsbTGDSMiHOy+lLGSHE8P9ocFoY+7kZ+Q65M+qU0/eAL8/jAA8FHR2
 uULV6e1Rhu1dsVoM6GM3sxjjHRPPRy2+/HsqU9+SriFcUhdmbG+SPwvLiEaPBS2loXm1
 7R6muKBo8bfQDzPb0oKGavtYPgxIbxsgKrA4tClsOYTVewS4K4fnImOxjkpG/N3eowTg
 NaNRVhSgnvL2ajvW4rYFTH1q0ju+2g60KIIvy9Knmp541liqNkJ8mL5WMHeFHmY1AvJ5
 jlDLKDLyycPoCyQY1FW8AvfX8Ph084RJYap09ytgeuFiAkpBPSjaQCNMRRcy8HFiTeIR
 S23g==
X-Gm-Message-State: AOAM532/m0aFPZAYw4cowLTJ15QMFxMgOlefIwvvMLaS05tyztjTzZm9
 xcRB2W/QtlMJww2/jBFZ05YbPg==
X-Google-Smtp-Source: ABdhPJzp4X5v15GE3Zc7zJfgHgDSaqiSDbZ9++70lo/F1w6eUXoCvxD8/KcNhsSXYbz+c+W3/7EE0Q==
X-Received: by 2002:a17:90a:f3cb:b0:1d9:62d4:25db with SMTP id
 ha11-20020a17090af3cb00b001d962d425dbmr15694380pjb.222.1651008675551; 
 Tue, 26 Apr 2022 14:31:15 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:eb63:4211:eb5d:f6b])
 by smtp.gmail.com with UTF8SMTPSA id
 d5-20020a056a0024c500b004fae56b2921sm17137609pfv.167.2022.04.26.14.31.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 Apr 2022 14:31:15 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Tue, 26 Apr 2022 14:31:07 -0700
Message-Id: <20220426213110.3572568-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: [dm-devel] [PATCH v2 0/3] LoadPin: Enable loading from trusted
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As of now LoadPin restricts loading of kernel files to a single
pinned filesystem, typically the rootfs. This works for many
systems, however it can result in a bloated rootfs (and OTA
updates) on platforms where multiple boards with different
hardware configurations use the same rootfs image. Especially
when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a
given board. Chrome OS uses Downloadable Content (DLC) [1] to
deploy certain 'packages' at runtime. As an example a DLC
package could contain firmware for a peripheral that is not
present on all boards. DLCs use dm-verity [2] to verify the
integrity of the DLC content.

This series extends LoadPin to allow loading of kernel files
from trusted dm-verity devices. It adds the concept of
trusted verity devices to LoadPin. Userspace can use the new
systl file 'loadpin/trusted_verity_root_digests_path' to
provide LoadPin with the path of a file with a list of root
digests from dm-verity devices that LoadPin should consider
as trusted. This file must be located on the pinned root.

When a kernel file is read LoadPin first checks (as usual)
whether the file is located on the pinned root, if so the
file can be loaded. Otherwise, if the verity extension is
enabled, LoadPin determines whether the file is located
on a verity backed device and whether the root digest of
that device is in the list of trusted digests. The file
can be loaded if the verity device has a trusted root
digest.

The path of the file with the trusted root digests can
only be written once, which is typically done at boot time.

[1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
[2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html

(no changes since v1)

Matthias Kaehlcke (3):
  dm: Add verity helpers for LoadPin
  LoadPin: Enable loading from trusted dm-verity devices
  dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional
    compilation

 drivers/md/Makefile               |   1 +
 drivers/md/dm-verity-loadpin.c    |  80 ++++++++++++
 drivers/md/dm-verity-target.c     |  33 +++++
 drivers/md/dm-verity.h            |   4 +
 include/linux/dm-verity-loadpin.h |  27 ++++
 security/loadpin/Kconfig          |  16 +++
 security/loadpin/loadpin.c        | 200 +++++++++++++++++++++++++++++-
 7 files changed, 360 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

