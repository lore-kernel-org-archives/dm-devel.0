Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C2AC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 15:52:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B51B7610CC
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 15:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B51B7610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621525935;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cAhwoZ7ncF/uK/Tp5ZuNJ8Kyw8TpmT1pgC2r4oGW77E=;
	b=B3kmYYZbJnBEHzUzuIdVh9kcOnDuMDd9S5xt0lhe4dJ6Y+HtQ6LiCukf+G7O3TIr83Nk8q
	EzMsoI9jU6II7JRuetzHUGbCA+XJ09gEbf+jSIxYTZMhjoQwfOQeaak00A9BnGF1PCGqOc
	63DM+Qm/pzedKdLVD1P2vfos22ZaggM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-uupDfGWKP4KBLUXWpCZ2PQ-1; Thu, 20 May 2021 11:52:09 -0400
X-MC-Unique: uupDfGWKP4KBLUXWpCZ2PQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16AA51854E21;
	Thu, 20 May 2021 15:52:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5FBE5C23E;
	Thu, 20 May 2021 15:52:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 78B7B55353;
	Thu, 20 May 2021 15:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14KFfV21021310 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 11:41:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9C90F5D742; Thu, 20 May 2021 15:41:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F80E5D6B1;
	Thu, 20 May 2021 15:41:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14KFfQBd029708; 
	Thu, 20 May 2021 10:41:26 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14KFfQTS029707;
	Thu, 20 May 2021 10:41:26 -0500
Date: Thu, 20 May 2021 10:41:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210520154125.GR25887@octiron.msp.redhat.com>
References: <20210517212727.25229-1-mwilck@suse.com>
	<20210517212727.25229-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210517212727.25229-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH v2 3/4] multipath-tools: enable
	-Wformat-overflow=2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 17, 2021 at 11:27:26PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Allow the compiler to catch possible format string overflows.
> Two were found by gcc 10.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc             | 3 ++-
>  libmultipath/discovery.c | 2 +-
>  libmultipath/print.c     | 4 ++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index f1e2313..91100a2 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -95,9 +95,10 @@ TEST_CC_OPTION = $(shell \
>  STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
>  ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
>  WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)
> +WFORMATOVERFLOW := $(call TEST_CC_OPTION,-Wformat-overflow=2,)
>  
>  OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
> -WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
> +WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
>  CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index ec99a7a..bfe2f56 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -635,7 +635,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
>  {
>  	struct udev_device *rport_dev = NULL;
>  	char value[16], *eptr;
> -	char rport_id[32];
> +	char rport_id[42];
>  	unsigned int tmo;
>  	int ret;
>  
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 8151e11..3c69bf4 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1,4 +1,4 @@
> -/*
> + /*
>   * Copyright (c) 2005 Christophe Varoqui
>   */
>  #include <stdio.h>
> @@ -594,7 +594,7 @@ int
>  snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
>  {
>  	struct udev_device *rport_dev = NULL;
> -	char rport_id[32];
> +	char rport_id[42];
>  	const char *value = NULL;
>  	int ret;
>  
> -- 
> 2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

