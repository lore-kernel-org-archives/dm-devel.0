Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B04C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 17:06:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-Kv4sZoFhPWyEaGW2Rgvbzw-1; Wed, 20 Apr 2022 13:06:16 -0400
X-MC-Unique: Kv4sZoFhPWyEaGW2Rgvbzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D321811E83;
	Wed, 20 Apr 2022 17:06:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BB55145BA44;
	Wed, 20 Apr 2022 17:06:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3050C1949763;
	Wed, 20 Apr 2022 17:06:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C46D719451EC
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 17:06:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 779A6550A32; Wed, 20 Apr 2022 17:06:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73B1054F895
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 17:06:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B8AC900768
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 17:06:12 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-ufRIMJ7cNgm0UYZvUFpy4g-1; Wed, 20 Apr 2022 13:06:10 -0400
X-MC-Unique: ufRIMJ7cNgm0UYZvUFpy4g-1
Received: by mail-pg1-f170.google.com with SMTP id x191so2164995pgd.4
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 10:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=S6WRgsV29at1u8BYECoaCAIUEhBO/TRLPFjdvW2DSKY=;
 b=WOVt3K62dv7WwLAInqMB8m1mWXhLqHm1U3tFCrMI3JaZC2c2MmlE5RzUXaQSZaGYmg
 ZNG9hgaeF5BDLpT1qldsed8l9EWoE7JX0uJnOUdMsCdEKiz6X7eKEp/iJg4KV6WqNuuW
 5ohr5aLUFb+zTMX8QLl2QCkNHdPTxINutSBphMMJ82T6NevSGuyp0XZLFzs9f1y/9SEB
 4bG+mNiSilWx/xOcg8RFDP27EzDdInpG1Ojb3fxH+jSTKmo7v50EOriAafXtYhiSP2Fc
 x0iZbS2dowl8CXWggCi+AueYtVRndv0WuU5tzCI6iZcN7Z/hsLTrDCAzzlEGBghhSe9T
 x9Uw==
X-Gm-Message-State: AOAM530VunidqjbKEZAk4YobuSSUvDf7KXag+imfxrPSYBsbyzav5Cwy
 ygQOHIio0+bRUv/egFCkna+hk/nPObH4f89FLiLlag==
X-Google-Smtp-Source: ABdhPJzjQxymGokqig+0dj9VMt0ZqpBg1SOZJb6EMhrcm6mpZ6hjDlL3AyoRVlLWi7CJ5RGG6wX7y+j7PIoYCPOrIBE=
X-Received: by 2002:a05:6a00:2992:b0:505:cf4b:baef with SMTP id
 cj18-20020a056a00299200b00505cf4bbaefmr24081084pfb.61.1650474369443; Wed, 20
 Apr 2022 10:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-8-jane.chu@oracle.com>
 <CAPcyv4gs2rEs71c6Lmtk1La2g3POhzBrppLvM0pkGxx+QZ3SbA@mail.gmail.com>
 <d48f9641-30e3-f459-2376-386c28a69026@oracle.com>
In-Reply-To: <d48f9641-30e3-f459-2376-386c28a69026@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Apr 2022 10:05:58 -0700
Message-ID: <CAPcyv4jTqBo+hRuza0WQhmn=D3uyOWU9u2dtk2C=AXYDqeMh5w@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v8 7/7] pmem: implement pmem_recovery_write()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 20, 2022 at 10:02 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/19/2022 11:26 PM, Dan Williams wrote:
> > On Tue, Apr 19, 2022 at 7:06 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> The recovery write thread started out as a normal pwrite thread and
> >> when the filesystem was told about potential media error in the
> >> range, filesystem turns the normal pwrite to a dax_recovery_write.
> >>
> >> The recovery write consists of clearing media poison, clearing page
> >> HWPoison bit, reenable page-wide read-write permission, flush the
> >> caches and finally write.  A competing pread thread will be held
> >> off during the recovery process since data read back might not be
> >> valid, and this is achieved by clearing the badblock records after
> >> the recovery write is complete. Competing recovery write threads
> >> are serialized by pmem device level .recovery_lock.
> >>
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> >> ---
> >>   drivers/nvdimm/pmem.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
> >>   drivers/nvdimm/pmem.h |  1 +
> >>   2 files changed, 56 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index c3772304d417..134f8909eb65 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -332,10 +332,63 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
> >>          return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
> >>   }
> >>
> >> +/*
> >> + * The recovery write thread started out as a normal pwrite thread and
> >> + * when the filesystem was told about potential media error in the
> >> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
> >> + *
> >> + * The recovery write consists of clearing media poison, clearing page
> >> + * HWPoison bit, reenable page-wide read-write permission, flush the
> >> + * caches and finally write.  A competing pread thread will be held
> >> + * off during the recovery process since data read back might not be
> >> + * valid, and this is achieved by clearing the badblock records after
> >> + * the recovery write is complete. Competing recovery write threads
> >> + * are serialized by pmem device level .recovery_lock.
> >> + */
> >>   static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> >>                  void *addr, size_t bytes, struct iov_iter *i)
> >>   {
> >> -       return 0;
> >> +       struct pmem_device *pmem = dax_get_private(dax_dev);
> >> +       size_t olen, len, off;
> >> +       phys_addr_t pmem_off;
> >> +       struct device *dev = pmem->bb.dev;
> >> +       long cleared;
> >> +
> >> +       off = offset_in_page(addr);
> >> +       len = PFN_PHYS(PFN_UP(off + bytes));
> >> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
> >> +               return _copy_from_iter_flushcache(addr, bytes, i);
> >> +
> >> +       /*
> >> +        * Not page-aligned range cannot be recovered. This should not
> >> +        * happen unless something else went wrong.
> >> +        */
> >> +       if (off || !PAGE_ALIGNED(bytes)) {
> >> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
> >> +                       addr, bytes);
> >
> > If this warn stays:
> >
> > s/dev_warn/dev_warn_ratelimited/
> >
> > The kernel prints hashed addresses for %p, so I'm not sure printing
> > @addr is useful or @bytes because there is nothing actionable that can
> > be done with that information in the log. @pgoff is probably the only
> > variable worth printing (after converting to bytes or sectors) as that
> > might be able to be reverse mapped back to the impacted data.
>
> The intention with printing @addr and @bytes is to show the
> mis-alignment. In the past when UC- was set on poisoned dax page,
> returning less than a page being written would cause dax_iomap_iter to
> produce next iteration with @addr and @bytes not-page-aligned.  Although
> UC- doesn't apply here, I thought it might still be worth while to watch
> for similar scenario.  Also that's why @pgoff isn't helpful.
>
> How about s/dev_warn/dev_dbg/ ?
>
> >
> >> +               return 0;
> >> +       }
> >> +
> >> +       mutex_lock(&pmem->recovery_lock);
> >> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> >> +       cleared = __pmem_clear_poison(pmem, pmem_off, len);
> >> +       if (cleared > 0 && cleared < len) {
> >> +               dev_warn(dev, "poison cleared only %ld out of %lu bytes\n",
> >> +                       cleared, len);
> >
> > This looks like dev_dbg() to me, or at minimum the same
> > dev_warn_ratelimited() print as the one above to just indicate a write
> > to the device at the given offset failed.
>
> Will s/dev_warn/dev_dbg/
>
> >
> >> +               mutex_unlock(&pmem->recovery_lock);
> >> +               return 0;
> >> +       }
> >> +       if (cleared < 0) {
> >> +               dev_warn(dev, "poison clear failed: %ld\n", cleared);
> >
> > Same feedback here, these should probably all map to the identical
> > error exit ratelimited print.
>
> Will s/dev_warn/dev_dbg/
>
> >
> >> +               mutex_unlock(&pmem->recovery_lock);
> >
> > It occurs to me that all callers of this are arriving through the
> > fsdax iomap ops and all of these callers take an exclusive lock to
> > prevent simultaneous access to the inode. If recovery_write() is only
> > used through that path then this lock is redundant. Simultaneous reads
> > are protected by the fact that the badblocks are cleared last. I think
> > this can wait to add the lock when / if a non-fsdax access path
> > arrives for dax_recovery_write(), and even then it should probably
> > enforce the single writer exclusion guarantee of the fsdax path.
> >
>
> Indeed, the caller dax_iomap_rw has already held the writer lock.
>
> Will remove .recovery_lock for now.
>
> BTW, how are the other patches look to you?

First pass looked good, so I'll do one more lookover, but this is
coming together nicely. Thanks for all the effort on this!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

