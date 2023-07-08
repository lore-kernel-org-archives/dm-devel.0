Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A4AEB64DC
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U1QgRKTl9+H5IbIpjqfYPrXaUsObrH9w3pqEy+DSBh4=;
	b=hOH2KU1/yKyfz3T0G/E3HN4N/0OaQhWGr6jUzSDgJUHAf9Iv+W3zMvjw1UlYm0TDIxxw4H
	p2ENNOeUt2dU6/6N3MpBzob2wkW3/kEN9odpVPkKYISndb8G/EQ+6D341eKKU5a+isKh3l
	i6J1BgH4fytx24PweQO/0iCOrRR0Ixw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-71hpS4cDPTqisax5LbDhKw-1; Sat, 08 Jul 2023 01:37:02 -0400
X-MC-Unique: 71hpS4cDPTqisax5LbDhKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EE9C28237D3;
	Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2674BF5CFF;
	Sat,  8 Jul 2023 05:37:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E05F81946A61;
	Sat,  8 Jul 2023 05:36:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2F8B1946A5E
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:36:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0C652166B26; Sat,  8 Jul 2023 05:36:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A72E02166B25
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:36:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F16638041C8
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:36:57 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-0C4AboIxPJaiUjC6ml4_cQ-1; Sat, 08 Jul 2023 01:36:55 -0400
X-MC-Unique: 0C4AboIxPJaiUjC6ml4_cQ-1
Received: by mail-qk1-f172.google.com with SMTP id
 af79cd13be357-766fd5f9536so208871285a.3
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794615; x=1691386615;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/6X+3H1ljfy7IjsbLjk8teqFst7rLlyJv0xIACsaZ2M=;
 b=MTDI8tFup43HC1M9v0y2mPqcd4r9XXY17AlZuTKpRP3B59YsozZtKfwJThnKXkqWEg
 egxTTf91PbfxhyYvOLW6/E58wG1LNuuTDOJC+V4PV86eL4B8CX0ddMtVoM++fpbQlY9t
 w38tPA4r6OpgIv+JOaLFLmMwmjWuiXqGBzxq7oWrDpXFuYmKd6/YPEFHVxfVwASCv37f
 lqBKfQYZ4IXEwUBGv7nuWkIeCb4qpczgP7HLfqIBxnoA9+b4wprsOan4nAEYz+sPynH+
 eKA4GXDeyfjSJxOAYIy7fHq0WfRzU7XdgVpWhXcs2ytNXX0LLQOF/77s18fGikUAaYb+
 BN+Q==
X-Gm-Message-State: ABy/qLYykOrd530StJPjNyP08WGQv8ihjfyNPIerXt9Rr//9RcfJ6B9j
 PvPSeiz0l+SpbpiCysfrvhQh
X-Google-Smtp-Source: APBJJlG+a1EKnj+jvMEDInNdvc1r1W/hz+0/12Nwm+mpbZz0DyPSVNjr9MqOf37m7Bq8n/2COLAfQA==
X-Received: by 2002:a05:620a:4051:b0:767:923:48d8 with SMTP id
 i17-20020a05620a405100b00767092348d8mr6721872qko.27.1688794615250; 
 Fri, 07 Jul 2023 22:36:55 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 c11-20020ae9e20b000000b0075cebaa1540sm2479491qkc.58.2023.07.07.22.36.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:36:54 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:36:54 -0400
Message-ID: <b460c0317dfbd5b4668015e104ea3e92.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-2-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-2-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH RFC v10 1/17] security: add ipe lsm
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Integrity Policy Enforcement (IPE) is an LSM that provides an
> complimentary approach to Mandatory Access Control than existing LSMs
> today.
> 
> Existing LSMs have centered around the concept of access to a resource
> should be controlled by the current user's credentials. IPE's approach,
> is that access to a resource should be controlled by the system's trust
> of a current resource.
> 
> The basis of this approach is defining a global policy to specify which
> resource can be trusted.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  MAINTAINERS           |  7 +++++++
>  security/Kconfig      | 11 ++++++-----
>  security/Makefile     |  1 +
>  security/ipe/Kconfig  | 17 +++++++++++++++++
>  security/ipe/Makefile | 10 ++++++++++
>  security/ipe/ipe.c    | 37 +++++++++++++++++++++++++++++++++++++
>  security/ipe/ipe.h    | 16 ++++++++++++++++
>  7 files changed, 94 insertions(+), 5 deletions(-)
>  create mode 100644 security/ipe/Kconfig
>  create mode 100644 security/ipe/Makefile
>  create mode 100644 security/ipe/ipe.c
>  create mode 100644 security/ipe/ipe.h

...

> diff --git a/MAINTAINERS b/MAINTAINERS
> index a82795114ad4..ad00887d38ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10278,6 +10278,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
>  F:	security/integrity/
>  F:	security/integrity/ima/
>  
> +INTEGRITY POLICY ENFORCEMENT (IPE)
> +M:	Fan Wu <wufan@linux.microsoft.com>
> +L:	linux-security-module@vger.kernel.org
> +S:	Supported
> +T:	git git://github.com/microsoft/ipe.git

Using the raw git protocol doesn't seem to work with GH, I think you
need to refernce the git/https URL:

 https://github.com/microsoft/ipe.git

> +F:	security/ipe/
> +
>  INTEL 810/815 FRAMEBUFFER DRIVER
>  M:	Antonino Daplas <adaplas@gmail.com>
>  L:	linux-fbdev@vger.kernel.org
> diff --git a/security/Kconfig b/security/Kconfig
> index 97abeb9b9a19..daa4626ea99c 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -202,6 +202,7 @@ source "security/yama/Kconfig"
>  source "security/safesetid/Kconfig"
>  source "security/lockdown/Kconfig"
>  source "security/landlock/Kconfig"
> +source "security/ipe/Kconfig"
>  
>  source "security/integrity/Kconfig"
>  
> @@ -241,11 +242,11 @@ endchoice
>  
>  config LSM
>  	string "Ordered list of enabled LSMs"
> -	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
> -	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> -	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
> -	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECURITY_DAC
> -	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"
> +	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf,ipe" if DEFAULT_SECURITY_SMACK
> +	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf,ipe" if DEFAULT_SECURITY_APPARMOR
> +	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf,ipe" if DEFAULT_SECURITY_TOMOYO
> +	default "landlock,lockdown,yama,loadpin,safesetid,bpf,ipe" if DEFAULT_SECURITY_DAC
> +	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf,ipe"

Generally speaking the BPF LSM should be the last entry in the LSM
list to help prevent issues caused by a BPF LSM returning an improper
error and shortcutting a LSM after it.

>  	help
>  	  A comma-separated list of LSMs, in initialization order.
>  	  Any LSMs left off this list, except for those with order

...

> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> new file mode 100644
> index 000000000000..571648579991
> --- /dev/null
> +++ b/security/ipe/Makefile
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (C) Microsoft Corporation. All rights reserved.
> +#
> +# Makefile for building the IPE module as part of the kernel tree.
> +#
> +
> +obj-$(CONFIG_SECURITY_IPE) += \
> +	hooks.o \
> +	ipe.o \

It doesn't look like security/ipe/hook.c is included in this patch.

It is important to ensure that each patch compiles after it is
applied.

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

