Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BD1C7EE31
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 05:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685684384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ok4va3Ld1DNBD021zi3vA00cYgp7m1f9sk9MYtCiDf0=;
	b=RZR41pwmsx25x98y1k3l9tZjHrFPbY9qqQxfpCU7Q3H7ZOuA/BgtdTfeQxlSLGH/nanxEu
	pY0hKwXUKkjC7MTkxWXn8OomAZ8ruQ+SOb8GTCChm8Yyz//e7/LBtLkM3vS9V37NLN7+3U
	V0di5WIrrqQxi/Y2mED+24cg7v133eg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-ewzCYfqENruItpi4i7tw9A-1; Fri, 02 Jun 2023 01:39:41 -0400
X-MC-Unique: ewzCYfqENruItpi4i7tw9A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60E882A2AD51;
	Fri,  2 Jun 2023 05:39:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50E2D492B0A;
	Fri,  2 Jun 2023 05:39:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E62ED19465A0;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6934D194343F
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:25:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B84E112132D; Thu,  1 Jun 2023 07:25:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43FD1112132C
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 911C58032EF
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:25:09 +0000 (UTC)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-8-1C3WkKOBmzBT6PKatJsg-1; Thu, 01 Jun 2023 03:25:08 -0400
X-MC-Unique: 8-1C3WkKOBmzBT6PKatJsg-1
Received: by mail-pg1-f197.google.com with SMTP id
 41be03b00d2f7-53450fa3a18so579707a12.0
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 00:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685604307; x=1688196307;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=aefU4VwU8oFOQYKmAqFmOKJxhlCYs6WtVK98Xo9Ylw8=;
 b=kPghHeyYkBMreDXgwdTHI+5y1H3rW7r3Jwsq9J66ChET3OHIxUNzyKzkmCWUIjC4rp
 EftaZX3WOCR6brHFn7ToNgUB/aeivglcGVugBHJRE2T+tH2Quktltl4WIqLOSXXUTXcY
 NS+YLtSdA1e4TVNh3d2UV4PpwVtPi7goPsCo2+pLqylFEjGPl6TY6Y65YH7sBvYFz/O8
 RB+KQbvzarznHSmINUEMdqFYrMRPbWsgMH1Ei7mtNwvn5IkkJ72nezn5lzpQevMkBQiq
 YEOfNOeA7GyMN+2JisoJ6IZ7MFarJkSvPAyG4hYD2yPJNXE+s5silqM8g/QJ8Lt9ate5
 nE3A==
X-Gm-Message-State: AC+VfDw2bvin5LhKKuaTFsanw3wTqBT7QroEmKYQzkyCDOTj6wC2tEDt
 iTunOOxfFYldfGR7e2c4GpG0310BVkKpDje7A8SnHbElBpkJkDqTvIgLfi0R7skwu6Iwzgoh2P0
 wTSJFP3oIGXx9At8=
X-Received: by 2002:a05:6a21:998c:b0:10c:37ed:3e88 with SMTP id
 ve12-20020a056a21998c00b0010c37ed3e88mr8900720pzb.23.1685604307400; 
 Thu, 01 Jun 2023 00:25:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63I95P8dhhdJ7s5jrMayaANp/DzsGmHfYS5azIKGpulSOOXmtAzsGrmoW2rz/wazIGcv1tqA==
X-Received: by 2002:a05:6a21:998c:b0:10c:37ed:3e88 with SMTP id
 ve12-20020a056a21998c00b0010c37ed3e88mr8900696pzb.23.1685604307121; 
 Thu, 01 Jun 2023 00:25:07 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 y15-20020a17090322cf00b001ac5896e96esm2644901plg.207.2023.06.01.00.25.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 00:25:06 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Thu,  1 Jun 2023 15:24:44 +0800
Message-Id: <20230601072444.2033855-6-coxu@redhat.com>
In-Reply-To: <20230601072444.2033855-1-coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Fri, 02 Jun 2023 05:39:36 +0000
Subject: [dm-devel] [PATCH 5/5] x86/crash: make the page that stores the
 LUKS volume key inaccessible
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
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds an addition layer of protection for the saved copy of LUKS
volume key. Trying to access the saved copy will cause page fault.

Suggested-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 arch/x86/kernel/machine_kexec_64.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 1a3e2c05a8a5..82d1ecb35827 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -546,9 +546,23 @@ static void kexec_mark_crashkres(bool protect)
 	kexec_mark_range(control, crashk_res.end, protect);
 }
 
+static void kexec_mark_luks_volume_key_inaccessible(void)
+{
+	unsigned long start_paddr, end_paddr;
+	unsigned int nr_pages;
+
+	if (kexec_crash_image->luks_volume_key_addr) {
+		start_paddr = kexec_crash_image->luks_volume_key_addr;
+		end_paddr = start_paddr + kexec_crash_image->luks_volume_key_sz - 1;
+		nr_pages = (PAGE_ALIGN(end_paddr) - PAGE_ALIGN_DOWN(start_paddr))/PAGE_SIZE;
+		set_memory_np((unsigned long)phys_to_virt(start_paddr), nr_pages);
+	}
+}
+
 void arch_kexec_protect_crashkres(void)
 {
 	kexec_mark_crashkres(true);
+	kexec_mark_luks_volume_key_inaccessible();
 }
 
 void arch_kexec_unprotect_crashkres(void)
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

