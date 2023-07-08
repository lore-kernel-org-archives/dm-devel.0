Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDCCEB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uRaMGEhvDmUt/KnFXGhha+n+lqfwmlZQBcA11O11hoA=;
	b=aliQaw3/ikxoJKovll1aiZijhUKIaskmoTURvw/TYOwEexxLnQK6qsVa4OWKqwP9pNM2vW
	9rGyjOc62aTcszVL+UlO8gXWPHKPpDTNaQxtf7jSkTKRwKV4RPlataFU+PGzywu9OnCpXe
	sANvKcf4OfOshB2fnvrIoduiUd0tZqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-F_5g-2ygO5ql68JUD8PjxQ-1; Sat, 08 Jul 2023 00:23:10 -0400
X-MC-Unique: F_5g-2ygO5ql68JUD8PjxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50EF386F124;
	Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B9E72166B28;
	Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14DB81946A7F;
	Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5A2681946A54
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D2F0C51488; Sat,  8 Jul 2023 04:23:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 354FBC478DF
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE5FD185A791
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:06 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-tKmMcYlwPQGDFJuzucaipg-1; Sat, 08 Jul 2023 00:23:03 -0400
X-MC-Unique: tKmMcYlwPQGDFJuzucaipg-1
Received: by mail-qv1-f51.google.com with SMTP id
 6a1803df08f44-63759b5983dso16092856d6.0
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790183; x=1691382183;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=v2wkHCwd4vm+IEtkc2nWyRw52RwR9sbRYqSY91RfFRQ=;
 b=dq5NpVXkuwpmwYmddtXXvdiJE8kO2N4OhfhG3d10ZIKOA7yks+z2NP31ehum4L1uSA
 Y1ngcVEZYZgiBlrvNVLT3WuMRT/K+yr0MwuHLjNyT6zin8OL2hwspwE5NtLj1a0EkuDF
 IXB2816XgSUbjO5WytmYa9FZ38v+0Iv8DswPALgoDp7JuEibfFpkFjkmO1wbxdoCNWpL
 l2rArLiRt7X1nPDuocnsxoGFderrx5UXFtdR6GPP5PJHCyfR8RkXkXl6PHU5IK59PyOY
 91V0GGb+XL7T8PhEboUnGFPN1YYwXCF5ow0ZWYX044eVMxwlw7kV1s0hp1VBEHvVDlun
 852w==
X-Gm-Message-State: ABy/qLbdiWYPlO/Ek6IRwBGestA2ozBIUJB7V05V8KpAyHbup3DMqQvY
 lZnVjqCR7xmJstUhMbq9GPq+
X-Google-Smtp-Source: APBJJlFWAMqjvSKrvzpvEh5u1Km9iyyNH8nqnIxyj/oNE7DYqHwz4uTI1TlmaS8pzIg+8UYxptjePQ==
X-Received: by 2002:a0c:8c8a:0:b0:635:d9c0:3121 with SMTP id
 p10-20020a0c8c8a000000b00635d9c03121mr5009840qvb.0.1688790182868; 
 Fri, 07 Jul 2023 21:23:02 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 w27-20020a05620a129b00b00767c4a1e9d3sm455470qki.76.2023.07.07.21.23.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:02 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:02 -0400
Message-ID: <cbe877b3905033d2b8c7c92e6d0cad4e.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE's initial goal is to control both execution and the loading of
> kernel modules based on the system's definition of trust. It
> accomplishes this by plugging into the security hooks for
> bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> and kernel_read_data.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/eval.c  |  14 ++++
>  security/ipe/eval.h  |   1 +
>  security/ipe/hooks.c | 182 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h |  25 ++++++
>  security/ipe/ipe.c   |   6 ++
>  5 files changed, 228 insertions(+)
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h

Adding the 'hooks.h' header allows for much of code added in the
previous patches to finally compile and there are a number of errors,
too many to include here.  Please fix those and ensure that each
point in the patchset compiles cleanly.

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..d896a5a474bc
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/binfmts.h>
> +#include <linux/mman.h>
> +
> +#include "ipe.h"
> +#include "hooks.h"
> +#include "eval.h"
> +
> +/**
> + * ipe_bprm_check_security - ipe security hook function for bprm check.
> + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> + *	  being evaluated.
> + *
> + * This LSM hook is called when a binary is loaded through the exec
> + * family of system calls.
> + * Return:
> + * *0	- OK
> + * *!0	- Error
> + */
> +int ipe_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	struct ipe_eval_ctx ctx = { 0 };

It's up to you, but when you have a fequently used initializer like
this it is often wrapped in a macro:

  #define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })

... so that you can write the variable decalaration like this:

  struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;

It's not a requirement, it just tends to look a little cleaner and
should you ever need to change the initializer it makes your life
a lot easier.

> +	build_eval_ctx(&ctx, bprm->file, __IPE_OP_EXEC);
> +	return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_mmap_file - ipe security hook function for mmap check.
> + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + * @flags: Unused.
> + *
> + * This hook is called when a file is loaded through the mmap
> + * family of system calls.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> +		  unsigned long flags)

Since @reqprot is always going to be unused in this function, you
might want to mark it as such to help prevent compiler
warnings/errors, for example:

 unsigned long reqprot __always_unused

> +{
> +	struct ipe_eval_ctx ctx = { 0 };
> +
> +	if (prot & PROT_EXEC) {
> +		build_eval_ctx(&ctx, f, __IPE_OP_EXEC);
> +		return ipe_evaluate_event(&ctx);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ipe_file_mprotect - ipe security hook function for mprotect check.
> + * @vma: Existing virtual memory area created by mmap or similar.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + *
> + * This LSM hook is called when a mmap'd region of memory is changing
> + * its protections via mprotect.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,

See my comment above about @reqprot.

> +		      unsigned long prot)
> +{
> +	struct ipe_eval_ctx ctx = { 0 };
> +
> +	/* Already Executable */
> +	if (vma->vm_flags & VM_EXEC)
> +		return 0;
> +
> +	if (prot & PROT_EXEC) {
> +		build_eval_ctx(&ctx, vma->vm_file, __IPE_OP_EXEC);
> +		return ipe_evaluate_event(&ctx);
> +	}
> +
> +	return 0;
> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

