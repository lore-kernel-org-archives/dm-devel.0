Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC4AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 04:27:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-h0WHK9oiNKyF0kEqnI0M0g-1; Tue, 12 Apr 2022 00:26:56 -0400
X-MC-Unique: h0WHK9oiNKyF0kEqnI0M0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605EE3C02B60;
	Tue, 12 Apr 2022 04:26:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2A08C28106;
	Tue, 12 Apr 2022 04:26:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 675F51949762;
	Tue, 12 Apr 2022 04:26:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACA9F1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 04:26:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C1344029A6; Tue, 12 Apr 2022 04:26:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 784404029B6
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 04:26:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E5A9185A7A4
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 04:26:51 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651--dM-ZrEuOZis6ELFHLMVyA-1; Tue, 12 Apr 2022 00:26:47 -0400
X-MC-Unique: -dM-ZrEuOZis6ELFHLMVyA-1
Received: by mail-pj1-f47.google.com with SMTP id
 a16-20020a17090a6d9000b001c7d6c1bb13so1533102pjk.4
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 21:26:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UCrOTwn1Apaa4uQLVmk5UD3cOc527xiwJT4PNuBWV0U=;
 b=EwJPitinXhNdwC8XfLG+KklxuHfJUF/NMr6lDSfj9CgG+7U4Tm9LzvsytYvC10ODpK
 CY7LHyfnEVtQpRdkWQaDOtFVdS9MJFMRLUPhXI7rb6m0AHSkg00X35hjXmDZgzscOfug
 sB2K8j0wU+Ld5c5sDuQOswKv1s8ceYlh1rmO0sezjW/RDwYHZURmbzMi2x17F8Gp8W+2
 3fugtV5/CPSTVd9jZIABJTLPh9DCEbuKsC2vFCGSLn4K5ZYEAVvWMF2WfxhAqwGL3tmZ
 e2va1lMtgClzGq0a0gQyS2HZ9vWhmPu05QftHIPYSwabyanJxTkVbqXKE+aGfG7dKXMb
 GaSQ==
X-Gm-Message-State: AOAM530T73etoQyvAp0+VCsbq0khSSqpZ+XuioYqNP5vJ+NL9LOqdFAE
 978DEoOSkJSrTnVsQqauzgeqAxRIRGj52LIABfUH9g==
X-Google-Smtp-Source: ABdhPJykgObq290XUnROGzq2QfTK7LzFthT5iMS5THy+7CybmACgJItes+F9wWuzrX+7pufyRJ0OO61OHh/NWBRaQSs=
X-Received: by 2002:a17:90b:1804:b0:1cb:82e3:5cd0 with SMTP id
 lw4-20020a17090b180400b001cb82e35cd0mr2859224pjb.8.1649737606512; Mon, 11 Apr
 2022 21:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-6-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-6-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 21:26:35 -0700
Message-ID: <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Refactor the pmem_clear_poison() in order to share common code
> later.
>

I would just add a note here about why, i.e. to factor out the common
shared code between the typical write path and the recovery write
path.

> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
>  1 file changed, 52 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 0400c5a7ba39..56596be70400 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
>         return to_nd_region(to_dev(pmem)->parent);
>  }
>
> -static void hwpoison_clear(struct pmem_device *pmem,
> -               phys_addr_t phys, unsigned int len)
> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>  {
> +       return (pmem->phys_addr + offset);

Christoph already mentioned dropping the unnecessary parenthesis.

> +}
> +
> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> +{
> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
> +}
> +
> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> +{
> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
> +}
> +
> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> +               unsigned int len)

Perhaps now is a good time to rename this to something else like
pmem_clear_mce_nospec()? Just to make it more distinct from
pmem_clear_poison(). While "hwpoison" is the page flag name
pmem_clear_poison() is the function that's actually clearing the
poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
toggling the page back into service.

> +{
> +       phys_addr_t phys = to_phys(pmem, offset);
>         unsigned long pfn_start, pfn_end, pfn;
> +       unsigned int blks = len >> SECTOR_SHIFT;
>
>         /* only pmem in the linear map supports HWPoison */
>         if (is_vmalloc_addr(pmem->virt_addr))
> @@ -67,35 +84,44 @@ static void hwpoison_clear(struct pmem_device *pmem,
>                 if (test_and_clear_pmem_poison(page))
>                         clear_mce_nospec(pfn);
>         }
> +
> +       dev_dbg(to_dev(pmem), "%#llx clear %u sector%s\n",
> +               (unsigned long long) to_sect(pmem, offset), blks,
> +               blks > 1 ? "s" : "");

In anticipation of better tracing support and the fact that this is no
longer called from pmem_clear_poison() let's drop it for now.

>  }
>
> -static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
> +static void pmem_clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
> +{
> +       if (blks == 0)
> +               return;
> +       badblocks_clear(&pmem->bb, sector, blks);
> +       if (pmem->bb_state)
> +               sysfs_notify_dirent(pmem->bb_state);
> +}
> +
> +static long __pmem_clear_poison(struct pmem_device *pmem,
>                 phys_addr_t offset, unsigned int len)
>  {
> -       struct device *dev = to_dev(pmem);
> -       sector_t sector;
> -       long cleared;
> -       blk_status_t rc = BLK_STS_OK;
> -
> -       sector = (offset - pmem->data_offset) / 512;
> -
> -       cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
> -       if (cleared < len)
> -               rc = BLK_STS_IOERR;
> -       if (cleared > 0 && cleared / 512) {
> -               hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
> -               cleared /= 512;
> -               dev_dbg(dev, "%#llx clear %ld sector%s\n",
> -                               (unsigned long long) sector, cleared,
> -                               cleared > 1 ? "s" : "");
> -               badblocks_clear(&pmem->bb, sector, cleared);
> -               if (pmem->bb_state)
> -                       sysfs_notify_dirent(pmem->bb_state);
> +       phys_addr_t phys = to_phys(pmem, offset);
> +       long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
> +
> +       if (cleared > 0) {
> +               pmem_clear_hwpoison(pmem, offset, cleared);
> +               arch_invalidate_pmem(pmem->virt_addr + offset, len);
>         }
> +       return cleared;
> +}
>
> -       arch_invalidate_pmem(pmem->virt_addr + offset, len);
> +static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
> +               phys_addr_t offset, unsigned int len)
> +{
> +       long cleared = __pmem_clear_poison(pmem, offset, len);
>
> -       return rc;
> +       if (cleared < 0)
> +               return BLK_STS_IOERR;
> +
> +       pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
> +       return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;

I prefer "if / else" syntax instead of a ternary conditional.

>  }
>
>  static void write_pmem(void *pmem_addr, struct page *page,
> @@ -143,7 +169,7 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>                         sector_t sector, unsigned int len)
>  {
>         blk_status_t rc;
> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
>         if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> @@ -158,7 +184,7 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>                         struct page *page, unsigned int page_off,
>                         sector_t sector, unsigned int len)
>  {
> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
>         if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {

With those small fixups you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

