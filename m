Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDFB7490
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBeHVgpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119558;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pxmiAw9v0MVA3JaImbhJkd/ZdwTT2GQ+ukfNRy8bQak=;
	b=XBeHVgpJ2AAiOlMR089yzae51T1KGd+3c4hM4l9paqXJrExEziYG7utCzMcyXQ83MZqiwU
	ICy/SmR0osofYwEEj4txHK/UVGPWrRiP588Nqq/Jyk09oOVPOmmESdLWV22aaEBHbSVZT1
	0fsppPdGPg/Emirk5+SMAPQ6L/QEq5M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-KjqMZZ50MIegAhdLEn-6Lw-1; Mon, 23 Oct 2023 23:52:37 -0400
X-MC-Unique: KjqMZZ50MIegAhdLEn-6Lw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F19AF80F8F7
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E98C0492BFB
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1EA01946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4FDC194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D37801121320; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBC361121318
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4167185A7A2
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-37Z6DqgCPlS9rpaIjVo8sg-1; Mon, 23 Oct 2023 23:52:25 -0400
X-MC-Unique: 37Z6DqgCPlS9rpaIjVo8sg-1
Received: by mail-qv1-f48.google.com with SMTP id
 6a1803df08f44-66d122e0c85so25461436d6.3
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119545; x=1698724345;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=pxmiAw9v0MVA3JaImbhJkd/ZdwTT2GQ+ukfNRy8bQak=;
 b=XgGmu0q4pzvC4P32Jf50DkIxr1FvXv2ZsuQBLV4qEgeBvXuFyBC4fGanW5kedaGNGQ
 0mKNs4mO3c5ScNaNT55osI222lwbFw/3g2kaOMxhFyrX05uAhpG0UK5FK2WE18UFHpO6
 I2b3k+oi9/VkvoEOeqG9Xa4GkMCjhU3KklMBz/n4PKn+5CnRTNU4/sx4sT1k+ayWsBKL
 gHx/LLiY//BKUKhlvk/ORkBfyXTKJwtb4fi+8/fVWXdxJ0rxEKWLMwIhJC40pI8Vzopa
 ttJs0OpUwC943n8k5P+RVyTVenMBsz0V+lUXDWNeh/84cFuwK4nfKtZZCqj45Z0M6Ikc
 wlwA==
X-Gm-Message-State: AOJu0Yyuw5kCoACtSpk/932TkzxvVJ1txwO+2Ste9yYWei7c2UGdeBOE
 IEO8UA1ZueD/vAcsb0HefzmB
X-Google-Smtp-Source: AGHT+IGtwY2oz/wgwv3J5Ra2yN8YlTA/mtD64ScMKcClxTGhlmWa8YZM7v6uqs3IwKjvRFLtsuevkA==
X-Received: by 2002:ad4:4ee1:0:b0:656:4a21:2c5a with SMTP id
 dv1-20020ad44ee1000000b006564a212c5amr15142920qvb.9.1698119545121; 
 Mon, 23 Oct 2023 20:52:25 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 ep5-20020a05621418e500b0065afedf3aabsm3342527qvb.48.2023.10.23.20.52.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:24 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:24 -0400
Message-ID: <46922873bd020f8cd443b7fca59ef802.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 4/19] ipe: add LSM hooks on execution and kernel
 read
References: <1696457386-3010-5-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-5-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
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
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move ipe_load_properties to patch 04.
>   + Remove useless 0-initializations
>   + Prefix extern variables with ipe_
>   + Remove kernel module parameters, as these are
>     exposed through sysctls.
>   + Add more prose to the IPE base config option
>     help text.
>   + Use GFP_KERNEL for audit_log_start.
>   + Remove unnecessary caching system.
>   + Remove comments from headers
>   + Use rcu_access_pointer for rcu-pointer null check
>   + Remove usage of reqprot; use prot only.
>   + Move policy load and activation audit event to 03/12
> 
> v4:
>   + Remove sysctls in favor of securityfs nodes
>   + Re-add kernel module parameters, as these are now
>     exposed through securityfs.
>   + Refactor property audit loop to a separate function.
> 
> v5:
>   + fix minor grammatical errors
>   + do not group rule by curly-brace in audit record,
>     reconstruct the exact rule.
> 
> v6:
>   + No changes
> 
> v7:
>   + Further split lsm creation, the audit system, the evaluation loop
>     and access control hooks into separate commits.
> 
> v8:
>   + Rename hook functions to follow the lsmname_hook_name convention
>   + Remove ipe_hook enumeration, can be derived from correlation with
>     syscall audit record.
> 
> v9:
>   + Minor changes for adapting to the new parser
> 
> v10:
>   + Remove @reqprot part
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/Makefile |   1 +
>  security/ipe/eval.c   |  14 ++++
>  security/ipe/eval.h   |   3 +
>  security/ipe/hooks.c  | 183 ++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h  |  25 ++++++
>  security/ipe/ipe.c    |   6 ++
>  6 files changed, 232 insertions(+)
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h

...

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..6164a9b53361
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +/**
> + * ipe_kernel_read_file - ipe security hook function for kernel read.
> + * @file: Supplies a pointer to the file structure being read in from disk.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * This LSM hook is called when a file is being read in from disk from
> + * the kernel.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
> +			 bool contents)
> +{
> +	enum ipe_op_type op;
> +	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> +
> +	switch (id) {
> +	case READING_FIRMWARE:
> +		op = IPE_OP_FIRMWARE;
> +		break;
> +	case READING_MODULE:
> +		op = IPE_OP_KERNEL_MODULE;
> +		break;
> +	case READING_KEXEC_INITRAMFS:
> +		op = IPE_OP_KEXEC_INITRAMFS;
> +		break;
> +	case READING_KEXEC_IMAGE:
> +		op = IPE_OP_KEXEC_IMAGE;
> +		break;
> +	case READING_POLICY:
> +		op = IPE_OP_IMA_POLICY;
> +		break;
> +	case READING_X509_CERTIFICATE:
> +		op = IPE_OP_IMA_X509;
> +		break;
> +	default:
> +		op = IPE_OP_INVALID;
> +		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);

I'm not sure you need to test @op above since you set @op on the line
above, just use true/1 to simplify things.  It also seems like it
might be helpful to provice some context for the enum above in the
WARN() message.  For example:

  WARN(1, "no rule setup for kernel_read_file %d", id);

> +	}
> +
> +	build_eval_ctx(&ctx, file, op);
> +	return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_kernel_load_data - ipe security hook function for kernel load data.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * This LSM hook is called when a buffer is being read in from disk.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
> +{
> +	enum ipe_op_type op;
> +	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> +
> +	switch (id) {
> +	case LOADING_FIRMWARE:
> +		op = IPE_OP_FIRMWARE;
> +		break;
> +	case LOADING_MODULE:
> +		op = IPE_OP_KERNEL_MODULE;
> +		break;
> +	case LOADING_KEXEC_INITRAMFS:
> +		op = IPE_OP_KEXEC_INITRAMFS;
> +		break;
> +	case LOADING_KEXEC_IMAGE:
> +		op = IPE_OP_KEXEC_IMAGE;
> +		break;
> +	case LOADING_POLICY:
> +		op = IPE_OP_IMA_POLICY;
> +		break;
> +	case LOADING_X509_CERTIFICATE:
> +		op = IPE_OP_IMA_X509;
> +		break;
> +	default:
> +		op = IPE_OP_INVALID;
> +		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);

See my comments in ipe_kernel_read_file(), they also apply here.

> +	}
> +
> +	build_eval_ctx(&ctx, NULL, op);
> +	return ipe_evaluate_event(&ctx);
> +}

--
paul-moore.com

