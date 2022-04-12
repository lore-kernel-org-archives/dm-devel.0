Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95704C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:08:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-hbdHYnxUMFu2wh9zhVBFNg-1; Tue, 12 Apr 2022 06:07:58 -0400
X-MC-Unique: hbdHYnxUMFu2wh9zhVBFNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ECFE3C01B8E;
	Tue, 12 Apr 2022 10:07:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1509F40BAE6;
	Tue, 12 Apr 2022 10:07:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B60551940365;
	Tue, 12 Apr 2022 10:07:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83D831947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 10:07:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7258F42623F; Tue, 12 Apr 2022 10:07:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ACEB54AC8C
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:07:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53576801E80
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:07:55 +0000 (UTC)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-WQkrUTT1M1S7c1uDIAGiGQ-1; Tue, 12 Apr 2022 06:07:51 -0400
X-MC-Unique: WQkrUTT1M1S7c1uDIAGiGQ-1
Received: from zn.tnic (p200300ea97156149329c23fffea6a903.dip0.t-ipconnect.de
 [IPv6:2003:ea:9715:6149:329c:23ff:fea6:a903])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9608C1EC04EC;
 Tue, 12 Apr 2022 12:07:45 +0200 (CEST)
Date: Tue, 12 Apr 2022 12:07:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YlVPcrK4SSXyPx+Y@zn.tnic>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220405194747.2386619-4-jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
 djwong@kernel.org, x86@kernel.org, david@fromorbit.com,
 linux-kernel@vger.kernel.org, willy@infradead.org, hch@infradead.org,
 dm-devel@redhat.com, vgoyal@redhat.com, vishal.l.verma@intel.com,
 linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, ira.weiny@intel.com,
 linux-xfs@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 05, 2022 at 01:47:44PM -0600, Jane Chu wrote:
> The set_memory_uc() approach doesn't work well in all cases.
> For example, when "The VMM unmapped the bad page from guest
> physical space and passed the machine check to the guest."
> "The guest gets virtual #MC on an access to that page.
>  When the guest tries to do set_memory_uc() and instructs
>  cpa_flush() to do clean caches that results in taking another
>  fault / exception perhaps because the VMM unmapped the page
>  from the guest."

I presume this is quoting someone...

> Since the driver has special knowledge to handle NP or UC,
> let's mark the poisoned page with NP and let driver handle it

s/let's mark/mark/

> when it comes down to repair.
> 
> Please refer to discussions here for more details.
> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
> 
> Now since poisoned page is marked as not-present, in order to
> avoid writing to a 'np' page and trigger kernel Oops, also fix

You can write it out: "non-present page..."

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

For such mixed subsystem patches we probably should talk about who picks
them up, eventually...

> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index 981496e6bc0e..fa67bb9d1afe 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
>  
>  	pfn = mce->addr >> PAGE_SHIFT;
>  	if (!memory_failure(pfn, 0)) {
> -		set_mce_nospec(pfn, whole_page(mce));
> +		set_mce_nospec(pfn);
>  		mce->kflags |= MCE_HANDLED_UC;
>  	}
>  
> @@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
>  
>  	ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
>  	if (!ret) {
> -		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>  		sync_core();
>  		return;
>  	}
> @@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
>  	p->mce_count = 0;
>  	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
>  	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
> -		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
> +		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
>  }

Both that ->mce_whole_page and whole_page() look unused after this.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

