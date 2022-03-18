Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E590C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bXOPN4aJN5glTJihedVQaquVSqkpDlujbTq+Lco8Ei8=;
	b=TWoPYQ3iCkZNGdf+NxXCGnCO9awnZWHFd6kbHgzzFbj6rIRQf2Sj4ezgo75MY3s8sT5TpK
	LEEIUnXvY18RBx3NDNjGkvKMIC/wasj6bdMdt+e9KTPY/uTeB3N7gqjnvKH7cF5BbsPL4m
	3PZRRcadEqHvwSKowJ2uyeG9lydXyEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-tDZM7q8_MdWQ2KNDHdzgkA-1; Mon, 21 Mar 2022 02:54:54 -0400
X-MC-Unique: tDZM7q8_MdWQ2KNDHdzgkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36E831857F17;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DCA01121314;
	Mon, 21 Mar 2022 06:54:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA39219451EF;
	Mon, 21 Mar 2022 06:54:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0892B1949763
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 10:34:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED31D56D1E0; Fri, 18 Mar 2022 10:34:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E93BB56D17C
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFA693811F29
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:39 +0000 (UTC)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-Vhjgj2kRNnaTTZtXMoPT7A-1; Fri, 18 Mar 2022 06:34:38 -0400
X-MC-Unique: Vhjgj2kRNnaTTZtXMoPT7A-1
Received: by mail-pl1-f198.google.com with SMTP id
 w24-20020a170902a71800b001538d7b076dso3928281plq.16
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 03:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EDf+Cue22NIq+++ettcFUZpGsy+wdzQQBWaXtBz9VhU=;
 b=NkXEjp4Et1lYvH/VLMHnpnaO/RxDKmoEDEwOu6+hr/uLzIW7ustcCL5Qc9lSYsNavF
 xRK0UplwlGrECCl7G4YbmXkWllIi230V1YTccWqOw4R3hutZNUaaid1gdu2NQIpAvWua
 u/Ce9G2snSUTHwccriqzp7r4JKvBUbv2T2XISr3yNjvhUqt2UxH2Lkvbkp5+0fvrhacG
 l1qBUD9uwr0DyKoKzkpShXKUpu7D2Ekel8EbUYiG2THruTtWDHG3OxBJhGv6TArhjgON
 oCN7+8SBTEnv9l5jOaSMCxXxIQI0JquPNvZGu85BNa5trwE8Cj8Wo+Z14LtqqIM1VKoL
 90FQ==
X-Gm-Message-State: AOAM533ktjl7+m4iuClRwW4c53C94uUDUG9NnQqnVmTybqJnAb1jUqtv
 w8GAixq8kWdEYbINeo4Yzcq4e7u53xbXKU4bM8RpgqxIFzB7sVAXSPCLPhMaQ3rIvdVJFqyLIeP
 W9WztXC+rfz/rnSk=
X-Received: by 2002:a17:902:db10:b0:151:ef9a:7e27 with SMTP id
 m16-20020a170902db1000b00151ef9a7e27mr9211905plx.39.1647599677359; 
 Fri, 18 Mar 2022 03:34:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4eHzy4IQF50hT/ddKSZ0UY2J9cU8InbYVKChGw7aJVMkZmTYKHNSbfCTQcgf4H6bZpxJhpw==
X-Received: by 2002:a17:902:db10:b0:151:ef9a:7e27 with SMTP id
 m16-20020a170902db1000b00151ef9a7e27mr9211781plx.39.1647599675619; 
 Fri, 18 Mar 2022 03:34:35 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 pi10-20020a17090b1e4a00b001bf9749b95bsm12445631pjb.50.2022.03.18.03.34.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 03:34:34 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri, 18 Mar 2022 18:34:21 +0800
Message-Id: <20220318103423.286410-3-coxu@redhat.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
Subject: [dm-devel] [RFC 2/4] kdump,
 x86: pass the LUKS master key to kdump kernel using a kernel
 command line parameter luksmasterkey
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
Cc: "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Mike Snitzer <snitzer@redhat.com>,
 Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Eric Biederman <ebiederm@xmission.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

kdump will build up the kernel command parameter luksmasterkey as
similar to elfcorehdr to pass the memory address of the stored info of LUKS
master key to kdump kernel.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 arch/x86/include/asm/crash.h      |  1 +
 arch/x86/kernel/crash.c           | 42 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/kexec-bzimage64.c |  7 ++++++
 include/linux/kexec.h             |  4 +++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
index 8b6bd63530dc..757374389296 100644
--- a/arch/x86/include/asm/crash.h
+++ b/arch/x86/include/asm/crash.h
@@ -4,6 +4,7 @@
 
 struct kimage;
 
+int crash_load_luks_key(struct kimage *image);
 int crash_load_segments(struct kimage *image);
 int crash_setup_memmap_entries(struct kimage *image,
 		struct boot_params *params);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e8326a8d1c5d..6d117da62da4 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -304,6 +304,7 @@ static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
 				 unsigned long long mend)
 {
 	unsigned long start, end;
+	int r;
 
 	cmem->ranges[0].start = mstart;
 	cmem->ranges[0].end = mend;
@@ -312,7 +313,19 @@ static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
 	/* Exclude elf header region */
 	start = image->elf_load_addr;
 	end = start + image->elf_headers_sz - 1;
-	return crash_exclude_mem_range(cmem, start, end);
+	r = crash_exclude_mem_range(cmem, start, end);
+
+	if (r)
+		return r;
+
+	/* Exclude LUKS master key region */
+	if (image->luks_master_key_addr) {
+		start = image->luks_master_key_addr;
+		end = start + image->luks_master_key_sz - 1;
+		return crash_exclude_mem_range(cmem, start, end);
+	}
+
+	return r;
 }
 
 /* Prepare memory map for crash dump kernel */
@@ -383,6 +396,33 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 	return ret;
 }
 
+int crash_load_luks_key(struct kimage *image)
+{
+	int ret;
+	struct kexec_buf kbuf = { .image = image, .buf_min = 0,
+				  .buf_max = ULONG_MAX, .top_down = false };
+
+	image->luks_master_key_addr = 0;
+	ret = kexec_pass_luks_master_key(&kbuf.buffer, &kbuf.bufsz);
+	if (ret)
+		return ret;
+
+	kbuf.memsz = kbuf.bufsz;
+	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
+	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
+	ret = kexec_add_buffer(&kbuf);
+	if (ret) {
+		vfree((void *)kbuf.buffer);
+		return ret;
+	}
+	image->luks_master_key_addr = kbuf.mem;
+	image->luks_master_key_sz = kbuf.bufsz;
+	pr_debug("Loaded LUKS master key at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		 image->luks_master_key_addr, kbuf.bufsz, kbuf.bufsz);
+
+	return ret;
+}
+
 int crash_load_segments(struct kimage *image)
 {
 	int ret;
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 170d0fd68b1f..64ea3b6a5768 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -76,6 +76,10 @@ static int setup_cmdline(struct kimage *image, struct boot_params *params,
 	if (image->type == KEXEC_TYPE_CRASH) {
 		len = sprintf(cmdline_ptr,
 			"elfcorehdr=0x%lx ", image->elf_load_addr);
+
+		if (image->luks_master_key_addr != 0)
+			len += sprintf(cmdline_ptr + len,
+					"luksmasterkey=0x%lx ", image->luks_master_key_addr);
 	}
 	memcpy(cmdline_ptr + len, cmdline, cmdline_len);
 	cmdline_len += len;
@@ -372,6 +376,9 @@ static void *bzImage64_load(struct kimage *image, char *kernel,
 		ret = crash_load_segments(image);
 		if (ret)
 			return ERR_PTR(ret);
+		ret = crash_load_luks_key(image);
+		if (ret)
+			pr_debug("Either no LUKS master key or error to retrieve the LUKS master key\n");
 	}
 
 	/*
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 91507bc684e2..456a5bc28518 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -316,6 +316,10 @@ struct kimage {
 	void *elf_headers;
 	unsigned long elf_headers_sz;
 	unsigned long elf_load_addr;
+
+	/* LUKS master key buffer */
+	unsigned long luks_master_key_addr;
+	unsigned long luks_master_key_sz;
 };
 
 /* kexec interface functions */
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

