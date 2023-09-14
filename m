Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD911EEAA66
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719190;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rZ6BPwuZNb/28GpmK2iPTvlHUvrzLMjVDDBYrVDEckE=;
	b=Yk3GUicBTQLawbMGSmV5OkcQe2ZsTMjYCU8ikOiHuDhDEL+znYNhiqw+HW3RUI11PHJo5d
	dEvaKEGaeWX2RCjEnGvs4vIMe1qYJSFcJ+TsA3VkZ4vCxjTMaVJPohHSrNJAMT1/jtTqQ1
	mK/aB9LHdrpZqXBnoc706L/pBlx4V7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-686-q-TUgV4aOreKu2S2PCgjnA-1; Thu, 14 Sep 2023 15:19:47 -0400
X-MC-Unique: q-TUgV4aOreKu2S2PCgjnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E245481D7A7;
	Thu, 14 Sep 2023 19:19:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B731128AC;
	Thu, 14 Sep 2023 19:19:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9466C19452EF;
	Thu, 14 Sep 2023 19:18:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B43D19451F4
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:18:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E96C421B2414; Thu, 14 Sep 2023 19:17:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1EC621B2413
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2116185A78E
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:57 +0000 (UTC)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
 [209.85.210.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-YrRnJL-OPROBT40li3MK0Q-1; Thu, 14 Sep 2023 15:17:56 -0400
X-MC-Unique: YrRnJL-OPROBT40li3MK0Q-1
Received: by mail-ot1-f54.google.com with SMTP id
 46e09a7af769-6c0d6fef60cso751995a34.1
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719075; x=1695323875;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tnEGgRA+cTyW+H/NWndh0ud7Va2YMirfEMgHkOBzJVs=;
 b=S+7QVWJntUzkwHYOCHYhmfXujXd0Cw1QfIJATsoDdgW5P4sPohoU7k+R146zE44/py
 My5ZoYmlUcNUT/BfUHWHbD1P23vl9+B36L45O7XeRmHtr653eP+o6LgMLUrAtf1nOCc/
 0EfRs7+CN9nuVsFovIXHEaaPJPTcBCntJ4lm4ubkz0oGb/d/sWjWi86IZ/seunNxLno/
 ZIrD5TrXnba5ulvd80vgdpz1B/GUtqyqPLd2cUSFAZ1pEIE/UU0UBwsX9m44a/lnh/mB
 rqcQbj12/kheZ+962T1LtBNsAOU87+x3ceLhAOWC6hA6qLAq+4DatuaC30XrNRhKRBVy
 VvpQ==
X-Gm-Message-State: AOJu0YyuFDmXaOj6y+XeY3a7CKPc0LDlYpX+y7LtWW6BLmNZSzu4VAaQ
 hbL0uB5UWGjvXHVCnIIqPWi0SPrDxrECA4/CE1zZApwKancLaA9UD47NRKcfTa3oOBT5sjoyEbK
 YXmV6fLZp8xl6wqoJDrmLHWaDBF0kCRqW6rfR96d12ZiyidglUtscEvLYbaJB1p2+utyx9wwV
X-Google-Smtp-Source: AGHT+IF+rvzBYNXsR18wRoIyYxIeGkZYtnovxaAAVKifplaCuCSVG3H5+D5ONaoGSGpLhahckE8mjw==
X-Received: by 2002:a05:6358:9306:b0:139:d24c:ed28 with SMTP id
 x6-20020a056358930600b00139d24ced28mr8051874rwa.12.1694719074951; 
 Thu, 14 Sep 2023 12:17:54 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 n14-20020a0ce48e000000b00655e52b0eb9sm666051qvl.29.2023.09.14.12.17.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:54 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:35 -0400
Message-Id: <20230914191635.39805-40-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v3 39/39] dm vdo: enable configuration and
 building of dm-vdo
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
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

The dm-vdo target is not supported for 32-bit configurations. A vdo
target typically requires 1 to 1.5 GB of memory at any given time,
which is likely a large fraction of the addressable memory of a 32-bit
system. At the same time, the amount of addressable storage attached
to a 32-bit system may not be large enough for deduplication to
provide much benefit. Thus 32-bit platforms are deemed unlikely to be
good candidates for benefiting from a vdo target, and thus dm-vdo is
targeted only at 64-bit platforms.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: John Wiele <jwiele@redhat.com>
Signed-off-by: John Wiele <jwiele@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/Kconfig  | 16 ++++++++++++++++
 drivers/md/Makefile |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b0a22e99bade..9fa9dec10292 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -521,6 +521,22 @@ config DM_FLAKEY
 	help
 	 A target that intermittently fails I/O for debugging purposes.
 
+config DM_VDO
+	tristate "VDO: deduplication and compression target"
+	depends on 64BIT
+	depends on BLK_DEV_DM
+	select DM_BUFIO
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This device mapper target presents a block device with
+	  deduplication, compression and thin-provisioning.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-vdo.
+
+	  If unsure, say N.
+
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 84291e38dca8..47444b393abb 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -25,6 +25,7 @@ dm-ebs-y	+= dm-ebs-target.o
 dm-era-y	+= dm-era-target.o
 dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
+dm-vdo-y	+= dm-vdo-target.o $(patsubst drivers/md/dm-vdo/%.c,dm-vdo/%.o,$(wildcard $(src)/dm-vdo/*.c))
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
 md-mod-y	+= md.o md-bitmap.o
@@ -74,6 +75,7 @@ obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)		+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING) += dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
+obj-$(CONFIG_DM_VDO)            += dm-vdo.o
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_EBS)		+= dm-ebs.o
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

