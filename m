Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDFEC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bWllzaPauRMjFiuiZ/1rTgcqtxhXnE/Vuw1CfEeNJGY=;
	b=bNnYxTtLmrLr4F1PcMGUHpl2y/GXgitKvcZyqxZLbUkYJAn62JDL40gpIAuYJXfMeeGRpS
	5+A9kgo+6EEfe/oYCt1HM5EVgm5VqFJ6WEigTmu4PQbqdoiaK2AsbUeGF18CD3PxnJt/Kt
	5ELTuNeS1g6OP/KqIYSa8J4jsuVpfXY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-Qk_YKAJyPdGBXGtP6u2BlQ-1; Mon, 21 Mar 2022 02:54:54 -0400
X-MC-Unique: Qk_YKAJyPdGBXGtP6u2BlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36D061857F16;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12BC91121318;
	Mon, 21 Mar 2022 06:54:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DC3E1947BBD;
	Mon, 21 Mar 2022 06:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D5D41949763
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 10:34:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FE491454559; Fri, 18 Mar 2022 10:34:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BD0B1400E73
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33F8180B71C
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:35 +0000 (UTC)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-M_S-PCfZNSW3U1JyyqhLhw-1; Fri, 18 Mar 2022 06:34:34 -0400
X-MC-Unique: M_S-PCfZNSW3U1JyyqhLhw-1
Received: by mail-pl1-f199.google.com with SMTP id
 x6-20020a1709029a4600b0014efe26b04fso3921869plv.21
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 03:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=PODFzb3mjImlWQPxxoECM7lRSKqdrL/May27LmTIUmk=;
 b=Fxtkq7WlldDnczdUOvk+N2CyKIcuGR3wQLeymRgTPGGlcj4Qwc1CAg8wraYZgvvTAJ
 zV/+6f0Iths32e5SNzKQCldjhXdIKO9mmVNq+uvVeFSi5+8fnBTY6wOX4oEdolDqlBcB
 OSf4M8syCfzpW3NLDKxq4MebGgmdpz0vBfPzFMu+Nsq1crKwph0+cQVN75U5YsKsvOGg
 Wqb7GU4EGz7uWyW8I9cq23kDqNo60atPrR8i+gnO2MaqlUhogoxApqw+vhyHhCQJvBOR
 eeeL1blQafSQbyxdlpfps13Mxqy8L5Z5Nr8qaqfTRtvcEiT1x6NBV2r+SH6n452V+jck
 VjMQ==
X-Gm-Message-State: AOAM531ETDxHYbUEyhQKoQXoX2o3cy8Pjf5yDJOboLWCoM2QPyClDyLG
 8RAqsyOhAyjjTnr78u0lU/gNYCCRQeHv67Kb8V7Zuxr5fiDPbBo+YrB09FLgV9wDB8EiYmD1Fhm
 ayDp/Orn86JcfqKc=
X-Received: by 2002:a05:6a00:1152:b0:4be:ab79:fcfa with SMTP id
 b18-20020a056a00115200b004beab79fcfamr9598491pfm.3.1647599671393; 
 Fri, 18 Mar 2022 03:34:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVqCTYHmMvd/+g0VOR29gw2GmqZvnV0UPmluByeNafGkhNa+o3V1s2U3kyohRsqW5FHTDTeA==
X-Received: by 2002:a05:6a00:1152:b0:4be:ab79:fcfa with SMTP id
 b18-20020a056a00115200b004beab79fcfamr9598457pfm.3.1647599671120; 
 Fri, 18 Mar 2022 03:34:31 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 s20-20020a056a00179400b004f709998d13sm9657970pfg.10.2022.03.18.03.34.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 03:34:30 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri, 18 Mar 2022 18:34:20 +0800
Message-Id: <20220318103423.286410-2-coxu@redhat.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
Subject: [dm-devel] [RFC 1/4] kexec,
 dm-crypt: receive LUKS master key from dm-crypt and pass it to kdump
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
Cc: Mike Snitzer <snitzer@redhat.com>, Baoquan He <bhe@redhat.com>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After receiving the LUKS master key from driver/md/dm-crypt, kdump has 1
hour at maximum to ask kexec to pass the key before the key gets wiped by
kexec. And after kdump retrieves the key, the key will be wiped
immediately.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/md/dm-crypt.c |  5 +++-
 include/linux/kexec.h |  3 ++
 kernel/kexec_core.c   | 66 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d4ae31558826..41f9ca377312 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -41,6 +41,7 @@
 #include <keys/trusted-type.h>
 
 #include <linux/device-mapper.h>
+#include <linux/kexec.h>
 
 #include "dm-audit.h"
 
@@ -2388,6 +2389,8 @@ static int crypt_setkey(struct crypt_config *cc)
 	unsigned subkey_size;
 	int err = 0, i, r;
 
+	/* save master key to kexec */
+	kexec_save_luks_master_key(cc->key, cc->key_size);
 	/* Ignore extra keys (which are used for IV etc) */
 	subkey_size = crypt_subkey_size(cc);
 
@@ -3580,6 +3583,7 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv,
 			DMWARN("not suspended during key manipulation.");
 			return -EINVAL;
 		}
+
 		if (argc == 3 && !strcasecmp(argv[1], "set")) {
 			/* The key size may not be changed. */
 			key_size = get_key_size(&argv[2]);
@@ -3587,7 +3591,6 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv,
 				memset(argv[2], '0', strlen(argv[2]));
 				return -EINVAL;
 			}
-
 			ret = crypt_set_key(cc, argv[2]);
 			if (ret)
 				return ret;
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0c994ae37729..91507bc684e2 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -205,6 +205,9 @@ int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
+extern int kexec_pass_luks_master_key(void **addr, unsigned long *sz);
+extern int kexec_save_luks_master_key(u8 *key, unsigned int key_size);
+
 /* Alignment required for elf header segment */
 #define ELF_CORE_HEADER_ALIGN   4096
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 68480f731192..86df36b71443 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1218,3 +1218,69 @@ void __weak arch_kexec_protect_crashkres(void)
 
 void __weak arch_kexec_unprotect_crashkres(void)
 {}
+
+
+static u8 *luks_master_key;
+static unsigned int luks_master_key_size;
+
+void wipe_luks_master_key(void)
+{
+	if (luks_master_key) {
+		memset(luks_master_key, 0, luks_master_key_size * sizeof(u8));
+		kfree(luks_master_key);
+		luks_master_key = NULL;
+	}
+}
+
+static void _wipe_luks_master_key(struct work_struct *dummy)
+{
+	wipe_luks_master_key();
+}
+
+static DECLARE_DELAYED_WORK(wipe_luks_master_key_work, _wipe_luks_master_key);
+
+static unsigned __read_mostly wipe_key_delay = 3600; /* 1 hour */
+
+int kexec_save_luks_master_key(u8 *key, unsigned int key_size)
+{
+	if (luks_master_key) {
+		memset(luks_master_key, 0, luks_master_key_size * sizeof(u8));
+		kfree(luks_master_key);
+	}
+
+	luks_master_key = kmalloc(key_size * sizeof(u8), GFP_KERNEL);
+
+	if (!luks_master_key)
+		return -ENOMEM;
+	memcpy(luks_master_key, key, key_size * sizeof(u8));
+	luks_master_key_size = key_size;
+	pr_debug("LUKS master key (size=%u): %64ph\n", key_size, luks_master_key);
+	schedule_delayed_work(&wipe_luks_master_key_work,
+			      round_jiffies_relative(wipe_key_delay * HZ));
+	return 0;
+}
+EXPORT_SYMBOL(kexec_save_luks_master_key);
+
+int kexec_pass_luks_master_key(void **addr, unsigned long *sz)
+{
+	unsigned long luks_key_sz;
+	unsigned char *buf;
+	unsigned int *size_ptr;
+
+	if (!luks_master_key)
+		return -EINVAL;
+
+	luks_key_sz = sizeof(unsigned int) + luks_master_key_size * sizeof(u8);
+
+	buf = vzalloc(luks_key_sz);
+	if (!buf)
+		return -ENOMEM;
+
+	size_ptr = (unsigned int *)buf;
+	memcpy(size_ptr, &luks_master_key_size, sizeof(unsigned int));
+	memcpy(size_ptr + 1, luks_master_key, luks_master_key_size * sizeof(u8));
+	*addr = buf;
+	*sz = luks_key_sz;
+	wipe_luks_master_key();
+	return 0;
+}
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

