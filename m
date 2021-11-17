Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208A5C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:21:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C0BC761BC1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0BC761BC1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637173275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KkFjeo64YguUFysTmuqKN1GKgXCzyRSlWzsGr45U1PA=;
	b=WYwJpCv+33NQHFv1OH3xxFjBOo2Kn08PiqESKdCs4karvBwiaQ53sMsNFLBILNFX80mW7Q
	8A8ywWWAV3dRtec64TyDZ7uIX7lWvWzvIRGgeOEQlz74XdM7Gwl+asDsxiiB9jCw+GHw9f
	AUHsIX251rvESN+tWBJmF/sJZe7k0iQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-BLxrkYKsPgamC3ekgAGkdQ-1; Wed, 17 Nov 2021 13:21:12 -0500
X-MC-Unique: BLxrkYKsPgamC3ekgAGkdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08E8A40C1;
	Wed, 17 Nov 2021 18:21:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9278C5F4ED;
	Wed, 17 Nov 2021 18:21:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D8061832DD2;
	Wed, 17 Nov 2021 18:21:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHIL68H005974 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 13:21:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2EE4719D9B; Wed, 17 Nov 2021 18:21:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4271F471;
	Wed, 17 Nov 2021 18:20:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHIKnR9003780; 
	Wed, 17 Nov 2021 12:20:50 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHIKnKJ003779;
	Wed, 17 Nov 2021 12:20:49 -0600
Date: Wed, 17 Nov 2021 12:20:49 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211117182049.GA19591@octiron.msp.redhat.com>
References: <20211112210551.12744-1-mwilck@suse.com>
	<20211112210551.12744-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211112210551.12744-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/3] multipath-tools: support generating
 compile_commands.json
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 12, 2021 at 10:05:51PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This file is necessary to run clangd as helper for an IDE, e.g.
> with emacs lsp-mode.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  .gitignore | 1 +
>  Makefile   | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 5dbac39..8e09f95 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -17,6 +17,7 @@ mpathpersist/mpathpersist
>  abi.tar.gz
>  abi
>  abi-test
> +compile_commands.json
>  .nfs*
>  *.swp
>  *.patch
> diff --git a/Makefile b/Makefile
> index 1cec777..82e0ea3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -66,6 +66,12 @@ abi-test:	abi reference-abi $(wildcard abi/*.abi)
>  	fi; \
>  	[ $$err -eq 0 ]
>  
> +# Create compile_commands.json, useful for using clangd with an IDE
> +# Requires bear (https://github.com/rizsotto/Bear)
> +compile_commands.json: Makefile Makefile.inc $(BUILDDIRS:=/Makefile)
> +	$(MAKE) clean
> +	bear -- $(MAKE)
> +
>  libmultipath libdmmp: libmpathcmd
>  libmpathpersist libmpathvalid multipath multipathd: libmultipath
>  libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

