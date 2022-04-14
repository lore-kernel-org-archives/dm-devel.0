Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72679C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 02:33:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-vPt3DDhKMBiMNUMWMfDjbQ-1; Wed, 13 Apr 2022 22:33:09 -0400
X-MC-Unique: vPt3DDhKMBiMNUMWMfDjbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32B3F296A60E;
	Thu, 14 Apr 2022 02:33:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4C16404D2F6;
	Thu, 14 Apr 2022 02:33:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 997871940347;
	Thu, 14 Apr 2022 02:33:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2CD371940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 02:33:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8D5D404D2F8; Thu, 14 Apr 2022 02:33:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A69404D2F7
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:33:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAC64800882
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:33:01 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-Pn-uaX4QNf60NeIAXX9GAw-1; Wed, 13 Apr 2022 22:32:59 -0400
X-MC-Unique: Pn-uaX4QNf60NeIAXX9GAw-1
Received: by mail-pg1-f172.google.com with SMTP id k14so3572384pga.0
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 19:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YSNIpToEpKx9C/PikZnCWZV0FikRekKMo16pPMd1DpA=;
 b=pbLtEIMgIyjRzVkVHSh8eeXKsWTgcVRAT0ntk53+d0l00nv9hmd/9JZY3b2pAt+YXj
 h9KSbGxuifiozQvqauDZK3e3MV4a4r+C9uHVe5iQN7jUhXe232qOeECZwDEjp4OBgE0r
 T9vAHMbrBMAGnQBCXy0BQrh50l6Oxt9oS0pUWNQ0IsiZvDxYjXRh1XwA7Zu0PZFJh/jh
 4z22xwScIpy8BpbU+Ek/Bx1maURax7yXkHpiY2VEHFjH2LBnpEHzthZzMf4SIrpSFHQ0
 1c0h+UkFMU8SOrBm/DOuMsg5VeVBQ7KL9zM83x7lSJmlQGmV3CFPoztvaxy91E599hCO
 3JvA==
X-Gm-Message-State: AOAM532VxsuuTNiwwOtkf8Pvyig6EmLtzkJyvch8JreQs3aPtU330I7D
 MheL9uRHl336ivzjtIKLkVMfeMACmPUCdUWoIHK1Tg==
X-Google-Smtp-Source: ABdhPJyJ7+lq6DXzFoR+6irZCG4YAQlpZndZMI7bifxiTNpKl3Ag2MIF6bdalp4DUmMY3P/bAV7PO08efRdZqcY2MLQ=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr522640pgb.74.1649903578582; Wed, 13 Apr
 2022 19:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
 <CAPcyv4jx=h+1QiB0NRRQrh1mHcD2TFQx4AH6JxnQDKukZ3KVZA@mail.gmail.com>
 <b511a483-4260-656a-ab04-2ba319e65ca7@oracle.com>
In-Reply-To: <b511a483-4260-656a-ab04-2ba319e65ca7@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 19:32:47 -0700
Message-ID: <CAPcyv4jpwzMPKtzzc=DEbC340+zmzXkj+QtPVxfYbraskLKv8g@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 Mike Snitzer <snitzer@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 "dave.hansen@intel.com" <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13, 2022 at 4:36 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/11/2022 4:27 PM, Dan Williams wrote:
> > On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> The set_memory_uc() approach doesn't work well in all cases.
> >> For example, when "The VMM unmapped the bad page from guest
> >> physical space and passed the machine check to the guest."
> >> "The guest gets virtual #MC on an access to that page.
> >>   When the guest tries to do set_memory_uc() and instructs
> >>   cpa_flush() to do clean caches that results in taking another
> >>   fault / exception perhaps because the VMM unmapped the page
> >>   from the guest."
> >>
> >> Since the driver has special knowledge to handle NP or UC,
> >
> > I think a patch is needed before this one to make this statement true? I.e.:
> >
> > diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
> > index ee8d9973f60b..11641f55025a 100644
> > --- a/drivers/acpi/nfit/mce.c
> > +++ b/drivers/acpi/nfit/mce.c
> > @@ -32,6 +32,7 @@ static int nfit_handle_mce(struct notifier_block
> > *nb, unsigned long val,
> >           */
> >          mutex_lock(&acpi_desc_lock);
> >          list_for_each_entry(acpi_desc, &acpi_descs, list) {
> > +               unsigned int align = 1UL << MCI_MISC_ADDR_LSB(mce->misc);
> >                  struct device *dev = acpi_desc->dev;
> >                  int found_match = 0;
> >
> > @@ -63,8 +64,7 @@ static int nfit_handle_mce(struct notifier_block
> > *nb, unsigned long val,
> >
> >                  /* If this fails due to an -ENOMEM, there is little we can do */
> >                  nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
> > -                               ALIGN(mce->addr, L1_CACHE_BYTES),
> > -                               L1_CACHE_BYTES);
> > +                                       ALIGN(mce->addr, align), align);
> >                  nvdimm_region_notify(nfit_spa->nd_region,
> >                                  NVDIMM_REVALIDATE_POISON);
> >
>
> Dan, I tried the above change, and this is what I got after injecting 8
> back-to-back poisons, then read them and received  SIGBUS/BUS_MCEERR_AR,
> then repair via the v7 patch which works until this change is added.
>
> [ 6240.955331] nfit ACPI0012:00: XXX, align = 100
> [ 6240.960300] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
> L1_CACHE_BYTES)=1851600400, L1_CACHE_BYTES=40, ALIGN(mce->addr,
> align)=1851600400
> [..]
> [ 6242.052277] nfit ACPI0012:00: XXX, align = 100
> [ 6242.057243] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
> L1_CACHE_BYTES)=1851601000, L1_CACHE_BYTES=40, ALIGN(mce->addr,
> align)=1851601000
> [..]
> [ 6244.917198] nfit ACPI0012:00: XXX, align = 1000
> [ 6244.922258] nfit ACPI0012:00: XXX, ALIGN(mce->addr,
> L1_CACHE_BYTES)=1851601200, L1_CACHE_BYTES=40, ALIGN(mce->addr,
> align)=1851602000
> [..]
>
> All 8 poisons remain uncleared.
>
> Without further investigation, I don't know why the failure.
> Could we mark this change to a follow-on task?

Perhaps a bit more debug before kicking this can down the road...

I'm worried that this means that the driver is not accurately tracking
poison data For example, that last case the hardware is indicating a
full page clobber, but the old code would only track poison from
1851601200 to 1851601400 (i.e. the first 512 bytes from the base error
address).

Oh... wait, I think there is a second bug here, that ALIGN should be
ALIGN_DOWN(). Does this restore the result you expect?

diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index ee8d9973f60b..d7a52238a741 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -63,8 +63,7 @@ static int nfit_handle_mce(struct notifier_block
*nb, unsigned long val,

                /* If this fails due to an -ENOMEM, there is little we can do */
                nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
-                               ALIGN(mce->addr, L1_CACHE_BYTES),
-                               L1_CACHE_BYTES);
+                                       ALIGN_DOWN(mce->addr, align), align);
                nvdimm_region_notify(nfit_spa->nd_region,
                                NVDIMM_REVALIDATE_POISON);


> The driver knows a lot about how to clear poisons besides hardcoding
> poison alignment to 0x40 bytes.

It does, but the badblocks tracking should still be reliable, and if
it's not reliable I expect there are cases where recovery_write() will
not be triggered because the driver will not fail the
dax_direct_access() attempt.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

