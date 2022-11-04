Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE98C4167D
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TbUcssmFtrJsI2ftrR0QuGTY91njWp8EekhZOnzvk4k=;
	b=Yib/1ZCSYMMnT7mLbhb8rOYAQojRj2jP1Y5L7DOF5Nj1mLadXSi6m/JjT1pN/CAtPudXbX
	I0s4HX70cjjcbKtkXEznFobYFX7bVf0cj6sf3rpsiIXos1g10OL9AyV8StNTuwMWyiK1lG
	A544XX1QbKyj76FPjwiKj/pARfAYsAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-VBJpUHHhMe2S2tk8JKy05A-1; Mon, 07 Nov 2022 03:40:13 -0500
X-MC-Unique: VBJpUHHhMe2S2tk8JKy05A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B568518ABF83;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9F6042166B34;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA27A1946A67;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90E5C1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85DBF49BB9A; Fri,  4 Nov 2022 11:30:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E85D403161
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62C07380406B
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:58 +0000 (UTC)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-ko_ZFL4-Os-tBMcpfe42cw-1; Fri, 04 Nov 2022 07:30:55 -0400
X-MC-Unique: ko_ZFL4-Os-tBMcpfe42cw-1
Received: by mail-pj1-f70.google.com with SMTP id
 my9-20020a17090b4c8900b002130d29fd7cso5411664pjb.7
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tChygk51qSEpKRajoEIhCZC1g4gkmcKbQyIR3WZ7WJ0=;
 b=C8dHXR8/Y6lVUs2TtAekyi6QxHEJliCtZkNejtbVUUY4WcWeT8TQ5+zlbukuJBLLeG
 uFBIYqZkiIgvq3l22agfjggzdM0vZWTWj9gCBIrfsU9grp5CNzv7pflQX+MrTmWVOFZ8
 TCsrdMrf1xy7edI47nRDohTee+WIyoSOhWb1mukQsXe0cPln1K1hxh+EO0i5sYCyAp1M
 7bXri0Ywv4VbfYG9UjzlWmESgZkZpEIsT/mUJBranyJ+M1wlRqOrC0qCZfoI4d9mtPQw
 yL2ojyYSRI2dqdN0e0a6B88h3XdFblngxQ2eR4VPt6aCtpXjtAFjVDd20VI5Rk4c4yzl
 +idg==
X-Gm-Message-State: ACrzQf24Pd5d5gACmh0OccBBDwtW4rdO9XWChUwUw+xUjLOdxyhBcJA7
 rrwPlDJd6CXqf89z1fpc7r3LZ5Ooe470dTHeHr8HAWU829a4ROFNbgCtR6AE6zeZzUVV4TuD0S3
 Zi3vR8tNFa5EmvTE=
X-Received: by 2002:a05:6a00:3698:b0:56d:3180:e88f with SMTP id
 dw24-20020a056a00369800b0056d3180e88fmr32007699pfb.66.1667561454069; 
 Fri, 04 Nov 2022 04:30:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6/YFb404UDQuedNToGLAqLTqEInClQiUntzz+pWfWaKxI00OswIw7b6D7Q0zuVJH1Lqg4s3g==
X-Received: by 2002:a05:6a00:3698:b0:56d:3180:e88f with SMTP id
 dw24-20020a056a00369800b0056d3180e88fmr32007679pfb.66.1667561453799; 
 Fri, 04 Nov 2022 04:30:53 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 ca8-20020a17090af30800b0020669c8bd87sm1483003pjb.36.2022.11.04.04.30.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:53 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:30:00 +0800
Message-Id: <20221104113000.487098-6-coxu@redhat.com>
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 5/5] crash_dump: retrieve LUKS volume key in
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
Cc: Baoquan He <bhe@redhat.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Dave Young <dyoung@redhat.com>,
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
 kernel/crash_dump.c        | 116 ++++++++++++++++++++++++++++++++++++-
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
diff --git a/kernel/crash_dump.c b/kernel/crash_dump.c
index 9c202bffbb8d..77a6b84415e8 100644
--- a/kernel/crash_dump.c
+++ b/kernel/crash_dump.c
@@ -5,7 +5,10 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 
+#include <linux/key.h>
+#include <linux/keyctl.h>
 #include <keys/user-type.h>
+
 /*
  * stores the physical address of elf header of crash image
  *
@@ -16,6 +19,8 @@
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 EXPORT_SYMBOL_GPL(elfcorehdr_addr);
 
+unsigned long long luks_volume_key_addr;
+EXPORT_SYMBOL_GPL(luks_volume_key_addr);
 /*
  * stores the size of elf header of crash image
  */
@@ -41,6 +46,76 @@ static int __init setup_elfcorehdr(char *arg)
 }
 early_param("elfcorehdr", setup_elfcorehdr);
 
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
 
@@ -62,12 +137,48 @@ static DECLARE_DELAYED_WORK(wipe_luks_volume_key_work, _wipe_luks_volume_key);
 
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
@@ -100,7 +211,8 @@ int crash_sysfs_luks_volume_key_write(const char *key_desc, size_t count)
 {
 	if (!is_kdump_kernel())
 		return crash_save_temp_luks_volume_key(key_desc, count);
-	return -EINVAL;
+	else
+		return retore_luks_volume_key_to_thread_keyring(key_desc);
 }
 EXPORT_SYMBOL(crash_sysfs_luks_volume_key_write);
 
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

