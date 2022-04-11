Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B01C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 22:20:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-3fNBoK4GN6-oHGZk36bIOA-1; Mon, 11 Apr 2022 18:20:39 -0400
X-MC-Unique: 3fNBoK4GN6-oHGZk36bIOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 824D8800B28;
	Mon, 11 Apr 2022 22:20:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D7C754AC93;
	Mon, 11 Apr 2022 22:20:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E885B1940366;
	Mon, 11 Apr 2022 22:20:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9456F1940365
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 22:20:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FD4D9D45; Mon, 11 Apr 2022 22:20:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69ED29D61
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:20:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 417F738149A3
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:20:32 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-rrWI0kZMPf6hj20gvezyNg-1; Mon, 11 Apr 2022 18:20:23 -0400
X-MC-Unique: rrWI0kZMPf6hj20gvezyNg-1
Received: by mail-pl1-f182.google.com with SMTP id t12so2712927pll.7
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 15:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ilC4hsjkYuKv6ebyejb/hqupiLMdVX0htffDOmrd7F4=;
 b=Y4Zivj+YRK5v54GsDqiXSlpR7JcMRGz9ZQlXlf0hZ3wmZadQlVLL0QLbPxI1P6nWi8
 qgQHuOzXZpP6LuY+UEM8MYF5p2s3ivsd9a0K73idvAa3KoI6lsel/fUKey2cFKOpfj3L
 7sMAcyMxgDoGCtv3YY3/k+m7Ai0jpGlxw3JtF2AKBJVjv9cNcjmEgeNxt+U+KZIIT2Yd
 8iEVA5OVMIhxRaBM+oRk5xINU8SEDpZnFRuDQZPgLEJQzwtWZmF2fX/kCxW9F+xDaKPN
 JvbrhTxTnt+AKZEmqZf97quyI+qKAb84XYqTmD4nj/33BO09EQqG2X13vWKvj2oYnxNY
 vxIQ==
X-Gm-Message-State: AOAM532Z4RnUFrazotcVmI5l5M5ilGnQaecwW21Z6mu6A6CZd4soh0KO
 1ef5O9alrCWEbKZJK7KkFXhLCWwgFpHdRZp1zfAlMg==
X-Google-Smtp-Source: ABdhPJwobl8Twz9/+FJGw8iwZ7aqkX15fxktugOjY8lPoNQzuoJOzcOfQ2MMC/mpkqomhSOO2S1HZ/lhTWtwo8KT1ZQ=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr1484772pjd.220.1649715621869; Mon, 11
 Apr 2022 15:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-3-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-3-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 15:20:10 -0700
Message-ID: <CAPcyv4iUWLsZRV4StCzHuVUhEsOB5WURD2r_w3L+LEjoQEheog@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v7 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I notice that none of the folks from "X86 MM" are on the cc, added.

On Tue, Apr 5, 2022 at 12:49 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 47 ++++++++++++++++++++++++++++
>  include/linux/set_memory.h        |  9 +++---
>  3 files changed, 52 insertions(+), 56 deletions(-)
>
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 78ca53512486..b45c4d27fd46 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
>
>  extern int kernel_set_to_readonly;
>
> -#ifdef CONFIG_X86_64
> -/*
> - * Prevent speculative access to the page by either unmapping
> - * it (if we do not require access to any part of the page) or
> - * marking it uncacheable (if we want to try to retrieve data
> - * from non-poisoned lines in the page).
> - */
> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
> -{
> -       unsigned long decoy_addr;
> -       int rc;
> -
> -       /* SGX pages are not in the 1:1 map */
> -       if (arch_is_platform_page(pfn << PAGE_SHIFT))
> -               return 0;
> -       /*
> -        * We would like to just call:
> -        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
> -        * but doing that would radically increase the odds of a
> -        * speculative access to the poison page because we'd have
> -        * the virtual address of the kernel 1:1 mapping sitting
> -        * around in registers.
> -        * Instead we get tricky.  We create a non-canonical address
> -        * that looks just like the one we want, but has bit 63 flipped.
> -        * This relies on set_memory_XX() properly sanitizing any __pa()
> -        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
> -        */
> -       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
> -
> -       if (unmap)
> -               rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> -       if (rc)
> -               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
> -       return rc;
> -}
> -#define set_mce_nospec set_mce_nospec
> -
> -/* Restore full speculative operation to the pfn. */
> -static inline int clear_mce_nospec(unsigned long pfn)
> -{
> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> -}
> -#define clear_mce_nospec clear_mce_nospec
> -#else
> -/*
> - * Few people would run a 32-bit kernel on a machine that supports
> - * recoverable errors because they have too much memory to boot 32-bit.
> - */
> -#endif
> -
>  #endif /* _ASM_X86_SET_MEMORY_H */
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 38af155aaba9..93dde949f224 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
>  }
>  EXPORT_SYMBOL(set_memory_wb);
>
> +#ifdef CONFIG_X86_64

It seems like the only X86_64 dependency in this routine is the
address bit 63 usage, so how about:

if (!IS_ENABLED(CONFIG_64BIT))
    return 0;

...and drop the ifdef?

Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

