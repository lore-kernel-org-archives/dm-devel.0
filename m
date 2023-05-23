Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B86C7EE33
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878425;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=THAFzKRerVBcsgNIRT6zgw/YWVJNsJB4Zmwf9H+RkV8=;
	b=biU+/BeJC3VEFGdNY4ukQ/ioLQU0MVD5qSSSkEDQ+pGxxTnfTXYlSTLp9uzZpL49qXz/OZ
	9tcIISVNGySgMSHePDINEYB7FcX38+DhT2dSBCaSY2O3rf8ttS9cBpe3mQ6a5WuM56Pmo/
	1KM81NH64U84ZjKj/nCNZZRl6QvlIf0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-NczRRGYRNbSu1ufbGkRhZQ-1; Tue, 23 May 2023 17:47:00 -0400
X-MC-Unique: NczRRGYRNbSu1ufbGkRhZQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 255DF811E7C;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10F43401026;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00F1D1946A42;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EF2719465B3
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:46:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F54B492B0A; Tue, 23 May 2023 21:46:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 77695492B0B
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A46B858F19
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:56 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-CmgWTdIXPIO9E8zD4jfJpg-1; Tue, 23 May 2023 17:46:55 -0400
X-MC-Unique: CmgWTdIXPIO9E8zD4jfJpg-1
Received: by mail-qv1-f71.google.com with SMTP id
 6a1803df08f44-62115d818ecso2157636d6.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878414; x=1687470414;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Hg/zaQe2dWvWWu17zwru47O61a0bYijZrhPqKVs23Ik=;
 b=GBJXKkya/5KEQ+ZFRZhooxVwsL8L4YxMlIxMPrdJdCl4vqJPCHiz75fVKMejpNtjzI
 YOxXwgcwg8+RlqVF+2n0yz6J8rY12IRyQhzHjFm1YYJnhGXtKeGyX6G4UYVxHHNBNwtG
 XFUwPj0QUEdxGVvN8gYxJezMHJw21sczq+/JgF4Ql3rR5W7TdWVYQKpB5tFjqYoRMml7
 EdhQjIb1oKRArctPLDNv050nT3rwysExYMyxOBORXRbnFBR/JYFjVzsF6Qoy/JozqPxJ
 rC03N1gCGEyVRbtBtK0U6e3e+/EuPo9vYn0JiJqle9t3fN61sCiO8sVOfF/7cosJVpMo
 5NDQ==
X-Gm-Message-State: AC+VfDzTY/svFjdvVQrC3e2Vk22jG95r7dKhqfKKxhrvxVtJdQSSJlTP
 TykHHCCN5OeeYv/IIeyUfI+zlNldqOidSmMeo08dmKRl/4xZSQatnSaG/umQHQzvPPgyCCvJO7W
 lo3sel2Ag9fdGVTSqSEfsIsnwkK1koTXjbDzFCefajgQC937iz7C1gghq0evKJPF4Ttfz+xuu
X-Received: by 2002:ae9:e8d5:0:b0:75b:23a1:3631 with SMTP id
 a204-20020ae9e8d5000000b0075b23a13631mr5071149qkg.66.1684878414696; 
 Tue, 23 May 2023 14:46:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ozzKH72v9R1bpoUGZsA0EiGmHkXmMCsqtMN/GguQIaO0RopbV2921RKgsM0ApwdxyDS1rEQ==
X-Received: by 2002:ae9:e8d5:0:b0:75b:23a1:3631 with SMTP id
 a204-20020ae9e8d5000000b0075b23a13631mr5071138qkg.66.1684878414461; 
 Tue, 23 May 2023 14:46:54 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 f25-20020a05620a15b900b0075b196ae392sm1489722qkk.104.2023.05.23.14.46.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:46:54 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:39 -0400
Message-Id: <20230523214539.226387-40-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 39/39] Enable configuration and building of
 dm-vdo.
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
Cc: vdo-devel@redhat.com, "J. corwin Coburn" <corwin@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds dm-vdo to the drivers/md Kconfig and Makefile.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/Kconfig  | 16 ++++++++++++++++
 drivers/md/Makefile |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b0a22e99bad..9fa9dec1029 100644
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
index 84291e38dca..47444b393ab 100644
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
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

