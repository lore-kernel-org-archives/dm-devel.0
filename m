Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34A5C43219
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810413;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+ziVCiOeRctKEvGFfAvbtrFskAyxTsmn0FWOeYsOV18=;
	b=OUUREX4WQBpZ4ovG1xdS7CsgDEA5bODUCtWutjN2pLZ7aZFge4tJCkMfhpxB8OjDZebMcB
	YWRYdrNeWYrdgue8RyP+Qzq2Aph5W9SgkrodQl/bf+fBv+OUWjZs4aRd1WZ/kk+Pye7tL2
	mlhhUQ+0giexA9kTVIcrYTaA1pEPU1Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-sP6_NPLMOyyRL3Sih6c2dg-1; Mon, 07 Nov 2022 03:40:12 -0500
X-MC-Unique: sP6_NPLMOyyRL3Sih6c2dg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 186072804BAE;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 077162166B29;
	Mon,  7 Nov 2022 08:40:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 46D0A1946A44;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 206C61946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02A52206400B; Fri,  4 Nov 2022 11:30:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFADB2064009
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0CE685A59D
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:47 +0000 (UTC)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-3bFGrqJAMc-V3AMx5r_j3w-1; Fri, 04 Nov 2022 07:30:46 -0400
X-MC-Unique: 3bFGrqJAMc-V3AMx5r_j3w-1
Received: by mail-pj1-f70.google.com with SMTP id
 pa16-20020a17090b265000b0020a71040b4cso2233893pjb.6
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=RevsFdiPw/fb8SaWA4i0OScuHjqawmx3PhXyedjj5ck=;
 b=q47yhu8mkuKEU722O4KSemm5KT2QehCVU+ap409/YNE4lkgTgiFzAjb2the0xeekET
 ZJ4d4nVJSbndlqHrKRQQ8tpLhJ3777ohyS5gvcEGor5dcoIZdvbPXvCgwZygeuTSYk34
 IzGwNcNeXomNpYOeZzcvP2RcaB5q7ZCMMtpiK8/Zpv0gOowF0h+SkynfKoKX99bmVTok
 Fy2a+f3LuWyLvHJmz1QsHhkudEKhty+m4pNk/MadZyWe/ZchgVTxCkMjLwc5UVEmEg1N
 zsuIDSIJSr7bf7SauHIQWsHj4bFfyFjwT9pO1BgxJrWY4oV2qeSdVdAnE/3klsspV62T
 9VNg==
X-Gm-Message-State: ACrzQf3Hjunodsvq+D0VJeI3idDBmQdHP6NEssSHtBygSgff8oQW2BR5
 zo+IbF8wGoafVy4kemTxZf57ZE5aT0XTqRih5jpbFoy1DGDkH/4lAeP+A4hjsldzfoUFbqEpocY
 lzqIhQAKaSrG7rCU=
X-Received: by 2002:a17:90a:6d22:b0:213:7e1e:9be0 with SMTP id
 z31-20020a17090a6d2200b002137e1e9be0mr35804892pjj.17.1667561445707; 
 Fri, 04 Nov 2022 04:30:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM51CDYLEqWginckV/rN0elEiAXD4s8pR8U6DdMP+NZPO37JWjN6xDUyvoO9upVjiEVTkeoywQ==
X-Received: by 2002:a17:90a:6d22:b0:213:7e1e:9be0 with SMTP id
 z31-20020a17090a6d2200b002137e1e9be0mr35804871pjj.17.1667561445499; 
 Fri, 04 Nov 2022 04:30:45 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 c5-20020a056a00008500b005629b6a8b53sm2609597pfj.15.2022.11.04.04.30.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:45 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:29:59 +0800
Message-Id: <20221104113000.487098-5-coxu@redhat.com>
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 4/5] x86/crash: make the page that stores the
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
Cc: "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds an addition layer of protection for the saved copy of LUKS
volume key. Trying to access the saved copy will cause page fault.

Suggested-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 0611fd83858e..f3d51c38a1c9 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -557,9 +557,25 @@ static void kexec_mark_crashkres(bool protect)
 	kexec_mark_range(control, crashk_res.end, protect);
 }
 
+static void kexec_mark_luks_volume_key_inaccessible(void)
+{
+	unsigned long start, end;
+	struct page *page;
+	unsigned int nr_pages;
+
+	if (kexec_crash_image->luks_volume_key_addr) {
+		start = kexec_crash_image->luks_volume_key_addr;
+		end = start + kexec_crash_image->luks_volume_key_sz - 1;
+		page = pfn_to_page(start >> PAGE_SHIFT);
+		nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
+		set_memory_np((unsigned long)page_address(page), nr_pages);
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
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

