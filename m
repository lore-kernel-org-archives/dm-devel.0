Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B06CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:11:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-5insqXBxMN2tPpVIGbJFpw-1; Tue, 19 Apr 2022 02:10:35 -0400
X-MC-Unique: 5insqXBxMN2tPpVIGbJFpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 544E11C10473;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4021EC27EBC;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 33055193F6DE;
	Tue, 19 Apr 2022 06:10:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4BAF01947BBD
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:16:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D7F540F497D; Mon, 18 Apr 2022 21:16:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39A0140F4941
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2044F8001EA
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:07 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-nUbxWUZ0MmuE3QV_H2T8gQ-3; Mon, 18 Apr 2022 17:16:05 -0400
X-MC-Unique: nUbxWUZ0MmuE3QV_H2T8gQ-3
Received: by mail-pg1-f176.google.com with SMTP id q19so21105253pgm.6
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 14:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=/8XJRkQ+Ngj+SVndYkt5Kqwy78yKeKiW3fonsocHm3g=;
 b=nDyqKDJgUJrwywSl8zt0XevmvmHtAfRFGForcUNGC58SRPfmb6gQcKMWk+XswHsha9
 rvFw/NzsWVfsNBXv7AqF6COsBkYBc/pGa2Ii5UKWqXFbFonSoM4K4u1i7MKZ+mdFowrS
 dv40FJtclekEW/c11QCxff7cgmM7mjlUuumArn9Qmr8DZvn7zK8icF/L2WvsGxq+Smvk
 DAHcBlQJmpYoBuFsKmSJKN9hgFih30n2BF6NkPMME9FW6fjEs/ILUXAIfpEgPs0zqLDL
 Oxtowp6G/Z6G/luzfDYJVeUqC6EZ9i2E5WzXFEmsAotJDyvHQ17uNlCVUDlATrK3gwUD
 gPdA==
X-Gm-Message-State: AOAM532ZtODGVZ75zJGf/zLC2cvPzVK01XLzvSoZ2AN7KjluNfzCo3Ix
 Rxdc6csioE6E7h4HBHU9/C+Lcg==
X-Google-Smtp-Source: ABdhPJy4XB+bbS97AAyRfwYXg0SHO4S5mnpEPALFnmvLrX6gjHaVLEhGa0FV74GcCXM0EQkzZfmXGg==
X-Received: by 2002:a63:1543:0:b0:39d:9729:1992 with SMTP id
 3-20020a631543000000b0039d97291992mr11756352pgv.155.1650316565036; 
 Mon, 18 Apr 2022 14:16:05 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:6b32:a0a5:ec32:c287])
 by smtp.gmail.com with UTF8SMTPSA id
 y23-20020a056a00181700b0050839558f4bsm14438421pfa.40.2022.04.18.14.16.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 Apr 2022 14:16:04 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 18 Apr 2022 14:15:56 -0700
Message-Id: <20220418211559.3832724-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: [dm-devel] [PATCH 0/3] LoadPin: Enable loading from trusted
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
trusted verity devices to LoadPin. Userspace can use the
new systl file 'loadpin/trusted_verity_root_digests' to
provide LoadPin with a list of root digests from dm-verity
devices that LoadPin should consider as trusted. When a
kernel file is read LoadPin first checks (as usual) whether
the file is located on the pinned root, if so the file can
be loaded. Otherwise, if the verity extension is enabled,
LoadPin determines whether the file is located on a verity
backed device and whether the root digest of that device
is in the list of trusted digests. The file can be loaded
if the verity device has a trusted root digest.

The list of trusted root digests can only be written once
(typically at boot time), to limit the possiblity of
attackers setting up rogue verity devices and marking them
as trusted.

[1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
[2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html


Matthias Kaehlcke (3):
  dm: Add verity helpers for LoadPin
  LoadPin: Enable loading from trusted dm-verity devices
  dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional
    compilation

 drivers/md/Makefile               |   1 +
 drivers/md/dm-verity-loadpin.c    |  80 ++++++++++++++
 drivers/md/dm-verity-target.c     |  34 ++++++
 drivers/md/dm-verity.h            |   4 +
 include/linux/dm-verity-loadpin.h |  27 +++++
 security/loadpin/Kconfig          |  11 ++
 security/loadpin/loadpin.c        | 168 +++++++++++++++++++++++++++++-
 7 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h

-- 
2.36.0.rc0.470.gd361397f0d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

