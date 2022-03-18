Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98802C43219
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845703;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=400Gvn5r+nwRiqtCdotVQv5kXmuBO1kMUlIGI8Ahk1g=;
	b=Zmc97WWlxjpuzgJ6XDpPdMjZg8rTxhrpLWV7YG74koM1F716KndKyac0ZT8BjrEjPkD/Tt
	yz28d6ZLCKBRcxYBA1KWqiG0kFRdefBrmzJu1TUnnzwxMA7uFi36IThrSFnicU1moOQJVc
	g+lBlZDN2OKp2tYyvqlQNyUBstB+BXM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-oFmpt665MJ266tYINj-98A-1; Mon, 21 Mar 2022 02:54:59 -0400
X-MC-Unique: oFmpt665MJ266tYINj-98A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0CA03C01B98;
	Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD84242D3B3;
	Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3EE7A1953552;
	Mon, 21 Mar 2022 06:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 856F61949761
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 10:34:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 739FCC3326C; Fri, 18 Mar 2022 10:34:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7009BC3326B
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55FFB101A54C
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:42 +0000 (UTC)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-ivjHMnKjM9uC6ZbizzPmRQ-1; Fri, 18 Mar 2022 06:34:41 -0400
X-MC-Unique: ivjHMnKjM9uC6ZbizzPmRQ-1
Received: by mail-pl1-f198.google.com with SMTP id
 g1-20020a170902fe0100b00153f95629f7so1711532plj.12
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 03:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=kuGSMiWQ1weBzk6gT/GPrRoo3pCEcdrOBhI/gZQe7L8=;
 b=qMB+0y3gTfBGUKm78C3cF83SHOmu6KYBLhmm+n2ZpO+is4Umn9CfsgaKEhhunhywWp
 7ubUsAYHcbNI4EA067xgbLISgJpCDm4HrDYGlTDC7JvD6iWFr2nDwtHe2QeHYwQK/QdJ
 ThYn+ZlL9yTl4q6dWfoup5eYHgPRyhHLaUG/ysrZFKWzYOZk2NypRErCr8Z+LroeVCEu
 /rksHD0CLH5oYtmCwSkeFt5ySK+OytymOTYkcW08SG3cJpaP+4DL6bETXXqgy3QC2s3S
 dyZcM+finIFxUBWwuyiY1sNDt8eDCAC4H1yVYbkQBb57ySXlqZZ+W01foE7KKNkrU6mK
 bKNw==
X-Gm-Message-State: AOAM530hz+4Ry9ES8kt3tAZxPQXZoRkfVg64wFxMlY9MMMjc1Bez+g5e
 DLnWa284cIAbc74x5Yszw/Nu6ywrwsmxIlb6IgjYKe0nxmD0hcGRgeOgPwr44IiOBVgqxQ+rDAY
 vbYMTYeDrpuGiag8=
X-Received: by 2002:a63:4560:0:b0:370:1f21:36b8 with SMTP id
 u32-20020a634560000000b003701f2136b8mr7182291pgk.181.1647599679834; 
 Fri, 18 Mar 2022 03:34:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhyV5GISqvWydR24KI3Wp7EU8nU5i/FqatRN/HUbpQQsjZ2tGrMtTSM/bkqPiyk99D7Hj1wA==
X-Received: by 2002:a63:4560:0:b0:370:1f21:36b8 with SMTP id
 u32-20020a634560000000b003701f2136b8mr7182281pgk.181.1647599679569; 
 Fri, 18 Mar 2022 03:34:39 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 p125-20020a622983000000b004f6c5d58225sm9146730pfp.90.2022.03.18.03.34.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 03:34:39 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri, 18 Mar 2022 18:34:22 +0800
Message-Id: <20220318103423.286410-4-coxu@redhat.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
Subject: [dm-devel] [RFC 3/4] crash_dump: retrieve LUKS master key in kdump
 kernel
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
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>,
 Vivek Goyal <vgoyal@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

kdump will retrieve the LUKS master key based on the luksmasterkey
command line parameter.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/crash_dump.h |  4 +++
 kernel/crash_dump.c        | 69 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 620821549b23..24acb84b716e 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -15,6 +15,8 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
+extern unsigned long long luks_master_key_addr;
+
 #ifdef CONFIG_CRASH_DUMP
 extern int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size);
 extern void elfcorehdr_free(unsigned long long addr);
@@ -32,6 +34,8 @@ extern ssize_t copy_oldmem_page_encrypted(unsigned long pfn, char *buf,
 
 void vmcore_cleanup(void);
 
+int retrive_kdump_luks_master_key(u8 *buffer, unsigned int *sz);
+
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
 #ifndef vmcore_elf_check_arch_cross
diff --git a/kernel/crash_dump.c b/kernel/crash_dump.c
index 92da32275af5..ee32de300b9e 100644
--- a/kernel/crash_dump.c
+++ b/kernel/crash_dump.c
@@ -15,6 +15,8 @@
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 EXPORT_SYMBOL_GPL(elfcorehdr_addr);
 
+unsigned long long luks_master_key_addr;
+EXPORT_SYMBOL_GPL(luks_master_key_addr);
 /*
  * stores the size of elf header of crash image
  */
@@ -39,3 +41,70 @@ static int __init setup_elfcorehdr(char *arg)
 	return end > arg ? 0 : -EINVAL;
 }
 early_param("elfcorehdr", setup_elfcorehdr);
+
+static int __init setup_luksmasterkey(char *arg)
+{
+	char *end;
+
+	if (!arg)
+		return -EINVAL;
+	luks_master_key_addr = memparse(arg, &end);
+	if (end > arg)
+		return 0;
+
+	luks_master_key_addr = 0;
+	return -EINVAL;
+}
+
+early_param("luksmasterkey", setup_luksmasterkey);
+
+/*
+ * Architectures may override this function to read LUKS master key
+ */
+ssize_t __weak luks_key_read(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0, false);
+}
+
+int retrive_kdump_luks_master_key(u8 *buffer, unsigned int *sz)
+{
+	unsigned int key_size;
+	size_t lukskeybuf_sz;
+	unsigned int *size_ptr;
+	char *lukskeybuf;
+	u64 addr;
+	int r;
+
+	if (luks_master_key_addr == 0) {
+		pr_debug("LUKS master key memory address inaccessible");
+		return -EINVAL;
+	}
+
+	addr = luks_master_key_addr;
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
+	addr = luks_master_key_addr;
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
+EXPORT_SYMBOL(retrive_kdump_luks_master_key);
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

