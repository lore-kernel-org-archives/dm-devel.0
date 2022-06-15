Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B14CCA481
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 22:12:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-JyUNOd18PFa1UZRmdd13iQ-1; Wed, 15 Jun 2022 18:12:40 -0400
X-MC-Unique: JyUNOd18PFa1UZRmdd13iQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 861A21C05EA6;
	Wed, 15 Jun 2022 22:12:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D56C492CA5;
	Wed, 15 Jun 2022 22:12:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10B501947041;
	Wed, 15 Jun 2022 22:12:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5AC4C19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 22:12:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48E7D112131B; Wed, 15 Jun 2022 22:12:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 447D21121315
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 22:12:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28D41811E81
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 22:12:35 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-IUomuyQHNMK3iwgrcRsdbg-1; Wed, 15 Jun 2022 18:12:33 -0400
X-MC-Unique: IUomuyQHNMK3iwgrcRsdbg-1
Received: by mail-wr1-f44.google.com with SMTP id h5so17148665wrb.0
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 15:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0nYF2+L0+nfm2ZZrGFnn5kpR2H6SVKM0WrlyyHrypck=;
 b=HN5Se/Ckx1YAlZMAQ0CN/3LTLyoATRN/RRbOge2Ja79UQkUV7GZlAw5rN0Z7hAHIQF
 s5Tmbo0h8hgGOLTkBt0AF9YWN04tb5s554R1SLqDRlSqXHrydn5HnmJ3OhTj5KX9sDb8
 WOl3HBwbXZigexf3ZZjH8wSlBC6LSqNvj9qi5CPRw5j9czxPCKLxCrvgpZnDURd7NmAi
 68QBT54ZIps/TWq/h9/ZTyAB84jzIkiDnkevzR3ElS+b2JYAwIhOcFUEO4EQPm5teLQA
 8xo+Y7GqH8n3QNeZZmKZ5roH8bPm35umtiRM0jHVqR7gQXFpsqKsm8af2TcIkrsiyIwm
 76KA==
X-Gm-Message-State: AJIora99lCGmfdPFgRXHoBpHaukMkpD1Th2PHoDH+Sco4k2/KRLMWfsR
 CGt+T6KuMgQY4Z7wKS4ijvUuoNJbAWfDYTAu+AGD
X-Google-Smtp-Source: AGRyM1u/WGHw/3tv1rjJVxbCcTw2Va1S87bCBsDXwO9w9w+rsBwJm64Rn4aYl5YK1dRF5MTqCXjGUMyJeamkdiB6/+E=
X-Received: by 2002:a05:6000:230:b0:210:31ca:28b8 with SMTP id
 l16-20020a056000023000b0021031ca28b8mr1794755wrz.538.1655331152126; Wed, 15
 Jun 2022 15:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-3-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-3-git-send-email-deven.desai@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 15 Jun 2022 18:12:21 -0400
Message-ID: <CAHC9VhQum+az8SLd64rPfi_fyHGE2nePodF_pTzUtk-8y6wpSg@mail.gmail.com>
To: Deven Bowers <deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH v8 02/17] ipe: add policy parser
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
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 8, 2022 at 3:03 PM Deven Bowers
<deven.desai@linux.microsoft.com> wrote:
>
> IPE's interpretation of the what the user trusts is accomplished through
> its policy. IPE's design is to not provide support for a single trust
> provider, but to support multiple providers to enable the end-user to
> choose the best one to seek their needs.
>
> This requires the policy to be rather flexible and modular so that
> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> some other system, can plug into the policy with minimal code changes,
> and IPE can
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
>
> v3:
>   + Move policy load and activation audit event to 03/12
>   + Fix a potential panic when a policy failed to load.
>   + use pr_warn for a failure to parse instead of an
>     audit record
>   + Remove comments from headers
>   + Add lockdep assertions to ipe_update_active_policy and
>     ipe_activate_policy
>   + Fix up warnings with checkpatch --strict
>   + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>     nodes.
>   + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>   + Remove strict_parse command line parameter, as it is added
>     by the sysctl command line.
>   + Prefix extern variables with ipe_
>
> v4:
>   + Remove securityfs to reverse-dependency
>   + Add SHA1 reverse dependency.
>   + Add versioning scheme for IPE properties, and associated
>     interface to query the versioning scheme.
>   + Cause a parser to always return an error on unknown syntax.
>   + Remove strict_parse option
>   + Change active_policy interface from sysctl, to securityfs,
>     and change scheme.
>
> v5:
>   + Cause an error if a default action is not defined for each
>     operaiton.
>   + Minor function renames
>
> v6:
>   + No changes
>
> v7:
>   + Further split parser and userspace interface into two
>     separate commits, for easier review.
>
>   + Refactor policy parser to make code cleaner via introducing a
>     more modular design, for easier extension of policy, and
>     easier review.
>
> v8:
>   + remove unnecessary pr_info emission on parser loading
>
>   + add explicit newline to the pr_err emitted when a parser
>     fails to load.
> ---
>  include/asm-generic/vmlinux.lds.h    |  16 +
>  security/ipe/Makefile                |   6 +
>  security/ipe/ipe.c                   |  61 ++
>  security/ipe/ipe.h                   |   5 +
>  security/ipe/ipe_parser.h            |  59 ++
>  security/ipe/modules.c               | 109 +++
>  security/ipe/modules.h               |  17 +
>  security/ipe/modules/ipe_module.h    |  33 +
>  security/ipe/parsers.c               | 143 ++++
>  security/ipe/parsers/Makefile        |  12 +
>  security/ipe/parsers/default.c       | 106 +++
>  security/ipe/parsers/policy_header.c | 126 ++++
>  security/ipe/policy.c                | 946 +++++++++++++++++++++++++++
>  security/ipe/policy.h                |  97 +++
>  14 files changed, 1736 insertions(+)
>  create mode 100644 security/ipe/ipe_parser.h
>  create mode 100644 security/ipe/modules.c
>  create mode 100644 security/ipe/modules.h
>  create mode 100644 security/ipe/modules/ipe_module.h
>  create mode 100644 security/ipe/parsers.c
>  create mode 100644 security/ipe/parsers/Makefile
>  create mode 100644 security/ipe/parsers/default.c
>  create mode 100644 security/ipe/parsers/policy_header.c
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h

I had a few small comments while reading through this code, e.g. try
to drop the support for quoted values, but I think my big issue here
is that non-trivial string parsers in the kernel make me nervous and
with +1700 lines spread across 14 files this is definitely a
non-trivial parser.

I understand the basic 'key=value' pair format, and I think that's
okay, but I worry about the added complexity in the parser brought
about by the need to introduce an abstraction layer between the core
parser(s) and modules.  I realize flexibility is an important part of
IPE, and this relies on the ability to add support for new language
keys/modules, but I don't believe that requires the level of
indirection seen here.

I'm not asking you to make radical changes to the IPE policy language,
but I do believe spending some time to rethink how you parse the
language would be a good idea.  When in doubt keep the parser as
simple as possible, you can always add complexity and more nuance in
the future when the language requires it.  The IPE policy language
grammar is the immutable kernel/userspace API promise, not the parser
implementation.

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

