Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E576FC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 17:04:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-6jgWT98eMz-nKL4PafOtHA-1; Mon, 28 Mar 2022 13:04:17 -0400
X-MC-Unique: 6jgWT98eMz-nKL4PafOtHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08153805F65;
	Mon, 28 Mar 2022 17:04:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5D1F7774;
	Mon, 28 Mar 2022 17:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 752C51949762;
	Mon, 28 Mar 2022 17:04:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C283E1947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 17:04:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A800B1410F3B; Mon, 28 Mar 2022 17:04:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A443F1410DD5
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 17:04:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73A943C23FA1
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 17:04:11 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-ORKh-qp5MeyZEwVq5zkOBA-1; Mon, 28 Mar 2022 13:04:09 -0400
X-MC-Unique: ORKh-qp5MeyZEwVq5zkOBA-1
Received: by mail-wr1-f49.google.com with SMTP id h4so21286683wrc.13;
 Mon, 28 Mar 2022 10:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=bPvKGLXS5czePB8EE7TL2P1ov1sxSxrETTLvxMbF3xs=;
 b=6PxFA8/tAnbof2pZrh+eRlTPGSZcMmelTIAZBN8OI6gFdktYFEWsvOrlUxiCDO7mNt
 ynwhoG5h/+75RGUUnA9CLd3z+fYfUiUNYBiHcDVVsn4nFkoB15QX/tgLsk4ZZP6SjhmV
 pcw1+aRd4urUsdTe8hdIRE4lvymjU4gbfJ2DDoC9w6ozo1zSeTnsWblGMLkSCoyVnpC4
 k7kYgYsXdzavVNZzK0vZY/7O0frYaY8JmAHmc5FLoq5Z/NDbCOZa78Midf1wiwlNFz+i
 GdNZ9Id8vzr0aVRCVMGRpOdF6tfEqIYE6lv92Yk7xoeRf5/g1z+0y7ZwXgbK2S8VIRLa
 0Urw==
X-Gm-Message-State: AOAM531X4uZFT0RlpVaeHpfBgWXcfJtAP2KuUWC39J0w2shQWVzQ8y/a
 3yopQYRtKIIZcGNS7uASr3dvz+qklA==
X-Google-Smtp-Source: ABdhPJzoPsZaja5xVhL7dvkX9FmWRzFkGUoUIQxaG3cmdFKefDoXJ5YxWW1Ue9ce4a9K0TjVAbAy1w==
X-Received: by 2002:adf:df84:0:b0:205:912d:8fee with SMTP id
 z4-20020adfdf84000000b00205912d8feemr24602270wrl.335.1648487047055; 
 Mon, 28 Mar 2022 10:04:07 -0700 (PDT)
Received: from localhost (136.red-176-87-3.dynamicip.rima-tde.net.
 [176.87.3.136]) by smtp.gmail.com with ESMTPSA id
 i74-20020adf90d0000000b0020373ba7beesm18755321wri.0.2022.03.28.10.04.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 28 Mar 2022 10:04:06 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Mon, 28 Mar 2022 19:04:04 +0200
Message-Id: <20220328170404.8565-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH] multipath-tools: add basic info on how to use
 multipath-tools with NVMe devices
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.nvme | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 README.nvme

diff --git a/README.nvme b/README.nvme
new file mode 100644
index 00000000..70bf6b0d
--- /dev/null
+++ b/README.nvme
@@ -0,0 +1,12 @@
+To use Device Mapper/multipath-tools with NVMe devices,
+if the Native NVMe Multipath subsystem is enabled
+( "Y" in /sys/module/nvme_core/parameters/multipath ),
+it has to be disabled:
+
+echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf
+regenerate the initramfs (dracut -f or update-initramfs) and reboot.
+
+Check that it is disabled(N) with:
+cat /sys/module/nvme_core/parameters/multipath
+or
+systool -m nvme_core -A multipath
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

