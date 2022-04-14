Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8A4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 02:02:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-KMqtGfLiNsmGGR6Nn6teRQ-1; Wed, 13 Apr 2022 22:02:22 -0400
X-MC-Unique: KMqtGfLiNsmGGR6Nn6teRQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A0F829DD9B5;
	Thu, 14 Apr 2022 02:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8C26111D3CC;
	Thu, 14 Apr 2022 02:02:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B6F91940347;
	Thu, 14 Apr 2022 02:02:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A5BD1940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 02:02:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 598531457F14; Thu, 14 Apr 2022 02:02:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55C681457F13
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:02:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CF3C38041C8
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:02:17 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-UdbKUU2OOJCZToEPJClDsQ-1; Wed, 13 Apr 2022 22:02:15 -0400
X-MC-Unique: UdbKUU2OOJCZToEPJClDsQ-1
Received: by mail-pj1-f47.google.com with SMTP id
 j8-20020a17090a060800b001cd4fb60dccso4277745pjj.2
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 19:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Z/AZcNPpuzZDgumlPPShqA1y0wj8q3uDg5REQ7nWe+g=;
 b=fRwsD5hUMM73TJuJNl1aNwgUfFPEKXKlNhFi7bYkQUdgn81eabfaZP7ZwTS7+zJJ1k
 eXmKfnxiUbQ4GM52ZivTUC5PrHAqiTBc4dbIKaPtRqVNW23MWkcAVWne54dJYzjLmbDO
 o4fkETEfN1lXqCgrHFt3rvxzwxp4wUB7UMc1aP1y/brS+xunOmTpdKAmy6rXTlvB3l/z
 lMGi6mcyGfCCjEwEbcx3PBkCOwM44B5XEqSoaP1+eBAqpVF+fmawD0reCDk+g6pCmczz
 zxyCP9X816iWlMwPOMwEvlqMwTdgRMVDY6bccxAndGJHI2V7rkUNGE1KvleGZQzxDBL+
 L5Zw==
X-Gm-Message-State: AOAM530fYlnZzBJhGaSvsK4kZxRKW4hegK+xIkHwbLYpn6cAyOcIhNkH
 YurEccYVkI9ibYJpN2kLDh/jPZhRekhkNLiq7Uc0gQ==
X-Google-Smtp-Source: ABdhPJwLDKKH3DT9JFgarja/Tnh6p2mmAGJ/wOpJuSGyolYLRI59NHTREVIMzFOVSkYOQVAxzofLTctfLriOkXyPajc=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr1171605pjd.220.1649901734577; Wed, 13
 Apr 2022 19:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-6-jane.chu@oracle.com>
 <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com>
 <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
In-Reply-To: <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 19:02:03 -0700
Message-ID: <CAPcyv4jrtUDf0zPB8aefVs2MsV8tW2Kmx2yq3D4ze2wr7SshsA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/11/2022 9:26 PM, Dan Williams wrote:
> > On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> Refactor the pmem_clear_poison() in order to share common code
> >> later.
> >>
> >
> > I would just add a note here about why, i.e. to factor out the common
> > shared code between the typical write path and the recovery write
> > path.
>
> Okay.
>
> >
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> >> ---
> >>   drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
> >>   1 file changed, 52 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index 0400c5a7ba39..56596be70400 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
> >>          return to_nd_region(to_dev(pmem)->parent);
> >>   }
> >>
> >> -static void hwpoison_clear(struct pmem_device *pmem,
> >> -               phys_addr_t phys, unsigned int len)
> >> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
> >>   {
> >> +       return (pmem->phys_addr + offset);
> >
> > Christoph already mentioned dropping the unnecessary parenthesis.
> >
> >> +}
> >> +
> >> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> >> +{
> >> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
> >> +}
> >> +
> >> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> >> +{
> >> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
> >> +}
> >> +
> >> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> >> +               unsigned int len)
> >
> > Perhaps now is a good time to rename this to something else like
> > pmem_clear_mce_nospec()? Just to make it more distinct from
> > pmem_clear_poison(). While "hwpoison" is the page flag name
> > pmem_clear_poison() is the function that's actually clearing the
> > poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
> > toggling the page back into service.
>
> I get your point. How about calling the function explicitly
> pmem_mkpage_present()?

Sure, I like pmem_mkpage_present().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

