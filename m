Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07953C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652130961;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uUxOT7HJ9vwk7v18VOiwDypM9WzbR0fEymJuSWcGo9c=;
	b=O8HpDDbwig6pertC4rMh3t180wIIUzIG4lKqYRHGQnKyc5POyc5Xc/Tv82V3CzmlgEfTv3
	6L8gD/JSHBL7lmgPUdUtr+pySAaTJ+2g/JJuzN1xV1Po2qZ5a20TsmCu+SW4eLympR2SB6
	F1TjXhOaTPMxxgywyJXjiJ98XbC9HTc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-d715oaTsNcyXZOaJdIyoLA-1; Mon, 09 May 2022 17:16:00 -0400
X-MC-Unique: d715oaTsNcyXZOaJdIyoLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5929985A5BE;
	Mon,  9 May 2022 21:15:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0AC2F151F5C7;
	Mon,  9 May 2022 21:15:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B25FD1947052;
	Mon,  9 May 2022 21:15:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A4E91947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 21:15:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 557B655085A; Mon,  9 May 2022 21:15:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40D07550857;
 Mon,  9 May 2022 21:15:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 249LFrg6021269;
 Mon, 9 May 2022 16:15:53 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 249LFr4r021268;
 Mon, 9 May 2022 16:15:53 -0500
Date: Mon, 9 May 2022 16:15:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220509211552.GA5254@octiron.msp.redhat.com>
References: <20220509152127.7257-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220509152127.7257-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] multipath-tools: Makefile.inc: add test for
 -D_FORTIFY_SOURCE=3
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com,
 Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 09, 2022 at 05:21:27PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> 6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
> does not work as-is, because OPTFLAGS can't be used to override CPPFLAGS.
> Instead, add a test for support of -D_FORTIFY_SOURCE=3, and use it
> automatically if supported. The test uses similar logic as e.g.
> https://sourceware.org/git/?p=elfutils.git;a=commit;h=29859f2e79ef3c650ee9712cae990c6a7f787a7d
> 
> This test works in environments with glibc 2.33 or newer. On older distributions,
> -D_FORTIFY_SOURCE=3 does not cause an error, and will thus be used. In this
> case, it has the same effect as -D_FORTIFY_SOURCE=2. On alpine Linux (musl
> libc), -D_FORTIFY_SOURCE=3 generates an error.
> 
> Fixes: 6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index cef7a06..b915c06 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -117,6 +117,20 @@ TEST_CC_OPTION = $(shell \
>  		echo "$(2)"; \
>  	fi)
>  
> +# "make" on some distros will fail on explicit '#' or '\#' in the program text below
> +__HASH__ := \#
> +# Check if _DFORTIFY_SOURCE=3 is supported.
> +# On some distros (e.g. Debian Buster) it will be falsely reported as supported
> +# but it doesn't seem to make a difference wrt the compilation result.
> +FORTIFY_OPT := $(shell \
> +	if /bin/echo -e '$(__HASH__)include <string.h>\nint main(void) { return 0; }' | \
> +		$(CC) -o /dev/null -c -O2 -Werror -D_FORTIFY_SOURCE=3 -xc - 2>/dev/null; \
> +	then \
> +		echo "-D_FORTIFY_SOURCE=3"; \
> +	else \
> +		echo "-D_FORTIFY_SOURCE=2"; \
> +	fi)
> +
>  STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
>  ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
>  WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)
> @@ -126,7 +140,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
>  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
> -CPPFLAGS	:= -D_FORTIFY_SOURCE=2
> +CPPFLAGS	:= $(FORTIFY_OPT)
>  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" -DRUN_DIR=\"${RUN}\" \
>  		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
> -- 
> 2.36.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

