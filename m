Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D11C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 03:56:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-kSRcnQjdPFqcA859J0Zx1Q-1; Tue, 10 May 2022 23:56:41 -0400
X-MC-Unique: kSRcnQjdPFqcA859J0Zx1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1688D185A794;
	Wed, 11 May 2022 03:56:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 329941544F58;
	Wed, 11 May 2022 03:56:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DBA4F1947078;
	Wed, 11 May 2022 03:56:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE9B81947077
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 May 2022 03:56:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F4E55676D9; Wed, 11 May 2022 03:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B5235676D7
 for <dm-devel@redhat.com>; Wed, 11 May 2022 03:56:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F5B71C01B22
 for <dm-devel@redhat.com>; Wed, 11 May 2022 03:56:34 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-hvOxyfGzOiiehwSDmUULSg-1; Tue, 10 May 2022 23:56:33 -0400
X-MC-Unique: hvOxyfGzOiiehwSDmUULSg-1
Received: by mail-pl1-f180.google.com with SMTP id q4so654754plr.11
 for <dm-devel@redhat.com>; Tue, 10 May 2022 20:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=elq3ZqCelpCSxkkjk1LXdyA6w9hgB+SCHXKMgxWGx/U=;
 b=LeCFFnnKuMnNj52XvbrH+SGiDbpoXHDAEAOLncpnR2qnHvDdgBNxijJKEqOTPwoZjk
 RLTEW7YqfemORnQwd4Ivu+K7nBueidD9ORyNsTMCUK783OqKINEb4D+h7QegLv+nMI9k
 ztK1jM3zSCIfjoxEhcYuyzDZiPnpQsuizo1YppflE8aSlh7yt+WYvR/l4HrpTEB15z+8
 94RU2dYpE0MBnDpbNQAGnMYwl5ogdkijNi28aemERyq3/aZVHPTUmjA7fZLlL20igaPI
 l9jlN9rL9t3bJxaVHlpy1xLt/MMdzNbyweN0RsZLTnto+K/lzfYJoWUUlzu8rHDgK1GS
 7RzA==
X-Gm-Message-State: AOAM531AAJQBfcRhnCbPDpZ3TqEnqVsOlibjCaSAoeZzM7FUwwMf/CZk
 uPvII+wWDSxFALiGeaocJNLp5ZoTUHawJCC8PBH5Wg==
X-Google-Smtp-Source: ABdhPJw5n1KJcz8j1FP3c7A6fBBMc1hcuPZsn2gE31BtaT8knvxsmvrFDZQnLCp0J+6DmYbEonpCWUJBRb2zAP6Umfo=
X-Received: by 2002:a17:902:da8b:b0:15e:c0e8:d846 with SMTP id
 j11-20020a170902da8b00b0015ec0e8d846mr23539490plx.34.1652241391912; Tue, 10
 May 2022 20:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-4-jane.chu@oracle.com>
 <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
In-Reply-To: <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 May 2022 20:56:21 -0700
Message-ID: <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>, Borislav Petkov <bp@alien8.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v9 3/7] mce: fix set_mce_nospec to always
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, "Luck, Tony" <tony.luck@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Mike Snitzer <snitzer@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Jue Wang <juew@google.com>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Vishal L Verma <vishal.l.verma@intel.com>,
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

On Fri, Apr 22, 2022 at 4:25 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> [ Add Tony as the originator of the whole_page() logic and Jue who
> reported the issue that lead to 17fae1294ad9 x86/{mce,mm}: Unmap the
> entire page if the whole page is affected and poisoned ]
>
>
> On Fri, Apr 22, 2022 at 3:46 PM Jane Chu <jane.chu@oracle.com> wrote:
> >
> > The set_memory_uc() approach doesn't work well in all cases.
> > As Dan pointed out when "The VMM unmapped the bad page from
> > guest physical space and passed the machine check to the guest."
> > "The guest gets virtual #MC on an access to that page. When
> > the guest tries to do set_memory_uc() and instructs cpa_flush()
> > to do clean caches that results in taking another fault / exception
> > perhaps because the VMM unmapped the page from the guest."
> >
> > Since the driver has special knowledge to handle NP or UC,
> > mark the poisoned page with NP and let driver handle it when
> > it comes down to repair.
> >
> > Please refer to discussions here for more details.
> > https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
> >
> > Now since poisoned page is marked as not-present, in order to
> > avoid writing to a not-present page and trigger kernel Oops,
> > also fix pmem_do_write().
> >
> > Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Jane Chu <jane.chu@oracle.com>

Boris,

This is the last patch in this set that needs an x86 maintainer ack.
Since you have been involved in the history for most of this, mind
giving it an ack so I can pull it in for v5.19? Let me know if you
want a resend.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

