Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7272C0015E
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jul 2023 23:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689291196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HdK6qCCoKxQUHDnRPFB/ZhyOod+T8ocuj0t04RhUOGo=;
	b=W+0UvG96wpdD+jwCNarkimW6k4CX1fhmDLakJKzp23sfTzbH7lwcOvIUsKFMlaK4dUs4U/
	7J97lzSRT/2yoCdn5aRXBoXU4o7TO5R56wOfD/hFPMhXXkxz11N0cWwoCp96VXnsBxhfjk
	O6jESm72LI3TY+HrD/lliEggzRNRDjc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-0WJpAU_EP4mQRAApaPFwSg-1; Thu, 13 Jul 2023 19:33:15 -0400
X-MC-Unique: 0WJpAU_EP4mQRAApaPFwSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD04528040A3;
	Thu, 13 Jul 2023 23:33:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80EBE40D285E;
	Thu, 13 Jul 2023 23:33:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DE5C194658F;
	Thu, 13 Jul 2023 23:33:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 399171946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Jul 2023 23:31:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4AEB40C206F; Thu, 13 Jul 2023 23:31:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD58A40C2063
 for <dm-devel@redhat.com>; Thu, 13 Jul 2023 23:31:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9080A185A78F
 for <dm-devel@redhat.com>; Thu, 13 Jul 2023 23:31:38 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-563-MzVk1BtPP3uMm3DNw9-w_w-1; Thu,
 13 Jul 2023 19:31:36 -0400
X-MC-Unique: MzVk1BtPP3uMm3DNw9-w_w-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 4D4A221C450A; Thu, 13 Jul 2023 16:31:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D4A221C450A
Date: Thu, 13 Jul 2023 16:31:35 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230713233135.GA11480@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-2-git-send-email-wufan@linux.microsoft.com>
 <ffd5c67f4a9bf45df0ce95a8fe0932a3.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <ffd5c67f4a9bf45df0ce95a8fe0932a3.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:22:59AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > Integrity Policy Enforcement (IPE) is an LSM that provides an
> > complimentary approach to Mandatory Access Control than existing LSMs
> > today.
> > 
> > Existing LSMs have centered around the concept of access to a resource
> > should be controlled by the current user's credentials. IPE's approach,
> > is that access to a resource should be controlled by the system's trust
> > of a current resource.
> > 
> > The basis of this approach is defining a global policy to specify which
> > resource can be trusted.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  MAINTAINERS           |  7 +++++++
> >  security/Kconfig      | 11 ++++++-----
> >  security/Makefile     |  1 +
> >  security/ipe/Kconfig  | 17 +++++++++++++++++
> >  security/ipe/Makefile | 10 ++++++++++
> >  security/ipe/ipe.c    | 37 +++++++++++++++++++++++++++++++++++++
> >  security/ipe/ipe.h    | 16 ++++++++++++++++
> >  7 files changed, 94 insertions(+), 5 deletions(-)
> >  create mode 100644 security/ipe/Kconfig
> >  create mode 100644 security/ipe/Makefile
> >  create mode 100644 security/ipe/ipe.c
> >  create mode 100644 security/ipe/ipe.h
> 
> ...
> 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a82795114ad4..ad00887d38ea 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10278,6 +10278,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
> >  F:	security/integrity/
> >  F:	security/integrity/ima/
> >  
> > +INTEGRITY POLICY ENFORCEMENT (IPE)
> > +M:	Fan Wu <wufan@linux.microsoft.com>
> > +L:	linux-security-module@vger.kernel.org
> > +S:	Supported
> > +T:	git git://github.com/microsoft/ipe.git
> 
> Using the raw git protocol doesn't seem to work with GH, I think you
> need to refernce the git/https URL:
> 
>  https://github.com/microsoft/ipe.git
> 
Sure I can change it.

> > +F:	security/ipe/
> > +
> >  INTEL 810/815 FRAMEBUFFER DRIVER
> >  M:	Antonino Daplas <adaplas@gmail.com>
> >  L:	linux-fbdev@vger.kernel.org
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 97abeb9b9a19..daa4626ea99c 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -202,6 +202,7 @@ source "security/yama/Kconfig"
> >  source "security/safesetid/Kconfig"
> >  source "security/lockdown/Kconfig"
> >  source "security/landlock/Kconfig"
> > +source "security/ipe/Kconfig"
> >  
> >  source "security/integrity/Kconfig"
> >  
> > @@ -241,11 +242,11 @@ endchoice
> >  
> >  config LSM
> >  	string "Ordered list of enabled LSMs"
> > -	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
> > -	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> > -	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
> > -	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECURITY_DAC
> > -	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"
> > +	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf,ipe" if DEFAULT_SECURITY_SMACK
> > +	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf,ipe" if DEFAULT_SECURITY_APPARMOR
> > +	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf,ipe" if DEFAULT_SECURITY_TOMOYO
> > +	default "landlock,lockdown,yama,loadpin,safesetid,bpf,ipe" if DEFAULT_SECURITY_DAC
> > +	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf,ipe"
> 
> Generally speaking the BPF LSM should be the last entry in the LSM
> list to help prevent issues caused by a BPF LSM returning an improper
> error and shortcutting a LSM after it.
> 
Thanks for the insight, I will update this part.

> >  	help
> >  	  A comma-separated list of LSMs, in initialization order.
> >  	  Any LSMs left off this list, except for those with order
> 
> ...
> 
> > diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> > new file mode 100644
> > index 000000000000..571648579991
> > --- /dev/null
> > +++ b/security/ipe/Makefile
> > @@ -0,0 +1,10 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Copyright (C) Microsoft Corporation. All rights reserved.
> > +#
> > +# Makefile for building the IPE module as part of the kernel tree.
> > +#
> > +
> > +obj-$(CONFIG_SECURITY_IPE) += \
> > +	hooks.o \
> > +	ipe.o \
> 
> It doesn't look like security/ipe/hook.c is included in this patch.
> 
> It is important to ensure that each patch compiles after it is
> applied.
Sorry this was accidentally added during a rebase, I will try to avoid such a mistake in the future.

-Fan

> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

