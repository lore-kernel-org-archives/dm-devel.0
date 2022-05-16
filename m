Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B70DC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 20:30:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-MJY0qfYbPSWb01e7SqAPnw-1; Mon, 16 May 2022 16:30:50 -0400
X-MC-Unique: MJY0qfYbPSWb01e7SqAPnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29F4D899EC2;
	Mon, 16 May 2022 20:30:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C32C40D1B98;
	Mon, 16 May 2022 20:30:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 227C41947059;
	Mon, 16 May 2022 20:30:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB4081947055
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 20:30:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABCE140D1B99; Mon, 16 May 2022 20:30:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A79F240D1B98
 for <dm-devel@redhat.com>; Mon, 16 May 2022 20:30:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E34238349A9
 for <dm-devel@redhat.com>; Mon, 16 May 2022 20:30:45 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-ETCZhqaOPkaKkaaUmx7exA-1; Mon, 16 May 2022 16:30:43 -0400
X-MC-Unique: ETCZhqaOPkaKkaaUmx7exA-1
Received: by mail-pf1-f169.google.com with SMTP id x52so15018779pfu.11
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3ACVB3Y0E0YBB7tPTLWC9kOdJEJz9VBk49uvnZGm168=;
 b=oXSQPLIhBF3maf/P4kqQAcH3JeMgwge4Ni3GvnRx6odHyeb5i+RexJooapzkfOBYSF
 KXAObTpEVSTmgRTgaBvoHwZlgW32VAF2ltYndJ3L5gmIVuNFlTDp0RWipBTOHyXG+1GK
 r4t/TlUN5ix9+BeYko4RSBX4asBa8C3+T16OIMRwZMmlekMI8QnNdItrn64a+C98vUoP
 F68TvxkRc3el1ijH33MrYEGH1j14hNANVHMrlVyiKH6L2Q0Vja/+iRadpXN8oI4opqDg
 A16S3vsdUy2th3a6PAc5WzrPLZncfi5joyjxFFxxwA1/ixWyD1vbxQMsTFEZskE+ucGD
 qBaw==
X-Gm-Message-State: AOAM532gCs5fZgW4GYr/d353r3FJGONv4B7pMxlVmbkwV1/MMhdw9VoC
 uTvu52yavykDMJqdyZmk8Bmg7HJ48EtBzs271p8C8w==
X-Google-Smtp-Source: ABdhPJxNfgFTQfSkBwC0NJUOFm4ZykQQ/RD3rs42AoQjvgd05emu3aDGtrxluv0uzUNgQwYGRoYx/NUiZsqjsEDg+7c=
X-Received: by 2002:a62:a105:0:b0:50d:c97b:3084 with SMTP id
 b5-20020a62a105000000b0050dc97b3084mr18768863pff.61.1652733042575; Mon, 16
 May 2022 13:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-3-jane.chu@oracle.com>
In-Reply-To: <20220422224508.440670-3-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 May 2022 13:30:31 -0700
Message-ID: <CAPcyv4g02C5LnDxqDG0_U51+v05fQa966LnrvvdadN2Eqf7eKA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v9 2/7] x86/mce: relocate
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
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 22, 2022 at 3:46 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
>
> While at it, fixup a function name in a comment.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 49 ++++++++++++++++++++++++++++-
>  include/linux/set_memory.h        |  8 ++---
>  3 files changed, 52 insertions(+), 57 deletions(-)
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
> index abf5ed76e4b7..978cf5bd2ab6 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> @@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
>  }
>  EXPORT_SYMBOL(set_memory_wb);
>
> +/*
> + * Prevent speculative access to the page by either unmapping
> + * it (if we do not require access to any part of the page) or
> + * marking it uncacheable (if we want to try to retrieve data
> + * from non-poisoned lines in the page).
> + */
> +int set_mce_nospec(unsigned long pfn, bool unmap)
> +{
> +       unsigned long decoy_addr;
> +       int rc;
> +
> +       if (!IS_ENABLED(CONFIG_64BIT))
> +               return 0;
> +
> +       /* SGX pages are not in the 1:1 map */
> +       if (arch_is_platform_page(pfn << PAGE_SHIFT))
> +               return 0;
> +       /*
> +        * We would like to just call:
> +        *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
> +        * but doing that would radically increase the odds of a
> +        * speculative access to the poison page because we'd have
> +        * the virtual address of the kernel 1:1 mapping sitting
> +        * around in registers.
> +        * Instead we get tricky.  We create a non-canonical address
> +        * that looks just like the one we want, but has bit 63 flipped.
> +        * This relies on set_memory_XX() properly sanitizing any __pa()
> +        * results with __PHYSICAL_MASK or PTE_PFN_MASK.
> +        */
> +       decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
> +
> +       if (unmap)
> +               rc = set_memory_np(decoy_addr, 1);
> +       else
> +               rc = set_memory_uc(decoy_addr, 1);
> +       if (rc)
> +               pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
> +       return rc;
> +}
> +
> +/* Restore full speculative operation to the pfn. */
> +int clear_mce_nospec(unsigned long pfn)
> +{
> +       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +}
> +EXPORT_SYMBOL_GPL(clear_mce_nospec);
> +
>  int set_memory_x(unsigned long addr, int numpages)
>  {
>         if (!(__supported_pte_mask & _PAGE_NX))
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index f36be5166c19..683a6c3f7179 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -42,14 +42,14 @@ static inline bool can_set_direct_map(void)
>  #endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
> -#ifndef set_mce_nospec
> +#ifdef CONFIG_X86_64

Jane,

I just noticed that this makes set_mce_nospec() and clear_mce_nospec()
x86_64-only. If / when more architectures add support for these
helpers they will need to go back to the "#ifndef $symbol" scheme to
allow asm/set_memory.h to indicate the availability of the arch-local
helper.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

