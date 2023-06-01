Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC82C7EE24
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 05:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685684381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BIGVCs4p465Q9RmqAogVxRSyCloXsoncy/0ShjcEZzs=;
	b=EfAIvnRkhX+5MEIz1mRyMGUJkdJCx1JJBUeL/HsRlJQZ4PA9ER46TanB7g+BAUnwZrJQcp
	qsuwMzDtC2FCW+Bu0plXtEjude8x9yuWOkcIxVxEoTkbfzV+eppT70KLJpzVk5T3WF1Wdo
	WXFqpfSoKYPYDLLxqNuDCR5JfzH3lfU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505--DjZsUDWMdu8KR5oJjCNGA-1; Fri, 02 Jun 2023 01:39:40 -0400
X-MC-Unique: -DjZsUDWMdu8KR5oJjCNGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3E0A101A5C5;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3F9D40C6CD7;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC87819465A2;
	Fri,  2 Jun 2023 05:39:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78CD919451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:25:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 664B040BAEE; Thu,  1 Jun 2023 07:25:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EC74492B00
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:06 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42F242800C20
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:06 +0000 (UTC)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-6a68YFHlN2CMGLFd81OMOA-1; Thu, 01 Jun 2023 03:25:05 -0400
X-MC-Unique: 6a68YFHlN2CMGLFd81OMOA-1
Received: by mail-pj1-f70.google.com with SMTP id
 98e67ed59e1d1-2568caac092so105323a91.1
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 00:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685604304; x=1688196304;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=AgH6lkMBE6SH6kwKQ2OLQdShNDxo5U5zIXrPWoXTrzY=;
 b=hKEk90N8A6Xbq2RPbdrESUuJiow2sB/6rLxhYg5IBgb+Lnlj9BhGLl5IbjqsEZ0g6c
 DzA75XG/4st+Z8pnt/JVGy/f7OM55qXqXbDQJVCiCpKtPp2xoPKTbXm6ca80t1tbYgi6
 +2dmkVnOIBae1y3aMEBEXEkhh3jZ7/dI7mmQFsdmB78uE33QYbVxkdqYprq3AlrjP4hN
 gpUVYhRpgl13NzMIOC/Hz4QJJII8EQjAuWDWZdwUroLahTfaEjFYtmSxd+XSuv7ZuZzy
 kmb4zQl8KwCq4+L0UF1db9Ds+UmgRuc6joPJhuBdLhH9hHlFw8HXL6xK2p5gJdfd0w56
 x49Q==
X-Gm-Message-State: AC+VfDxuNauGlRT5u9y+MndeoHkPmQgXRbSpqfiB9utYp9tXm/3f/smw
 rcOuetEj/ErgQgX7fI0qqwsQNMPBkCd/rK9IdkWy86Vm4juNq5biiVNe6OUHHJjP579eN5sAvhx
 MnPsDBBMwaIvo/bc=
X-Received: by 2002:a17:90a:1d5:b0:258:ad44:1881 with SMTP id
 21-20020a17090a01d500b00258ad441881mr348558pjd.11.1685604303892; 
 Thu, 01 Jun 2023 00:25:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7xgKGdx+9FIXW6GTYR3P3F8V57UwAyR9jIH88D5P2XGZN+XYlgvqnsqFZh+mlMZMuhp1bt/w==
X-Received: by 2002:a17:90a:1d5:b0:258:ad44:1881 with SMTP id
 21-20020a17090a01d500b00258ad441881mr348543pjd.11.1685604303582; 
 Thu, 01 Jun 2023 00:25:03 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 o11-20020a17090a4e8b00b00256799877ffsm702466pjh.47.2023.06.01.00.25.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 00:25:03 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Thu,  1 Jun 2023 15:24:43 +0800
Message-Id: <20230601072444.2033855-5-coxu@redhat.com>
In-Reply-To: <20230601072444.2033855-1-coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 02 Jun 2023 05:39:36 +0000
Subject: [dm-devel] [PATCH 4/5] x86/crash: pass the LUKS volume key to kdump
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Baoquan He <bhe@redhat.com>, x86@kernel.org, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@intel.com>, Kairui Song <ryncsn@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Eric Biederman <ebiederm@xmission.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

1st kernel will build up the kernel command parameter luksvolumekey as
similar to elfcorehdr to pass the memory address of the stored info of
LUKS volume key to kdump kernel.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 arch/x86/include/asm/crash.h      |  1 +
 arch/x86/kernel/crash.c           | 47 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/kexec-bzimage64.c |  7 +++++
 include/linux/kexec.h             |  4 +++
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
index 8b6bd63530dc..485f75dce2ca 100644
--- a/arch/x86/include/asm/crash.h
+++ b/arch/x86/include/asm/crash.h
@@ -4,6 +4,7 @@
 
 struct kimage;
 
+int crash_load_luks_volume_key(struct kimage *image);
 int crash_load_segments(struct kimage *image);
 int crash_setup_memmap_entries(struct kimage *image,
 		struct boot_params *params);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index cdd92ab43cda..32d4a9e3badf 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -289,6 +289,7 @@ static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
 				 unsigned long long mend)
 {
 	unsigned long start, end;
+	int r;
 
 	cmem->ranges[0].start = mstart;
 	cmem->ranges[0].end = mend;
@@ -297,7 +298,19 @@ static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
 	/* Exclude elf header region */
 	start = image->elf_load_addr;
 	end = start + image->elf_headers_sz - 1;
-	return crash_exclude_mem_range(cmem, start, end);
+	r = crash_exclude_mem_range(cmem, start, end);
+
+	if (r)
+		return r;
+
+	/* Exclude LUKS volume key region */
+	if (image->luks_volume_key_addr) {
+		start = image->luks_volume_key_addr;
+		end = start + image->luks_volume_key_sz - 1;
+		return crash_exclude_mem_range(cmem, start, end);
+	}
+
+	return r;
 }
 
 /* Prepare memory map for crash dump kernel */
@@ -368,6 +381,38 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 	return ret;
 }
 
+int crash_load_luks_volume_key(struct kimage *image)
+{
+	int ret;
+	struct kexec_buf kbuf = {
+		.image = image,
+		.buf_min = 0,
+		.buf_max = ULONG_MAX,
+		.top_down = false,
+		.random = true,
+	};
+
+	image->luks_volume_key_addr = 0;
+	ret = crash_pass_temp_luks_volume_key(&kbuf.buffer, &kbuf.bufsz);
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
+	image->luks_volume_key_addr = kbuf.mem;
+	image->luks_volume_key_sz = kbuf.bufsz;
+	pr_debug("Loaded LUKS volume key at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		 image->luks_volume_key_addr, kbuf.bufsz, kbuf.bufsz);
+
+	return ret;
+}
+
 int crash_load_segments(struct kimage *image)
 {
 	int ret;
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index a61c12c01270..a859e9e5c876 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -76,6 +76,10 @@ static int setup_cmdline(struct kimage *image, struct boot_params *params,
 	if (image->type == KEXEC_TYPE_CRASH) {
 		len = sprintf(cmdline_ptr,
 			"elfcorehdr=0x%lx ", image->elf_load_addr);
+
+		if (image->luks_volume_key_addr != 0)
+			len += sprintf(cmdline_ptr + len,
+					"luksvolumekey=0x%lx ", image->luks_volume_key_addr);
 	}
 	memcpy(cmdline_ptr + len, cmdline, cmdline_len);
 	cmdline_len += len;
@@ -433,6 +437,9 @@ static void *bzImage64_load(struct kimage *image, char *kernel,
 		ret = crash_load_segments(image);
 		if (ret)
 			return ERR_PTR(ret);
+		ret = crash_load_luks_volume_key(image);
+		if (ret)
+			pr_debug("Either no LUKS volume key or error to retrieve the LUKS volume key\n");
 	}
 
 	/*
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 5b2440444112..20d213076e46 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -374,6 +374,10 @@ struct kimage {
 	void *elf_headers;
 	unsigned long elf_headers_sz;
 	unsigned long elf_load_addr;
+
+	/* LUKS volume key buffer */
+	unsigned long luks_volume_key_addr;
+	unsigned long luks_volume_key_sz;
 };
 
 /* kexec interface functions */
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

