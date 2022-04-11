Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7691BC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 23:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-B777wC7HMQiik9Fbp5ZSAA-1; Mon, 11 Apr 2022 19:27:49 -0400
X-MC-Unique: B777wC7HMQiik9Fbp5ZSAA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96BB738041D1;
	Mon, 11 Apr 2022 23:27:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1560F401473;
	Mon, 11 Apr 2022 23:27:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B11861949762;
	Mon, 11 Apr 2022 23:27:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 355731947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 23:27:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23E0E401473; Mon, 11 Apr 2022 23:27:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FD024292C8
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:27:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAA64899EC5
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:27:43 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-WiRZ2Js4MZW_N4dkeQh7kQ-1; Mon, 11 Apr 2022 19:27:40 -0400
X-MC-Unique: WiRZ2Js4MZW_N4dkeQh7kQ-1
Received: by mail-pj1-f42.google.com with SMTP id
 e8-20020a17090a118800b001cb13402ea2so927254pja.0
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 16:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZyCNtqi2liVUhJyPLcqvhIOqdeRMoLiJ26fVX/78cd4=;
 b=Q4exaus/a7t1XODaeVFLNZGV98o4jByC9F3F1ezHWXQvRkpUc8QNcEFaqyD3d5kP8c
 E1cMwSnUm8sUimajh5L1ln7MhHdrwcW45UoNWAnOys89ce5EMLfbuH+totH1eyFXA5T+
 FL5ENCwfPfFd/OJjQd+PbRbT3yR/pCn7/b67tfxDC77S22r83xnFqVLsNSdCaBEvyVhI
 hBLOmME9DqGbJLRv8aR5x+AaWCveCo1+IMvgOTyFlxxV9F4h70IwHap7iYTlNQinIHCD
 FsT8cEjSbNHiPqMKO0klZqGZH3oh3JnPFSnahjgRlGiZtTqqxxbccv8Btlj1QCIivPOO
 V2LA==
X-Gm-Message-State: AOAM532Q9DmDNNWRPtahma1h8n/2ouU0x5RI03Z1Py1RSm13bMIVRr/5
 lf62TFeiLo4er0RdQOA34qj9KY3Xyt5YoS2nNEufPA==
X-Google-Smtp-Source: ABdhPJwpCCv6NB1Rjiy6AYdsIPpnabFEG4O5rr1GgxZyZs+D8oAl+RDykuVfMYg4xQGlEZtWu2prZSOs7aNN9C9UisA=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr34289628pll.132.1649719659088; Mon, 11
 Apr 2022 16:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-4-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 16:27:28 -0700
Message-ID: <CAPcyv4jx=h+1QiB0NRRQrh1mHcD2TFQx4AH6JxnQDKukZ3KVZA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 3/6] mce: fix set_mce_nospec to always
 unmap the whole page
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
 Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> The set_memory_uc() approach doesn't work well in all cases.
> For example, when "The VMM unmapped the bad page from guest
> physical space and passed the machine check to the guest."
> "The guest gets virtual #MC on an access to that page.
>  When the guest tries to do set_memory_uc() and instructs
>  cpa_flush() to do clean caches that results in taking another
>  fault / exception perhaps because the VMM unmapped the page
>  from the guest."
>
> Since the driver has special knowledge to handle NP or UC,

I think a patch is needed before this one to make this statement true? I.e.:

diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index ee8d9973f60b..11641f55025a 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -32,6 +32,7 @@ static int nfit_handle_mce(struct notifier_block
*nb, unsigned long val,
         */
        mutex_lock(&acpi_desc_lock);
        list_for_each_entry(acpi_desc, &acpi_descs, list) {
+               unsigned int align = 1UL << MCI_MISC_ADDR_LSB(mce->misc);
                struct device *dev = acpi_desc->dev;
                int found_match = 0;

@@ -63,8 +64,7 @@ static int nfit_handle_mce(struct notifier_block
*nb, unsigned long val,

                /* If this fails due to an -ENOMEM, there is little we can do */
                nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
-                               ALIGN(mce->addr, L1_CACHE_BYTES),
-                               L1_CACHE_BYTES);
+                                       ALIGN(mce->addr, align), align);
                nvdimm_region_notify(nfit_spa->nd_region,
                                NVDIMM_REVALIDATE_POISON);


> let's mark the poisoned page with NP and let driver handle it
> when it comes down to repair.
>
> Please refer to discussions here for more details.
> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
>
> Now since poisoned page is marked as not-present, in order to
> avoid writing to a 'np' page and trigger kernel Oops, also fix
> pmem_do_write().
>
> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/kernel/cpu/mce/core.c |  6 +++---
>  arch/x86/mm/pat/set_memory.c   | 18 ++++++------------
>  drivers/nvdimm/pmem.c          | 31 +++++++------------------------
>  include/linux/set_memory.h     |  4 ++--
>  4 files changed, 18 insertions(+), 41 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index 981496e6bc0e..fa67bb9d1afe 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
>
>         pfn = mce->addr >> PAGE_SHIFT;
>         if (!memory_failure(pfn, 0)) {
> -               set_mce_nospec(pfn, whole_page(mce));
> +               set_mce_nospec(pfn);
>                 mce->kflags |= MCE_HANDLED_UC;
>         }
>
> @@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
>
>         ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
>         if (!ret) {
> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>                 sync_core();
>                 return;
>         }
> @@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
>         p->mce_count = 0;
>         pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
>         if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
> -               set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +               set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>  }
>
>  static void queue_task_work(struct mce *m, char *msg, void (*func)(struct callback_head *))
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 93dde949f224..404ffcb3f2cb 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1926,13 +1926,8 @@ int set_memory_wb(unsigned long addr, int numpages)
>  EXPORT_SYMBOL(set_memory_wb);
>
>  #ifdef CONFIG_X86_64
> -/*
> - * Prevent speculative access to the page by either unmapping
> - * it (if we do not require access to any part of the page) or
> - * marking it uncacheable (if we want to try to retrieve data
> - * from non-poisoned lines in the page).
> - */
> -int set_mce_nospec(unsigned long pfn, bool unmap)
> +/* Prevent speculative access to a page by marking it not-present */
> +int set_mce_nospec(unsigned long pfn)
>  {
>         unsigned long decoy_addr;
>         int rc;
> @@ -1954,10 +1949,7 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
>          */
>         decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>
> -       if (unmap)
> -               rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> +       rc = set_memory_np(decoy_addr, 1);
>         if (rc)
>                 pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>         return rc;
> @@ -1966,7 +1958,9 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
>  /* Restore full speculative operation to the pfn. */
>  int clear_mce_nospec(unsigned long pfn)
>  {
> -       return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +       unsigned long addr = (unsigned long) pfn_to_kaddr(pfn);
> +
> +       return change_page_attr_set(&addr, 1, __pgprot(_PAGE_PRESENT), 0);

This probably warrants a set_memory_present() helper.

>  }
>  EXPORT_SYMBOL_GPL(clear_mce_nospec);
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 58d95242a836..30c71a68175b 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -158,36 +158,19 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>                         struct page *page, unsigned int page_off,
>                         sector_t sector, unsigned int len)
>  {
> -       blk_status_t rc = BLK_STS_OK;
> -       bool bad_pmem = false;
>         phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
> -       if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> -               bad_pmem = true;
> +       if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
> +               blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);
>
> -       /*
> -        * Note that we write the data both before and after
> -        * clearing poison.  The write before clear poison
> -        * handles situations where the latest written data is
> -        * preserved and the clear poison operation simply marks
> -        * the address range as valid without changing the data.
> -        * In this case application software can assume that an
> -        * interrupted write will either return the new good
> -        * data or an error.
> -        *
> -        * However, if pmem_clear_poison() leaves the data in an
> -        * indeterminate state we need to perform the write
> -        * after clear poison.
> -        */
> +               if (rc != BLK_STS_OK)
> +                       pr_warn_ratelimited("%s: failed to clear poison\n", __func__);

This should be either "dev_warn_ratelimited(to_dev(pmem), ...", or a
trace point similar to trace_block_rq_complete() that tells userspace
about adverse I/O completion results.

However, that's probably a discussion for another patch, so I would
just drop this new addition for now and we can discuss the logging in
a follow-on patch.


> +                       return rc;
> +       }
>         flush_dcache_page(page);
>         write_pmem(pmem_addr, page, page_off, len);
> -       if (unlikely(bad_pmem)) {
> -               rc = pmem_clear_poison(pmem, pmem_off, len);
> -               write_pmem(pmem_addr, page, page_off, len);
> -       }
> -
> -       return rc;
> +       return BLK_STS_OK;
>  }
>
>  static void pmem_submit_bio(struct bio *bio)
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index d6263d7afb55..cde2d8687a7b 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -43,10 +43,10 @@ static inline bool can_set_direct_map(void)
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
>  #ifdef CONFIG_X86_64
> -int set_mce_nospec(unsigned long pfn, bool unmap);
> +int set_mce_nospec(unsigned long pfn);
>  int clear_mce_nospec(unsigned long pfn);
>  #else
> -static inline int set_mce_nospec(unsigned long pfn, bool unmap)
> +static inline int set_mce_nospec(unsigned long pfn)

Looks like after this change the "whole_page()" helper can be deleted
and the ->mce_whole_page flag in the task_struct can also go, right?
In a follow-on of course.

Other than those small issues, this looks good!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

