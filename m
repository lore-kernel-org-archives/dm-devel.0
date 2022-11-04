Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94210C4167E
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ww18CL8GrMqzmShIOBJjHX1ePdJgAIx+BSrwLhV/wKA=;
	b=COA8HXqIPqrNL71KMgnApv0sHGfKnYUIQfmBugYMxEF1inlbEABWC5KOikX23zp1xNmaA4
	nr8MpyWa9rTx0atXpC+jP4a9e/YWietVlIKvX3RemLRKX6QUj1of0KExA/jd1/eU1fHoz8
	QA95u04m+eA2tJFpYfXoYixrIdRCKm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-5ShQ1rJEMxqLUf_FlN1ZZQ-1; Mon, 07 Nov 2022 03:40:12 -0500
X-MC-Unique: 5ShQ1rJEMxqLUf_FlN1ZZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48C7E85A5B6;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3679F39DB3;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7720D1946A4A;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 478821946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35876112132C; Fri,  4 Nov 2022 11:30:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E14E1121325
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E19A101A528
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:40 +0000 (UTC)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-uITczoENN_SVx5PoLE46oA-1; Fri, 04 Nov 2022 07:30:38 -0400
X-MC-Unique: uITczoENN_SVx5PoLE46oA-1
Received: by mail-pg1-f198.google.com with SMTP id
 g66-20020a636b45000000b0043a256d3639so2421172pgc.12
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=E9ieE4VIDGcBaiULL1C+z5L6S0lWIm/B8H9v1NRSxPo=;
 b=JI9Ac85tPVuQg68HaPcZWvrIgxi4HDHePmguj4sVx/AyVQFbnbJn2gfxlUlfk2hq/2
 6FQOZd2LVLLKUE50x6G/ahtZ8Ctrglyiv4e7uvci3dZ8agAcuGpzKbb+MZlRJYWhmzn+
 xUZXq0grAS0M6+6UeSZgUT8FeTyLGA/3W0qA3e/+2rlNPIAPUnVI193dI8JUcKq5aZQD
 F85FWAiKIAVFuDVx8k5psod74cwtChS7tVy6jQdGAlFx4RD+CicQl7htv+LOdM3ddxyL
 puc683Gl98QvDjcFhkTHDisKu3P/csF8fypPS5GAIzwYPYrza3HOa2rOkEudF8/wEnFo
 EZZA==
X-Gm-Message-State: ACrzQf3+PDqNb0RCbqm6Kpk6LkDX2j3Ui4HwM0NHKHU+C5fMmDyaLUOg
 /q22butr7amxYWPvXRp9VfotdNyaTDOLMdA8Qw1IO8ofzxihfzBu1l3g11/33m/BCTPfbeme6WV
 8Y/1c4AYxXzHKvrY=
X-Received: by 2002:a17:902:f28b:b0:186:b069:63fc with SMTP id
 k11-20020a170902f28b00b00186b06963fcmr35566374plc.38.1667561437564; 
 Fri, 04 Nov 2022 04:30:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7qypMeRgTqbqOB76+RxKWKqrfx12CwgsfSjDZBxgJGySGlq0PpZpwe2FJNfIghklVFI91+FQ==
X-Received: by 2002:a17:902:f28b:b0:186:b069:63fc with SMTP id
 k11-20020a170902f28b00b00186b06963fcmr35566345plc.38.1667561437294; 
 Fri, 04 Nov 2022 04:30:37 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 k30-20020aa7999e000000b0056bcfe015c9sm2458149pfh.204.2022.11.04.04.30.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:36 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:29:58 +0800
Message-Id: <20221104113000.487098-4-coxu@redhat.com>
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 3/5] x86/crash: pass the LUKS volume key to
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
Cc: "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Eric Biederman <ebiederm@xmission.com>,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
index 9730c88530fc..5ceda2802482 100644
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
@@ -383,6 +396,38 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
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
index f299b48f9c9f..e556dbf96695 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -75,6 +75,10 @@ static int setup_cmdline(struct kimage *image, struct boot_params *params,
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
@@ -371,6 +375,9 @@ static void *bzImage64_load(struct kimage *image, char *kernel,
 		ret = crash_load_segments(image);
 		if (ret)
 			return ERR_PTR(ret);
+		ret = crash_load_luks_volume_key(image);
+		if (ret)
+			pr_debug("Either no LUKS volume key or error to retrieve the LUKS volume key\n");
 	}
 
 	/*
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index c0edb64bf6c4..ed7a0ec70129 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -385,6 +385,10 @@ struct kimage {
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
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

