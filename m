Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33AEC7EE2D
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 05:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685684381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jJr0BKhJD7NKurgXBm95SmDzb0kHkswOk8A9Y+AkY0w=;
	b=F7Dl0gbm0pA5qyiXJrfXAQT88YO2TKJh63YGJ50KMjXYc9e2EKyLfcwwGI3SMihOJtqa3H
	q9NeFdspgxuToejCJGzrEn1RfONrvyvG6BAsP5UbfUlh2uf9I7DfvrvJO+guEI5mhZNr8s
	CEuLLkr68cwvLLHOjglEkgOKlElkLUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-VGSe6qd6Pg-VpWRpNogt2A-1; Fri, 02 Jun 2023 01:39:40 -0400
X-MC-Unique: VGSe6qd6Pg-VpWRpNogt2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED3B1185A797;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 765C72166B27;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 426A01946A41;
	Fri,  2 Jun 2023 05:39:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 284C419451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:25:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 09194140E964; Thu,  1 Jun 2023 07:25:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01402140E962
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0B302800C20
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:02 +0000 (UTC)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-fP13d_1wOJqrfZixyKgLaA-1; Thu, 01 Jun 2023 03:25:01 -0400
X-MC-Unique: fP13d_1wOJqrfZixyKgLaA-1
Received: by mail-pf1-f198.google.com with SMTP id
 d2e1a72fcca58-64d24df4852so254243b3a.2
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 00:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685604300; x=1688196300;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BSdEOOvVOvBHgbxdtA0aSxX16fM93R7Xrib46N4HMRQ=;
 b=lfroMYhZr0nzil8qfMPjmyM49gEWF0zfmQZ1cMIYbbj1FjiW1umsMmQo9ZJmu9uV4K
 NyhgzX6bigmFkzwV9jZFP/9MRKq+0BRxFWkoBWALnIj6FPe2+F2zJBQ0HguUweSvWtis
 MAQMccNDYcQZGqcmChaz+msXTBzqdPbDnCXLeIR+cvTdx37t3Kfs28VzsTNIkOfV4TKP
 LBOWt+Hm+1YTKN1XEcgRNwj17mP6zRYCj5linakHVdZryTTDavjhCxBdDmW74ntGYhXe
 hMGXncmhcoJnCIkA9ZCtRR1drCqdfqgX7eLfCb7WCYfTIHmf695K4GfwUYpUNEfBy3q8
 nQsA==
X-Gm-Message-State: AC+VfDyq/hxHf/kviT9ddVkYH3MTjnFD3nT2CJx+QddGMYZLv6pjo2dd
 T06fJB4mBe41Eruy34RIMfWBmHhaec5sQcxUgns+m5xmdOSrJoNVVzq/26NDPWBuxoB6+YydwrI
 eiQANJcYpeMo+FA0=
X-Received: by 2002:a05:6a00:1a51:b0:63b:5496:7af5 with SMTP id
 h17-20020a056a001a5100b0063b54967af5mr7757655pfv.1.1685604300243; 
 Thu, 01 Jun 2023 00:25:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dvgVyrzGCsjuOATzcCkMb2NCswn1qLkQ0iET/24u8jgUcZoCb8ABgYZHVIPusFMkwCuiucw==
X-Received: by 2002:a05:6a00:1a51:b0:63b:5496:7af5 with SMTP id
 h17-20020a056a001a5100b0063b54967af5mr7757634pfv.1.1685604299873; 
 Thu, 01 Jun 2023 00:24:59 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 f18-20020aa78b12000000b0064d27a28451sm4433388pfd.100.2023.06.01.00.24.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 00:24:59 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Thu,  1 Jun 2023 15:24:42 +0800
Message-Id: <20230601072444.2033855-4-coxu@redhat.com>
In-Reply-To: <20230601072444.2033855-1-coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 02 Jun 2023 05:39:36 +0000
Subject: [dm-devel] [PATCH 3/5] crash_dump: retrieve LUKS volume key in
 kdump kernel
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
Cc: Baoquan He <bhe@redhat.com>, x86@kernel.org, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@intel.com>, Kairui Song <ryncsn@gmail.com>,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Crash kernel will retrieve the LUKS volume key based on the
luksvolumekey command line parameter. When libcryptsetup writes the key
description to /sys/kernel/crash_luks_volume_key, crash kernel will
create a thread keyring and add a logon key.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/crash_dump.h |   2 +
 kernel/crash_dump_luks.c   | 116 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 0f3a656293b0..bc848e058c64 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -15,6 +15,8 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
+extern unsigned long long luks_volume_key_addr;
+
 #ifdef CONFIG_CRASH_DUMP
 extern int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size);
 extern void elfcorehdr_free(unsigned long long addr);
diff --git a/kernel/crash_dump_luks.c b/kernel/crash_dump_luks.c
index 2d88b77a93f8..63718db318c3 100644
--- a/kernel/crash_dump_luks.c
+++ b/kernel/crash_dump_luks.c
@@ -1,7 +1,82 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/key.h>
+#include <linux/keyctl.h>
 #include <keys/user-type.h>
 #include <linux/crash_dump.h>
 
+unsigned long long luks_volume_key_addr;
+EXPORT_SYMBOL_GPL(luks_volume_key_addr);
+
+static int __init setup_luksvolumekey(char *arg)
+{
+	char *end;
+
+	if (!arg)
+		return -EINVAL;
+	luks_volume_key_addr = memparse(arg, &end);
+	if (end > arg)
+		return 0;
+
+	luks_volume_key_addr = 0;
+	return -EINVAL;
+}
+
+early_param("luksvolumekey", setup_luksvolumekey);
+
+/*
+ * Architectures may override this function to read LUKS master key
+ */
+ssize_t __weak luks_key_read(char *buf, size_t count, u64 *ppos)
+{
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	return read_from_oldmem(&iter, count, ppos, false);
+}
+
+static int retrive_kdump_luks_volume_key(u8 *buffer, unsigned int *sz)
+{
+	unsigned int key_size;
+	size_t lukskeybuf_sz;
+	unsigned int *size_ptr;
+	char *lukskeybuf;
+	u64 addr;
+	int r;
+
+	if (luks_volume_key_addr == 0) {
+		pr_debug("LUKS master key memory address inaccessible");
+		return -EINVAL;
+	}
+
+	addr = luks_volume_key_addr;
+
+	/* Read LUKS master key size */
+	r = luks_key_read((char *)&key_size, sizeof(unsigned int), &addr);
+
+	if (r < 0)
+		return r;
+
+	pr_debug("Retrieve LUKS master key: size=%u\n", key_size);
+	/* Read in LUKS maste rkey */
+	lukskeybuf_sz = sizeof(unsigned int) + key_size * sizeof(u8);
+	lukskeybuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					      get_order(lukskeybuf_sz));
+	if (!lukskeybuf)
+		return -ENOMEM;
+
+	addr = luks_volume_key_addr;
+	r = luks_key_read((char *)lukskeybuf, lukskeybuf_sz, &addr);
+
+	if (r < 0)
+		return r;
+	size_ptr = (unsigned int *)lukskeybuf;
+	memcpy(buffer, size_ptr + 1, key_size * sizeof(u8));
+	pr_debug("Retrieve LUKS master key (size=%u): %48ph...\n", key_size, buffer);
+	*sz = key_size;
+	return 0;
+}
+
 static u8 *luks_volume_key;
 static unsigned int luks_volume_key_size;
 
@@ -23,12 +98,48 @@ static DECLARE_DELAYED_WORK(wipe_luks_volume_key_work, _wipe_luks_volume_key);
 
 static unsigned __read_mostly wipe_key_delay = 3600; /* 1 hour */
 
+static int retore_luks_volume_key_to_thread_keyring(const char *key_desc)
+{
+	key_ref_t keyring_ref, key_ref;
+	int ret;
+
+	/* find the target keyring (which must be writable) */
+	keyring_ref = lookup_user_key(KEY_SPEC_THREAD_KEYRING, 0x01, KEY_NEED_WRITE);
+	if (IS_ERR(keyring_ref)) {
+		pr_alert("Failed to get keyring");
+		return PTR_ERR(keyring_ref);
+	}
+
+	luks_volume_key = kmalloc(128, GFP_KERNEL);
+	ret = retrive_kdump_luks_volume_key(luks_volume_key, &luks_volume_key_size);
+	if (ret) {
+		kfree(luks_volume_key);
+		return ret;
+	}
+
+	/* create or update the requested key and add it to the target keyring */
+	key_ref = key_create_or_update(keyring_ref, "logon", key_desc,
+				       luks_volume_key, luks_volume_key_size,
+				       KEY_PERM_UNDEF, KEY_ALLOC_IN_QUOTA);
+
+	if (!IS_ERR(key_ref)) {
+		ret = key_ref_to_ptr(key_ref)->serial;
+		key_ref_put(key_ref);
+		pr_alert("Success adding key %s", key_desc);
+	} else {
+		ret = PTR_ERR(key_ref);
+		pr_alert("Error when adding key");
+	}
+
+	key_ref_put(keyring_ref);
+	return ret;
+}
+
 static int crash_save_temp_luks_volume_key(const char *key_desc, size_t count)
 {
 	const struct user_key_payload *ukp;
 	struct key *key;
 
-
 	if (luks_volume_key) {
 		memset(luks_volume_key, 0, luks_volume_key_size * sizeof(u8));
 		kfree(luks_volume_key);
@@ -61,7 +172,8 @@ int crash_sysfs_luks_volume_key_write(const char *key_desc, size_t count)
 {
 	if (!is_kdump_kernel())
 		return crash_save_temp_luks_volume_key(key_desc, count);
-	return -EINVAL;
+	else
+		return retore_luks_volume_key_to_thread_keyring(key_desc);
 }
 EXPORT_SYMBOL(crash_sysfs_luks_volume_key_write);
 
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

