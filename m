Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5CCC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 08:11:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-quzMy7UsMBeFWN1fTqWl0Q-1; Wed, 11 May 2022 04:11:29 -0400
X-MC-Unique: quzMy7UsMBeFWN1fTqWl0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1811857F08;
	Wed, 11 May 2022 08:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB52053AC;
	Wed, 11 May 2022 08:11:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E766F1937755;
	Wed, 11 May 2022 08:11:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B9001947055
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 10:31:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBA6914A4F8B; Tue, 10 May 2022 10:31:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E4C14A4F88
 for <dm-devel@redhat.com>; Tue, 10 May 2022 10:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0890101AA44
 for <dm-devel@redhat.com>; Tue, 10 May 2022 10:31:25 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-O6MWq6bXNbCUcd44nx_Trw-1; Tue, 10 May 2022 06:31:22 -0400
X-MC-Unique: O6MWq6bXNbCUcd44nx_Trw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id CA47B1F8B3;
 Tue, 10 May 2022 10:31:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB98013AC1;
 Tue, 10 May 2022 10:31:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 837FKPg+emJDTwAAMHmgww
 (envelope-from <mliska@suse.cz>); Tue, 10 May 2022 10:31:20 +0000
Message-ID: <18ae082e-e37b-973d-2ed9-2656699faa5d@suse.cz>
Date: Tue, 10 May 2022 12:31:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20220510093538.25199-1-mwilck@suse.com>
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <20220510093538.25199-1-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 11 May 2022 08:11:20 +0000
Subject: Re: [dm-devel] [PATCH 1/2] multipath-tools: move CPPFLAGS before
 CFLAGS
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/10/22 11:35, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Distributions may want to override -D_FORTIFY_SOURCE in the generic
> OPTFLAGS variable. That requires that the autodected setting is
> evaluated before OPTFLAGS on the compiler command line.
> This way, distributions can use OPTFLAGS="-U_FORTIFY_SOURCE
> -D_FORTIFY_SOURCE=3 ..." without causing compilation errors.
> (Note that the "-U" is required).
> 
> Move CPPFLAGS before CFLAGS in the compiler command line. Moreover, make sure
> CPPFLAGS is referenced in all compilation steps.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Martin Liska <mliska@suse.cz>

> ---
>  Makefile.inc          | 2 +-
>  libmultipath/Makefile | 6 +++---
>  multipathd/Makefile   | 2 +-
>  tests/Makefile        | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index b915c06..7422666 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -191,7 +191,7 @@ check_var = $(shell \
>  
>  %.o:	%.c
>  	@echo building $@ because of $?
> -	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
>  
>  %.abi:  %.so.0
>  	abidw $< >$@
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index a56dd1e..2fc3f3b 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -70,12 +70,12 @@ OBJS := $(OBJS-O) $(OBJS-U)
>  all:	$(DEVLIB)
>  
>  nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
> -	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-function -c -o $@ $<
>  
>  # there are lots of "unused parameters" in dict.c
>  # because not all handler / snprint methods need all parameters
>  dict.o:	dict.c
> -	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
>  
>  make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
>  
> @@ -112,7 +112,7 @@ abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
>  # This rule is invoked from tests/Makefile, overriding configdir and plugindir
>  %-test.o: %.c
>  	@echo building $@ because of $?
> -	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
>  
>  test-lib:	../tests/$(LIBS)
>  
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 9a49144..1449080 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -52,7 +52,7 @@ $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>  
>  cli_handlers.o:	cli_handlers.c
> -	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
>  
>  install:
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
> diff --git a/tests/Makefile b/tests/Makefile
> index 0b39c30..a069e37 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -72,7 +72,7 @@ endif
>  strbuf-test_OBJDEPS := ../libmultipath/strbuf.o
>  
>  %.o: %.c
> -	$(CC) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
> +	$(CC) $(CPPFLAGS) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
>  
>  lib/libchecktur.so:
>  	mkdir -p lib

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

