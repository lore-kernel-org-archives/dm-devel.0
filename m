Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183A679C7
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmypWiyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119594;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9D20GBuYY3uJJiQrbUxHHBPEASCxtbko8RJ2E48OU8Y=;
	b=bmypWiyzwK+/vDZaNzc/xS4fDU6WKGlNEPCMe35faHvWgemmy7RNUm47W3YSNhLF5eVMzS
	NnQF6v3MnCgovm6hujaReK7zrFBE9WYRR5fJS64Fa0YWFKeGcyoFy5xYNk7dIMzPEZTXZ2
	59/sfJiyypM0wYBXvkW7cBHf0DCsC28=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-g-_X2aqDNeStrvJOOcIYHg-1; Mon,
 23 Oct 2023 23:52:57 -0400
X-MC-Unique: g-_X2aqDNeStrvJOOcIYHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 362DF38143A4
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F13825C2
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0FBEE1946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CCD321946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B14E51C060B6; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9D811C060AE
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857B6280604A
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-GWhvVSz-M2aI_x2l-JvYig-1; Mon, 23 Oct 2023 23:52:29 -0400
X-MC-Unique: GWhvVSz-M2aI_x2l-JvYig-1
Received: by mail-qv1-f46.google.com with SMTP id
 6a1803df08f44-66cee0d62fbso29202966d6.3
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119549; x=1698724349;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9D20GBuYY3uJJiQrbUxHHBPEASCxtbko8RJ2E48OU8Y=;
 b=ap/1FLW40mJEAyR8D8o3ch0vyhqMs7ZYpTnN/+UleeNACTTVkF4vKBG1KEmJ58ZaHM
 njLqsxV2c7VeRILTskShCiy1+UsAhyBXcuzFyyUXBKbCjXD15+CcF0BdmGpXke5fx2l1
 9FaSvZ/kTvPIS66xPrBxF6FHP4V0CONW9IwtxjFEkIF8X7jFwoFJle9B+ExdnV3PgsEn
 aafKYqb4F/iHYL26X4yevxpTeFMYFFkhYMqX4snNREgGaI8AGlN+7dcu8lmKA3xHmnx/
 KpRqH7fGVdpB+1jDkMN4JIs0FrGoOZCHPCiyFOhBujte6ulqyHNMjEyMdQAygoSKq8P4
 Q3sA==
X-Gm-Message-State: AOJu0YwI9E+hpaxkckEdGkqU+aON8DYEXKvFc0ISAW3Ubw3XMYZGzpWH
 es8u7/7ts5xc9NNi1H/peJKI
X-Google-Smtp-Source: AGHT+IFpIqqh1fB4hnxmAOL2NoddL/lzIp7ju14Dk5onQmmR8wOSeU2mbOH9yH4fSAzqdyjSPcWQFA==
X-Received: by 2002:ad4:5bcd:0:b0:65b:896:a5bb with SMTP id
 t13-20020ad45bcd000000b0065b0896a5bbmr13586438qvt.34.1698119549271; 
 Mon, 23 Oct 2023 20:52:29 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 c15-20020a0cd60f000000b00658266be23fsm3330187qvj.41.2023.10.23.20.52.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:28 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:28 -0400
Message-ID: <1ef52e983dd5b9a7759dc76bfe156804.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 9/19] ipe: add permissive toggle
References: <1696457386-3010-10-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-10-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
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
> IPE, like SELinux, supports a permissive mode. This mode allows policy
> authors to test and evaluate IPE policy without it effecting their
> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> be reported.
> 
> This patch adds the following audit records:
> 
>     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> 
> The audit record only emit when the value from the user input is
> different from the current enforce value.
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
>   + Further split lsm creation into a separate commit from the
>     evaluation loop and audit system, for easier review.
>   + Propagating changes to support the new ipe_context structure in the
>     evaluation loop.
>   + Split out permissive functionality into a separate patch for easier
>     review.
>   + Remove permissive switch compile-time configuration option - this
>     is trivial to add later.
> 
> v8:
>   + Remove "IPE" prefix from permissive audit record
>   + align fields to the linux-audit field dictionary. This causes the
>     following fields to change:
>       enforce -> permissive
> 
>   + Remove duplicated information correlated with syscall record, that
>     will always be present in the audit event.
>   + Change audit types:
>     + AUDIT_TRUST_STATUS -> AUDIT_MAC_STATUS
>       + There is no significant difference in meaning between
>         these types.
> 
> v9:
>   + Clean up ipe_context related code
> 
> v10:
>   + Change audit format to comform with the existing format selinux is
>     using
>   + Remove the audit record emission during init to align with selinux,
>     which does not perform this action.
> 
> v11:
>   + Remove redundant code
> ---
>  security/ipe/audit.c | 22 ++++++++++++++
>  security/ipe/audit.h |  1 +
>  security/ipe/eval.c  | 14 +++++++--
>  security/ipe/eval.h  |  1 +
>  security/ipe/fs.c    | 68 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 104 insertions(+), 2 deletions(-)

...

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 499b6b3338f2..78c54ff1fdd3 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -167,9 +172,12 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>  	ipe_audit_match(ctx, match_type, action, rule);
>  
>  	if (action == IPE_ACTION_DENY)
> -		return -EACCES;
> +		rc = -EACCES;
> +
> +	if (!enforcing)
> +		rc = 0;

Why the local @enforcing variable?  Why not:

  if (!READ_ONCE(enforce))
    rc = 0;

> -	return 0;
> +	return rc;
>  }
>  
>  /**
> @@ -198,3 +206,5 @@ void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
>  
>  module_param(success_audit, bool, 0400);
>  MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
> +module_param(enforce, bool, 0400);
> +MODULE_PARM_DESC(enforce, "Start IPE in enforce or permissive mode");

"enforcing"

--
paul-moore.com

