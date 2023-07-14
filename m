Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4783DC0015E
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689371232;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9BMIk8dDdbxPySUWSaPZPHvqn+O8Y7B+ufcA4E2g47E=;
	b=AD4ZCP9uRGA9RjUib6ZkOYF53hsvtNpLa8z5w6YsOo+Uzz9a5YesKMfhtnHgvX2ZHKx74D
	NFl0MdLJScIGfKIQgVu4gw+KngfsMKqcnxFm++kNUytA1i3B3j11utL+kHolJ8LRUXZk81
	Gw79XFYmy+n5rHSBztWMCe96DJGqhgc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-amyk1-usPfy4bGCw1pxrww-1; Fri, 14 Jul 2023 17:47:11 -0400
X-MC-Unique: amyk1-usPfy4bGCw1pxrww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAE7C1C05AB9;
	Fri, 14 Jul 2023 21:47:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9268010C9D;
	Fri, 14 Jul 2023 21:47:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 647D3194658F;
	Fri, 14 Jul 2023 21:47:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 421681946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 21:47:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2236B40C206F; Fri, 14 Jul 2023 21:47:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B6AF40C2063
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 21:47:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F313E856F66
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 21:47:05 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-311-XpEvqpgBP5-KSzLy0_ONJA-1; Fri,
 14 Jul 2023 17:47:04 -0400
X-MC-Unique: XpEvqpgBP5-KSzLy0_ONJA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id B253220ABD64; Fri, 14 Jul 2023 14:47:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B253220ABD64
Date: Fri, 14 Jul 2023 14:47:02 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230714214702.GC15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
 <cbe877b3905033d2b8c7c92e6d0cad4e.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <cbe877b3905033d2b8c7c92e6d0cad4e.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH RFC v10 4/17] ipe: add LSM hooks on execution
 and kernel read
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:02AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE's initial goal is to control both execution and the loading of
> > kernel modules based on the system's definition of trust. It
> > accomplishes this by plugging into the security hooks for
> > bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> > and kernel_read_data.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/eval.c  |  14 ++++
> >  security/ipe/eval.h  |   1 +
> >  security/ipe/hooks.c | 182 +++++++++++++++++++++++++++++++++++++++++++
> >  security/ipe/hooks.h |  25 ++++++
> >  security/ipe/ipe.c   |   6 ++
> >  5 files changed, 228 insertions(+)
> >  create mode 100644 security/ipe/hooks.c
> >  create mode 100644 security/ipe/hooks.h
> 
> Adding the 'hooks.h' header allows for much of code added in the
> previous patches to finally compile and there are a number of errors,
> too many to include here.  Please fix those and ensure that each
> point in the patchset compiles cleanly.
> 
Sorry again for the mistake I made here.

> > diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> > new file mode 100644
> > index 000000000000..d896a5a474bc
> > --- /dev/null
> > +++ b/security/ipe/hooks.c
> > @@ -0,0 +1,182 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/mman.h>
> > +
> > +#include "ipe.h"
> > +#include "hooks.h"
> > +#include "eval.h"
> > +
> > +/**
> > + * ipe_bprm_check_security - ipe security hook function for bprm check.
> > + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> > + *	  being evaluated.
> > + *
> > + * This LSM hook is called when a binary is loaded through the exec
> > + * family of system calls.
> > + * Return:
> > + * *0	- OK
> > + * *!0	- Error
> > + */
> > +int ipe_bprm_check_security(struct linux_binprm *bprm)
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> 
> It's up to you, but when you have a fequently used initializer like
> this it is often wrapped in a macro:
> 
>   #define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })
> 
> ... so that you can write the variable decalaration like this:
> 
>   struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> 
> It's not a requirement, it just tends to look a little cleaner and
> should you ever need to change the initializer it makes your life
> a lot easier.
> 
Yes I agree this looks way better, I will update all the context init.

> > +	build_eval_ctx(&ctx, bprm->file, __IPE_OP_EXEC);
> > +	return ipe_evaluate_event(&ctx);
> > +}
> > +
> > +/**
> > + * ipe_mmap_file - ipe security hook function for mmap check.
> > + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *	  system configuration.
> > + * @flags: Unused.
> > + *
> > + * This hook is called when a file is loaded through the mmap
> > + * family of system calls.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Error
> > + */
> > +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> > +		  unsigned long flags)
> 
> Since @reqprot is always going to be unused in this function, you
> might want to mark it as such to help prevent compiler
> warnings/errors, for example:
> 
>  unsigned long reqprot __always_unused
> 
Thanks for telling me this useful mark! I will add it.

-Fan
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> > +
> > +	if (prot & PROT_EXEC) {
> > +		build_eval_ctx(&ctx, f, __IPE_OP_EXEC);
> > +		return ipe_evaluate_event(&ctx);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ipe_file_mprotect - ipe security hook function for mprotect check.
> > + * @vma: Existing virtual memory area created by mmap or similar.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *	  system configuration.
> > + *
> > + * This LSM hook is called when a mmap'd region of memory is changing
> > + * its protections via mprotect.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Error
> > + */
> > +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> 
> See my comment above about @reqprot.
> 
> > +		      unsigned long prot)
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> > +
> > +	/* Already Executable */
> > +	if (vma->vm_flags & VM_EXEC)
> > +		return 0;
> > +
> > +	if (prot & PROT_EXEC) {
> > +		build_eval_ctx(&ctx, vma->vm_file, __IPE_OP_EXEC);
> > +		return ipe_evaluate_event(&ctx);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

